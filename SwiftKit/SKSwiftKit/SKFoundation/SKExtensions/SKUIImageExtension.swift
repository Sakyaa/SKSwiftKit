//
//  SKUIImageExtension.swift
//  RACDemo
//
//  Created by Sakya on 2017/12/15.
//  Copyright © 2017年 Sakya. All rights reserved.
//

import UIKit


extension UIImage {
    
    func sk_drawImageSize(radius: CGFloat, size: CGSize) -> UIImage {
        
        let rect = CGRect(origin: CGPoint(x: 0, y: 0), size: size)
        // 开启上下文
        UIGraphicsBeginImageContextWithOptions(rect.size, false, UIScreen.main.scale)
        let context = UIGraphicsGetCurrentContext()
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners:UIRectCorner.allCorners, cornerRadii: CGSize(width: radius, height: radius)).cgPath
        
        context!.addPath(path)
        context?.clip()
        self.draw(in: rect)
        
        let imageWithCorner = UIGraphicsGetImageFromCurrentImageContext();
        //关闭上下文
        UIGraphicsEndImageContext();
        
        return imageWithCorner!
        
    }
    /// EZSE: Use current image for pattern of color
    public func withColor(_ tintColor: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        
        let context = UIGraphicsGetCurrentContext()
        context?.translateBy(x: 0, y: self.size.height)
        context?.scaleBy(x: 1.0, y: -1.0)
        context?.setBlendMode(CGBlendMode.normal)
        
        let rect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height) as CGRect
        context?.clip(to: rect, mask: self.cgImage!)
        tintColor.setFill()
        context?.fill(rect)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()! as UIImage
        UIGraphicsEndImageContext()
        
        return newImage
    }
}



