//
//  cSegment.swift
//  RatherMe
//
//  Created by Swami on 17/07/17.
//  Copyright © 2017 brainstorm. All rights reserved.
//

import UIKit

class cSegment: UISegmentedControl {

    @IBInspectable var height1: CGFloat = 29
        {
        didSet
        {
            let centerSave = center
            frame = CGRect(x: frame.minX, y: frame.minY, width: frame.width, height: height1)
            center = centerSave
        }
    }
}
