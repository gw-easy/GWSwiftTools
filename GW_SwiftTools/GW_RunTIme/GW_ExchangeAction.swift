//
//  GW_ExchangeAction.swift
//  GW_SwiftTools
//
//  Created by zdwx on 2019/1/11.
//  Copyright © 2019 DoubleK. All rights reserved.
//

import UIKit

//runtime 方法交换
class GW_ExchangeAction: NSObject {
    @objc dynamic static func exchangeAction(cls:AnyClass?,oriSel:Selector?,swiSel:Selector?){
        guard let cls = cls, let oriSel = oriSel, let swiSel = swiSel else { return }

        guard let oriS = class_getInstanceMethod(cls, oriSel),let swiS = class_getInstanceMethod(cls, swiSel) else { return }
        
        if class_addMethod(cls, oriSel, method_getImplementation(swiS), method_getTypeEncoding(swiS)) {
            class_replaceMethod(cls, swiSel, method_getImplementation(oriS), method_getTypeEncoding(oriS))
        }else{
            method_exchangeImplementations(oriS, swiS)
        }
        
    }
}
