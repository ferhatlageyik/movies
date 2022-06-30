//
//  NetworkManager.swift
//  Movies
//
//  Created by Ferhat Geyik on 30.06.2022.
//

import Foundation

class NetworkManager {
    
    private  let baseURL = "https://www.omdbapi.com"
    private let apiKey = "9ca250e0"
    
    static let shared = NetworkManager()
    
    func fetchImage(with url: URL?, completion: @escaping (Data) -> Void ){
        if let url = url {
            let request = URLRequest(url: url)
            URLSession.shared.dataTask(with: request){ data, response, error in
                if let error = error {
                    debugPrint(error)
                    return
                }
                if let data = data {
                    DispatchQueue.main.async {
                        completion(data)
                    }
                }
            }.resume()
        }
    }
    
    func fetchMovieDetails(with movieId: String, completion: @escaping (MovieDetail) -> Void) {
        guard let url = URL(string: "\(baseURL)/?&apikey=\(apiKey)&i=\(movieId)") else { return }
        
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                debugPrint(error)
            }
            
            if let data = data, let response = try? JSONDecoder().decode(MovieDetail.self, from: data) {
                completion(response)
            }
            
        }.resume()
    }
    
    func fetchMovieResults(with text: String, completion: @escaping (SearchResult) -> Void) {
        guard let url = URL(string: "\(baseURL)/?&apikey=\(apiKey)&s=\(text)") else { return }
        
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                debugPrint(error)
            }
            
            if let data = data, let response = try? JSONDecoder().decode(SearchResult.self, from: data) {
                completion(response)
            }
            
        }.resume()
    }
}
