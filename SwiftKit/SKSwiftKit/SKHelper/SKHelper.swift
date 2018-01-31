//
//  SKHelper.swift
//  RACDemo
//
//  Created by Sakya on 2017/12/18.
//  Copyright © 2017年 Sakya. All rights reserved.
//

import UIKit


public class SKHelper {
    
    class func sk_disbaleAutoAdjustScrollViewInsets(currentView:UIView) {
        if #available(iOS 11.0, *) {
            disbaleAutoAdjustScrollViewInsets(currentView: currentView)
        } else {
            currentView.sk_viewController?.automaticallyAdjustsScrollViewInsets = false
        }
    }
    //MAAK:-- jsonsting <->dic
   class func getDictionaryFromJSONString(jsonString:String) ->NSDictionary {
        let jsonData:Data = jsonString.data(using: .utf8)!
        let dict = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)
        if dict != nil {
            return dict as! NSDictionary
        }
        return NSDictionary()
    }
    class func getJSONStringFromDictionary(dictionary:NSDictionary) -> String {
        if (!JSONSerialization.isValidJSONObject(dictionary)) {
            print("无法解析出JSONString")
            return ""
        }
        let data : NSData! = try? JSONSerialization.data(withJSONObject: dictionary, options: []) as NSData!
        let JSONString = NSString(data:data as Data,encoding: String.Encoding.utf8.rawValue)
        return JSONString! as String
    }
    
    class func componentsInstance(date:Date) -> DateComponents {
        struct Static {
            static let calendar = NSCalendar.init(calendarIdentifier: .gregorian)
        }
        let calendarUnit = NSCalendar.Unit.quarter
        let timeZone = NSTimeZone.init(name: "Asia/Shanghai")
        Static.calendar?.timeZone = timeZone! as TimeZone
        let theComponents = Static.calendar?.components(calendarUnit, from: date)
        return theComponents!
    }
    class func sk_getCurrentDate() -> String {
        let date:Date = Date()
        let weekDays = [NSNull.init(),"星期日","星期一","星期二","星期三","星期四","星期五","星期六"] as [Any]
        let calendar = Calendar.current
        let dateComponents =  calendar.dateComponents([.month,.day,.weekday], from: date)
        let dateString = "\(dateComponents.month ?? 0)月\(dateComponents.day ?? 0)日  \(weekDays[(dateComponents.weekday)!])"

        return dateString
    }
    
    
    class func sk_resizeImage(originalImg:UIImage) -> UIImage{

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
 
    class func getSeparatedString(orgStr: String) -> String {
        let length = orgStr.utf16.count
        if length < 4 {  return orgStr }
        var dstStr = String()
        var orgChars = orgStr.characters
        let startIndex = orgChars.startIndex
        var counter = 0
        var i = length - 1
        repeat  {
            counter += 1
            dstStr.insert(orgChars.popLast()!, at: startIndex)
            if counter == 3 {
                dstStr.insert(",", at: startIndex)
                counter = 0;
            }
            i -= 1  // Swift 2.2已经废弃使用++、--了，请注意！
        }
            while i > 0
        dstStr.insert(orgChars.popLast()!, at: startIndex)
        return dstStr;
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


