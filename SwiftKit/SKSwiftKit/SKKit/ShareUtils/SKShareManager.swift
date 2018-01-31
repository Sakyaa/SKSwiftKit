//
//  SKShareManager.swift
//  GZCanLian
//
//  Created by Sakya on 2018/1/5.
//  Copyright © 2018年 Sakya. All rights reserved.
//



class SKShareManager: NSObject {
    
    class func shareUrl(url:String,viewController:UIViewController,platformType:UMSocialPlatformType)-> Void {
        if !UMSocialManager.default().isInstall(platformType) {
            switch platformType {
            case .QQ:
                SKHUDManager.sk_showWarning(withStatus: GZCLTextConstant.warning_platformQQ_notInstalled)
                return
            case .wechatSession:
                SKHUDManager.sk_showWarning(withStatus: GZCLTextConstant.warning_platformWeChat_notInstalled)
                return
            default:
                SKHUDManager.sk_showWarning(withStatus: GZCLTextConstant.warning_platformOther_notInstalled)
                return
            }
        }
        //创建分享消息对象
        let messageObject:UMSocialMessageObject = UMSocialMessageObject.init()
        let describeApp:String = Bundle.main.infoDictionary!["CFBundleDisplayName"] as! String //App 名称
        //创建网页内容对象
        let shareObject:UMShareWebpageObject = UMShareWebpageObject.shareObject(withTitle: "分享", descr: describeApp, thumImage: UIImage.init(named: "app_icon"))
        shareObject.webpageUrl = url
        messageObject.shareObject = shareObject
        UMSocialManager.default().share(to:platformType, messageObject: messageObject, currentViewController: viewController) { (data, error) in
            print(error as Any)
            if (error != nil &&
                (error! as NSError).code == 2001) {
                    switch platformType {
                    case .QQ:
                        SKHUDManager.sk_showWarning(withStatus: GZCLTextConstant.warning_platformQQ_notInstalled)
                        return
                    case .wechatSession:
                        SKHUDManager.sk_showWarning(withStatus: GZCLTextConstant.warning_platformWeChat_notInstalled)
                        return
                    default:
                        SKHUDManager.sk_showWarning(withStatus: GZCLTextConstant.warning_platformOther_notInstalled)
                        return
                    }

            }
        }
    }
    
}
