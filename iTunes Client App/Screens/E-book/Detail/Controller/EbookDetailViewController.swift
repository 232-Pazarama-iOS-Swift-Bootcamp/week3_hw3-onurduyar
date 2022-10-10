//
//  EbookDetailViewController.swift
//  iTunes Client App
//
//  Created by Onur Duyar on 10.10.2022.
//

import UIKit

final class EbookDetailViewController: UIViewController {
    
    var ebook: EBook? {
        didSet {
            title = ebook?.collectionName
            detailView.imageView.downloadImage(from: ebook?.artworkLarge)
            detailView.releaseDate = ebook?.releaseDate
            detailView.artistName = ebook?.artistName
            detailView.country = ebook?.country
            detailView.genres = ebook?.primaryGenreName
        }
    }
    
    private let detailView = EbookDetailView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = detailView
    }
}
