//
//  GW_CollectionView.swift
//  GW_SwiftTools
//
//  Created by zdwx on 2019/1/17.
//  Copyright © 2019 DoubleK. All rights reserved.
//

import UIKit

class GW_CollectionView: UIView {
    var dataA:[AnyObject] = [AnyObject]()
    
    lazy var collectionV:UICollectionView = {
        let collV = UICollectionView.init()
        collV.frame = self.bounds
        collV.showsVerticalScrollIndicator = false
        collV.showsHorizontalScrollIndicator = false
        collV.delegate = self
        collV.dataSource = self
        return collV
    }()
    
    override init(frame: CGRect,data:[AnyObject]) {
        super.init(frame: frame)
        self.dataA = data
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension GW_CollectionView{
//    注册cell
    func addCollectViewCell() {
        
    }
//    添加layout
    func addCollectLayout() {
        
    }
}

extension GW_CollectionView:UICollectionViewDelegate{
    
}

extension GW_CollectionView:UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataA.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
    }
    
}
