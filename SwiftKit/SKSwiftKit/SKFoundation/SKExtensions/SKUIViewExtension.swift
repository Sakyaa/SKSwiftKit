//
//  SKUIViewExtension
//  RACDemo
//
//  Created by Sakya on 2017/12/14.
//  Copyright © 2017年 Sakya. All rights reserved.
//

import UIKit

//MARK: - UIKit frame extension
extension UIView {
    /// x
    public final var sk_x: CGFloat {
        set(x) {
            frame.origin.x = x
        }
        
        get {
            return frame.origin.x
        }
    }
    public final var sk_size: CGSize {
        set(size) {
            frame.size = size
        }
        
        get {
            return frame.size
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
    /// centerX
    public final var sk_centerX: CGFloat {
        set(centerX) {
            center.x = centerX
        }
        
        get {
            return center.x
        }
    }
    /// centerY
    public final var sk_centerY: CGFloat {
        set(centerY) {
            center.y = centerY
        }
        get {
            return center.y
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
//MARK responder
extension UIView {
    
    /// controller
    var sk_viewController: UIViewController? {
        var currentView:UIView? = self
        // 当还有superView的时候就循环
        while currentView != nil {
            // 当还有下一级响应者的时候
            if let responder = currentView!.next {
                if responder is UIViewController {
                    return responder as? UIViewController
                } else {
                    if let nextView = currentView!.superview {
                        currentView = nextView
                    }
                }
                
            }
        }
        return nil
        
    }
}
extension UIView {
    //layer color
    public func sk_viewColorWithGradientStyle(gradientStyle:SKUIGradientStyle,colors:[UIColor]) -> Void {
        
        var backgroundGradientLayer:CAGradientLayer?
        if ((self.layer.sublayers) != nil) {
            for item in self.layer.sublayers! {
                if item.isKind(of: CAGradientLayer.self) {
                    backgroundGradientLayer = item as? CAGradientLayer
                }
            }
        }
        if backgroundGradientLayer == nil {
            backgroundGradientLayer = CAGradientLayer()
            backgroundGradientLayer?.frame = bounds
            backgroundGradientLayer?.cornerRadius = layer.cornerRadius
            layer.insertSublayer(backgroundGradientLayer!, at: 0)
        }
        var cgColors:[CGColor] = [CGColor]()
        for item in colors {
            cgColors.append(item.cgColor)
        }
        
        //switch
        switch gradientStyle {
        case .leftToRight:
            backgroundGradientLayer?.colors = cgColors;
            backgroundGradientLayer?.startPoint = CGPoint(x:0.0,y:0.5)
            backgroundGradientLayer?.endPoint = CGPoint(x:1.0,y:0.5)
            
        case .topToBottom:
            backgroundGradientLayer?.colors = cgColors;
            //        default:
            //            break
        }
        
    }
    
    
}


extension UIView {

    //设置背景图
    
//    UIImage *image=[UIImage imageNamed:@"login_background_icon"];
//    self.view.layer.contents=(__bridge id _Nullable)(image.CGImage);
//    self.view.layer.backgroundColor=[UIColor clearColor].CGColor;
    /**
     依照图片轮廓对控制进行裁剪
     - parameter stretchImage:  模子图片
     - parameter stretchInsets: 模子图片的拉伸区域
     */
    func clipShape(stretchImage: UIImage, stretchInsets: UIEdgeInsets) {
        // 绘制 imageView 的 bubble layer
        let bubbleMaskImage = stretchImage.resizableImage(withCapInsets: stretchInsets, resizingMode: .stretch)
        
        // 设置图片的mask layer
        let layer = CALayer()
        layer.contents = bubbleMaskImage.cgImage
        layer.contentsCenter = self.CGRectCenterRectForResizableImage(bubbleMaskImage)
        layer.frame = self.bounds
        layer.contentsScale = UIScreen.main.scale
        layer.opacity = 1
        self.layer.mask = layer
        self.layer.masksToBounds = true
    }
    
    func CGRectCenterRectForResizableImage(_ image: UIImage) -> CGRect {
        return CGRect(
            x: image.capInsets.left / image.size.width,
            y: image.capInsets.top / image.size.height,
            width: (image.size.width - image.capInsets.right - image.capInsets.left) / image.size.width,
            height: (image.size.height - image.capInsets.bottom - image.capInsets.top) / image.size.height
        )
    }
    /// 将View画成图
    func trans2Image() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(self.sk_size, false, 0)
        let ctx = UIGraphicsGetCurrentContext()
        self.layer.render(in: ctx!)
        let newImg = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImg
    }
    func setBackgroundImage(atLayer imageName:String) {
        let image = UIImage.init(named: imageName)
        self.layer.contents = image?.cgImage
        self.layer.backgroundColor = UIColor.clear.cgColor
    }
    open func setBackgroundImage(atImageView named: String) {
        let image = UIImage(named: named)
        let imageView = UIImageView(frame: self.frame)
        imageView.image = image
        addSubview(imageView)
        sendSubview(toBack: imageView)
    }
}

