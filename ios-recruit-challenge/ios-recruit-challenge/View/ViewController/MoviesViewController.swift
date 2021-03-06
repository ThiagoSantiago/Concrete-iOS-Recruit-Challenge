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
    func noResultsFound()
    func startLoadingMore()
    func finishLoadingMore()
}

class MoviesViewController: UIViewController {
    @IBOutlet weak var errorView: UIView!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var notFoundView: UIView!
    @IBOutlet weak var spinner: DRPLoadingSpinner!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var loadMoreView: UIView!
    @IBOutlet weak var loadMoreSpinner: DRPLoadingSpinner!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var viewModel: MoviesViewModelType = MoviesViewModel()
    
    override func viewDidLoad() {
        MovieHelper.configLoadingSpinner(spinner)
        MovieHelper.configLoadingSpinner(loadMoreSpinner)
        
        viewModel.inputs.fetchPopularMovies()
        viewModel.inputs.setMoviesDelegate(self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.tabBarController?.title = "Filmes"
        self.collectionView.reloadData()
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
    
    func startLoadingMore() {
        loadMoreView.isHidden = false
    }
    
    func finishLoadingMore() {
        loadMoreView.isHidden = true
    }
    
    func finishLoading() {
        spinner.isHidden = true
    }
    
    func noResultsFound() {
        errorView.isHidden = true
        notFoundView.isHidden = false
        collectionView.isHidden = true
        
        self.searchBar.resignFirstResponder()
    }
    
    func resultSuccess() {
        errorView.isHidden = true
        notFoundView.isHidden = true
        collectionView.isHidden = false
        
        self.searchBar.resignFirstResponder()
        collectionView.reloadData()
    }
}

extension MoviesViewController: UISearchBarDelegate {
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

extension MoviesViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       return viewModel.outputs.listOfMovies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PopularMovieCell", for: indexPath) as? PopularMovieCell
        
        viewModel.inputs.setContentFor(index: indexPath.row)
        viewModel.inputs.verifyIfIsFavorite(index: indexPath.row)
        
        let posterPath = viewModel.outputs.posterPath
        let url = URL(string: "\(Constants.imageBaseUrl)\(posterPath)")
        
        cell?.movieTitle.text = viewModel.outputs.movieTitle
        cell?.moviePoster.af_setImage(withURL: url!, placeholderImage: UIImage(named: "placeholder"))
        
        if viewModel.outputs.isFavorite {
            cell?.favoriteView.image = UIImage(named: "favorite_full_icon")
        } else {
            cell?.favoriteView.image = UIImage(named: "favorite_empty_icon")
        }
        
        return cell ?? UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: ((collectionView.bounds.width/2)-35.0), height: 240.0);
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.inputs.movieCellSelected(atIndex: indexPath.row)
        self.performSegue(withIdentifier: "showMovieDetailsSegue", sender: viewModel.outputs.movieSelected)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let lastItem = (viewModel.outputs.listOfMovies.count)-1
        
        if indexPath.row == lastItem && !viewModel.outputs.isSearching{
            viewModel.inputs.fetchMorePopularMovies()
        }
    }
}
