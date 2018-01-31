//
//  AppManager.swift
//  GZCanLian
//
//  Created by Sakya on 2018/1/12.
//  Copyright © 2018年 Sakya. All rights reserved.
//



let AppManagerShare = AppManager.shareInstance

final class AppManager: BaseViewModel {
    static var shareInstance : AppManager = {
        let app = AppManager()
        return app
    }()
    private override init() {}
    // app login
    func appLoginOperation(username:String,password:String,handle:@escaping (_ loadState:LoadState) -> Void) {
        let parames = ["username":username,
                       "password":password]
        NetworkLib.request(.post, header: false, URLString:apiUrl(APIConstant.url_login), parameters:parames as [String : AnyObject], successHandler: {[weak self] (result) in
            
            let error = GZCLHelper.responseHandleResults(results: result!)
            if error.isEmpty {
                if let loadData = LoginModel.deserialize(from: result as? Dictionary){
                    UserOperation.shareInstance.loginStatus = true
                    UserOperation.shareInstance.app_token = loadData.token
                    UserOperation.shareInstance.newToken = true
                    UserOperation.shareInstance.isEditable = loadData.isEditable
                    handle(.success(result: SuccessResult.init(msg:"登录成功" )))
                    //更新用户信息了啊
                    self?.userUpdateInformation()
                } else {
                    handle(.failure(error: FailureResult.init(msg: "返回数据有误")))
                }
            } else {
                handle(.failure(error: FailureResult.init(msg: error)))
            }
        }) { (error) in
            handle(.failure(error: FailureResult.init(msg: GZCLTextConstant.network_error,errorType:.errorNetwork)))
        }
    }
    //app 升级管理啊
    func appUpdateDetection(handle:@escaping HandleLoadStatus) {
        let params:[String:AnyObject] = ["type":"1" as AnyObject]
        NetworkLib.request(.get, header: true, URLString: apiUrl(APIConstant.url_userAppUpdate),parameters: params, successHandler: {(result) in
            let msg = GZCLHelper.responseHandleResults(false, results: result!)
            if msg.isEmpty {
                if let data = AppVersionModel.deserialize(from: (result as! Dictionary)){
                    if ((data.data?.code)! > AppVersionInformation.appCode) {
                        if let url = URL(string: (data.data?.url!)!) {
                            let alertView:SKAlertView = SKAlertView.init(style: .normal(title: "提示"), actions: [.cancelAction(title: "暂缓"),.defaultAction(title: "升级")], content: (data.data?.content)!)
                            alertView.actionBlock = { (sender:UIButton)->Void in
                                if sender.tag == 1 {
                                    if #available(iOS 10, *) {
                                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                                    } else {
                                        UIApplication.shared.openURL(url)
                                    }
                                }
                            }
                            alertView.viewShow()
                            handle(.success(result: SuccessResult()))
                        } else {
                            handle(.failure(error: FailureResult(msg: GZCLTextConstant.reponse_error)))
                        }
                    } else {
                        handle(.failure(error: FailureResult.init(msg: "暂无新版本更新", errorType: .warningData)))
                    }
                } else {
                    handle(.failure(error: FailureResult(msg: GZCLTextConstant.reponse_error)))
                }
            } else {
                handle(.failure(error: FailureResult(msg: msg)))
            }
        }) { (error) in
            handle(.failure(error: FailureResult(msg: GZCLTextConstant.network_error)))
        }
    }
///--个人用户信息更新
    func userUpdateInformation() {
        NetworkLib.request(.get, header: true, URLString: apiUrl(APIConstant.url_getUserInformation), successHandler: {(result) in
            if let resultJson = result {
                if GZCLHelper.responseHandleResults(false, results: result!).isEmpty {
                    if let data = UserInformationModel.deserialize(from: (resultJson as! Dictionary)) {
                        UserOperation.shareInstance.user = data
                    }
                }
            }
        }) { (error) in
            
        }
    }
}
