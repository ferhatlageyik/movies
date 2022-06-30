//
//  SearchedMoviesTableViewController.swift
//  Movies
//
//  Created by Ferhat Geyik on 30.06.2022.
//

import UIKit

class SearchedMoviesTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let cell = tableView.dequeueReusableCell(withIdentifier: "movie", for: indexPath) as! MovieTableViewCell
        
        cell.moviePoster.backgroundColor = .darkGray
        cell.movieLabel.text = "kaybolan yıllar"
        cell.movieGenre.text = "drama"
        cell.movieYear.text = "2020"
        cell.movieType.text = "Series"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }


}

