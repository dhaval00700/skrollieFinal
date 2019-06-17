//
//  UIButton+Extension.swift
//  Trustfund
//
//  Created by Smit Patel on 19/03/19.
//  Copyright © 2019 Smit Patel. All rights reserved.
//

import Foundation
import UIKit

extension UIButton {
    
    func setBackgroundColor(_ color: UIColor?, for state: UIControl.State) {
        self.setBackgroundImage(color?.image(), for: state)
    }
    
    func makeImageLeftAligned(image: UIImage, leftMargin: CGFloat) {
        let margin = leftMargin - image.size.width / 2
        let titleRect = self.titleRect(forContentRect: self.bounds)
        let titleOffset = (bounds.width - titleRect.width - image.size.width) / 2 - margin / 2
        
        
        contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
        imageEdgeInsets = UIEdgeInsets(top: 0, left: margin, bottom: 0, right: 0)
        titleEdgeInsets = UIEdgeInsets(top: 0, left: titleOffset, bottom: 0, right: 0)
    }
    
    func centerVerticallyWithPadding(padding: CGFloat) {
        let imageSize: CGSize = (self.imageView?.frame.size)!
        let titleString: NSString = (self.titleLabel?.text)! as NSString
        let titleSize: CGSize = titleString.size(withAttributes: [NSAttributedString.Key.font: (self.titleLabel?.font)!])
        
        let totalHeight: CGFloat = imageSize.height + titleSize.height + padding
        
        self.imageEdgeInsets = UIEdgeInsets(top: -(totalHeight - imageSize.height), left: 0.0, bottom: 0.0, right: -titleSize.width)
        
        self.titleEdgeInsets = UIEdgeInsets(top: 0.0, left: -imageSize.width, bottom: -(totalHeight - titleSize.height), right: 0.0)
    }
    
    func centerVertically() {
        let kDefaultPadding: CGFloat  = 6.0;
        self.centerVerticallyWithPadding(padding: kDefaultPadding);
    }
    
    func setBackGroundColorGradient(_ colors: [UIColor]) {
        let image = UIImage.gradientImageWith(size: CGSize(width: self.frame.width, height: self.frame.height), colors: colors)
        self.clipsToBounds = true
        self.setBackgroundImage(image, for: .normal)
    }
}
