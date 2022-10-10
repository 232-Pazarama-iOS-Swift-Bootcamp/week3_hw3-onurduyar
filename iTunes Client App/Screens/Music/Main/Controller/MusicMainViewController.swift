//
//  MusicMainViewController.swift
//  iTunes Client App
//
//  Created by Onur Duyar on 10.10.2022.
//

import UIKit

final class MusicMainViewController: UIViewController {
    
    // MARK: - Properties
    private let mainView = MusicMainView()
    private let networkService = BaseNetworkService()
    private var musicResponse: MusicResponse? {
        didSet {
            mainView.refresh()
        }
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Musics"
        view = mainView
        mainView.setCollectionViewDelegate(self, andDataSource: self)
        
        let searchController = UISearchController()
        searchController.searchBar.placeholder = "Pop, Rock..."
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
        
        fetchMusics()
    }
    
    // MARK: - Methods
    private func fetchMusics(with text: String = "Musics") {
        networkService.request(MusicRequest(searchText: text)) { result in
            switch result {
            case .success(let response):
                self.musicResponse = response
            case .failure(let error):
                fatalError(error.localizedDescription)
            }
        }
    }
}

// MARK: - UICollectionViewDelegate
extension MusicMainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailViewController = MusicDetailViewController()
        detailViewController.music = musicResponse?.results?[indexPath.row]
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}

// MARK: - UICollectionViewDataSource
extension MusicMainViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        musicResponse?.results?.count ?? .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MusicCollectionViewCell
        let music = musicResponse?.results?[indexPath.row]
        cell.title = music?.trackName
        cell.imageView.downloadImage(from: music?.artworkLarge)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        collectionView.reloadItems(at: [indexPath])
    }
}

// MARK: - UISearchResultsUpdating
extension MusicMainViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if let text = searchController.searchBar.text, text.count > 1 {
            fetchMusics(with: text)
        }
    }
}
