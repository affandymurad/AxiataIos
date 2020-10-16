//
//  DetailViewController.swift
//  axiata
//
//  Created by docotel on 15/10/20.
//  Copyright © 2020 Affandy Murad. All rights reserved.
//

import Foundation
import UIKit

class videoViewCell: UITableViewCell {
    
    @IBOutlet weak var ivVideo: UrlPhotoHandling!
    @IBOutlet weak var title: UILabel!
}

class reviewViewCell: UITableViewCell {
    
    @IBOutlet weak var author: UILabel!
    @IBOutlet weak var content: UILabel!
}


class DetailViewController: BaseViewController<DetailPresenter>, DetailDelegates, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tabelView: UITableView!
    
    @IBOutlet weak var tabelView2: UITableView!
    
    @IBOutlet weak var movieTitle: UILabel!
    
    @IBOutlet weak var overview: UILabel!
    
    @IBOutlet weak var ivPoster: UrlPhotoHandling!
    
    
    func loadMovieDetail(movieDetail: MovieDetail?) {
        self.videoList = movieDetail?.videos.results ?? []
        
        presenter.getMovieReview(id: String(self.movieId))
        DispatchQueue.main.async {
            self.tabelView.reloadData()
            self.overview.numberOfLines = 0
            self.overview.sizeToFit()
            
        }
        
        
    }
    
    func loadMovieReviewList(reviewList: [ReviewList]?) {
        self.reviewList = reviewList ?? []
        DispatchQueue.main.async {
            self.taskDidFinish()
            self.tabelView2.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tabelView {
            return videoList.count
        } else {
            return reviewList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == tabelView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "videoCell", for: indexPath) as! videoViewCell
            cell.title.text = videoList[indexPath.row].name
            let youtubeUrl = "http://img.youtube.com/vi/\(videoList[indexPath.row].key)/default.jpg"
//            let url = URL(string: youtubeUrl)
            
            let name = videoList[indexPath.row].name
            cell.ivVideo.loadImageUsingUrlString(youtubeUrl, kata: name)
            
            
            cell.title.numberOfLines = 0
            cell.title.sizeToFit()
            
            cell.separatorInset = .zero
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "reviewCell", for: indexPath) as! reviewViewCell
            cell.author.text = reviewList[indexPath.row].author
            cell.content.text = reviewList[indexPath.row].content
            
            cell.content.numberOfLines = 0
            cell.content.sizeToFit()
            
            cell.separatorInset = .zero
            return cell
        }
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == tabelView {
            tableView.deselectRow(at: indexPath as IndexPath, animated: true)
            let baris = videoList[indexPath.row]
            let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc : VideoController = storyboard.instantiateViewController(withIdentifier: "Videos") as! VideoController
            vc.data = baris.key
            self.navigationController?.pushViewController(vc, animated: true)
        } else if tableView == tabelView2 {
            tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        }
    }
    
    
    var videoList = Array<VideoList>()
    var reviewList = Array<ReviewList>()
    var movieId = 0
    var movieName = ""
    var overviewText = ""
    var posterPath = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = "Detail"
        tabelView.delegate = self
        tabelView.dataSource = self
        tabelView2.delegate = self
        tabelView2.dataSource = self
        
        movieTitle.text = self.movieName
        overview.text = self.overviewText
        
        overview.numberOfLines = 0
        overview.sizeToFit()
        
        let img = "http://image.tmdb.org/t/p/w500\(posterPath)"
        ivPoster.loadImageUsingUrlString(img, kata: movieName)
        
        presenter = DetailPresenter(view: self)
        
        presenter.getMovieDetail(id: String(self.movieId))

    }
    
    func taskDidBegin() {
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
    

}
