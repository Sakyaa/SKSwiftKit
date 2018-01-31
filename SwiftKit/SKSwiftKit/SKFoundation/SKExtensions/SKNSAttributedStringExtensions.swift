//
//  SKNSAttributedStringExtensions.swift
//  SwiftKit
//
//  Created by Sakya on 2018/1/29.
//  Copyright © 2018年 Sakya. All rights reserved.
//

#if os(macOS)
    import Cocoa
#else
    import UIKit
#endif

// MARK: - Properties
public extension NSAttributedString {

    //计算富文本高度的
    public func bounds(size:CGSize)->(CGSize) {
        let attrString:NSMutableAttributedString = NSMutableAttributedString.init(attributedString: self)
        var range:NSRange = NSRange(location: 0, length: attrString.length)
        let dict = self.attributes(at: 0, effectiveRange: &range)
        var paraStyle: NSMutableParagraphStyle? = dict[NSAttributedStringKey.paragraphStyle] as? NSMutableParagraphStyle
        if paraStyle == nil {
            paraStyle = NSMutableParagraphStyle.init()
            paraStyle?.lineSpacing = 0.0;//增加行高
            paraStyle?.headIndent = 0;//头部缩进，相当于左padding
            paraStyle?.tailIndent = 0;//相当于右padding
            paraStyle?.lineHeightMultiple = 0;//行间距是多少倍
            paraStyle?.alignment = .left;//对齐方式
            paraStyle?.firstLineHeadIndent = 0;//首行头缩进
            paraStyle?.paragraphSpacing = 0;//段落后面的间距
            paraStyle?.paragraphSpacingBefore = 0;//段落之前的间距
            attrString.addAttribute(NSAttributedStringKey.paragraphStyle, value: paraStyle as Any, range: range)
        }
        var font:UIFont? = dict[NSAttributedStringKey.font] as? UIFont
        if (font == nil) {
            font = UIFont.init(name: "HelveticaNeue", size: 12);
            attrString.addAttribute(NSAttributedStringKey.font, value: font as Any, range: range)
        }
        let attributedDict:NSMutableDictionary = NSMutableDictionary.init(dictionary: dict)
        attributedDict.setObject(font as Any, forKey: NSAttributedStringKey.font as NSCopying)
        attributedDict.setObject(paraStyle as Any, forKey: NSAttributedStringKey.paragraphStyle as NSCopying)
        let atrstring:NSString = self.string as NSString
        let attrStringSize:CGSize = atrstring.boundingRect(with: size, options:NSStringDrawingOptions(rawValue: Int(UInt8(NSStringDrawingOptions.usesFontLeading.rawValue)|UInt8(NSStringDrawingOptions.usesLineFragmentOrigin.rawValue))), attributes: attributedDict as? [NSAttributedStringKey : Any], context: nil).size
        let ceilWidth:CGFloat = ceil(attrStringSize.width)
        let ceilHeight:CGFloat = ceil(attrStringSize.height)
        return CGSize.init(width: ceilWidth, height: ceilHeight)
    }

}
