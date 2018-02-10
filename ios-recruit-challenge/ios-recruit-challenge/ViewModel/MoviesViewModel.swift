//
//  MoviesViewModel.swift
//  ios-recruit-challenge
//
//  Created by Thiago Alexandre Araújo Santiago on 08/02/2018.
//  Copyright © 2018 Thiago Alexandre Araújo Santiago. All rights reserved.
//

import Foundation

protocol MoviesViewModelInputs {
    func fetchPopularMovies()
    func movieCellSelected(atIndex: Int)
    func setMoviesDelegate(_ moviesDelegate: MoviesDelegate)
}

protocol MoviesViewModelOutputs {
    var popularMovies: [Movie] { get }
    var errorMessage: String { get }
    var movieSelected: Movie { get }
}

protocol MoviesViewModelType {
    var inputs: MoviesViewModelInputs { get }
    var outputs: MoviesViewModelOutputs { get }
}

final class MoviesViewModel: MoviesViewModelType, MoviesViewModelInputs, MoviesViewModelOutputs {
    internal var inputs: MoviesViewModelInputs { return self }
    internal var outputs: MoviesViewModelOutputs { return self }
    
    var errorMessage: String = ""
    var popularMovies: [Movie] = []
    var movieSelected: Movie = Movie()
    var delegate: MoviesDelegate?
    
    func fetchPopularMovies() {
        delegate?.startLoading()
        MovieWorker.getPopularMovies(success: { movies in
            self.popularMovies = movies.results ?? []
            self.delegate?.resultSuccess()
            self.delegate?.finishLoading()
        }) { error in
            self.errorMessage = error.errorMessage
            self.delegate?.hasError()
        }
    }
    
    func movieCellSelected(atIndex: Int) {
        if popularMovies.count > atIndex {
            movieSelected = popularMovies[atIndex]
        }
    }
    
    func setMoviesDelegate(_ moviesDelegate: MoviesDelegate) {
        delegate = moviesDelegate
    }
}
