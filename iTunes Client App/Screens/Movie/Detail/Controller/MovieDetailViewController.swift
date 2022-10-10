//
//  MovieDetailViewController.swift
//  iTunes Client App
//
//  Created by Onur Duyar on 10.10.2022.
//

import UIKit

final class MovieDetailViewController: UIViewController {
    
    var movie: Movie? {
        didSet {
            title = movie?.trackName
            detailView.imageView.downloadImage(from: movie?.artworkLarge)
            detailView.releaseDate = movie?.releaseDate
            detailView.artistName = movie?.artistName
            detailView.country = movie?.country
            detailView.genres = movie?.primaryGenreName
        }
    }
    
    private let detailView = MovieDetailView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = detailView
    }
}
