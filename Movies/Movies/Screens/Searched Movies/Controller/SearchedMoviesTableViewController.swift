//
//  SearchedMoviesTableViewController.swift
//  Movies
//
//  Created by Ferhat Geyik on 30.06.2022.
//

import UIKit

class SearchedMoviesTableViewController: UITableViewController {
    
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
    
  
    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let viewController = segue.destination as? MovieDetailViewController {
            viewController.selectedMoviesImdbId = selectedMoviesImdbId
            viewController.poster = poster
        }
    }
    
    //MARK: - Actions
    
    @IBAction func searchButtonTapped(_ sender: Any) {
        guard let text = navigationItem.searchController?.searchBar.text else { return }
        getSearchResults(with: text)
    }
    
    //MARK: - Functions
    
    private func getMoviesDetails(with imdbId: String) {
        NetworkManager.shared.fetchMovieDetails(with: imdbId) { response in
            self.movieDetail = response
        }
    }
    
    private func getSearchResults(with text: String) {
        NetworkManager.shared.fetchMovieResults(with: text) { response in
            DispatchQueue.main.async {
                if response.response == "False"{
                    self.showAlertInvalidMovieName()
                }else{
                    self.response = response
                }
            }
            
        }
    }
    
    private func showAlertInvalidMovieName() {
        let alert = UIAlertController(title: "Warning", message: "Please enter a valid movie name", preferredStyle: .alert)
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelButton)
        self.present(alert, animated: true, completion: nil)
        navigationItem.searchController?.searchBar.text = ""
        
    }
}

//MARK: - Extensions

extension SearchedMoviesTableViewController: UISearchResultsUpdating{
    
    func updateSearchResults(for searchController: UISearchController) {
    }
    
    
    private func setupSearchController() {
        let search = UISearchController(searchResultsController: nil)
        search.searchResultsUpdater = self
        search.obscuresBackgroundDuringPresentation = false
        search.hidesNavigationBarDuringPresentation = false
        search.searchBar.placeholder = "Type something here to search"
        navigationItem.searchController = search
    }
}

extension SearchedMoviesTableViewController {
    
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
        }
        
        cell.movieLabel.text = movieDetail?.title
        cell.movieGenre.text = movieDetail?.genre
        cell.movieType.text = movieDetail?.type
        cell.movieYear.text = movieDetail?.year
        cell.moviePlot.text = movieDetail?.plot
        
        NetworkManager.shared.fetchImage(with: self.movieDetail?.poster) { data in
                cell.moviePoster.image = UIImage(data: data)
            }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedMoviesImdbId = response?.movies?[indexPath.row].imdbID
        poster = response?.movies?[indexPath.row].poster
        performSegue(withIdentifier: "movieDetailSegue", sender: nil)
    }
}
