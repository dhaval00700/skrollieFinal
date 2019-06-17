//
//  UIFont+Extension.swift
//  SKROLLIE
//
//  Created by PC on 17/06/19.
//  Copyright © 2019 Dhaval Bhanderi. All rights reserved.
//

import Foundation
import UIKit

extension UIFont
{
    class func Thin(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: FontName.montserratThin.rawValue, size: size)!
    }
    class func light(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: FontName.montserratLight.rawValue, size: size)!
    }
    class func Bold(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: FontName.montserratBold.rawValue, size: size)!
    }
    class func Regular(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: FontName.montserratRegular.rawValue, size: size)!
    }
    class func Medium(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: FontName.montserratMedium.rawValue, size: size)!
    }
    
}
