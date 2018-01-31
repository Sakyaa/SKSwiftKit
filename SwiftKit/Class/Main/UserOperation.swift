//
//  UserOperation.swift
//  GZCanLian
//
//  Created by Sakya on 2017/12/20.
//  Copyright © 2017年 Sakya. All rights reserved.
//

let UserOperationShare = UserOperation.shareInstance

final class UserOperation: NSObject {
    static var shareInstance : UserOperation = {
        let user = UserOperation()
        return user
    }()
    private override init() {}
    struct UserLoginInfo {
    
    }
    var newToken:Bool = false ///<判断是否获取到新的token 每次登录的时候需要用的防治token过期退出
    ///app——记录账号密码的状态
    var account:String {
        set(account) {
            MyUserDefaults.set(account, forKey: "account")
            MyUserDefaults.synchronize()
        }
        get {
            let account = MyUserDefaults.object(forKey: "account") == nil ? "" :  MyUserDefaults.string(forKey: "account")
            return account!
        }
    }
    var password:String {
        set(password) {
            MyUserDefaults.set(password, forKey: "password")
            MyUserDefaults.synchronize()
        }
        get {
            let password = MyUserDefaults.object(forKey: "password") == nil ? "" :  MyUserDefaults.string(forKey: "password")
            return password!
        }
    }
    ///app的状态
    var loginStatus:Bool {
        set(loginStatus) {
            MyUserDefaults.set(loginStatus, forKey: "loginStatus")
            MyUserDefaults.synchronize()
        }
        get {
            return MyUserDefaults.bool(forKey: "loginStatus")
        }
    }
    ///是否可编辑是否在可编辑时间内
    var isEditable:Bool {
        set(isEditable) {
            MyUserDefaults.set(isEditable, forKey: "isEditable")
            MyUserDefaults.synchronize()
        }
        get {
            return MyUserDefaults.bool(forKey: "isEditable")
        }
    }
    ///app——tokent的状态
    var app_token:String {
        set(app_token) {
            MyUserDefaults.set(app_token, forKey: "app_token")
            MyUserDefaults.synchronize()
        }
        get {
            let app_token = MyUserDefaults.object(forKey: "app_token") == nil ? "" :  MyUserDefaults.string(forKey: "app_token")
            return app_token!
        }
    }
    var user:UserInformationModel {
        set(user) {
//            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:basicModel];
            //classArray = [NSKeyedUnarchiver unarchiveObjectWithData:[result dataForColumn:@"classList"]];
            let data = NSKeyedArchiver.archivedData(withRootObject: user)
            MyUserDefaults.set(data, forKey: "app_user")
            MyUserDefaults.synchronize()
        }
        get {
            let data = MyUserDefaults.object(forKey: "app_user")
            if data == nil { return UserInformationModel() }
            let user = NSKeyedUnarchiver.unarchiveObject(with: data as! Data)
            return user as! UserInformationModel
        }
    }
    
}
