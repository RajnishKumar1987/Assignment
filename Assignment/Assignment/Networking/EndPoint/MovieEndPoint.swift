//
//  MovieEndPoint.swift
//  Assignment
//
//  Created by Test on 4/21/18.
//  Copyright © 2018 hungama. All rights reserved.
//

let kBaseImageURLPath: String = "https://image.tmdb.org/t/p/w200"


import Foundation


enum NetworkEnvironment {
    case qa
    case production
    case staging
}

public enum MovieApi {
    case newMovies(page:Int)
    case movieDetails(id:Int)
}

extension MovieApi: EndPointType {
    
    var environmentBaseURL : String {
        switch NetworkManager.environment {
        case .production: return "https://api.themoviedb.org/3/"
        case .qa: return "https://qa.themoviedb.org/3/"
        case .staging: return "https://staging.themoviedb.org/3/"
        }
    }
    
    var baseURL: URL {
        guard let url = URL(string: environmentBaseURL) else { fatalError("baseURL could not be configured.")}
        return url
    }
    
    var path: String {
        switch self {
        case .movieDetails(let id):
            return "movie/\(id)"
        case .newMovies:
            return "discover/movie"
        }
    }
    
    var httpMethod: HTTPMethod {
        return .get
    }
    
    var task: HTTPTask {
        switch self {
        case .newMovies(let page):
            return .requestParameters(bodyParameters: nil,
                                      bodyEncoding: .urlEncoding,
                                      urlParameters: ["page":page,
                                                      "api_key":NetworkManager.MovieAPIKey])
        case .movieDetails:
            return .requestParameters(bodyParameters: nil,
                                      bodyEncoding: .urlEncoding,
                                      urlParameters: ["api_key":NetworkManager.MovieAPIKey])
        }
    }
    
    var headers: HTTPHeaders? {
        return nil
    }
}
