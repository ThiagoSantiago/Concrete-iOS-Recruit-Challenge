//
//  FavoriteMoviesViewModel.swift
//  ios-recruit-challenge
//
//  Created by Thiago Alexandre Araújo Santiago on 11/02/2018.
//  Copyright © 2018 Thiago Alexandre Araújo Santiago. All rights reserved.
//

import Foundation
import AlamofireImage

protocol FavoriteMoviesViewModelInputs {
    func loadFavoriteMovies(_ movies: [Movie])
    func favoriteCellSelected(atIndex: Int)
    func setFavoriteMoviesDelegate(_ favoriteDelegate: FavoriteMovieDelegate)
}

protocol FavoriteMoviesViewModelOutputs {
    var movieTitle: String { get }
    var dateConverted: String { get }
    var movieOverview: String { get }
    var posterPath: String { get }
    var favoriteMovies: [Movie] { get }
    var favoriteSelected: Movie { get }
}

protocol FavoriteMoviesViewModelType {
    var inputs: FavoriteMoviesViewModelInputs { get }
    var outputs: FavoriteMoviesViewModelOutputs { get }
}

class FavoriteMoviesViewModel: FavoriteMoviesViewModelType, FavoriteMoviesViewModelInputs, FavoriteMoviesViewModelOutputs {
    internal var inputs: FavoriteMoviesViewModelInputs { return self }
    internal var outputs: FavoriteMoviesViewModelOutputs { return self }
    
    var movieTitle: String = ""
    var dateConverted: String = ""
    var movieOverview: String = ""
    var posterPath: String = ""
    var favoriteMovies: [Movie] = []
    var favoriteSelected: Movie = Movie()
    var delegate: FavoriteMovieDelegate?
    
    func loadFavoriteMovies(_ movies: [Movie]) {
        delegate?.startLoading()
        let favoritesIds = UserDefaults.standard.array(forKey: Constants.favoritesKey) as? [Int] ?? []
        
        favoriteMovies = []
        
        for favorieId in favoritesIds {
            if let favoriteMovie = getFavoriteMovie(movieId: favorieId, moviesList: movies) {
                favoriteMovies.append(favoriteMovie)
            }
        }
        
        delegate?.finishLoading()
        delegate?.reloadTableView()
    }
    
    func setFavoriteMoviesDelegate(_ favoriteDelegate: FavoriteMovieDelegate) {
        delegate = favoriteDelegate
    }
    
    func getFavoriteMovie(movieId: Int, moviesList: [Movie]) -> Movie? {
        for movie in moviesList where movie.id == movieId {
            return movie
        }
        return nil
    }
    
    func favoriteCellSelected(atIndex: Int) {
        if favoriteMovies.count > atIndex {
            favoriteSelected = favoriteMovies[atIndex]
        }
    }
}
