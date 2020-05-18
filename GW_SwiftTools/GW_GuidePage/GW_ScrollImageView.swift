//
//  GW_ScrollImageView.swift
//  GW_SwiftTools
//
//  Created by zdwx on 2019/1/12.
//  Copyright © 2019 DoubleK. All rights reserved.
//

import UIKit

class GW_ScrollImageView: UIImageView {
//    target
    private var target:AnyObject!
//    sel
    private var sel:Selector!
    
    func addTarget(target:AnyObject,sel:Selector) {
        self.target = target
        self.sel = sel
        self.isUserInteractionEnabled = true
        self.contentMode = UIView.ContentMode.scaleAspectFill
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if self.target.responds(to: self.sel) {
            self.target.performSelector(inBackground: self.sel, with: self)
        }
    }
}

