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
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

