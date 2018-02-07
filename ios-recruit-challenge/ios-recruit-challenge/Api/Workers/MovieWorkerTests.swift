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
            guard let path = OHPathForFile("movie_popular_unauthorized.json", type(of: self)) else {
                preconditionFailure("Could not find expected file in test bundle")
            }
            return OHHTTPStubsResponse(fileAtPath: path, statusCode: 401, headers: [:])
        }
        
        MovieWorker.getPopularMovies(success: { _ in
        }) { error in
            XCTAssertEqual(error.errorMessage, "Invalid API key: You must be granted a valid key.")
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
            XCTAssertEqual(error.errorMessage, "The resource you requested could not be found.")
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testShouldGetListOfGenreWithSuccess() {
        let expectation = XCTestExpectation(description: "Get list of genre expectation")
        
        stub(condition: isHost("api.themoviedb.org")) { _ in
            guard let path = OHPathForFile("genre_success.json", type(of: self)) else {
                preconditionFailure("Could not find expected file in test bundle")
            }
            return OHHTTPStubsResponse(fileAtPath: path, statusCode: 200, headers: [:])
        }
        
        MovieWorker.getGenreList(success: { result in
            guard let genres = result.genres else { return }
            guard let firstGenre = genres.first else { return }
            
            XCTAssertFalse(genres.isEmpty)
            XCTAssertEqual(firstGenre.id, 28)
            XCTAssertEqual(firstGenre.name, "Action")
            
            expectation.fulfill()
        }) { _ in }
        
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testShouldGetListOfGenreWithUnauthorized() {
        let expectation = XCTestExpectation(description: "Get list of genre expectation")
        
        stub(condition: isHost("api.themoviedb.org")) { _ in
            guard let path = OHPathForFile("genre_unauthorized.json", type(of: self)) else {
                preconditionFailure("Could not find expected file in test bundle")
            }
            return OHHTTPStubsResponse(fileAtPath: path, statusCode: 401, headers: [:])
        }
        
        MovieWorker.getGenreList(success: { _ in
        }) { error in
            XCTAssertEqual(error.errorMessage, "Invalid API key: You must be granted a valid key.")
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testShouldGetListOfGenreWithNotFound() {
        let expectation = XCTestExpectation(description: "Get list of genre expectation")
        
        stub(condition: isHost("api.themoviedb.org")) { _ in
            guard let path = OHPathForFile("genre_not_found.json", type(of: self)) else {
                preconditionFailure("Could not find expected file in test bundle")
            }
            return OHHTTPStubsResponse(fileAtPath: path, statusCode: 404, headers: [:])
        }
        
        MovieWorker.getGenreList(success: { _ in
        }) { error in
            XCTAssertEqual(error.errorMessage, "The resource you requested could not be found.")
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testShouldGetTheMovieDetailsWithSuccess() {
        let expectation = XCTestExpectation(description: "Get movie details expectation")
        
        stub(condition: isHost("api.themoviedb.org")) { _ in
            guard let path = OHPathForFile("movie_details_success.json", type(of: self)) else {
                preconditionFailure("Could not find expected file in test bundle")
            }
            return OHHTTPStubsResponse(fileAtPath: path, statusCode: 200, headers: [:])
        }
        
        MovieWorker.getMovieDetails(movieId: "198663", success: { movie in
            XCTAssertEqual(movie.id, 198663)
            XCTAssertEqual( movie.title, "Maze Runner: Correr ou Morrer")
            XCTAssertEqual(movie.overview, "Num cenário pós-apocalíptico, uma comunidade de rapazes descobre que estão presos num labirinto misterioso. Juntos, terão de descobrir como escapar, resolver o enigma e revelar o arrepiante segredo acerca de quem os colocou ali e por que razão.")
            
            expectation.fulfill()
        }) { _ in }
        
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testShouldGetTheMovieDetailsWithUnauthorized() {
        let expectation = XCTestExpectation(description: "Get movie details expectation")
        
        stub(condition: isHost("api.themoviedb.org")) { _ in
            guard let path = OHPathForFile("movie_details_unauthorized.json", type(of: self)) else {
                preconditionFailure("Could not find expected file in test bundle")
            }
            return OHHTTPStubsResponse(fileAtPath: path, statusCode: 401, headers: [:])
        }
        
        MovieWorker.getMovieDetails(movieId: "198663", success: { _ in
        }) { error in
            XCTAssertEqual(error.errorMessage, "Invalid API key: You must be granted a valid key.")
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testShouldGetTheMovieDetailsNotFound() {
        let expectation = XCTestExpectation(description: "Get movie details expectation")
        
        stub(condition: isHost("api.themoviedb.org")) { _ in
            guard let path = OHPathForFile("movie_details_not_found.json", type(of: self)) else {
                preconditionFailure("Could not find expected file in test bundle")
            }
            return OHHTTPStubsResponse(fileAtPath: path, statusCode: 401, headers: [:])
        }
        
        MovieWorker.getMovieDetails(movieId: "198663", success: { _ in
        }) { error in
            XCTAssertEqual(error.errorMessage, "The resource you requested could not be found.")
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10.0)
    }
}
