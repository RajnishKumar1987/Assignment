//
//  MovieDetailsModel.swift
//  Assignment
//
//  Created by Test on 4/22/18.
//  Copyright © 2018 hungama. All rights reserved.
//

import Foundation

struct MovieDetailsModel {
    
    var title: String?
    var overView: String?
    var posterPath: String?
    var popularity: Double?
    var movieId: Int?
    var generes: [Genere]? = []
    var languages: [Languages]? = []
    var releaseDate: String?
    var runTime: Int?
    
}

struct Genere {
    var genereId: Int?
    var name: String?
}
struct Languages {
    var name: String?
}

extension Languages: Decodable {
    
    private enum LanguangesCodingKey: String, CodingKey{
        case name
    }
    init(from decoder: Decoder) throws {
        
        let conatiner = try decoder.container(keyedBy: LanguangesCodingKey.self)
        name = try conatiner.decodeIfPresent(String.self, forKey: .name)
        
    }
}


extension Genere: Decodable{
    
    private enum GenereCodingKeys: String, CodingKey{
        case genereId = "id"
        case name
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: GenereCodingKeys.self)
        genereId = try container.decodeIfPresent(Int.self, forKey: .genereId)
        name = try container.decodeIfPresent(String.self, forKey: .name)
    }
}



extension MovieDetailsModel: Decodable {
    
    private enum MovieDetailsCodingKeys: String, CodingKey {
        case title
        case overView = "overview"
        case posterPath = "poster_path"
        case movieId = "id"
        case popularity = "popularity"
        case generes = "genres"
        case languages = "spoken_languages"
        case releaseDate = "release_date"
        case runTime = "runtime"
        
    }
    
    init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: MovieDetailsCodingKeys.self)
        title = try container.decodeIfPresent(String.self, forKey: .title)
        overView = try container.decodeIfPresent(String.self, forKey: .overView)
        posterPath = try container.decodeIfPresent(String.self, forKey: .posterPath)
        popularity = try container.decodeIfPresent(Double.self, forKey: .popularity)
        movieId = try container.decodeIfPresent(Int.self, forKey: .movieId)
        generes = try container.decodeIfPresent([Genere].self, forKey: .generes)
        languages = try container.decodeIfPresent([Languages].self, forKey: .languages)
        releaseDate = try container.decodeIfPresent(String.self, forKey: .releaseDate)
        runTime = try container.decodeIfPresent(Int.self, forKey: .runTime)

    }
}




