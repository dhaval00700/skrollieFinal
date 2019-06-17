//
//  UIImageView+Extension.swift
//  SKROLLIE
//
//  Created by PC on 17/06/19.
//  Copyright © 2019 Dhaval Bhanderi. All rights reserved.
//

import Foundation
import UIKit


let imageCache = NSCache<NSString, UIImage>()

extension UIImageView {
    
    public func imageFromURL(link:String!, errorImage: UIImage?, contentMode mode: UIView.ContentMode?, isCache cache: Bool = true) {
        self.image = errorImage
        self.imageFromURL(link: link, contentMode: contentMode, isCache: cache) {
            self.image = errorImage
        }
    }
    
    public func imageFromURL(link:String!, contentMode mode: UIView.ContentMode?, isCache cache: Bool = true, fallAction:@escaping (() -> Void)) {
        guard let url = URL(string: link) else {
            DispatchQueue.main.async(execute: fallAction)
            return
        }
        
        if cache {
            if let cachedImage = imageCache.object(forKey: link as NSString) {
                self.image = cachedImage
                return
            }
        }
        
        if mode != nil {
            contentMode = mode!
        }
        
        self.image = nil
        
        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            
            guard
                
                let httpURLResponse = response as? HTTPURLResponse , httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType , mimeType.hasPrefix("image"),
                let data = data , error == nil,
                let image = UIImage(data: data)
                
                else {
                    
                    DispatchQueue.main.async(execute: fallAction)
                    return
            }
            
            DispatchQueue.main.async {
                imageCache.setObject(image, forKey: link as NSString)
                self.image = image
            }
            
        }).resume()
    }
    
    func setRandomDownloadImage(_ width: Int, height: Int) {
        if self.image != nil {
            self.alpha = 1
            return
        }
        self.alpha = 0
        let url = URL(string: "http://lorempixel.com/\(width)/\(height)/")!
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 15
        configuration.timeoutIntervalForResource = 15
        configuration.requestCachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData
        let session = URLSession(configuration: configuration)
        let task = session.dataTask(with: url) { (data, response, error) in
            if error != nil {
                return
            }
            
            if let response = response as? HTTPURLResponse {
                if response.statusCode / 100 != 2 {
                    return
                }
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async(execute: { () -> Void in
                        self.image = image
                        UIView.animate(withDuration: 0.3, animations: { () -> Void in
                            self.alpha = 1
                        }, completion: { (finished: Bool) -> Void in
                        })
                    })
                }
            }
        }
        task.resume()
    }
    
    func clipParallaxEffect(_ baseImage: UIImage?, screenSize: CGSize, displayHeight: CGFloat) {
        if let baseImage = baseImage {
            if displayHeight < 0 {
                return
            }
            let aspect: CGFloat = screenSize.width / screenSize.height
            let imageSize = baseImage.size
            let imageScale: CGFloat = imageSize.height / screenSize.height
            
            let cropWidth: CGFloat = floor(aspect < 1.0 ? imageSize.width * aspect : imageSize.width)
            let cropHeight: CGFloat = floor(displayHeight * imageScale)
            
            let left: CGFloat = (imageSize.width - cropWidth) / 2
            let top: CGFloat = (imageSize.height - cropHeight) / 2
            
            let trimRect : CGRect = CGRect(x: left, y: top, width: cropWidth, height: cropHeight)
            self.image = baseImage.trim(trimRect: trimRect)
            self.frame = CGRect(x: 0, y: 0, width: screenSize.width, height: displayHeight)
        }
    }
}
