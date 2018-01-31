//
//  SKHUDView.swift
//  RACDemo
//
//  Created by Sakya on 2017/12/14.
//  Copyright © 2017年 Sakya. All rights reserved.
//

import UIKit
/**
import NVActivityIndicatorView


class SKHUDView: UIView {
    
    /// 加载错误提示
    private lazy var messageLabel: UILabel = {
        
        let label = UILabel(frame: CGRect.zero)
        label.font = UIFont.boldSystemFont(ofSize: 16.0)
        label.backgroundColor = UIColor.black
        label.layer.masksToBounds = true
        label.textColor = UIColor.white
        label.textAlignment = .center
        addSubview(label)
        return label
    }()
    
    //MARK:life
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK:publick
    class func showHUD(text: String, autoHide: Bool, afterTime time: Double) {
        if let window = UIApplication.shared.keyWindow {
            let hud = SKHUDView(frame: CGRect(origin: CGPoint.zero, size: window.bounds.size))
            window.addSubview(hud)
            
            hud.messageLabel.text = text
            let textSize = (text as NSString).boundingRect(with: CGSize(width:CGFloat(MAXFLOAT),height: 0.0), options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: hud.messageLabel.font], context: nil)
            
            hud.messageLabel.frame = CGRect(x: (UIScreen.main.bounds.width - textSize.width - 16)*0.5, y: (UIScreen.main.bounds.height - 40.0)*0.5, width: textSize.width + 16, height: 40.0)
            
            hud.messageLabel.layer.cornerRadius = hud.messageLabel.bounds.height / 3
            
            if autoHide {
                DispatchQueue.main.asyncAfter(deadline: .now() + time) {
                    SKHUDView.hideHUD()
                }
            }
        }
        
    }
    class func hideHUD() {
        if let window = UIApplication.shared.keyWindow {
            for subview in window.subviews {
                if subview is SKHUDView {
                    subview.removeFromSuperview()
                }
            }
        }
    }
    class func showLoadHUD() {
        if let window = UIApplication.shared.keyWindow {
            
            let hud = SKHUDView(frame: CGRect(origin: CGPoint.zero, size: window.bounds.size))
            let size = CGSize(width: 100, height: 100)
            let type:NVActivityIndicatorType = NVActivityIndicatorType.init(rawValue: 23)!
            
            let activityView:NVActivityIndicatorView = NVActivityIndicatorView.init(frame: CGRect.init(origin: CGPoint.zero, size: size), type:type , color: UIColor.red, padding: 0.5)
            activityView.center = hud.center
            hud.addSubview(activityView)
            window.addSubview(hud)
            activityView.startAnimating()
//            activityView.startAnimating(size, message: "Loading...", type: NVActivityIndicatorType(rawValue: 23)!)
        }
    }
    
    
    class func stopAnimating() {
        if let window = UIApplication.shared.keyWindow {
            for subview in window.subviews {
                if subview is SKHUDView {
                    for activityView in subview.subviews {
                        if activityView is NVActivityIndicatorView {
                            
                            (activityView as! NVActivityIndicatorView).stopAnimating()
                        }
                    }
                    subview.removeFromSuperview()
                }
            }
        }
    }
}
 */

