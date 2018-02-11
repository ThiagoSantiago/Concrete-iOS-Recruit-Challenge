//
//  MoviesViewController.swift
//  ios-recruit-challenge
//
//  Created by Thiago Alexandre Araújo Santiago on 07/02/2018.
//  Copyright © 2018 Thiago Alexandre Araújo Santiago. All rights reserved.
//

import UIKit
import AlamofireImage
import DRPLoadingSpinner

protocol MoviesDelegate {
    func hasError()
    func startLoading()
    func finishLoading()
    func resultSuccess()
}

class MoviesViewController: UIViewController {
    @IBOutlet weak var errorView: UIView!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var notFoundView: UIView!
    @IBOutlet weak var spinner: DRPLoadingSpinner!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var viewModel: MoviesViewModelType = MoviesViewModel()
    
    override func viewDidLoad() {
        MovieHelper.configLoadingSpinner(spinner)
        
        viewModel.inputs.fetchPopularMovies()
        viewModel.inputs.setMoviesDelegate(self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.tabBarController?.title = "Filmes"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? MovieDetailViewController, let item = sender as? Movie {
            let movieDetailViewModel: MovieDetailsViewModelType = MovieDetailsViewModel()
            movieDetailViewModel.inputs.setMovieSelected(item)
            controller.movieDetailsViewModel = movieDetailViewModel
        }
    }
}

extension MoviesViewController: MoviesDelegate {
    func hasError() {
        errorView.isHidden = false
        notFoundView.isHidden = true
        collectionView.isHidden = true
        
        errorLabel.text = viewModel.outputs.errorMessage
    }
    
    func startLoading() {
        spinner.isHidden = false
    }
    
    func finishLoading() {
        spinner.isHidden = true
    }
    
    func resultSuccess() {
        errorView.isHidden = true
        notFoundView.isHidden = true
        collectionView.isHidden = false
        
        collectionView.reloadData()
    }
}

extension MoviesViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       return viewModel.outputs.popularMovies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PopularMovieCell", for: indexPath) as? PopularMovieCell
        
        let movie = viewModel.outputs.popularMovies[indexPath.row]
        let posterPath = movie.posterPath ?? ""
        let url = URL(string: "\(Constants.imageBaseUrl)\(posterPath)")
        
        cell?.movieTitle.text = movie.title
        cell?.moviePoster.af_setImage(withURL: url!, placeholderImage: UIImage(named: "placeholder"))
        
        return cell ?? UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: ((collectionView.bounds.width/2)-35.0), height: 240.0);
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.inputs.movieCellSelected(atIndex: indexPath.row)
        self.performSegue(withIdentifier: "showMovieDetailsSegue", sender: viewModel.outputs.movieSelected)
    }
}
