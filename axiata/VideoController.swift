//
//  VideoController.swift
//  axiata
//
//  Created by docotel on 16/10/20.
//  Copyright © 2020 Affandy Murad. All rights reserved.
//

import UIKit
import WebKit
import AVKit

class VideoController: UIViewController {
    
    var data = ""
    var webView: WKWebView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let webView = WKWebView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
         self.view.addSubview(webView)
         let url = URL(string: "https://www.youtube.com/embed/\(data)")
         webView.load(URLRequest(url: url!))
        
    }
    
    
    
    
}
