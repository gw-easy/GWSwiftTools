//
//  ViewController.swift
//  GW_SwiftTools
//
//  Created by zdwx on 2019/1/11.
//  Copyright © 2019 DoubleK. All rights reserved.
//

import UIKit

enum jumpType:String {
    case gifTest = "gif图自动播放"
    case guidePageAndBannerPage = "引导页和广告轮播"
}

class ViewController: UITableViewController {
    
    lazy var dataA:[jumpType] = {
        var data = [jumpType]()
        data.append(jumpType.gifTest)
        data.append(jumpType.guidePageAndBannerPage)
        return data
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    
}


extension ViewController{
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dic = dataA[indexPath.row]
        let testVC = TestViewController.init(type: dic)
        self.navigationController?.pushViewController(testVC, animated: true)
    }
}

extension ViewController{
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataA.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellID = "cellID"
        var cell = tableView.dequeueReusableCell(withIdentifier: cellID)
        if cell == nil {
            cell = UITableViewCell.init(style: UITableViewCell.CellStyle.default, reuseIdentifier: cellID)
        }
        let dic = dataA[indexPath.row]
        cell?.textLabel?.text = "\(indexPath.row+1).  \(dic.rawValue)"
        return cell ?? UITableViewCell.init()
    }
}
