//
//  MovieDetailViewController.swift
//  Movies
//
//  Created by Ferhat Geyik on 30.06.2022.
//

import UIKit

class MovieDetailViewController: UIViewController {
    
    var selectedMoviesImdbId: String?
    var poster: URL?
    var selectedMovie: MovieDetail?
    let networkManager = NetworkManager()
    
    @IBOutlet weak var moviePoster: UIImageView!
    @IBOutlet weak var movieGenre: UILabel!
    @IBOutlet weak var moviePlot: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getMovieDetails(imdb: selectedMoviesImdbId ?? "")
        if let url = poster {
            getMovieImage(with: url)
            
        }
    }
    
    private func getMovieDetails(imdb: String) {
        NetworkManager.shared.fetchMovieDetails(with: self.selectedMoviesImdbId ?? "") { response in
            DispatchQueue.main.async {
                self.movieGenre.text = response.genre
                self.moviePlot.text = response.plot
            }
            
        }
        
    }
    
    private func getMovieImage(with poster: URL) {
        NetworkManager.shared.fetchImage(with: poster) { data in
            DispatchQueue.main.async {
                self.moviePoster.image = UIImage(data: data)
            }
            
        }
    }
    
}
