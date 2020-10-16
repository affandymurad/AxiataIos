//
//  UrlPhotoHandling.swift
//  axiata
//
//  Created by docotel on 15/10/20.
//  Copyright © 2020 Affandy Murad. All rights reserved.
//

import UIKit

class UrlPhotoHandling: UIImageView {
    
    let djkiBlue = UIColor(red: 41/255, green: 154/255, blue: 246/255, alpha: 1.0)
    
    var imageUrlString: String?
    
    func loadImageUsingUrlString(_ urlString: String, kata: String) {
        
        imageUrlString = urlString
        let url = URL(string: urlString)
        image = nil
        
        if let imageFromCache = imageCache.object(forKey: urlString as NSString) {
            self.image = imageFromCache
            return
        }
        
        if verifyUrl(urlString) == false {
            self.setImageForName(kata, backgroundColor: djkiBlue, circular: true, textAttributes: nil, gradient: true)
            return
        }
        
        URLSession.shared.dataTask(with: url!, completionHandler: { (data, respones, error) in
            if error != nil {
                print(error as Any)
                return
            }
            DispatchQueue.main.async(execute: {
                let imageToCache = UIImage(data: data!)
                if imageToCache != nil {
                    if self.imageUrlString == urlString {
                        self.image = imageToCache
                    }
                    imageCache.setObject(imageToCache!, forKey: urlString as NSString)
                } else {
                    self.setImageForName(kata, backgroundColor: self.djkiBlue, circular: true, textAttributes: nil, gradient: true)
                    print("Error Loading Image")
                }
            })
        }).resume()
    }
    
    func verifyUrl (_ urlString: String?) -> Bool {
        if let urlString = urlString {
            if let url = NSURL(string: urlString) {
                return UIApplication.shared.canOpenURL(url as URL)
            }
        }
        return false
    }
    
}
