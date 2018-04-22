//
//  MovieViewModel.swift
//  Assignment
//
//  Created by Test on 4/21/18.
//  Copyright © 2018 hungama. All rights reserved.
//

import Foundation

struct MoviewCellViewModel {
    
    var title: String?
    var imageUrl: URL?
    var description: String?
    
    init(with movieIteam: Movie) {
        
        self.title = movieIteam.title
        
        if let imageUrl = movieIteam.posterPath  {
            
            let imageURL = kBaseImageURLPath + imageUrl
            self.imageUrl = URL(string: imageURL)
        }
        
        if let description = movieIteam.overview {
            
            self.description = description
        }
        
    }
    
}


class MoviesListViewModel {
    
    var movieApiReponse = MovieApiResponse()
    var isUserRefreshingList: Bool = false
    var isLoadingNextPageResults: Bool = false

    lazy var networkManager: NetworkManager = {
        return NetworkManager()
    }()
    
    
    func canLoadNextPage() -> Bool {
        
        if isLoadingNextPageResults { return false }
        
        if let currentPage = movieApiReponse.page, let totalPages = movieApiReponse.numberOfPages, currentPage + 1 > totalPages {
            return false
        }
        
        return true
    }
    
    func getMovieCellModel(for indexPath: IndexPath) -> MoviewCellViewModel {
        
        return MoviewCellViewModel(with: movieApiReponse.movies[indexPath.row])
    }
    func isLoadingResultsFirstTime() -> Bool {
        return movieApiReponse.movies.count == 0
    }

    
    func getMoviesList(completionHandler: @escaping ((_ moviesList: MovieApiResponse?, _ error: String?)->())) {
        
       let page = isUserRefreshingList ? 1 : (movieApiReponse.page ?? 0) + 1
       
        
        networkManager.httpRequest(apiType: .newMovies(page: page)) {[weak self] (responseData, error) in
            
            
            
            guard let response = responseData as? MovieApiResponse else {
                completionHandler(nil, error)
                return
            }
            
            if self?.isUserRefreshingList == true {
                self?.movieApiReponse = response
                self?.isUserRefreshingList = false
            }
            else
            {
                self?.movieApiReponse.addResults(from: response)
            }
            completionHandler(response, error)
        }
        
    }
    
}


