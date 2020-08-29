//
//  AlbumsTableViewController.swift
//  NikeProjectMVVM
//
//  Created by Riccardo Washington on 8/6/20.
//  Copyright © 2020 Riccardo Washington. All rights reserved.
//

import Foundation

class DataFetcher: AlbumInfoStore {
    
    static let shared = DataFetcher()
    
    private init() { }
    
    private let url = URL(string: "https://rss.itunes.apple.com/api/v1/us/apple-music/top-albums/all/100/explicit.json")
    
    private let session: URLSession = URLSession(configuration: .default)
    
    private let queue = DispatchQueue(label: "DataFetcher", qos: .userInitiated, attributes: .concurrent)
    
    func fetchAlbums(completion: @escaping ([Album], AlbumInfoStoreError?) -> Void) {
        guard let url = url else { completion([], AlbumInfoStoreError.CannotFetch("bad url")); return }
        var result: ([Album], AlbumInfoStoreError?) = ([], nil)
        
        queue.async {
            let task = self.session.dataTask(with: url) { (data, response, error) in
                
                if let error = error {
                    result = ([], AlbumInfoStoreError.CannotFetch(error.localizedDescription))
                    
                } else if let data = data, let response = response as? HTTPURLResponse,
                    response.statusCode == 200 {
                    
                    let (albums, errorMessage) = self.makeModelsWithData(data)
                    if albums.count > 0 {
                        result = (albums, nil)
                    } else {
                        result = ([], AlbumInfoStoreError.CannotFetch(errorMessage ?? "Error Decoding"))
                    }
                }
                DispatchQueue.main.async {
                    completion(result.0, result.1)
                    return
                }
            }
            task.resume()
        }
    }
    
    private func makeModelsWithData(_ data: Data) -> ([Album], String?) {
        var albums: [Album] = []
        
        do {
            guard let welcome = try? JSONDecoder().decode(Welcome.self, from: data) else { return ([], "error decoding")}
            albums = welcome.feed.results
            return (albums, nil)
        }
    }
}
