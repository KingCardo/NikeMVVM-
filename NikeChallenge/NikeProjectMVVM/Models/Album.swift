//
//  AlbumsTableViewController.swift
//  NikeProjectMVVM
//
//  Created by Riccardo Washington on 8/6/20.
//  Copyright © 2020 Riccardo Washington. All rights reserved.
//

import Foundation


// MARK: - Welcome
struct Welcome: Codable {
    let feed: Feed
}

// MARK: - Feed
struct Feed: Codable {
    let results: [Album]
}


// MARK: - Result
struct Album: Codable {
    let artistName: String
    let releaseDate: String
    let albumName: String
    var copyright: String?
    let artistURL: String
    let artworkUrl100: String
    let genres: [Genre]
    let albumPageUrl: String
    

    enum CodingKeys: String, CodingKey {
        case artistName, releaseDate, copyright
        case artistURL = "artistUrl"
        case artworkUrl100, genres
        case albumName = "name"
        case albumPageUrl = "url"
    }
}

// MARK: - Genre
struct Genre: Codable {
    let name: String

    enum CodingKeys: String, CodingKey {
        case name
    }
}
