//
//  DetailViewController.swift
//  MovieViewer
//
//  Created by Gerard Recinto on 2/9/17.
//  Copyright © 2017 Gerard Recinto. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!

    var movie: NSDictionary?

    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width, height: infoView.frame.origin.y + infoView.frame.size.height)

        titleLabel.text = movie?["title"] as? String
        overviewLabel.text = movie?["overview"] as? String
        overviewLabel.sizeToFit()

        self.navigationItem.title = "Movies"

        if let posterPath = movie?["poster_path"] as? String,
           let imageUrl = URL(string: "https://image.tmdb.org/t/p/w500" + posterPath) {
            self.posterImageView.loadImage(from: imageUrl)
        }

        print(movie as Any)
    }
}
