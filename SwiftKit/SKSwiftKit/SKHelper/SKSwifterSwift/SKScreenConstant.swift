//
//  SKScreenConstant.swift
//  SwiftKit
//
//  Created by Sakya on 2018/1/29.
//  Copyright © 2018年 Sakya. All rights reserved.
//

import UIKit
//／ 定义平屏幕宽高
struct KScreenConstant {
    /// 屏幕高度
    static let sk_kScreenHeight:CGFloat = UIScreen.main.bounds.height
    /// 屏幕宽度
    static let sk_kScreenWidth:CGFloat  = UIScreen.main.bounds.width
    /// 屏幕宽度
    static let sk_kScreenBounds:CGRect  = UIScreen.main.bounds
    /// tabBar高度
    static let sk_kTabBarHeight: CGFloat = {
        return sk_iPhoneX ? 49 + 34 : 49
    }()
    ///不包括状态栏的导航条高度
    static let sk_kNavigationBarHeight:CGFloat = 44
    ///状态栏高度
    static let sk_kStatusBarHeight: CGFloat = {
        return sk_iPhoneX ? 44 : 20
    }()
    ///底部边距
    static let sk_kTabbarSafeBottomMargin: CGFloat = {
        return sk_iPhoneX ? 34 : 0
    }()
    ///导航条总体高度
    static let sk_kNavigationStatusBarHeight:CGFloat = {
        return sk_iPhoneX ? 88 : 64
    }()
}
/// 定义判断手机型号
let sk_iPhone5: Bool = {
    if __CGSizeEqualToSize(CGSize(width:640,height:1136), (UIScreen.main.currentMode?.size)! ) {
        return true
    }
    return false
}()
let sk_iPhone6: Bool = {
    if __CGSizeEqualToSize(CGSize(width:750,height:1334), (UIScreen.main.currentMode?.size)! ) {
        return true
    }
    return false
}()
let sk_iPhone6Plus: Bool = {
    if __CGSizeEqualToSize(CGSize(width:1242,height:2208), (UIScreen.main.currentMode?.size)! ) {
        return true
    }
    return false
}()
///6p 放大模式
let iPhone6PlusBigMode: Bool = {
    if __CGSizeEqualToSize(CGSize(width:1125,height:2001), (UIScreen.main.currentMode?.size)! ) {
        return true
    }
    return false
}()
let sk_iPhoneX: Bool = {
    if __CGSizeEqualToSize(CGSize(width:1125,height:2436), (UIScreen.main.currentMode?.size)! ) {
        return true
    }
    return false
}()

