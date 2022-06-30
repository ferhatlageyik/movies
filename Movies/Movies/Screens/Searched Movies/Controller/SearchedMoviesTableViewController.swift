//
//  SearchedMoviesTableViewController.swift
//  Movies
//
//  Created by Ferhat Geyik on 30.06.2022.
//

import UIKit

class SearchedMoviesTableViewController: UITableViewController, UISearchResultsUpdating {
    
    //MARK: - Properties
    private var response: SearchResult? {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    private var movieDetail: MovieDetail?
    var selectedMoviesImdbId: String?
    var poster: URL?
    
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchController()
    }
    
    //MARK: - UITableViewDataSource & UITableViewDelegate
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return response?.movies?.count ?? .zero
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let movie = response?.movies?[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "movie", for: indexPath) as! MovieTableViewCell
        
        if let imdbId = movie?.imdbID {
            getMoviesDetails(with: imdbId)
            cell.movieGenre.text = movieDetail?.genre
            cell.moviePlot.text = movieDetail?.plot
        }
        
        cell.moviePoster.backgroundColor = .darkGray
        NetworkManager.shared.fetchImage(with: movie?.poster) { data in
            cell.moviePoster.image = UIImage(data: data)
        }
        
        cell.movieLabel.text = movie?.title
        cell.movieYear.text = movie?.year
        cell.movieType.text = movie?.type?.rawValue
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedMoviesImdbId = response?.movies?[indexPath.row].imdbID
        poster = response?.movies?[indexPath.row].poster
        performSegue(withIdentifier: "movieDetailSegue", sender: nil)
        
    }
    
    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let viewController = segue.destination as? MovieDetailViewController {
            viewController.selectedMoviesImdbId = selectedMoviesImdbId
            viewController.poster = poster
        }
    }
    
    //MARK: - UISearchResultsUpdating
    func updateSearchResults(for searchController: UISearchController) {
        
        guard let text = searchController.searchBar.text else { return }
        if text.count > 2 {
            getSearchResults(with: text)
        }
        
    }
    
    //MARK: - Functions
    
    private func setupSearchController() {
        let search = UISearchController(searchResultsController: nil)
        search.searchResultsUpdater = self
        search.obscuresBackgroundDuringPresentation = false
        search.searchBar.placeholder = "Type something here to search"
        navigationItem.searchController = search
    }
    
    private func getMoviesDetails(with imdbId: String) {
        NetworkManager.shared.fetchMovieDetails(with: imdbId) { response in
            self.movieDetail = response
        }
    }
    
    private func getSearchResults(with text: String) {
        NetworkManager.shared.fetchMovieResults(with: text) { response in
            self.response = response
        }
    }
}
