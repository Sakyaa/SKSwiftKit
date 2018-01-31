//
//  SKUIImageViewExtension.swift
//  RACDemo
//
//  Created by Sakya on 2017/12/15.
//  Copyright © 2017年 Sakya. All rights reserved.
//

import UIKit

extension UIImageView {
    /// 设置圆角
    func sk_setCircleImage(image: UIImage?) {
        sk_setCircleImage(image: image, radius: bounds.size.width/2)
    }
    /// 设置圆角
    /// radius
    func sk_setCircleImage(image: UIImage?, radius: CGFloat ) {
        self.image = image?.sk_drawImageSize(radius: radius, size: bounds.size)
    }
}
