//
//  SKHelper.swift
//  RACDemo
//
//  Created by Sakya on 2017/12/18.
//  Copyright © 2017年 Sakya. All rights reserved.
//

import UIKit


public class SKHelper {
    
    public class func sk_disbaleAutoAdjustScrollViewInsets(currentView:UIView) {
        if #available(iOS 11.0, *) {
            disbaleAutoAdjustScrollViewInsets(currentView: currentView)
        } else {
            currentView.sk_viewController?.automaticallyAdjustsScrollViewInsets = false
        }
    }
    //MAAK:-- jsonsting <->dic
   public class func getDictionaryFromJSONString(jsonString:String) ->NSDictionary {
        let jsonData:Data = jsonString.data(using: .utf8)!
        let dict = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)
        if dict != nil {
            return dict as! NSDictionary
        }
        return NSDictionary()
    }
    public class func getJSONStringFromDictionary(dictionary:NSDictionary) -> String {
        if (!JSONSerialization.isValidJSONObject(dictionary)) {
            print("无法解析出JSONString")
            return ""
        }
        let data : NSData! = try? JSONSerialization.data(withJSONObject: dictionary, options: []) as NSData!
        let JSONString = NSString(data:data as Data,encoding: String.Encoding.utf8.rawValue)
        return JSONString! as String
    }
    
    public class func componentsInstance(date:Date) -> DateComponents {
        struct Static {
            static let calendar = NSCalendar.init(calendarIdentifier: .gregorian)
        }
        let calendarUnit = NSCalendar.Unit.quarter
        let timeZone = NSTimeZone.init(name: "Asia/Shanghai")
        Static.calendar?.timeZone = timeZone! as TimeZone
        let theComponents = Static.calendar?.components(calendarUnit, from: date)
        return theComponents!
    }
      //MARK:-- 获取当前星期
    public class func sk_getCurrentDate() -> String {
        let date:Date = Date()
        let weekDays = [NSNull.init(),"星期日","星期一","星期二","星期三","星期四","星期五","星期六"] as [Any]
        let calendar = Calendar.current
        let dateComponents =  calendar.dateComponents([.month,.day,.weekday], from: date)
        let dateString = "\(dateComponents.month ?? 0)月\(dateComponents.day ?? 0)日  \(weekDays[(dateComponents.weekday)!])"
        return dateString
    }
    
      //MARK:-- 图片压缩
    public class func sk_resizeImage(originalImg:UIImage) -> UIImage{

        //prepare constants
        let width = originalImg.size.width
        let height = originalImg.size.height
        let scale = width/height
        
        var sizeChange = CGSize()
        
        if width <= 1280 && height <= 1280{ //a，图片宽或者高均小于或等于1280时图片尺寸保持不变，不改变图片大小
            return originalImg
        }else if width > 1280 || height > 1280 {//b,宽或者高大于1280，但是图片宽度高度比小于或等于2，则将图片宽或者高取大的等比压缩至1280
            
            if scale <= 2 && scale >= 1 {
                let changedWidth:CGFloat = 1280
                let changedheight:CGFloat = changedWidth / scale
                sizeChange = CGSize(width: changedWidth, height: changedheight)
                
            }else if scale >= 0.5 && scale <= 1 {
                
                let changedheight:CGFloat = 1280
                let changedWidth:CGFloat = changedheight * scale
                sizeChange = CGSize(width: changedWidth, height: changedheight)
                
            }else if width > 1280 && height > 1280 {//宽以及高均大于1280，但是图片宽高比大于2时，则宽或者高取小的等比压缩至1280
                
                if scale > 2 {//高的值比较小
                    
                    let changedheight:CGFloat = 1280
                    let changedWidth:CGFloat = changedheight * scale
                    sizeChange = CGSize(width: changedWidth, height: changedheight)
                    
                }else if scale < 0.5{//宽的值比较小
                    
                    let changedWidth:CGFloat = 1280
                    let changedheight:CGFloat = changedWidth / scale
                    sizeChange = CGSize(width: changedWidth, height: changedheight)
                    
                }
            }else {//d, 宽或者高，只有一个大于1280，并且宽高比超过2，不改变图片大小
                return originalImg
            }
        }
        
        UIGraphicsBeginImageContext(sizeChange)
        
        //draw resized image on Context
        originalImg.draw(in: CGRect(x: 0, y: 0, width: sizeChange.width, height: sizeChange.width))
        //create UIImage
        let resizedImg = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resizedImg!
    }

    //    分割千分位
    public class func getSeparatedString(orgStr: String) -> String {
     
        if let num:Int = Int(orgStr) {
            let numberFormatter = NumberFormatter()
            numberFormatter.positiveFormat = ",###;"
            let changeNum = numberFormatter.string(from: NSNumber(value: num))
            return changeNum!
        }
        return orgStr
    }
    
    //MARK:-- 定时器
    /// GCD定时器倒计时⏳
    ///   - timeInterval: 循环间隔时间
    ///   - repeatCount: 重复次数
    ///   - handler: 循环事件, 闭包参数： 1. timer， 2. 剩余执行次数
    public class func DispatchTimer(timeInterval: Double, repeatCount:Int, handler:@escaping (DispatchSourceTimer?, Int)->()) {
        if repeatCount <= 0 {
            return
        }
        let timer = DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.main)
        var count = repeatCount
        timer.schedule(wallDeadline: .now(), repeating: timeInterval)
        timer.setEventHandler(handler: {
            count -= 1
            DispatchQueue.main.async {
                //倒计时完成
                handler(timer, count)
            }
            if count == 0 {
                timer.cancel()
            }
        })
        timer.resume()
    }
    /// GCD定时器循环操作
    ///   - timeInterval: 循环间隔时间
    ///   - handler: 循环事件
    public class func DispatchTimer(timeInterval: Double, handler:@escaping (DispatchSourceTimer?)->()) {
        let timer = DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.main)
        timer.schedule(deadline: .now(), repeating: timeInterval)
        timer.setEventHandler {
            DispatchQueue.main.async {
                handler(timer)
            }
        }
        timer.resume()
    }
    /// GCD延时操作
    ///   - after: 延迟的时间
    ///   - handler: 事件
    public class func DispatchAfter(after: Double, handler:@escaping ()->())
    {
        DispatchQueue.main.asyncAfter(deadline: .now() + after) {
            handler()
        }
    }
    
    //MARK:-- private
    private class func disbaleAutoAdjustScrollViewInsets (currentView:UIView) {
        if currentView.isKind(of: UIScrollView.self) {
            if #available(iOS 11.0, *) {
                (currentView as! UIScrollView).contentInsetAdjustmentBehavior = .never
            }
        }
        for childView in currentView.subviews {
            if childView.isKind(of: UIScrollView.self) {
                if #available(iOS 11.0, *) {
                    (childView as! UIScrollView).contentInsetAdjustmentBehavior = .never
                }
            }
        }
    }
}


