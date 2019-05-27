//
//  cSlider.swift
//  RatherMe
//
//  Created by Swami on 11/08/17.
//  Copyright © 2017 brainstorm. All rights reserved.
//

import UIKit

class cSlider: UISlider {

    override func trackRect(forBounds bounds: CGRect) -> CGRect {
        var newBounds = super.trackRect(forBounds: bounds)
        newBounds.size.height = 4
        return newBounds
    }

}
