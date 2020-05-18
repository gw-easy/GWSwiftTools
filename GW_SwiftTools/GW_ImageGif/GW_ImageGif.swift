//
//  GW_ImageGif.swift
//  GW_SwiftTools
//
//  Created by zdwx on 2019/1/11.
//  Copyright © 2019 DoubleK. All rights reserved.
//

import UIKit
import MobileCoreServices

extension UIImage{
    
    class func gw_image(imageName:String)->UIImage?{
        if let path = Bundle.main.path(forResource: imageName, ofType: nil),
            let data = try? Data.init(contentsOf: URL.init(fileURLWithPath: path)){
            return gw_image(imageData: data);
        }
        return nil;
    }
    
    class func gw_image(imageContentsOfFile:String)->UIImage?{
        if let data = try? Data.init(contentsOf: URL.init(fileURLWithPath: imageContentsOfFile)) {
            return gw_image(imageData: data);
        }else{
            return gw_image(imageName:imageContentsOfFile)
        }
    }
    
    class func gw_image(imageData:Data?)->UIImage?{
        return gw_image(imageData: imageData, scale: UIScreen.main.scale);
    }
    
    class func gw_image(imageData:Data?, scale:CGFloat)->UIImage?{
        if let data = imageData {
            return gw_image(imageData: data, scale: scale, duration: 0)
        }
        return nil;
    }
    
    class func gw_image(imageData:Data, scale:CGFloat,duration:TimeInterval)->UIImage?{
        if gifDataIsValid(data: imageData) {
            return imageWithData(data: imageData, scale: scale, duration: duration, error: nil)
        }
        return UIImage.init(data: imageData);
    }
    
    private class func imageWithData(data:Data,scale:CGFloat,duration:TimeInterval,error:Error?) -> UIImage? {
        var dic = Dictionary<String,Any>();
        dic[kCGImageSourceShouldCache as String] = true;
        dic[kCGImageSourceTypeIdentifierHint as String] = kUTTypeGIF as String;
        guard let source = CGImageSourceCreateWithData(data as CFData, dic as CFDictionary) else {
            print("image doesn't exist")
            return nil
        }
        
        let count = CGImageSourceGetCount(source)
        var images = [UIImage]()
        var delay:TimeInterval = 0.0
        
        // Seconds to ms
        for i in 0..<count {
            if let image = CGImageSourceCreateImageAtIndex(source, i, dic as CFDictionary){
                images.append(UIImage.init(cgImage: image, scale: scale, orientation: UIImage.Orientation.up))
            }
            
            let cfProperties = CGImageSourceCopyPropertiesAtIndex(source, i, nil) as? Dictionary<String, AnyObject>
            
            if let gifDic = cfProperties?[kCGImagePropertyGIFDictionary as String],let gifDT = gifDic[kCGImagePropertyGIFDelayTime as String],let del = gifDT as? Double{
                delay += del
            }
        }
        
        if images.count == 1 {
            return images.first
        }else{
            return UIImage.animatedImage(with: images, duration: duration <= 0.0 ?delay : duration)
        }
    }
    
    //    是否是gif图
    private class func gifDataIsValid(data:Data)->Bool{
        let bytes = [UInt8](data)
        if bytes.count > 4 {
            //判断是否是gif格式
            return bytes[0] == 0x47 && bytes[1] == 0x49 && bytes[2] == 0x46;
        }
        return false;
    }
}


