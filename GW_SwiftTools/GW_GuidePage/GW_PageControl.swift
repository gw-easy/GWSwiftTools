//
//  GW_PageControl.swift
//  GW_SwiftTools
//
//  Created by zdwx on 2019/1/12.
//  Copyright © 2019 DoubleK. All rights reserved.
//

import UIKit

class GW_PageControl: UIPageControl {
    
    //按钮宽度
    public var pageWidth:CGFloat = 7
    //按钮高度
    public var pageHeight:CGFloat = 7
    //按钮之间间距
    public var pageMagrin:CGFloat = 5
    
    //MARK: 如果使用图片-必须保证底部图片和当前图片同时存在，否则报错
    //pageControl底部图片
    var pageImageName:String = ""{
        willSet{
            setValue(UIImage.gw_image(imageContentsOfFile: newValue), forKey: "_pageImage")
        }
    }
    //pageControl当前图片
    var currentPageImageName:String = ""{
        willSet{
            setValue(UIImage.gw_image(imageContentsOfFile: newValue), forKey: "_currentPageImage")
        }
    }
    
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        //计算圆点间距
        let marginX = self.pageWidth + self.pageMagrin;
        
        //计算整个pageControl的宽度
        let newW = CGFloat(self.subviews.count) * marginX - self.pageMagrin;
        
        //设置新frame
        self.frame = CGRect.init(x: self.frame.origin.x, y: self.frame.origin.y, width: newW, height: self.frame.size.height)
        
        //设置居中
        if let sizeW = self.superview?.frame.size.width{
            var center = self.center;
            center.x = sizeW/2;
            self.center = center;
        }
        
        
        //遍历subview,设置圆点frame
        for i in 0..<self.subviews.count {
            let pageImage = self.subviews[i];
            pageImage.frame = CGRect.init(x: CGFloat(i) * marginX, y: self.frame.size.height/2-self.pageHeight/2, width: self.pageWidth, height: self.pageHeight)
            print(pageImage.frame)
            
        }
        
    }
}
