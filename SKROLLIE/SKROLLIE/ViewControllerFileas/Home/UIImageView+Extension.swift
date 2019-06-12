import Foundation
import UIKit

let imageCache = NSCache<NSString, UIImage>()

extension UIImageView {
    /**
     Runs the task for downloading the image by URL and after the task is successfully completed sets the image content.
     * Thread safe.
     - parameter link: The URL the image will be downloaded from.
     - parameter content: The UIViewContentMode to be set to the UIImageView if provided.
     */
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
}
