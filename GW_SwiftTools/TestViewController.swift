//
//  GifTestViewController.swift
//  GW_SwiftTools
//
//  Created by zdwx on 2019/1/11.
//  Copyright © 2019 DoubleK. All rights reserved.
//

import UIKit

class TestViewController: UIViewController {

    var jumpT:jumpType = jumpType.gifTest
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.white
        switch jumpT {
        case .gifTest:
            test1()
            test2()
            break
        case .guidePageAndBannerPage:
            scrollTest()
            scrollTest2()
            VideoTest()
            break
        }
        
    }
    
    init(type:jumpType) {
        super.init(nibName: nil, bundle: nil)
        self.title = type.rawValue
        self.jumpT = type
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.dismiss(animated: true, completion: nil)
    }

    deinit {
        print("释放了")
    }
}

//gif图片展示
extension TestViewController{
    
    
    
    
    func test1() {
        let image = UIImage.gw_image(imageName: "test2.jpg")
        let imageV:UIImageView = UIImageView.init(frame: CGRect.init(x: 0, y: 100, width: 300, height: 100))
        imageV.image = image
        self.view.addSubview(imageV)
    }
    
    func test2(){
        let image = UIImage.gw_image(imageName: "test.gif")
        let imageV:UIImageView = UIImageView.init(frame: CGRect.init(x: 0, y: 300, width: 300, height: 100))
        imageV.image = image
        self.view.addSubview(imageV)
    }
}

//引导页和广告轮播
extension TestViewController{
    func scrollTest() {
        let guidePage = GW_GuidePage.init(frame: CGRect.init(x: 0, y: 100, width: 300, height: 100), imageArr: ["test2.jpg","test3.jpg"])
        self.view.addSubview(guidePage)
        guidePage.isBannerV = false
        guidePage.dataType = pageDataType.dataType_Str
        guidePage.pageC.currentPageIndicatorTintColor = UIColor.orange
        guidePage.pageC.pageIndicatorTintColor = UIColor.gray
        guidePage.selectAction = {(select:Int)->Void in
            print("选择了：\(select)")
        }
        
        guidePage.showPageV()
    }

    
    func scrollTest2() {
        let guidePage = GW_GuidePage.init(frame: CGRect.init(x: 0, y: 220, width: 300, height: 100), imageArr: ["test3.jpg","test2.jpg"])
        guidePage.backgroundColor = UIColor.red
        self.view.addSubview(guidePage)
        guidePage.isBannerV = true
        guidePage.autoScroll = false
        guidePage.dataType = pageDataType.dataType_Str
        guidePage.pageC.currentPageImageName = "小太阳.gif"
        guidePage.pageC.pageImageName = "tb4.png"
        guidePage.pageControlHeight = 40
        guidePage.pageC.pageWidth = 30
        guidePage.pageC.pageHeight = 30
        guidePage.selectAction = {(select:Int)->Void in
            print("选择了：\(select)")
        }
        
        guidePage.showPageV()
    }
    
    func VideoTest() {
        if let videoP = Bundle.main.path(forResource: "testVideo1.mp4", ofType: nil){
            let guidePage = GW_GuidePage.init(frame: CGRect.init(x: 0, y: 340, width: 300, height: 300), videoURL: URL.init(fileURLWithPath: videoP), isHiddenSkipButton: true)
            guidePage.backgroundColor = UIColor.red
            self.view.addSubview(guidePage)
            
            guidePage.showVideoView()
        }
        
    }
}
