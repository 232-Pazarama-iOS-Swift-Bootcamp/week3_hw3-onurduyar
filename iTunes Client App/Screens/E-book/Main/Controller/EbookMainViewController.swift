//
//  EbookMainViewController.swift
//  iTunes Client App
//
//  Created by Onur Duyar on 10.10.2022.
//

import UIKit

final class EbookMainViewController: UIViewController {
    
    // MARK: - Properties
    private let mainView = EbookMainView()
    private let networkService = BaseNetworkService()
    private var eBookResponse: EbookResponse? {
        didSet {
            mainView.refresh()
        }
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "E-books"
        view = mainView
        mainView.setCollectionViewDelegate(self, andDataSource: self)
        
        let searchController = UISearchController()
        searchController.searchBar.placeholder = "Fantasy, Thriller..."
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
        
        fetchEbook()
    }
    
    // MARK: - Methods
    private func fetchEbook(with text: String = "E-book") {
        networkService.request(EbookRequest(searchText: text)) { result in
            switch result {
            case .success(let response):
                self.eBookResponse = response
            case .failure(let error):
                fatalError(error.localizedDescription)
            }
        }
    }
}

// MARK: - UICollectionViewDelegate
extension EbookMainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailViewController = EbookDetailViewController()
        detailViewController.ebook = eBookResponse?.results?[indexPath.row]
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}

// MARK: - UICollectionViewDataSource
extension EbookMainViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        eBookResponse?.results?.count ?? .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! EbookCollectionViewCell
        let ebook = eBookResponse?.results?[indexPath.row]
        cell.title = ebook?.collectionName
        cell.imageView.downloadImage(from: ebook?.artworkLarge)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        collectionView.reloadItems(at: [indexPath])
    }
}

// MARK: - UISearchResultsUpdating
extension EbookMainViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if let text = searchController.searchBar.text, text.count > 1 {
            fetchEbook(with: text)
        }
    }
}
