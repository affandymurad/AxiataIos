//
//  GenrePresenter.swift
//  axiata
//
//  Created by docotel on 15/10/20.
//  Copyright © 2020 Affandy Murad. All rights reserved.
//

import Foundation
import UIKit

class GenrePresenter: BasePresenter<GenreDelegates> {
    var movieList: [MovieList] = []
//    let apiKey = "AIzaSyC320_WDKC2bbdwep2_WQT3Mj-dA_Pw_-o"
    let apiKey = "f002c90cf2d54e6b83801cbe9408e82b"
    
    func getMovieList(region: String, genre: String, pages: String){
        self.view.taskDidBegin()
        let url = URL(string: "https://api.themoviedb.org/3/discover/movie?api_key=\(apiKey)&region=\(region)&with_genres=\(genre)&page=\(pages)")
        let request = NSMutableURLRequest(url: url!)
        request.httpMethod = "GET"
//        request.addValue(apiKey, forHTTPHeaderField: "api_key")
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) in
            guard let _: Data = data, let _: URLResponse = response, error == nil else {
                self.view.taskDidError(txt: error?.localizedDescription ?? "Unknown")
                return
            }
            
            do{
                let movie = try JSONDecoder().decode(Movie.self, from: data!)
                self.movieList = movie.results ?? []
                self.view.loadMovieList(movies: self.movieList)
            } catch _ {
                do{
                    let errors = try JSONDecoder().decode(Errors.self, from: data!)
                    self.view.taskDidError(txt: errors.status_message)
                } catch DecodingError.keyNotFound(let key, let context) {
                      self.view.taskDidError(txt: "could not find key \(key) in JSON: \(context.debugDescription)")
                  } catch DecodingError.valueNotFound(let type, let context) {
                      self.view.taskDidError(txt: "could not find type \(type) in JSON: \(context.debugDescription)")
                  } catch DecodingError.typeMismatch(let type, let context) {
                      self.view.taskDidError(txt: "type mismatch for type \(type) in JSON: \(context.debugDescription)")
                  } catch DecodingError.dataCorrupted(let context) {
                      self.view.taskDidError(txt: "data found to be corrupted in JSON: \(context.debugDescription)")
                  } catch let error as NSError {
                      self.view.taskDidError(txt: "Error in read(from:ofType:) domain= \(error.domain), description= \(error.localizedDescription)")
                  }
            }
        })
        task.resume()
    }
}


protocol GenreDelegates: BaseDelegate {
    func loadMovieList(movies: [MovieList])
}
