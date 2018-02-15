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
    func searchMovies(text: String)
    func setContentFor(index: Int)
    func notSearchingBehavior()
    func setFavoriteMoviesDelegate(_ favoriteDelegate: FavoriteMovieDelegate)
}

protocol FavoriteMoviesViewModelOutputs {
    var movieTitle: String { get }
    var dateConverted: String { get }
    var movieOverview: String { get }
    var posterPath: String { get }
    var listOfMovies: [Movie] { get }
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
    var listOfMovies: [Movie] = []
    var favoriteMovies: [Movie] = []
    var favoriteSelected: Movie = Movie()
    var delegate: FavoriteMovieDelegate?
    var favoriteMoviesSearched: [Movie] = []
    
    
    func loadFavoriteMovies(_ movies: [Movie]) {
        let favoritesIds = UserDefaults.standard.array(forKey: Constants.favoritesKey) as? [Int] ?? []
        delegate?.startLoading()
        
        favoriteMovies = []
        
        for favorieId in favoritesIds {
            if let favoriteMovie = getFavoriteMovie(movieId: favorieId, moviesList: movies) {
                favoriteMovies.append(favoriteMovie)
            }
        }
        
        listOfMovies = favoriteMovies
        delegate?.finishLoading()
        delegate?.resultSuccess()
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
    
    func setContentFor(index: Int) {
        let movie = listOfMovies[index]
        
        movieTitle = movie.title ?? ""
        dateConverted = MovieHelper.convertDate(movie.releaseDate ?? "")
        movieOverview = movie.overview ?? ""
        posterPath = movie.posterPath ?? ""
    }
    
    func searchMovies(text: String) {
        let trimmedString = text.trimmingCharacters(in: .whitespaces)
        if !trimmedString.isEmpty {
            favoriteMoviesSearched = []
    
            for movie in favoriteMovies where (movie.title?.contains(trimmedString) ?? false) {
                favoriteMoviesSearched.append(movie)
            }
            
            listOfMovies = favoriteMoviesSearched
        } else {
            listOfMovies = favoriteMovies
        }
        
        if listOfMovies.isEmpty {
            delegate?.noResultFound()
        } else {
            delegate?.resultSuccess()
        }
    }
    
    func notSearchingBehavior() {
        listOfMovies = favoriteMovies
        delegate?.resultSuccess()
    }
}
