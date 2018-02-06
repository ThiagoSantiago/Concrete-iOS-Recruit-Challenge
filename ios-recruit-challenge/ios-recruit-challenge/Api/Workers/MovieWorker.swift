//
//  MovieWorker.swift
//  ios-recruit-challenge
//
//  Created by Thiago Alexandre Araújo Santiago on 06/02/2018.
//  Copyright © 2018 Thiago Alexandre Araújo Santiago. All rights reserved.
//

import Foundation
import Alamofire

class MovieWorker {
    typealias Failure = (_ error: MovieApiError) -> Void
    
    typealias GetPopularMoviesSuccess = (_ movies: MovieResult) -> Void
    class func getPopularMovies(success: @escaping GetPopularMoviesSuccess, failure: @escaping Failure) {
        MovieApi.request( .getPopularMovies()) { (result: Result<MovieResult>) in
            switch result {
            case .success(let movies):
                success(movies)
            case .failure(let error):
                guard let apiError = error as? MovieApiError else {
                    failure(MovieApiError.unknownResponse)
                    return
                }
                
                failure(apiError)
            }
        }
    }
}
