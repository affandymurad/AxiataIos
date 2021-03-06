//
//  ViewController.swift
//  axiata
//
//  Created by docotel on 15/10/20.
//  Copyright © 2020 Affandy Murad. All rights reserved.
//


import UIKit


class genreViewCell: UITableViewCell{
    
    @IBOutlet weak var genre: UILabel!
    
}

class ViewController: BaseViewController<ViewPresenter>, MainDelegates, UITableViewDelegate, UITableViewDataSource {

    
    var genreList = Array<Genre>()
    
    @IBOutlet weak var tabelView: UITableView!
    private let refreshControl = UIRefreshControl()
    
    func loadGenreList(genres: [Genre]) {
        self.genreList = genres
        DispatchQueue.main.async {
            self.taskDidFinish()
            self.tabelView.reloadData()
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = "Genre"
        tabelView.delegate = self
        tabelView.dataSource = self
        
        presenter = ViewPresenter(view: self)
        
        presenter.getGenreList()
        
        if #available(iOS 10.0, *) {
            tabelView.refreshControl = refreshControl
        } else {
            tabelView.addSubview(refreshControl)
        }
        
        refreshControl.addTarget(self, action: #selector(refreshInfo(_:)), for: .valueChanged)

    }
    
    @objc private func refreshInfo(_ sender: Any) {
        self.genreList.removeAll()
         self.tabelView.reloadData()
                presenter.getGenreList()
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
        genreList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "genreCell", for: indexPath) as! genreViewCell
        cell.genre.text = genreList[indexPath.row].name
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        let baris = genreList[indexPath.row]
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc : GenreViewController = storyboard.instantiateViewController(withIdentifier: "GenreController") as! GenreViewController
        vc.genre = baris.id
        vc.genreName = baris.name
        self.navigationController?.pushViewController(vc, animated: true)
    }

}

