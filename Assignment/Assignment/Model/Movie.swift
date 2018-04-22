//
//  Movie.swift
//  Assignment
//
//  Created by Test on 4/21/18.
//  Copyright © 2018 hungama. All rights reserved.
//

import Foundation

struct MovieApiResponse {
    var page: Int? = 0
    var numberOfResults: Int? = 0
    var numberOfPages: Int? = 0
    var movies: [Movie] = []
    
   mutating func addResults(from newObject: MovieApiResponse) {
        
        if let newPage = newObject.page {
            
            self.page = newPage
            self.numberOfPages = newObject.numberOfPages
            movies.append(contentsOf: newObject.movies)
        }
    }
}

extension MovieApiResponse: Decodable {
    
    private enum MovieApiResponseCodingKeys: String, CodingKey {
        case page
        case numberOfResults = "total_results"
        case numberOfPages = "total_pages"
        case movies = "results"
    }
    
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: MovieApiResponseCodingKeys.self)
        
        page = try container.decode(Int.self, forKey: .page)
        numberOfResults = try container.decode(Int.self, forKey: .numberOfResults)
        numberOfPages = try container.decode(Int.self, forKey: .numberOfPages)
        movies = try container.decode([Movie].self, forKey: .movies)
        
    }
}


struct Movie {
    var id: Int?
    var posterPath: String?
    var backdrop: String?
    var title: String?
    var releaseDate: String?
    var rating: Double?
    var overview: String?
    var language: String?
    var gener: String?

    
}

extension Movie: Decodable {
    
    enum MovieCodingKeys: String, CodingKey {
        case id
        case posterPath = "poster_path"
        case backdrop = "backdrop_path"
        case title
        case releaseDate = "release_date"
        case rating = "vote_average"
        case overview
        case language = "original_language"
        case genere = "genere"
    }
    
    
    init(from decoder: Decoder) throws {
        let movieContainer = try decoder.container(keyedBy: MovieCodingKeys.self)
        
        id = try movieContainer.decodeIfPresent(Int.self, forKey: .id)
        posterPath = try movieContainer.decodeIfPresent(String.self, forKey: .posterPath)
        backdrop = try movieContainer.decodeIfPresent(String.self, forKey: .backdrop)
        title = try movieContainer.decodeIfPresent(String.self, forKey: .title)
        releaseDate = try movieContainer.decodeIfPresent(String.self, forKey: .releaseDate)
        rating = try movieContainer.decodeIfPresent(Double.self, forKey: .rating)
        overview = try movieContainer.decodeIfPresent(String.self, forKey: .overview)
        language = try movieContainer.decodeIfPresent(String.self, forKey: .language)
        gener = try movieContainer.decodeIfPresent(String.self, forKey: .genere)

    }
}
