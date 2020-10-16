//
//  DetailPresenter.swift
//  axiata
//
//  Created by docotel on 15/10/20.
//  Copyright © 2020 Affandy Murad. All rights reserved.
//

import Foundation
import UIKit

class DetailPresenter: BasePresenter<DetailDelegates> {
    var reviewList: [ReviewList] = []
    let apiKey = "f002c90cf2d54e6b83801cbe9408e82b"
    var movieDetail: MovieDetail?
    
    func getMovieDetail(id: String){
        self.view.taskDidBegin()
        let url = URL(string: "https://api.themoviedb.org/3/movie/\(id)?api_key=\(apiKey)&append_to_response=videos")
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
                let movieDetail = try JSONDecoder().decode(MovieDetail.self, from: data!)
                self.movieDetail = movieDetail
                self.view.loadMovieDetail(movieDetail: self.movieDetail)
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
    
        func getMovieReview(id: String){
            self.view.taskDidBegin()
            let url = URL(string: "https://api.themoviedb.org/3/movie/\(id)/reviews?api_key=\(apiKey)")
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
                    let review = try JSONDecoder().decode(Review.self, from: data!)
                    self.reviewList = review.results ?? []
                    self.view.loadMovieReviewList(reviewList: self.reviewList)
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


protocol DetailDelegates: BaseDelegate {
    func loadMovieDetail(movieDetail: MovieDetail?)
    func loadMovieReviewList(reviewList: [ReviewList]?)
}
