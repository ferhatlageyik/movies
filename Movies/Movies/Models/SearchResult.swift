//
//  SearchResult.swift
//  Movies
//
//  Created by Ferhat Geyik on 30.06.2022.
//

import Foundation

// MARK: - SearchResult
struct SearchResult: Codable {
    let movies: [Movie]
    let totalResults, response: String

    enum CodingKeys: String, CodingKey {
        case movies = "Search"
        case totalResults
        case response = "Response"
    }
}

// MARK: - Movie
struct Movie: Codable {
    let title, year, imdbID: String
    let type: TypeEnum
    let poster: String

    enum CodingKeys: String, CodingKey {
        case title = "Title"
        case year = "Year"
        case imdbID
        case type = "Type"
        case poster = "Poster"
    }
}

enum TypeEnum: String, Codable {
    case movie = "movie"
    case series = "series"
}
