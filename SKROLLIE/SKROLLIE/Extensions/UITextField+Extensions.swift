//
//  UITextField+Extensions.swift
//  SKROLLIE
//
//  Created by Smit Patel on 19/03/19.
//  Copyright © 2019 Smit Patel. All rights reserved.
//

import Foundation
import UIKit

extension UITextField {
    @IBInspectable var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: newValue!])
        }
    }
    
    func setBottomBorder(lineColor: UIColor, lineWidth: CGFloat) {
        self.borderStyle = .none
        self.layer.backgroundColor = UIColor.white.cgColor
        
        self.layer.masksToBounds = false
        self.layer.shadowColor = lineColor.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: lineWidth)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
    }
    
    enum Direction {
        case Left
        case Right
    }
    
    func addImage(image: UIImage, direction: Direction, width: CGFloat, height: CGFloat, contentMode: UIView.ContentMode) {
        let imageView = UIImageView()
        imageView.frame.size = CGSize(width: height, height: width)
        imageView.contentMode = contentMode
        imageView.image = image
        
        if(Direction.Left == direction){
            self.leftViewMode = .always
            self.leftView = imageView
        } else {
            self.rightView = imageView
            self.rightViewMode = .always
        }
    }
    
    func addLeftPadding(padding: CGFloat) {
        let tempView = UIView()
        tempView.frame = CGRect(x: 0, y: 0, width: padding, height: self.frame.height)
        
        self.leftView = tempView
        self.leftViewMode = .always
    }
    
    func addRightPadding(padding: CGFloat) {
        let tempView = UIView()
        tempView.frame = CGRect(x: 0, y: 0, width: padding, height: self.frame.height)
        
        self.rightView = tempView
        self.rightViewMode = .always
    }
}

var datePicker: UIDatePicker!
extension UITextField: UIPickerViewDelegate
{
    
    func addDatePicker()
    {
        
        datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.maximumDate = Date()
        
        let keyboardToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44))
        keyboardToolbar.barStyle = .black
        keyboardToolbar.tintColor = UIColor.white
        
        let barButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(clickToKeyboardToolbarDone(_:)))
        
        let flex = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        
        let items = [flex, barButtonItem]
        keyboardToolbar.setItems(items, animated: true)
        
        self.inputAccessoryView = keyboardToolbar
        
        self.inputView = datePicker
        
        
    }
    
    
    @IBAction func clickToKeyboardToolbarDone(_ sender: UIBarButtonItem)
    {
        if(self.isFirstResponder)
        {
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM dd, yyyy"
            self.text = formatter.string(from: datePicker.date)
        }
        
        self.resignFirstResponder()
    }
    
}
