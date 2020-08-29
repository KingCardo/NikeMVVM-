//
//  AlbumsViewModel.swift
//  NikeProjectMVVM
//
//  Created by Riccardo Washington on 8/6/20.
//  Copyright © 2020 Riccardo Washington. All rights reserved.
//

import Foundation

protocol AlbumsViewModelProtocol {
    func getAlbums(completion: @escaping(Bool, Error?) -> Void)
    var albums: [Album] { get set }
    var albumsCount: Int { get } 
}

class AlbumsViewModel: AlbumsViewModelProtocol {
    
    var albums: [Album] = []
    
    init(worker: AlbumWorker) {
        self.worker = worker
    }
    var albumsCount: Int {
        return albums.count
    }
    
    private var worker: AlbumWorker
    
    func getAlbums(completion: @escaping(Bool, Error?) -> Void) {
        
        let loaded = AlbumStorage.shared.loadAlbums()
        if !loaded {
            worker.fetchAlbums(completion: { (albums, error) in
                if error != nil {
                    completion(false, error)
                }
                if !albums.isEmpty {
                    self.albums = albums
                    completion(true, nil)
                }
            })
        } else {
            self.albums = AlbumStorage.shared.albums
            completion(true, nil)
        }
    }
}
