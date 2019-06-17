//
//  SkyFloatingLabelTextField+Extension.swift
//  SerwizConsumer
//
//  Created by PC on 23/03/19.
//  Copyright © 2019 PC. All rights reserved.
//

import Foundation
import SkyFloatingLabelTextField

extension SkyFloatingLabelTextField {
    func addTextFieldFloatingProperty() {
        self.placeholderColor   = #colorLiteral(red: 0.4980392157, green: 0.4980392157, blue: 0.4980392157, alpha: 1)
        self.textColor          = #colorLiteral(red: 0.07058823529, green: 0.5764705882, blue: 0.7490196078, alpha: 1)
        self.lineColor          = #colorLiteral(red: 0.4980392157, green: 0.4980392157, blue: 0.4980392157, alpha: 1)
        self.selectedLineColor  = #colorLiteral(red: 0.07058823529, green: 0.5764705882, blue: 0.7490196078, alpha: 1)
        self.titleColor         = #colorLiteral(red: 0.2941176471, green: 0.2941176471, blue: 0.2941176471, alpha: 1)
        self.selectedTitleColor = #colorLiteral(red: 0.2941176471, green: 0.2941176471, blue: 0.2941176471, alpha: 1)
        
        /*titleFormatter = { (text: String) -> String in
         return text.capitalized
         }*/
    }
}
