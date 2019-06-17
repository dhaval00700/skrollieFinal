//
//  UIView+Extensions.swift
//  Trustfund
//
//  Created by Smit Patel on 19/03/19.
//  Copyright © 2019 Smit Patel. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    func addCornerRadius(_ radius: CGFloat, maskBounds: Bool? = nil) {
        self.layer.cornerRadius = radius
        if let maskBounds = maskBounds {
            self.layer.masksToBounds = maskBounds
        }
    }
    
    func applyBorder(_ width: CGFloat, borderColor: UIColor) {
        self.layer.borderWidth = width
        self.layer.borderColor = borderColor.cgColor
    }
    
    func addShadow(color: UIColor, opacity: Float, offset: CGSize, radius: CGFloat) {
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = offset
        self.layer.shadowRadius = radius
        self.layer.masksToBounds = false
    }
    
    func addShadowWithBezierPath(color: UIColor, opacity: Float, offset: CGSize, radius: CGFloat, cornerRadius: CGFloat) {
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = offset
        self.layer.shadowRadius = radius
        self.layer.masksToBounds = false
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: cornerRadius).cgPath
    }
    
    func applyViewGradient(colors : [UIColor]) {
        let image = UIImage.gradientImageWith(size: CGSize(width: self.bounds.width, height: self.bounds.height), colors: colors)
        self.backgroundColor = UIColor.init(patternImage: image!)
    }
    
    func addSubViewWithAutolayout(subView: UIView) {
        self.addSubview(subView)
        
        subView.translatesAutoresizingMaskIntoConstraints = false
        
        if #available(iOS 11.0, *) {
            let guide = self.safeAreaLayoutGuide
            subView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
            subView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
            subView.topAnchor.constraint(equalTo: guide.topAnchor).isActive = true
            subView.bottomAnchor.constraint(equalTo: guide.bottomAnchor).isActive = true
        } else {
            subView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
            subView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
            subView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
            subView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        }
        
        subView.layoutIfNeeded()
        self.layoutIfNeeded()
    }
    
    func addShadowView() {
        //Remove previous shadow views
        superview?.viewWithTag(100)?.removeFromSuperview()
        
        //Create new shadow view with frame
        let shadowView = UIView(frame: frame)
        
        shadowView.tag = 100
        shadowView.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        shadowView.layer.shadowOffset = CGSize(width: 0.8, height: 0.8)
        shadowView.layer.masksToBounds = false
        shadowView.layer.cornerRadius = 5.0
        shadowView.layer.shadowOpacity = 0.2
        shadowView.layer.shadowRadius = 8
        shadowView.layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        shadowView.layer.rasterizationScale = 1
        shadowView.layer.shouldRasterize = false
        
        superview?.insertSubview(shadowView, belowSubview: self)
    }
    
    class func loadNib<T: UIView>(_ viewType: T.Type) -> T {
        let className = String.className(viewType)
        return Bundle(for: viewType).loadNibNamed(className, owner: nil, options: nil)!.first as! T
    }
    
    class func loadNib() -> Self {
        return loadNib(self)
    }
    
    func animateConstraintWithDuration(duration: TimeInterval = 0.5) {
        UIView.animate(withDuration: duration, animations: { [weak self] in
            self?.layoutIfNeeded() ?? ()
        })
    }
    func fadeIn() {
        
        UIView.animate(withDuration: 0.3, delay: 0.0, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.alpha = 1.0
        }, completion: nil)
    }
    func fadeOut() {
        UIView.animate(withDuration: 0.2, delay: 0.0, options: UIView.AnimationOptions.curveEaseOut, animations: {
            self.alpha = 0.0
        }, completion: nil)
    }
    func shake() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.duration = 0.6
        animation.values = [-20.0, 20.0, -20.0, 20.0, -10.0, 10.0, -5.0, 5.0, 0.0 ]
        layer.add(animation, forKey: "shake")
    }
    
    func showToastAtBottom(message: String) {
        guard !message.isEmpty else {
            return
        }
        
        var style = ToastStyle()
        
        style.messageColor = .white
        style.backgroundColor = .black
        
        self.makeToast(message, duration: 4.0, position: .bottom, style: style)
    }
    
    func showToastAtTop(message: String) {
        guard !message.isEmpty else {
            return
        }
        
        var style = ToastStyle()
        
        style.messageColor = .white
        style.backgroundColor = .black
        
        self.makeToast(message, duration: 4.0, position: .top, style: style)
    }
}
