//
//  BlockBasedSelector.swift
//
//  Created by Charlton Provatas on 19/03/19.
//  Copyright © 2017 CharltonProvatas. All rights reserved.

import Foundation
import UIKit

func Selector(_ block: @escaping () -> Void) -> Selector {
    let selector = NSSelectorFromString("\(CACurrentMediaTime())")
    class_addMethodWithBlock(anyClass: _Selector.self, newSelector: selector) {  block() }
    return selector
}

let Selector = _Selector.shared
@objc class _Selector: NSObject {
    static let shared = _Selector()
}

func class_addMethodWithBlock(anyClass: AnyClass, newSelector: Selector, block: @escaping () -> Void) {
    let blockObject = unsafeBitCast(block, to: AnyObject.self)
    let newImplementation: IMP = imp_implementationWithBlock(blockObject)
    let method: Method = class_getInstanceMethod(anyClass, newSelector)!
    class_addMethod(anyClass, newSelector, newImplementation,  method_getTypeEncoding(method))
}
