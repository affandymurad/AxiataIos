//
//  GenreViewController.swift
//  axiata
//
//  Created by docotel on 15/10/20.
//  Copyright © 2020 Affandy Murad. All rights reserved.
//

import Foundation
import UIKit

class movieViewCell: UITableViewCell{
    
    @IBOutlet weak var ivPoster: UrlPhotoHandling!
    
    @IBOutlet weak var title: UILabel!
    
    @IBOutlet weak var date: UILabel!
    
    @IBOutlet weak var language: UILabel!
    
}

class GenreViewController: BaseViewController<GenrePresenter>, GenreDelegates, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tabelView: UITableView!
    
    private let refreshControl = UIRefreshControl()
    
    var movieList = Array<MovieList>()
    var page = 1
    var region = "US"
    var genre = 0
    var genreName = ""
    var isFinish = false
    
    func loadMovieList(movies: [MovieList]) {
        if (movies.count != 0) {
            movieList.append(contentsOf: movies)
            self.isFinish = false
        } else {
            self.isFinish = true
        }
        DispatchQueue.main.async {
            self.taskDidFinish()
              self.tabelView.reloadData()
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = self.genreName
        tabelView.delegate = self
        tabelView.dataSource = self
        
        presenter = GenrePresenter(view: self)
        
        presenter.getMovieList(region: self.region, genre: String(self.genre), pages: String(self.page))
        
        if #available(iOS 10.0, *) {
            tabelView.refreshControl = refreshControl
        } else {
            tabelView.addSubview(refreshControl)
        }
        
        refreshControl.addTarget(self, action: #selector(refreshInfo(_:)), for: .valueChanged)

    }
    
    @objc private func refreshInfo(_ sender: Any) {
        movieList.removeAll()
        tabelView.reloadData()
        self.page = 1
        presenter.getMovieList(region: self.region, genre: String(self.genre), pages: String(self.page))
       }

    func taskDidBegin() {
        self.refreshControl.endRefreshing()
        DispatchQueue.main.async {
            var indicatorView = self.navigationController?.view.viewWithTag(88) as? UIActivityIndicatorView
            if (indicatorView == nil) {
                indicatorView = UIActivityIndicatorView.init(style: .whiteLarge)
                indicatorView?.tag = 88
            }
            indicatorView?.frame = self.navigationController!.view.bounds
            indicatorView?.backgroundColor = UIColor.init(white: 0, alpha: 0.50)
            indicatorView?.startAnimating()
            indicatorView?.isHidden = false
            self.navigationController?.view.addSubview(indicatorView!)
            self.navigationController?.view.isUserInteractionEnabled = false
        }
    }
    
    
    func taskDidFinish() {
        self.refreshControl.endRefreshing()
        DispatchQueue.main.async {
            let indicatorView = self.navigationController?.view.viewWithTag(88) as? UIActivityIndicatorView
            if (indicatorView != nil) {
                indicatorView?.stopAnimating()
                indicatorView?.removeFromSuperview()
            }
            self.navigationController?.view.isUserInteractionEnabled = true
        }
    }
    
    func taskDidError(txt: String) {
        taskDidFinish()
        DispatchQueue.main.async {
            self.showAlertAction(title: "Error", message: txt)
        }
    }
    
    func showAlertAction(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        movieList.count
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "movieCell", for: indexPath) as! movieViewCell
        cell.title.text = movieList[indexPath.row].title
        
        let img = "http://image.tmdb.org/t/p/w500\(movieList[indexPath.row].poster_path ?? "")"
        let name = movieList[indexPath.row].original_title
        cell.ivPoster.loadImageUsingUrlString(img, kata: name)
        
        cell.date.text = Date.convertDateString(string: movieList[indexPath.row].release_date)
        
        let lang = Locale.current.localizedString(forLanguageCode: movieList[indexPath.row].original_language)
        cell.language.text = lang
        
        loadMore(indexPath: indexPath)
        
        return cell
    }
    
    private func loadMore(indexPath: IndexPath){
        if (indexPath.row == movieList.count - 1) && (!isFinish){
            self.page += 1
            presenter.getMovieList(region: self.region, genre: String(self.genre), pages: String(self.page))
        }
    }
    
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            self.tabelView.deselectRow(at: indexPath, animated: true)
            let baris = movieList[indexPath.row]
            let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc : DetailViewController = storyboard.instantiateViewController(withIdentifier: "DetailController") as! DetailViewController

            vc.movieId = baris.id
            vc.movieName = baris.title
            vc.overviewText = baris.overview
            vc.posterPath = baris.poster_path ?? ""
            self.navigationController?.pushViewController(vc, animated: true)
        }

}


