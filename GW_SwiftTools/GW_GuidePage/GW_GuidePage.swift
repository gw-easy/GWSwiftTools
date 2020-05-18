//
//  GW_GuidePage.swift
//  GW_SwiftTools
//
//  Created by zdwx on 2019/1/12.
//  Copyright © 2019 DoubleK. All rights reserved.
//

import UIKit
import Kingfisher
import AVKit
typealias gwScrollViewSelectAction = (Int)->()

enum pageDataType{
    //    图片路径(默认)
    case dataType_Str
    //    请求地址
    case dataType_Url
    //    图片
    case dataType_Image
}

class GW_GuidePage: UIView {
    //  图片或者gif图数组
    var imageArr = [Any]()
//    数据类型
    var dataType:pageDataType = pageDataType.dataType_Str
//    点击图片闭包
    var selectAction:gwScrollViewSelectAction?
//    定时器
    var timer:Timer?
//    是否是广告 false引导页 true广告
    var isBannerV = false{
        willSet{
            if newValue {
                autoScroll = true
            }
        }
    }
    
    //MARK: scrollview
    // 是否显示pageControl
    var showPageControl:Bool = true
    //定义scroll高度
    var scrollHeight:CGFloat = 0
    // 是否自动滚动
    var autoScroll:Bool = false
    //滚动时间间隔
    var autoTime:TimeInterval = 2
    //placeholderImage 默认图片姓名
    var defaultImageName:String = ""
    //    scrollView
    lazy var scrollV:UIScrollView = {
        let scrollV = UIScrollView.init(frame: self.bounds)
        scrollV.contentSize = CGSize(width: CGFloat(self.imageArr.count) * scrollV.bounds.size.width, height: scrollV.bounds.size.height)
        scrollV.bounces = true
        scrollV.isPagingEnabled = true
        scrollV.showsVerticalScrollIndicator = false
        scrollV.showsHorizontalScrollIndicator = false
        scrollV.delegate = self;
        self.addSubview(scrollV)
        return scrollV
    }()
    
    //MARK: pageControl
    //pageControl高度
    var pageControlHeight:CGFloat = 0
//    page当前页面
    var curPage:Int = 0
//    pageControl
    lazy var pageC:GW_PageControl = {
        let page = GW_PageControl.init(frame: CGRect.init(x: 0, y: self.bounds.size.height-40, width: self.bounds.size.width, height: 30))
        page.currentPage = 0
        page.numberOfPages = self.imageArr.count
        page.pageIndicatorTintColor = UIColor.blue
        page.currentPageIndicatorTintColor = UIColor.white
        page.addTarget(self, action: #selector(pageControlClickAction), for: UIControl.Event.valueChanged)
        self.addSubview(page)
        return page
    }()
    
    //MARK: 视频引导页
//    视频url地址
    var videoURL:URL!
//    是否隐藏按钮
    var isHiddenSkipButton:Bool = false
    
//    avplayer
    var playerLayer:AVPlayerLayer!
    var playerItem:AVPlayerItem!
    var avPlayer:AVPlayer!
    
//    进入按钮
    lazy var enterBtn:UIButton = {
        let ent = UIButton.init(type: UIButton.ButtonType.custom)
        ent.setTitle("进入", for: UIControl.State.normal)
        ent.backgroundColor = UIColor.orange
        ent.layer.cornerRadius = 5
        ent.clipsToBounds = true
        return ent
    }()
    
//    跳过按钮
    lazy var jumpBtn:UIButton = {
        let ent = UIButton.init(type: UIButton.ButtonType.custom)
        ent.setTitle("跳过", for: UIControl.State.normal)
        ent.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        ent.backgroundColor = UIColor.orange
        ent.layer.cornerRadius = 5
        ent.clipsToBounds = true
        return ent
    }()
    
//    初始化scroll数据
    init(frame:CGRect, imageArr:[Any]){
        super.init(frame: frame)
        self.imageArr = imageArr
    }

//    初始化视频播放器
    init(frame:CGRect, videoURL: URL, isHiddenSkipButton: Bool) {
        super.init(frame: frame)
        self.videoURL = videoURL
        self.isHiddenSkipButton = isHiddenSkipButton
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: 显示banner或者引导页UI
extension GW_GuidePage{
    //MARK: 显示banner或者引导页数据
    func showPageV() {
        if imageArr.count == 0{
            print("没有数据")
            return
        }
        addScrollV()
        addPageControl()
        bannerAddImage()
        //        添加图片
        addSubviewImage()
        //        设置定时器
        addTimer()
        //        把pageview提到最前
        self.bringSubviewToFront(pageC)
    }
    
    func addScrollV() {
        if scrollHeight > 0{
            self.scrollV.frame = CGRect.init(x: 0, y: 0, width: self.bounds.size.width, height: scrollHeight)
        }
        
        if imageArr.count < 2 {
            self.scrollV.isScrollEnabled = false
        }
    }
    
    func addPageControl() {
        if pageControlHeight > 0{
            var pageSize = self.pageC.frame.size
            pageSize.height = pageControlHeight
            self.pageC.frame.size = pageSize
        }
        if imageArr.count < 2{
            self.pageC.isHidden = true
        }
    }
    
//    广告添加图片
    func bannerAddImage() {
        if autoScroll && isBannerV{
            guard let firstImage = imageArr.first,let lastImage = imageArr.last else{
                return
            }
            imageArr.insert(lastImage, at: 0)
            imageArr.append(firstImage)
            scrollV.bounces = false
        }
    }
    
    func addSubviewImage() {
        for i in 0..<imageArr.count {
            let slideImage = GW_ScrollImageView()
            switch dataType{
            case .dataType_Str:
                if let imStr = imageArr[i] as? String{
                    slideImage.image = UIImage.gw_image(imageContentsOfFile: imStr)
                }
                break
            case .dataType_Url:
                if let imageS = imageArr[i] as? String,let url = URL.init(string: imageS){
                    slideImage.kf.setImage(with: ImageResource(downloadURL: url), placeholder: UIImage.gw_image(imageContentsOfFile: self.defaultImageName), options: nil, progressBlock: nil, completionHandler: nil)
                }
                break
            case .dataType_Image:
                if let im = imageArr[i] as? UIImage{
                    slideImage.image = im
                }
                break
            }
            slideImage.frame = CGRect.init(x: CGFloat(i) * scrollV.bounds.size.width, y: 0, width: scrollV.bounds.size.width, height: scrollV.bounds.size.height)
            scrollV.addSubview(slideImage)
            
            if isBannerV{
                if (i != 0 && i != imageArr.count-1) {
                    slideImage.tag = i-1;
                }
                slideImage.addTarget(target: self, sel: #selector(imageAction))
            }else if i == imageArr.count-1 {
//                这里添加进入btn
//                slideImage.addSubview(enterBtn)
            }
            
        }
    }
    
//    图片点击事件
    @objc func imageAction(imageV:UIImageView) {
        if let sele = selectAction {
            DispatchQueue.main.async {
                sele(imageV.tag)
            }
        }
    }
    
    
}

//MARK: 设置定时器
extension GW_GuidePage{
//    添加定时器
    func addTimer() {
        //        定时器
        if imageArr.count>3 && autoScroll{
            if timer != nil{
                stopTimer()
            }
            timer = Timer.init(timeInterval: autoTime, target: self, selector: #selector(timeAction), userInfo: nil, repeats: true)
            RunLoop.main.add(timer!, forMode: RunLoop.Mode.common)
        }
    }
    
    @objc func timeAction() {
        var page = pageC.currentPage
        page += 1
        turnPage(page: page)
    }
//    停止定时器
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
}

//MARK: 显示视频引导页
extension GW_GuidePage{
    func showVideoView() {
        playerItem = AVPlayerItem(url: videoURL)
        avPlayer = AVPlayer(playerItem: playerItem)
        playerLayer = AVPlayerLayer(player: avPlayer)
        playerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        playerLayer.contentsScale = UIScreen.main.scale
        playerLayer.frame = self.bounds
        self.layer.insertSublayer(playerLayer, at: 0)
        play()
        //注册通知-循环播放 不需要就将通知去掉
        NotificationCenter.default.addObserver(self, selector: #selector(runloopPlayer), name: Notification.Name.AVPlayerItemDidPlayToEndTime, object: nil)

    }
    
//    循环播放action
    @objc func runloopPlayer() {
        playerItem.seek(to: CMTime.zero, completionHandler: nil)
        play()
    }
    
//    播放
    func play() {
        avPlayer.play()
    }
    
//    停止
    func stop() {
        avPlayer.pause()
        avPlayer.replaceCurrentItem(with: nil)
        playerItem = nil
        avPlayer = nil
        NotificationCenter.default.removeObserver(self)
    }
}

//页面滚动
extension GW_GuidePage{
//    pageControl的点击方法
    @objc func pageControlClickAction(page:UIPageControl) {
        if isBannerV == false{
            return
        }
        scrollV.scrollRectToVisible(CGRect.init(x: scrollV.frame.size.width * CGFloat(page.currentPage + 1), y: 0, width: scrollV.frame.size.width, height: scrollV.frame.size.height), animated: false)
    }
    
//    定时器方法
    func turnPage(page:Int) {
        curPage = page
        scrollV.scrollRectToVisible(CGRect.init(x: scrollV.frame.size.width * CGFloat(page + 1), y: 0, width: scrollV.frame.size.width, height: scrollV.frame.size.height), animated: true)
        
    }
}

//UIScrollViewDelegate
extension GW_GuidePage:UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if autoScroll && isBannerV{
            let pageWith = scrollV.frame.size.width;
            var currentPage = floor((scrollV.contentOffset.x - pageWith / CGFloat(imageArr.count)) / pageWith) + 1
            currentPage -= 1
            pageC.currentPage = Int(currentPage)
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if autoScroll == false || isBannerV == false {
            let page = scrollView.contentOffset.x / scrollView.frame.size.width
            self.pageC.currentPage = Int(page)
            return
        }
        let pageWith = scrollV.frame.size.width;
        let currentPage = floor((scrollV.contentOffset.x - pageWith / CGFloat(imageArr.count)) / pageWith) + 1
        if currentPage == 0 {
            scrollV.scrollRectToVisible(CGRect.init(x: scrollV.frame.size.width * CGFloat(imageArr.count-2), y: 0, width: scrollV.frame.size.width, height: scrollV.frame.size.height), animated: false)
        }else if currentPage == CGFloat(imageArr.count - 1){
            scrollV.scrollRectToVisible(CGRect.init(x: scrollV.frame.size.width * CGFloat(imageArr.count-2), y: 0, width: scrollV.frame.size.width, height: scrollV.frame.size.height), animated: false)
        }
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        if isBannerV{
            if curPage == 0{
                scrollV.scrollRectToVisible(CGRect.init(x: scrollV.frame.size.width * CGFloat(imageArr.count-2), y: 0, width: scrollV.frame.size.width, height: scrollV.frame.size.height), animated: false)
            }else if curPage == imageArr.count-2{
                scrollV.scrollRectToVisible(CGRect.init(x: scrollV.frame.size.width, y: 0, width: scrollV.frame.size.width, height: scrollV.frame.size.height), animated: false)
            }
        }
    }
}
