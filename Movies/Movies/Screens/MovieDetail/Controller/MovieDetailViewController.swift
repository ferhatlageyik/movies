//
//  MovieDetailViewController.swift
//  Movies
//
//  Created by Ferhat Geyik on 30.06.2022.
//

import UIKit

class MovieDetailViewController: UIViewController {

    @IBOutlet weak var moviePoster: UIImageView!
    @IBOutlet weak var movieGenre: UILabel!
    @IBOutlet weak var moviePlot: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "movie Detail"
        moviePoster.backgroundColor = .gray
        movieGenre.text = "Drama"
        moviePlot.text = "A poor village under attack by bandits recruits seven unemployed samurai to help them defend themselves Language Japanese Country Japan Awards Nominated for 2 Oscars. 5 wins & 8 nominations total"
    }
    

    

}
