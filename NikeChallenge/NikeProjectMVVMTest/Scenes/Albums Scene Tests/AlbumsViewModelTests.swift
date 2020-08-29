//
//  AlbumsViewModelTests.swift
//  NikeProjectMVVMTests
//
//  Created by Riccardo Washington on 8/8/20.
//  Copyright © 2020 Riccardo Washington. All rights reserved.
//

import XCTest
@testable import NikeProjectMVVM

class AlbumsViewModelTests: XCTestCase {
    
    var sut: AlbumsViewModelProtocolMock!

    override func setUpWithError() throws {
        sut = AlbumsViewModelProtocolMock()
    }

    override func tearDownWithError() throws {
        sut = nil
    }
    
    struct AlbumsViewModelProtocolMock: AlbumsViewModelProtocol {
        
        func getAlbums(completion: @escaping (Bool, Error?) -> Void) {
            completion(true, AlbumInfoStoreError.CannotFetch("Error"))
            
        }
        
        var albums: [Album] = []
        
        var albumsCount: Int {
            return albums.count
        }
        
        
    }
    
    func testGetAlbumsSuccess() {
        //Given
        
        var successGettingAlbums = false
        
        //When
        
        sut.getAlbums { (success, error) in
            if success {
                successGettingAlbums = true
            }
        }
        
        //Then
        
        XCTAssertTrue(successGettingAlbums, "Error albums wasnt fetched")
         
        
    }
    
    func testGetAlbumsFailure() {
        
        //Given
        
        var successGettingAlbums = false
        
        //When
        
        sut.getAlbums { (success, error) in
            if error != nil {
                successGettingAlbums = false
            }
        }
        
        //Then
        
        XCTAssertFalse(successGettingAlbums, "Albums was fetched")
        
    }
    
}
