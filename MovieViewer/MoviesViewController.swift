//
//  MoviesViewController.swift
//  MovieViewer
//
//  Created by Gerard Recinto on 1/31/17.
//  Copyright © 2017 Gerard Recinto. All rights reserved.
//

import UIKit
import AFNetworking
import M13ProgressSuite
import MBProgressHUD

class MoviesViewController: UIViewController,UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var errorLabel: UILabel!

    lazy var searchBar = UISearchBar()
    
    var movies: [NSDictionary]?
    
    var filteredData:[NSDictionary]?
    var endpoint = String()
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.filteredData = searchText.isEmpty ? movies : movies?.filter({ (movie) -> Bool in
            (movie.value(forKey: "title") as! String).range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
        })
        self.tableView.reloadData()
        
    }
    
    // Makes a network request to get updated data
    // Updates the tableView with the new data
    // Hides the RefreshControl
    func refreshControlAction(_ refreshControl: UIRefreshControl) {
        
        // ... Create the URLRequest `myRequest` ...
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = URL(string: "https://api.themoviedb.org/3/movie/\(endpoint)?api_key=\(apiKey)")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        // Configure session so that completion handler is executed on main UI thread
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task: URLSessionDataTask = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            
            // ... Use the new data to update the data source ...
            
            // Reload the tableView now that there is new data
            self.tableView.reloadData()
            
            // Tell the refreshControl to stop spinning
            refreshControl.endRefreshing()
        }
        task.resume()
    }
    func loadDataFromNetwork() {
        
        // ... Create the NSURLRequest (myRequest) ...
        let myRequest = NSURLRequest()
        // Configure session so that completion handler is executed on main UI thread
        let session = URLSession(
            configuration: URLSessionConfiguration.default,
            delegate:nil,
            delegateQueue:OperationQueue.main
        )
        
        // Display HUD right before the request is made
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        let task : URLSessionDataTask = session.dataTask(with: myRequest as URLRequest,
                                                                      completionHandler: { (data, response, error) in
                                                                        
                                                                        // Hide HUD once the network request comes back (must be done on main UI thread)
                                                                        MBProgressHUD.hide(for: self.view, animated: true)
                                                                        
                                                                        // ... Remainder of response handling code ...
                                                                        if (error != nil){
                                                                            self.errorLabel.isHidden = false
                                                                        } else {
                                                                            self.errorLabel.isHidden = true
                                                                        }
                                                                        
                                                                        
                                                                        
        });
        task.resume()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        self.searchBar.delegate = self
    
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        // add refresh control to table view
        tableView.insertSubview(refreshControl, at: 0)
        loadDataFromNetwork()

        
        self.navigationItem.titleView  = searchBar
        
        
        definesPresentationContext = true
        
        automaticallyAdjustsScrollViewInsets = false

        // Do any additional setup after loading the view.
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = URL(string: "https://api.themoviedb.org/3/movie/\(endpoint)?api_key=\(apiKey)")
        let request = URLRequest(url: url! , cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        
        

        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        
        let task: URLSessionDataTask = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in

            if let data = data {
                if let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
                    print(dataDictionary)
                    self.movies = dataDictionary["results"]
                        as! [NSDictionary]
             
                    self.tableView.reloadData()
                }
            }
        }
        
        task.resume()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
       
        
        if self.searchBar.text!.isEmpty{
            return self.movies?.count ?? 0
        }else{
            return self.filteredData?.count ?? 0
        }
        
        
        
//        if let movies = movies {
//            return movies.count
//        } else {
//            return 0
//        }
//        return filteredData!.count

    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
        let movie =  self.searchBar.text!.isEmpty ?  movies![indexPath.row] : filteredData![indexPath.row]
        let title = movie["title"] as! String
        let overview = movie["overview"] as! String
        let baseUrl = "https://image.tmdb.org/t/p/w500"
        if let posterPath = movie["poster_path"] as? String{

        let imageUrl = URL(string: baseUrl + posterPath)
        cell.posterView.setImageWith(imageUrl!)
        }
        cell.titleLabel.text = title
        cell.overviewLabel.text = overview
        cell.backgroundColor = UIColor.brown
//        cell.textLabel?.text = filteredData[indexPath.row]

        return cell
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! UITableViewCell
        let indexPath = tableView.indexPath(for: cell)
        let movie = movies?[(indexPath?.row)!]
        let detailViewController = segue.destination as! DetailViewController
        detailViewController.movie = movie
        cell.selectionStyle = .gray
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.red
        cell.selectedBackgroundView = backgroundView

        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    

}
