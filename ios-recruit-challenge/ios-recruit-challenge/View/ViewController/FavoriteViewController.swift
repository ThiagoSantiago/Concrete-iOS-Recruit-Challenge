//
//  FavoriteViewController.swift
//  ios-recruit-challenge
//
//  Created by Thiago Alexandre Araújo Santiago on 07/02/2018.
//  Copyright © 2018 Thiago Alexandre Araújo Santiago. All rights reserved.
//

import UIKit
import DRPLoadingSpinner

protocol FavoriteMovieDelegate {
    func startLoading()
    func finishLoading()
    func reloadTableView()
}

class FavoriteViewController: UIViewController {
    @IBOutlet weak var errorView: UIView!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var notFoundView: UIView!
    @IBOutlet weak var spinner: DRPLoadingSpinner!
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel: FavoriteMoviesViewModelType = FavoriteMoviesViewModel()
    
    override func viewDidLoad() {
        MovieHelper.configLoadingSpinner(spinner)
        
        viewModel.inputs.setFavoriteMoviesDelegate(self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.tabBarController?.title = "Favoritos"
        
        let moviesTab = self.tabBarController?.viewControllers![0] as! MoviesViewController
        viewModel.inputs.loadFavoriteMovies(moviesTab.viewModel.outputs.listOfMovies)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? MovieDetailViewController, let item = sender as? Movie {
            let movieDetailViewModel: MovieDetailsViewModelType = MovieDetailsViewModel()
            movieDetailViewModel.inputs.setMovieSelected(item)
            controller.movieDetailsViewModel = movieDetailViewModel
        }
    }
}

extension FavoriteViewController: FavoriteMovieDelegate {
    func startLoading() {
        spinner.isHidden = false
    }
    
    func finishLoading() {
        spinner.isHidden = true
    }
    
    func reloadTableView() {
        tableView.reloadData()
    }
}

extension FavoriteViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.outputs.favoriteMovies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteMovieCell", for: indexPath) as? FavoriteMovieCell
        
        let movie = viewModel.outputs.favoriteMovies[indexPath.row]
        let posterPath = movie.posterPath ?? ""
        let url = URL(string: "\(Constants.imageBaseUrl)\(posterPath)")
        
        cell?.movieTitle.text = movie.title
        cell?.movieReleaseDate.text = movie.releaseDate
        cell?.movieOverview.text = movie.overview
        cell?.moviePoster.af_setImage(withURL: url!, placeholderImage: UIImage(named: "placeholder"))
        
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.inputs.favoriteCellSelected(atIndex: indexPath.row)
        self.performSegue(withIdentifier: "showMovieDetailsFromFavoriteSegue", sender: viewModel.outputs.favoriteSelected)
    }
}
