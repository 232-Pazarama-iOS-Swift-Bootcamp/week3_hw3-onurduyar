//
//  MainViewController.swift
//  iTunes Client App
//
//  Created by Onur Duyar on 10.10.2022.
//

import UIKit

final class MovieMainViewController: UIViewController {
    
    // MARK: - Properties
    private let mainView = MovieMainView()
    private let networkService = BaseNetworkService()
    private var movieResponse: MovieResponse? {
        didSet {
            mainView.refresh()
        }
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Movies"
        view = mainView
        mainView.setCollectionViewDelegate(self, andDataSource: self)
        
        let searchController = UISearchController()
        searchController.searchBar.placeholder = "Comedy, Fun..."
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
        
        fetchMovies()
    }
    
    // MARK: - Methods
    private func fetchMovies(with text: String = "Movie") {
        networkService.request(MovieRequest(searchText: text)) { result in
            switch result {
            case .success(let response):
                self.movieResponse = response
            case .failure(let error):
                fatalError(error.localizedDescription)
            }
        }
    }
}

// MARK: - UICollectionViewDelegate
extension MovieMainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailViewController = MovieDetailViewController()
        detailViewController.movie = movieResponse?.results?[indexPath.row]
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}

// MARK: - UICollectionViewDataSource
extension MovieMainViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        movieResponse?.results?.count ?? .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MovieCollectionViewCell
        let movie = movieResponse?.results?[indexPath.row]
        cell.title = movie?.trackName
        cell.imageView.downloadImage(from: movie?.artworkLarge)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        collectionView.reloadItems(at: [indexPath])
    }
}

// MARK: - UISearchResultsUpdating
extension MovieMainViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if let text = searchController.searchBar.text, text.count > 1 {
            fetchMovies(with: text)
        }
    }
}

