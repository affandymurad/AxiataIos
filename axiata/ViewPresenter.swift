//
//  ViewPresenter.swift
//  axiata
//
//  Created by docotel on 15/10/20.
//  Copyright © 2020 Affandy Murad. All rights reserved.
//

import Foundation
import UIKit

class ViewPresenter: BasePresenter<MainDelegates> {
    var genreList: [Genre] = []
//    let apiKey = "AIzaSyC320_WDKC2bbdwep2_WQT3Mj-dA_Pw_-o"
    let apiKey = "f002c90cf2d54e6b83801cbe9408e82b"
    
    func getGenreList(){
        self.view.taskDidBegin()
        let url = URL(string: "https://api.themoviedb.org/3/genre/movie/list?api_key=\(apiKey)")
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
                let genre = try JSONDecoder().decode(Respon.self, from: data!)
                self.genreList = genre.genres
                self.view.loadGenreList(genres: self.genreList)
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


protocol MainDelegates: BaseDelegate {
    func loadGenreList(genres: [Genre])
}
