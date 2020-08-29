//
//  AlbumDetailViewModel.swift
//  NikeProjectMVVM
//
//  Created by Riccardo Washington on 8/6/20.
//  Copyright © 2020 Riccardo Washington. All rights reserved.
//

import Foundation

protocol AlbumDetailViewModelProtocol {
    var album: AlbumDetail { get }
}

struct AlbumDetail {
    let albumImage: String
    let artistname: String
    let albumName: String
    let genre: [String]
    let releasedate: String
    let copyright: String
    let url: String
}

class AlbumDetailViewModel: AlbumDetailViewModelProtocol {
    
    var album: AlbumDetail
    
    init(album: Album) {
        self.album = AlbumDetail(albumImage: album.artworkUrl100, artistname: album.artistName, albumName: album.albumName, genre: album.genres.map { $0.name }, releasedate: album.releaseDate, copyright: album.copyright ?? "N/A", url: album.albumPageUrl)
    }
}
