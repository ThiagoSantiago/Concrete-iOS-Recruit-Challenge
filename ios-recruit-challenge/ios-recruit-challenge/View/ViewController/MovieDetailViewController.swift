//
//  MovieDetailViewController.swift
//  ios-recruit-challenge
//
//  Created by Thiago Alexandre Araújo Santiago on 09/02/2018.
//  Copyright © 2018 Thiago Alexandre Araújo Santiago. All rights reserved.
//

import UIKit

protocol MovieDetailsDelegate {
    func resultSuccess()
}

class MovieDetailViewController: UIViewController {
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieReleaseDate: UILabel!
    @IBOutlet weak var movieGenre: UILabel!
    @IBOutlet weak var movieOverview: UITextView!
    @IBOutlet weak var moviePoster: UIImageView!
    @IBOutlet weak var favoriteImage: UIImageView!
    
    var movie: Movie?
    var movieDetailsViewModel: MovieDetailsViewModelType?
    
    override func viewDidLoad() {
        guard let viewModel = movieDetailsViewModel else { return }
        
        viewModel.inputs.setMovieDetailsDelegate(self)
        viewModel.inputs.fetchGenreList()
        viewModel.inputs.verifyIfIsFavorite()
        
        movieTitle.text = viewModel.outputs.movieTitle
        movieReleaseDate.text = viewModel.outputs.dateConverted
        movieOverview.text = viewModel.outputs.movieOverview
        movieGenre.text = "-"
        
        if let url = URL(string: "\(Constants.imageBaseUrl)\(viewModel.outputs.posterPath)") {
            moviePoster.af_setImage(withURL: url, placeholderImage: UIImage(named: "placeholder"))
        } else {
            print("could not open url, it was nil")
        }
        
        favoriteImage.isHighlighted = viewModel.outputs.isFavorite
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        movieOverview.setContentOffset(CGPoint(x: 0, y: 7), animated: false)
    }
    
    @IBAction func favoriteMovieSelected() {
        guard let viewModel = movieDetailsViewModel else { return }
        
        if favoriteImage.isHighlighted {
            viewModel.inputs.unfavoriteMovie()
            favoriteImage.isHighlighted = false
        } else {
            viewModel.inputs.favoriteMovie()
            favoriteImage.isHighlighted = true
        }
    }
}

extension MovieDetailViewController: MovieDetailsDelegate {
    func resultSuccess() {
        movieGenre.text = movieDetailsViewModel?.outputs.genresString
    }
}
