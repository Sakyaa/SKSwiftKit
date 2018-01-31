//
//  SKStringExtension.swift
//  RACDemo
//
//  Created by Sakya on 2017/12/15.
//  Copyright © 2017年 Sakya. All rights reserved.
//

import Foundation
import UIKit
//MARK: - String extension

extension String {
    static func getNowTimeString() -> String {
        return String(format: "%.0f", NSDate().timeIntervalSince1970)
    }
}
extension String {
    //密码高的复杂度
    public var skIsHighComplexity: Bool {
        let pattern:String = "^(?=.*[a-zA-Z0-9].*)(?=.*[a-zA-Z\\W].*)(?=.*[0-9\\W].*).{8,16}$"
        let pred:NSPredicate = NSPredicate(format: "SELF MATCHES %@",pattern)
        let isMatch:Bool = pred.evaluate(with: self)
        return isMatch
    }
    public var skIsEmailAddress:Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        let testPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        return testPredicate.evaluate(with: self)
    }
//    身份证有效性
    public var skIsIdCard:Bool {
        let emailRegex = "^(\\d{14}|\\d{17})(\\d|[xX])$"
        let testPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        return testPredicate.evaluate(with: self)
    }
    
}
extension String {

    func heightText(font:UIFont,width:CGFloat) -> CGFloat {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = self
        label.sizeToFit()
        return label.frame.height
    }
    
    func heightAttributesText(attributes:[NSAttributedStringKey:Any],width:CGFloat) -> CGFloat {
        guard self.characters.count > 0 && width > 0 else {
            return 0
        }
        let size = CGSize(width:width, height:CGFloat.greatestFiniteMagnitude)
        let text = self as NSString
        let rect = text.boundingRect(with: size, options:.usesLineFragmentOrigin, attributes: attributes, context:nil)
        return rect.size.height
    }

}
