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
    func fetchMorePopularMovies()
    func searchMovies(text: String)
    func notSearchingBehavior()
    func verifyIfIsFavorite(index: Int)
    func movieCellSelected(atIndex: Int)
    func setMoviesDelegate(_ moviesDelegate: MoviesDelegate)
}

protocol MoviesViewModelOutputs {
    var isSearching: Bool { get }
    var errorMessage: String { get }
    var movieSelected: Movie { get }
    var listOfMovies: [Movie] { get }
    var moviesSearched: [Movie] { get }
    var isFavorite: Bool { get }
}

protocol MoviesViewModelType {
    var inputs: MoviesViewModelInputs { get }
    var outputs: MoviesViewModelOutputs { get }
}

final class MoviesViewModel: MoviesViewModelType, MoviesViewModelInputs, MoviesViewModelOutputs {
    internal var inputs: MoviesViewModelInputs { return self }
    internal var outputs: MoviesViewModelOutputs { return self }
    

    var moviesPage = 1
    var errorMessage = ""
    var isSearching = false
    var movieSelected = Movie()
    var delegate: MoviesDelegate?
    var listOfMovies: [Movie] = []
    var popularMovies: [Movie] = []
    var moviesSearched: [Movie] = []
    var isFavorite: Bool = false
    let favoriteMovies: [Int] = UserDefaults.standard.array(forKey: Constants.favoritesKey) as? [Int] ?? []
    
    
    func fetchPopularMovies() {
        moviesPage = 1
        delegate?.startLoading()
        
        MovieWorker.getPopularMovies(page: moviesPage, success: { movies in
            self.popularMovies = movies.results ?? []
            self.listOfMovies = self.popularMovies
            self.delegate?.resultSuccess()
            self.delegate?.finishLoading()
        }) { error in
            self.errorMessage = error.errorMessage
            self.delegate?.hasError()
        }
    }
    
    func verifyIfIsFavorite(index: Int) {
        let favoriteMovies: [Int] = UserDefaults.standard.array(forKey: Constants.favoritesKey) as? [Int] ?? []
        let id = popularMovies[index].id ?? 0
        
        if favoriteMovies.contains(id)  {
            isFavorite = true
        } else {
            isFavorite = false
        }
    }
    
    func fetchMorePopularMovies() {
        moviesPage += moviesPage
        delegate?.startLoadingMore()
        MovieWorker.getPopularMovies(page: moviesPage, success: { movies in
            self.popularMovies.append(contentsOf: movies.results ?? [])
            self.listOfMovies = self.popularMovies
            self.delegate?.resultSuccess()
            self.delegate?.finishLoadingMore()
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
    
    func notSearchingBehavior() {
        listOfMovies = popularMovies
        isSearching = false
        delegate?.resultSuccess()
    }
    
    func searchMovies(text: String) {
        let trimmedString = text.trimmingCharacters(in: .whitespaces)
        if !trimmedString.isEmpty {
            isSearching = true
            moviesSearched = []
            
            for movie in popularMovies where (movie.title?.contains(trimmedString) ?? false) {
                moviesSearched.append(movie)
            }
            
            listOfMovies = moviesSearched
        } else {
          listOfMovies = popularMovies
            isSearching = false
        }
        
        if listOfMovies.isEmpty {
            delegate?.noResultsFound()
        } else {
            delegate?.resultSuccess()
        }
    }
}
