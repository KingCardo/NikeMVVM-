//
//  AlbumsTableViewController.swift
//  NikeProjectMVVM
//
//  Created by Riccardo Washington on 8/6/20.
//  Copyright © 2020 Riccardo Washington. All rights reserved.
//

import Foundation

class AlbumStorage {
    
    static let shared = AlbumStorage()
    
    private init() { }
    
    private(set) var albums: [Album] = [] {
        didSet {
            save()
        }
    }
    
    func addAlbums(_ albums: [Album]) {
        self.albums += albums
    }
    
    private func save() {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let archiveURL = documentsDirectory.appendingPathComponent("Albums").appendingPathExtension("json")
        
        let jsonEncoder = JSONEncoder()
        
        do {
            let encodedData = try jsonEncoder.encode(albums)
            try encodedData.write(to: archiveURL)
        } catch let error {
            print(error)
        }
    }
    
    func loadAlbums() -> Bool {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return false }
        let archiveURL = documentsDirectory.appendingPathComponent("Albums").appendingPathExtension("json")
        
        let jsonDecoder = JSONDecoder()
        guard let decodedData = try? Data(contentsOf: archiveURL) else { return false }
        
        do {
            self.albums = try jsonDecoder.decode([Album].self, from: decodedData)
            return albums.count > 0 ? true : false
        } catch {
            return false
        }
    }
}
