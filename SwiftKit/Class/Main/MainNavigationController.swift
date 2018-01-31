//
//  MainNavigationController.swift
//  GZCanLian
//
//  Created by Sakya on 2017/12/20.
//  Copyright © 2017年 Sakya. All rights reserved.
//

import UIKit

class MainNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationBar.isHidden = true

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    /**
     暂时不需要
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if (self.childViewControllers.count==1) {
            viewController.hidesBottomBarWhenPushed = true; //viewController是将要被push的控制器
        }
        super.pushViewController(viewController, animated: animated)
        
    }
*/
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
