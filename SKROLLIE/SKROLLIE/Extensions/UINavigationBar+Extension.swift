//
//  UINavigationBar+Extension.swift
//  SerwizConsumer
//
//  Created by PC on 25/03/19.
//  Copyright © 2019 PC. All rights reserved.
//

import Foundation
import UIKit

extension UINavigationBar
{
    func applyNavigationGradient( colors : [UIColor]) {
        var frameAndStatusBar: CGRect = ScreenSize.SCREEN_BOUNDS
        frameAndStatusBar.size.height += 20
        
        setBackgroundImage(UIImage.gradientImageWith(size: frameAndStatusBar.size, colors: colors), for: .default)
    }
}
