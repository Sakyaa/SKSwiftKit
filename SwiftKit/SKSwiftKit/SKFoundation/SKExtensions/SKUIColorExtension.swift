//
//  SKUIColorExtension.swift
//  RACDemo
//
//  Created by Sakya on 2017/12/19.
//  Copyright © 2017年 Sakya. All rights reserved.
//

import UIKit
//import CoreGraphics

public enum SKUIGradientStyle {
    //calayer 方向
    case leftToRight
    case topToBottom
}

extension UIColor {
    
    
    public static func sk_colorWithGradientStyle(gradientStyle:SKUIGradientStyle,frame:CGRect,colors:[UIColor]) -> CAGradientLayer {
        
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
    
}
