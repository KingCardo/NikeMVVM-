//
//  AlbumsTableViewController.swift
//  NikeProjectMVVM
//
//  Created by Riccardo Washington on 8/6/20.
//  Copyright © 2020 Riccardo Washington. All rights reserved.
//

import UIKit

protocol AlbumInfoStore {
    func fetchAlbums(completion: @escaping([Album], AlbumInfoStoreError?) -> Void)
}

class AlbumWorker {
    
    var albumInfoDataStore: AlbumInfoStore
    
    init(service: AlbumInfoStore) {
        self.albumInfoDataStore = service
    }
    
    func fetchAlbums(completion: @escaping([Album], AlbumInfoStoreError?) -> Void) {
        albumInfoDataStore.fetchAlbums { (albums, error) in
            DispatchQueue.main.async {
                if let error = error {
                    completion([], error)
                }
                if !albums.isEmpty {
                    AlbumStorage.shared.addAlbums(albums)
                    completion(albums, nil)
                }
            }
        }
    }
}

enum AlbumInfoStoreResult<U> {
    case Success(result: U)
    case Failure(error: AlbumInfoStoreError)
}

enum AlbumInfoStoreError: Equatable, Error {
    case CannotFetch(String)
}

func ==(lhs: AlbumInfoStoreError, rhs: AlbumInfoStoreError) -> Bool {
    switch (lhs, rhs) {
    case (.CannotFetch(let a), .CannotFetch(let b)) where a == b: return true
    default: return false
    }
}

