//
//  DetailViewController.swift
//  iTunes Client App
//
//  Created by Pazarama iOS Bootcamp on 2.10.2022.
//

import UIKit

final class DetailViewController: UIViewController {
    
    var podcast: Podcast? {
        didSet {
            title = podcast?.trackName
            detailView.imageView.downloadImage(from: podcast?.artworkLarge)
            detailView.releaseDate = podcast?.releaseDate
            detailView.artistName = podcast?.artistName
            detailView.country = podcast?.country
            detailView.genres = podcast?.genres?.reduce("") { $1 + ", " + $0 }
        }
    }
    
    private let detailView = DetailView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = detailView
        
         let button = UIButton(frame: CGRect(x: 100, y: 725, width: 200, height: 50))
         button.backgroundColor = .blue
         button.setTitle("Add to Favorites", for: .normal)
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)

          self.view.addSubview(button)
    }
    @objc func buttonAction(sender: UIButton!) {
        
      }
}
