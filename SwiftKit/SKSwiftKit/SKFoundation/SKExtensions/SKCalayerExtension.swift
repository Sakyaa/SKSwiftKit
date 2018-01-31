//
//  SKCalayerExtension.swift
//  GZCanLian
//
//  Created by Sakya on 2017/12/19.
//  Copyright © 2017年 Sakya. All rights reserved.
//

import UIKit
//MARK:--frame
extension CALayer {
    /// x
    public final var sk_x: CGFloat {
        set(x) {
            frame.origin.x = x
        }
        
        get {
            return frame.origin.x
        }
    }
    public final var sk_left: CGFloat {
        set(sk_left) {
            frame.origin.x = sk_left
        }
        get {
            return frame.origin.x
        }
    }
    
    /// y
    public final var sk_y:CGFloat {
        set(y) {
            frame.origin.y = y
        }
        get {
            return frame.origin.y
        }
    }
    public final var sk_top:CGFloat {
        set(sk_top) {
            frame.origin.y = sk_top
        }
        get {
            return frame.origin.y
        }
    }
    ///size
    public final var sk_size:CGSize {
        set(size) {
            var skframe:CGRect = frame;
            skframe.size = size;
            frame = skframe;
        }
        get {
            return frame.size
        }
    }
    
    /// center
    public final var sk_center: CGPoint {
        set(center) {
            var skframe:CGRect = self.frame;
            skframe.origin.x = center.x - skframe.size.width * 0.5;
            skframe.origin.y = center.y - skframe.size.height * 0.5;
            frame = skframe;
        }
        
        get {
            return CGPoint(x:frame.origin.x + frame.size.width * 0.5,y:frame.origin.y + frame.size.height * 0.5);
        }
    }
    /// centerX
    public final var sk_centerX: CGFloat {
        set(sk_centerX) {
            var skframe:CGRect = frame;
            skframe.origin.x = sk_centerX - skframe.size.width * 0.5;
            frame = skframe;
        }
        get {
            return frame.origin.x + frame.size.width * 0.5;
        }
    }
    /// centerY
    public final var sk_centerY: CGFloat {
        set(centerY) {
            var skframe:CGRect = frame;
            skframe.origin.y = centerY - skframe.size.height * 0.5;
            self.frame = skframe;
        }
        get {
            return frame.origin.y + frame.size.height * 0.5
        }
    }
    /// width
    public final var sk_width: CGFloat {
        set(width) {
            frame.size.width = width
        }
        get {
            return bounds.size.width
        }
    }
    /// height
    public final var sk_height: CGFloat {
        set(height) {
            frame.size.height = height
        }
        
        get {
            return bounds.size.height
        }
    }
    
    public final var sk_right: CGFloat {
        set(sk_right) {
            frame.origin.x =  sk_right - bounds.size.width
        }
        get {
            return frame.origin.x + bounds.size.width
        }
    }
    public final var sk_bottom: CGFloat {
        set(sk_bottom) {
            frame.origin.y =  sk_bottom - bounds.size.height
        }
        get {
            return frame.origin.y + bounds.size.height
        }
    }
}
extension CALayer {
    
    public static func sk_colorWithGradientStyle(gradientStyle:SKUIGradientStyle,frame:CGRect,colors:[UIColor]) -> CAGradientLayer {
//        cell.layer.insertSublayer(gradientLayer, atIndex: 0)

        let backgroundGradientLayer:CAGradientLayer = CAGradientLayer()
        backgroundGradientLayer.frame = frame
        var cgColors:[CGColor] = [CGColor]()
        for item in colors {
            cgColors.append(item.cgColor)
        }
        //switch
        switch gradientStyle {
        case .leftToRight:
            backgroundGradientLayer.colors = cgColors;
            backgroundGradientLayer.startPoint = CGPoint(x:0.0,y:0.5)
            backgroundGradientLayer.endPoint = CGPoint(x:1.0,y:0.5)
            return backgroundGradientLayer;
            
        case .topToBottom:
            backgroundGradientLayer.colors = cgColors;
            return backgroundGradientLayer;
            //        default:
            //            break
        }
        
    }
    public func sk_layerColorWithGradientStyle(gradientStyle:SKUIGradientStyle,colors:[UIColor]) -> Void {
        
        let backgroundGradientLayer:CAGradientLayer = self as! CAGradientLayer
        var cgColors:[CGColor] = [CGColor]()
        for item in colors {
            cgColors.append(item.cgColor)
        }
        //switch
        switch gradientStyle {
        case .leftToRight:
            backgroundGradientLayer.colors = cgColors;
            backgroundGradientLayer.startPoint = CGPoint(x:0.0,y:0.5)
            backgroundGradientLayer.endPoint = CGPoint(x:1.0,y:0.5)
            
        case .topToBottom:
            backgroundGradientLayer.colors = cgColors;
            //        default:
            //            break
        }
        
    }
 
}
