//
//  MoviesViewController.swift
//  MovieViewer
//
//  Created by Gerard Recinto on 1/31/17.
//  Copyright © 2017 Gerard Recinto. All rights reserved.
//

import UIKit

@MainActor
class MoviesViewController: UIViewController, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var errorLabel: UILabel!

    private lazy var searchBar = UISearchBar()
    private var movies: [[String: Any]] = []
    private var filteredMovies: [[String: Any]] = []
    var endpoint = "now_playing"

    private let apiKey = ProcessInfo.processInfo.environment["TMDB_API_KEY"] ?? ""
    private let baseURL = "https://api.themoviedb.org/3/movie/"

    private var isSearching: Bool {
        !(searchBar.text?.isEmpty ?? true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 120
        searchBar.delegate = self
        navigationItem.titleView = searchBar

        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: .valueChanged)
        tableView.insertSubview(refreshControl, at: 0)

        fetchMovies()
    }

    @objc private func refreshControlAction(_ refreshControl: UIRefreshControl) {
        Task {
            await fetchMoviesAsync()
            refreshControl.endRefreshing()
        }
    }

    private func fetchMovies() {
        Task { await fetchMoviesAsync() }
    }

    private func fetchMoviesAsync() async {
        guard !apiKey.isEmpty,
              let url = URL(string: "\(baseURL)\(endpoint)?api_key=\(apiKey)") else { return }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            guard let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                  let results = json["results"] as? [[String: Any]] else {
                errorLabel.isHidden = false
                return
            }
            movies = results
            filteredMovies = results
            errorLabel.isHidden = true
            tableView.reloadData()
        } catch {
            errorLabel.isHidden = false
        }
    }

    // MARK: - UISearchBarDelegate

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredMovies = searchText.isEmpty ? movies : movies.filter {
            ($0["title"] as? String ?? "").localizedCaseInsensitiveContains(searchText)
        }
        tableView.reloadData()
    }

    // MARK: - UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        isSearching ? filteredMovies.count : movies.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
        let movie = isSearching ? filteredMovies[indexPath.row] : movies[indexPath.row]
        cell.titleLabel.text = movie["title"] as? String
        cell.overviewLabel.text = movie["overview"] as? String
        if let posterPath = movie["poster_path"] as? String,
           let url = URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)") {
            cell.posterView.loadImage(from: url)
        }
        return cell
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let cell = sender as? UITableViewCell,
              let indexPath = tableView.indexPath(for: cell) else { return }
        let movie = isSearching ? filteredMovies[indexPath.row] : movies[indexPath.row]
        let detailVC = segue.destination as! DetailViewController
        detailVC.movie = movie
    }
}
