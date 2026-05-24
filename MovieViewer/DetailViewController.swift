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
    var movie: NSDictionary!


    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width, height: infoView.frame.origin.y + infoView.frame.size.height)
        let title = movie["title"] as? String
        titleLabel.text = title
        let overview = movie["overview"]
        overviewLabel.text = overview as? String

        overviewLabel.sizeToFit()
        let baseUrl = "https://image.tmdb.org/t/p/w500"

        if let posterPath = movie["poster_path"] as? String{


            let smallImageUrl = URL(string: "https://image.tmdb.org/t/p/w45" + posterPath)
            let largeImageUrl = URL(string: "https://image.tmdb.org/t/p/original" + posterPath)
            let smallImageRequest = NSURLRequest(url: smallImageUrl!)
            let largeImageRequest = NSURLRequest(url: largeImageUrl!)
            self.navigationItem.title = "Movies"
            if let navigationBar = navigationController?.navigationBar {
                //  navigationBar.setBackgroundImage(UIImage(named: "star"), for: .default)
                let shadow = NSShadow()
                shadow.shadowColor = UIColor.gray.withAlphaComponent(0.5)
                shadow.shadowOffset = CGSize(width: 2, height: 2)
                // shadow.shadowOffset = CGSizeMake(2, 2)
                shadow.shadowBlurRadius = 4
                navigationBar.titleTextAttributes = [
                    NSFontAttributeName : UIFont.boldSystemFont(ofSize: 22),
                    NSForegroundColorAttributeName : UIColor(red: 0.5, green: 0.15, blue: 0.15, alpha: 0.8),
                    NSShadowAttributeName : shadow
                ]
            }



            self.posterImageView.loadImage(from: imageUrl!)
                    })
            },
                failure: { (request, response, error) -> Void in
                    // do something for the failure condition
                    // possibly try to get the large image
            })

            //let imageUrl = URL(string: baseUrl + posterPath)
            //posterImageView.loadImage(from: imageUrl!)



        }

        print(movie)
        // Do any additional setup after loading the view.
    }



    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
