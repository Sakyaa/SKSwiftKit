//
//  ViewController.swift
//  SwiftKit
//
//  Created by Sakya on 2018/1/26.
//  Copyright © 2018年 Sakya. All rights reserved.
//

import UIKit
import SKSwiftKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        //        let greatNovellas = NovellasCollection(novellas:["Mist"])
        //        for novella in greatNovellas {
        //            print("I've read: \(novella)")
        //        }
        
        let attstring:NSMutableAttributedString = NSMutableAttributedString.init(string: "阿斯顿撒大上帝啊上帝撒谎 i 的哈斯皇帝上帝和 i 的三第三地方爬时峰片发 的哈斯皇帝上帝和 i 的三第三地方爬时峰片发 的哈斯皇帝上帝和 i 的三第三地方爬时峰片发 的哈斯皇帝上帝和 i 的三第三地方爬时峰片发 的哈斯皇帝上帝和 i 的三第三地方爬时峰片发放给对方更多更多废话的哈斯皇帝上帝和 i 的三第三地方爬时峰片发放发")
        let strHeight:CGFloat = attstring.bounds(size: CGSize.init(width: 200, height: 1000)).height
        let label:UILabel = UILabel.init(frame: CGRect.init(x: 20, y: 40, width: 200, height: strHeight))
        label.numberOfLines = 0
        let font = UIFont.init(name: "HelveticaNeue", size: 12);
        attstring.addAttribute(NSAttributedStringKey.font, value: font as Any, range: NSRange.init(location: 0, length: attstring.length))
        label.backgroundColor = UIColor.orange
        label.attributedText = attstring
        view.addSubview(label)
        
        let file = FileManager.default
        let cachesPath = file.skCachesPath
        let documentsPath = file.skDocumentsPath
        SKInfoLog(cachesPath! + documentsPath!)
        SKInfoLog(KScreenConstant.sk_kScreenHeight)
        //千分位
        let thons = SKHelper.getSeparatedString(orgStr: "asdas")
        SKInfoLog(thons)
        SKHelper.DispatchTimer(timeInterval: 1, repeatCount: 30) { (timer, count)  in
            SKInfoLog(1,1)
        }
        
        view.addSubview(scrollPageView)

        
        
    }
    lazy var childVcs: [UIViewController] = {
        let recommendVc = UIViewController()
        recommendVc.view.backgroundColor = UIColor.orange
        let gameVc = UIViewController()
        let entertainmentVc = UIViewController()
        entertainmentVc.view.backgroundColor = UIColor.purple
        let interestingVc = UIViewController()
        let interestingVc1 = UIViewController()
        let interestingVc2 = UIViewController()
        interestingVc2.view.backgroundColor = UIColor.cyan
        
        let interestingVc3 = UIViewController()
        let interestingVc4 = UIViewController()
        interestingVc4.view.backgroundColor = UIColor.blue
        
        return [recommendVc, gameVc, entertainmentVc, interestingVc, interestingVc1, interestingVc2, interestingVc3, interestingVc4, entertainmentVc, interestingVc, interestingVc1, interestingVc2, interestingVc3, interestingVc4]
    }()
    lazy var scrollPageView: SKScrollPageView = {
        let titles = ["推撒打算打算打算荐", "游戏", "娱乐", "趣玩","关注","吧吧","牛吧","直播", "娱乐", "趣玩","关注","吧吧","牛吧","直播"]
        var style = SKSegmentStyle()
        style.showLine = true
        style.normalTitleColor = UIColor(red: 105.0/255.0, green: 106.0/255.0, blue: 107.0/255.0, alpha: 1)
        style.selectedTitleColor = UIColor(red: 248.0/255.0, green: 122.0/255.0, blue: 8.0/255.0, alpha: 1)
        style.scrollLineColor = UIColor(red: 248.0/255.0, green: 122.0/255.0, blue: 8.0/255.0, alpha: 1)
        style.gradualChangeTitleColor = true
        style.scrollTitle = true
        style.showExtraButton = false
        
        
        let scrollPageView = SKScrollPageView(frame: CGRect(x:0.0, y: 64.0, width: self.view.bounds.width, height: self.view.bounds.height - 64.0 - 44.0), segmentStyle: style, titles: titles, childVcs: self.childVcs, parentViewController: self)
        scrollPageView.segmentView.backgroundColor = UIColor.lightText
        return scrollPageView
    }()

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

