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
    func noResultFound()
    func resultSuccess()
}

class FavoriteViewController: UIViewController {
    @IBOutlet weak var errorView: UIView!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var notFoundView: UIView!
    @IBOutlet weak var spinner: DRPLoadingSpinner!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
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
    
    func resultSuccess() {
        errorView.isHidden = true
        notFoundView.isHidden = true
        tableView.isHidden = false
        
        self.searchBar.resignFirstResponder()
        tableView.reloadData()
    }
    
    func noResultFound() {
        errorView.isHidden = true
        notFoundView.isHidden = false
        tableView.isHidden = true
        
        searchBar.resignFirstResponder()
    }
}

extension FavoriteViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        viewModel.inputs.notSearchingBehavior()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        viewModel.inputs.searchMovies(text: searchBar.text ?? "")
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let trimmedString = searchText.trimmingCharacters(in: .whitespaces)
        if trimmedString.isEmpty {
            viewModel.inputs.notSearchingBehavior()
        }
    }
}

extension FavoriteViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.outputs.listOfMovies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteMovieCell", for: indexPath) as? FavoriteMovieCell
        
        viewModel.inputs.setContentFor(index: indexPath.row)
        let posterPath = viewModel.outputs.posterPath
        let url = URL(string: "\(Constants.imageBaseUrl)\(posterPath)")
        
        cell?.movieTitle.text = viewModel.outputs.movieTitle
        cell?.movieReleaseDate.text = viewModel.outputs.dateConverted
        cell?.movieOverview.text = viewModel.outputs.movieOverview
        cell?.moviePoster.af_setImage(withURL: url!, placeholderImage: UIImage(named: "placeholder"))
        
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.inputs.favoriteCellSelected(atIndex: indexPath.row)
        self.performSegue(withIdentifier: "showMovieDetailsFromFavoriteSegue", sender: viewModel.outputs.favoriteSelected)
    }
}
