//
//  SVPinView+Extension.swift
//  Trustfund
//
//  Created by Smit Patel on 19/03/19.
//  Copyright © 2019 Smit Patel. All rights reserved.
//

import Foundation
import SVPinView

extension SVPinView {
    func setupDefaultTheme(pinLength: Int, secureText: Bool) {
        self.font = UIFont(name: FontName.montserratMedium.rawValue, size: 18)!
        self.shouldSecureText = secureText
        self.borderLineThickness = 0.3
        self.activeBorderLineThickness = 0.3
        self.becomeFirstResponderAtIndex = 0
        self.pinLength = pinLength
        self.pinInputAccessoryView = nil
    }
}
