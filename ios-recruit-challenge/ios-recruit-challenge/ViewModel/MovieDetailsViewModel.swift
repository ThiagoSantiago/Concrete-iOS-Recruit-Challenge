//
//  MovieDetailsViewModel.swift
//  ios-recruit-challenge
//
//  Created by Thiago Alexandre Araújo Santiago on 11/02/2018.
//  Copyright © 2018 Thiago Alexandre Araújo Santiago. All rights reserved.
//

import UIKit
import AlamofireImage

protocol MovieDetailsViewModelInputs {
    func fetchGenreList()
    func favoriteMovie(id: Int)
    func setMovieSelected(_ movie: Movie)
    func setMovieDetailsDelegate(_ detailsDelegate: MovieDetailsDelegate)
}

protocol MovieDetailsViewModelOutputs {
    var movieTitle: String { get }
    var genresString: String { get }
    var dateConverted: String { get }
    var movieOverview: String { get }
    var posterPath: String { get }
}

protocol MovieDetailsViewModelType {
    var inputs: MovieDetailsViewModelInputs { get }
    var outputs: MovieDetailsViewModelOutputs { get }
}

class MovieDetailsViewModel: MovieDetailsViewModelType, MovieDetailsViewModelInputs, MovieDetailsViewModelOutputs {
    internal var inputs: MovieDetailsViewModelInputs { return self }
    internal var outputs: MovieDetailsViewModelOutputs { return self }
    
    var genres: [Int: String] = [:]
    var genresString: String = ""
    var dateConverted: String = ""
    var movieTitle: String = ""
    var movieOverview: String = ""
    var posterPath: String = ""
    var movieSelected: Movie = Movie()
    var delegate: MovieDetailsDelegate?
    var defaults = UserDefaults.standard
    
    func fetchGenreList() {
        if genres.isEmpty {
            MovieWorker.getGenreList(success: { genreList in
                guard let list = genreList.genres else { return }
                for item in list {
                    self.genres[item.id ?? 0] = item.name
                }
                self.getGenreString(ids: self.movieSelected.genreIds ?? [])
            }) { error in
                print("error message: \(error.errorMessage)")
        }
        }
    }
    
    func favoriteMovie(id: Int) {
        var favoriteMovies: [Int] = defaults.array(forKey: Constants.favoritesKey) as? [Int] ?? []
        
        if !favoriteMovies.contains(id) {
            favoriteMovies.append(id)
            UserDefaults.standard.set(favoriteMovies, forKey: Constants.favoritesKey)
        }
    }
    
    func getGenreString(ids: [Int]) {
        if !genres.isEmpty {
            for (index,id) in ids.enumerated() {
                genresString.append(genres[id] ?? "")
                
                if index < (ids.count-1) {
                    genresString.append(", ")
                }
            }
        }
        
        self.delegate?.resultSuccess()
    }
    
    func setMovieSelected(_ movie: Movie) {
        movieSelected = movie
        movieTitle = movie.title ?? ""
        dateConverted = convertDate(movie.releaseDate ?? "")
        movieOverview = movie.overview ?? ""
        posterPath = movie.posterPath ?? ""
    }
    
    func setMovieDetailsDelegate(_ detailsDelegate: MovieDetailsDelegate) {
        delegate = detailsDelegate
    }
    
    func convertDate(_ date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from: date)
        dateFormatter.dateFormat = "dd/MM/yyyy"
        return dateFormatter.string(from: date!)
    }
}
