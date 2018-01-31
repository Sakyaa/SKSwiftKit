//
//  SKHUDManager.swift
//  RACDemo
//
//  Created by Sakya on 2017/12/14.
//  Copyright © 2017年 Sakya. All rights reserved.
//

import SVProgressHUD

fileprivate enum HUDType: Int {
    case success
    case errorObject
    case errorString
    case info
    case loading
    case load
}

final class SKHUDManager: NSObject {
    /// 创建单例
    static let shareInstance : SKHUDManager = {
        let instance = SKHUDManager()
        return instance
    }()
    //MARK-- init
    class func sk_initHUD() {
//        SVProgressHUD.setBackgroundColor(UIColor ( red: 0.0, green: 0.0, blue: 0.0, alpha: 0.7 ))
//        SVProgressHUD.setForegroundColor(UIColor.white)
//        SVProgressHUD.setDefaultStyle(.dark)
//        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.none)
        SVProgressHUD.setMinimumSize(CGSize(width:100,height:100))
        SVProgressHUD.setFont(UIFont.systemFont(ofSize: 14))
        SVProgressHUD.setMinimumDismissTimeInterval(1.0)
    }
    //MARK-- config
    //成功
    class func sk_showSuccess(withStatus string: String?) {
        self.skProgressHUDShow(.success, status: string)
    }
    
    //失败 ，NSError
    class func sk_showError(withObject error: NSError) {
        self.skProgressHUDShow(.errorObject, status: nil, error: error)
    }
    
    //失败，String
    class func sk_showError(withStatus string: String?) {
        self.skProgressHUDShow(.errorString, status: string)
    }
    
    //转菊花
    class func sk_showWithStatus(_ string: String?) {
        self.skProgressHUDShow(.loading, status: string)
    }
    //
    class func sk_showLoading() {
        self.skProgressHUDShow(.load)
    }
    //警告
    class func sk_showWarning(withStatus string: String?) {
        self.skProgressHUDShow(.info, status: string)
    }
    
    //dismiss消失
    class func sk_dismiss() {
        SVProgressHUD.dismiss()
    }
    
    //私有方法
    fileprivate class func skProgressHUDShow(_ type: HUDType, status: String? = "", error: NSError? = nil) {
        SVProgressHUD.setDefaultMaskType(.none)
        switch type {
        case .success:
            SVProgressHUD.showSuccess(withStatus: status)
            break
        case .errorObject:
            guard let newError = error else {
                SVProgressHUD.showError(withStatus: "Error:出错拉")
                return
            }
            if newError.localizedFailureReason == nil {
                SVProgressHUD.showError(withStatus: "Error:出错拉")
            } else {
                SVProgressHUD.showError(withStatus: error!.localizedFailureReason)
            }
            break
        case .errorString:
            SVProgressHUD.showError(withStatus: status)
            break
        case .info:
            SVProgressHUD.showInfo(withStatus: status)
            break
        case .loading:
            SVProgressHUD.setDefaultMaskType(.clear)
            SVProgressHUD.show(withStatus: status)
            break
        case .load:
                SVProgressHUD.setDefaultMaskType(.clear)
                SVProgressHUD.show()
            break
        }
    }
}
