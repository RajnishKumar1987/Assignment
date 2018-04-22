//
//  NetworkManager.swift
//  Assignment
//
//  Created by Test on 4/21/18.
//  Copyright © 2018 hungama. All rights reserved.
//

import Foundation

enum NetworkResponse:String {
    case success
    case authenticationError = "You need to be authenticated first."
    case badRequest = "Bad request"
    case outdated = "The url you requested is outdated."
    case failed = "Network request failed."
    case noData = "Response returned with no data to decode."
    case unableToDecode = "We could not decode the response."
}

enum Result<String>{
    case success
    case failure(String)
}

struct NetworkManager {
    static let environment : NetworkEnvironment = .production
    static let MovieAPIKey = "7a312711d0d45c9da658b9206f3851dd"

    let router = Router<MovieApi>()
    
    func httpRequest(apiType: MovieApi, completion: @escaping (_ movie: Any?,_ error: String?)->()){
        
        router.request(apiType) { data, response, error in
            
            if error != nil {
                completion(nil, "Please check your network connection.")
            }
            
                if let response = response as? HTTPURLResponse {
                    let result = self.handleNetworkResponse(response)
                    switch result {
                    case .success:
                        guard let responseData = data else {
                            completion(nil, NetworkResponse.noData.rawValue)
                            return
                        }
                        do {
                            //print(responseData)
                            //printlet jsonData = try JSONSerialization.jsonObject(with: responseData, options: .mutableContainers)
                            //print(jsonData)
                            let apiResponse = try self.parseData(for: apiType, responseData: responseData)
                            completion(apiResponse,nil)
                        }catch {
                            print(error)
                            completion(nil, NetworkResponse.unableToDecode.rawValue)
                        }
                    case .failure(let networkFailureError):
                        completion(nil, networkFailureError)
                    }
                }
            
            
        }
    }
    
    
    func parseData(for apiType: MovieApi, responseData: Data) throws -> Any? {
        
        var apiResponse: Any? = nil
        
        switch apiType {
        case .newMovies:
             apiResponse = try JSONDecoder().decode(MovieApiResponse.self, from: responseData)
        case .movieDetails:
            apiResponse = try JSONDecoder().decode(MovieDetailsModel.self, from: responseData)
        }
        
        return apiResponse
    }
    
    
    

    fileprivate func handleNetworkResponse(_ response: HTTPURLResponse) -> Result<String>{
        switch response.statusCode {
        case 200...299: return .success
        case 401...500: return .failure(NetworkResponse.authenticationError.rawValue)
        case 501...599: return .failure(NetworkResponse.badRequest.rawValue)
        case 600: return .failure(NetworkResponse.outdated.rawValue)
        default: return .failure(NetworkResponse.failed.rawValue)
        }
    }
}
