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
    @IBOutlet weak var relasedYear: UILabel!
    @IBOutlet weak var directorName: UILabel!
    @IBOutlet weak var duration: UILabel!
    @IBOutlet weak var actorsNames: UILabel!
    @IBOutlet weak var moviePlot: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getMovieDetails(imdbId: selectedMoviesImdbId ?? "")
        if let url = poster {
            getMovieImage(with: url)
        }
    }
    
    private func getMovieDetails(imdbId: String) {
        
        NetworkManager.shared.fetchMovieDetails(with: selectedMoviesImdbId ?? "") { [self] response in
            DispatchQueue.main.async { [self] in
                movieGenre.text = response.genre
                relasedYear.text = "Relased Date: \(response.released ?? "")"
                duration.text = response.runtime
                directorName.text = "Directed by: \(response.director ?? "")"
                actorsNames.text = response.actors
                moviePlot.text = response.plot
            }
        }
    }
    
    private func getMovieImage(with poster: URL) {
        NetworkManager.shared.fetchImage(with: poster) { data in
            self.moviePoster.image = UIImage(data: data)
        }
    }
}
