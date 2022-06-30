//
//  SearchedMoviesTableViewController.swift
//  Movies
//
//  Created by Ferhat Geyik on 30.06.2022.
//

import UIKit

class SearchedMoviesTableViewController: UITableViewController, UISearchResultsUpdating {
    

    private var response: SearchResult? {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    private var movieDetail: MovieDetail?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchController()
        fetchMovieResults(with: "batman")
        
    }
    
    
    private func setupSearchController() {
        let search = UISearchController(searchResultsController: nil)
        search.searchResultsUpdater = self
        search.obscuresBackgroundDuringPresentation = false
        search.searchBar.placeholder = "Type something here to search"
        navigationItem.searchController = search
    }
    
    private func fetchMovieResults(with text: String) {
        guard let url = URL(string: "https://www.omdbapi.com/?&apikey=9ca250e0&s=\(text)") else { return }
    
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                debugPrint(error)
            }
            
            if let data = data, let response = try? JSONDecoder().decode(SearchResult.self, from: data) {
                self.response = response
            }

        }.resume()
    }
    
    private func fetchMovieDetails(with movieName: String) {
        guard let url = URL(string: "https://www.omdbapi.com/?&apikey=9ca250e0&t=\(movieName)") else { return }
    
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                debugPrint(error)
            }
            
            if let data = data, let response = try? JSONDecoder().decode(MovieDetail.self, from: data) {
                self.movieDetail = response
            }

        }.resume()
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
        
        if let url = movie?.poster {
            let request = URLRequest(url: url)
            URLSession.shared.dataTask(with: request){ data, response, error in
                if let error = error {
                    debugPrint(error)
                    return
                }
                if let data = data {
                    DispatchQueue.main.async {
                        cell.moviePoster.image = UIImage(data: data)
                    }
                }
            }.resume()
        }
       
        
        cell.moviePoster.backgroundColor = .darkGray
        cell.movieLabel.text = movie?.title
        cell.movieYear.text = movie?.year
        cell.movieType.text = movie?.type?.rawValue
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "movieDetailSegue", sender: nil)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let viewController = segue.destination as? MovieDetailViewController {
            
        }
    }
    
    //MARK: - UISearchResultsUpdating
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        
        if text.count > 2 {
           fetchMovieResults(with: text)
        }
        
    }
    

}
