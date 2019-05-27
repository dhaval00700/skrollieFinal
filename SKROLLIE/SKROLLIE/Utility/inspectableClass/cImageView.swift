//
//  cImageView.swift
//  RatherMe
//
//  Created by Swami on 12/24/16.
//  Copyright © 2016 brainstorm. All rights reserved.
//

import UIKit

class cImageView: UIImageView
{

    @IBInspectable var cornerRadius: CGFloat = 0.0
        {
        didSet
        {
            self.layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.white
        {
        didSet
        {
            self.layer.borderColor = borderColor.cgColor
        }
    }
    @IBInspectable var borderWidth: CGFloat = 0.0
        {
        didSet
        {
            self.layer.borderWidth = borderWidth
        }
    }

}
