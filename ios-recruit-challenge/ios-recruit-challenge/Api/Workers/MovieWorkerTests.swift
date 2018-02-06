//
//  MovieWorkerTests.swift
//  ios-recruit-challengeTests
//
//  Created by Thiago Alexandre Araújo Santiago on 06/02/2018.
//  Copyright © 2018 Thiago Alexandre Araújo Santiago. All rights reserved.
//

import XCTest
import OHHTTPStubs
@testable import ios_recruit_challenge

class MovieWorkerTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testShouldGetTheListOfPopularMoviesWithSuccess() {
        let expectation = XCTestExpectation(description: "Get popular movies expectation")
        
        stub(condition: isHost("api.themoviedb.org")) { _ in
            guard let path = OHPathForFile("movie_popular_success.json", type(of: self)) else {
                preconditionFailure("Could not find expected file in test bundle")
            }
            return OHHTTPStubsResponse(fileAtPath: path, statusCode: 200, headers: [:])
        }
        
        MovieWorker.getPopularMovies(success: { result in
            guard let movies = result.results else { return }
            guard let firstMovie = movies.first else { return }
            
            XCTAssertFalse(movies.isEmpty)
            XCTAssertEqual(movies.count, 20)
            XCTAssertEqual(firstMovie.id, 198663)
            XCTAssertEqual(firstMovie.originalTitle, "The Maze Runner")
            
            expectation.fulfill()
        }) { _ in }
        
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testShouldGetTheListOfPopularMoviesUnauthorized() {
        let expectation = XCTestExpectation(description: "Get popular movies expectation")
        
        stub(condition: isHost("api.themoviedb.org")) { _ in
            guard let path = OHPathForFile("movie_popular_ unauthorized.json", type(of: self)) else {
                preconditionFailure("Could not find expected file in test bundle")
            }
            return OHHTTPStubsResponse(fileAtPath: path, statusCode: 401, headers: [:])
        }
        
        MovieWorker.getPopularMovies(success: { _ in
        }) { error in
            
            XCTAssertTrue(error is MovieApiError, "error instance is MovieApiError")
            XCTAssertEqual((error as! MovieApiError).errorMessage, "Invalid API key: You must be granted a valid key.")
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testShouldGetTheListOfPopularMoviesNotFound() {
        let expectation = XCTestExpectation(description: "Get popular movies expectation")
        
        stub(condition: isHost("api.themoviedb.org")) { _ in
            guard let path = OHPathForFile("movie_popular_not_found.json", type(of: self)) else {
                preconditionFailure("Could not find expected file in test bundle")
            }
            return OHHTTPStubsResponse(fileAtPath: path, statusCode: 404, headers: [:])
        }
        
        MovieWorker.getPopularMovies(success: { _ in
        }) { error in
            
            XCTAssertTrue(error is MovieApiError, "error instance is MovieApiError")
            XCTAssertEqual((error as! MovieApiError).errorMessage, "The resource you requested could not be found.")
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10.0)
    }
}
