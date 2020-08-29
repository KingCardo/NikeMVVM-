//
//  AlbumsTableViewController.swift
//  NikeProjectMVVM
//
//  Created by Riccardo Washington on 8/6/20.
//  Copyright © 2020 Riccardo Washington. All rights reserved.
//

import UIKit

extension UIImageView {
    
    func fetchImage(from url: URL, completionHandler: @escaping (_ data: Data?) -> ()) {
        let session = URLSession.shared
            
        let dataTask = session.dataTask(with: url) { (data, response, error) in
            if error != nil {
                completionHandler(nil)
            } else {
                completionHandler(data)
            }
        }
            
        dataTask.resume()
    }
    
    func setImage(with url: URL, completion: @escaping(UIImage?, String?) -> Void) {
        fetchImage(from: url) { (imageData) in
            if let data = imageData {
                DispatchQueue.main.async {
                    let image = UIImage(data: data)
                    self.image = image
                    completion(image, nil)
                    return 
                }
            } else {
                completion(nil, "Error loading image")
            }
        }
    }
}
