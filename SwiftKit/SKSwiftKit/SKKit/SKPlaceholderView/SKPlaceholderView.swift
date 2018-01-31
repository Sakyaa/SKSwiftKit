//
//  SKPlaceholderView.swift
//  GZCanLian
//
//  Created by Sakya on 2018/1/8.
//  Copyright © 2018年 Sakya. All rights reserved.
//

import UIKit

enum SKPlaceholderViewStyle {
    case noData    ///<没有数据
    case networkError  ///<网络错误
}
typealias SKPlaceholderViewClickBlock = () -> Void

class SKPlaceholderView: BaseView {
    var placeholderStyle:SKPlaceholderViewStyle? {
        didSet{
            //更好风格
            setUpPlaceholderView()
        }
    }
     var placeholderViewBlock:SKPlaceholderViewClickBlock?
    lazy var placeholderLabel:UILabel = {
        let placeholderLabel = UILabel()
        placeholderLabel.textColor = ColorConstant.color_3
        placeholderLabel.font = SKFontConstant.font_navigationBarTitle
        placeholderLabel.numberOfLines = 0
        placeholderLabel.sk_width =  self.sk_width - 60
        placeholderLabel.sk_height =  50
        placeholderLabel.sk_centerX = self.sk_centerX
        placeholderLabel.sk_centerY = self.sk_height * 0.4
        placeholderLabel.textAlignment = .center
        return placeholderLabel
    }()
    lazy var retryButton:UIButton = {
        let retryButton = UIButton.init(type: .custom)
        retryButton.sk_width = 90
        retryButton.sk_height = 40
        retryButton.setTitle("重试", for: .normal)
        retryButton.titleLabel?.font = SKFontConstant.sk_font17
        retryButton.setTitleColor(ColorConstant.color_8, for: .normal)
        retryButton.layer.borderColor = ColorConstant.color_c?.cgColor
        retryButton.layer.borderWidth = 1.0
        retryButton.layer.cornerRadius = 6.0
        retryButton.rx.tap
            .subscribe({ [weak self] _ in
                self?.placeholderViewBlock != nil ? self?.placeholderViewBlock!() : nil
            })
            .disposed(by: disposeBag)
        retryButton.isHidden = true
        return retryButton
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        addSubview(placeholderLabel)
        addSubview(retryButton)
    }
    fileprivate func setUpPlaceholderView(){
        switch placeholderStyle {
        case .networkError?:
            placeholderLabel.textColor = ColorConstant.color_8
            placeholderLabel.font = SKFontConstant.sk_font21
            let text:String = "由于网络连接问题，您的申请无法发送，请重试。"
            placeholderLabel.text = text
            let contentHeight = text.heightText(font: SKFontConstant.sk_font21, width: placeholderLabel.sk_width)
            placeholderLabel.sk_height = contentHeight
            placeholderLabel.sk_centerY = self.sk_height * 0.2
            retryButton.isHidden = false
            retryButton.sk_centerX = self.sk_centerX
            retryButton.sk_top = placeholderLabel.sk_bottom + 15
            break
        case .noData?:
            placeholderLabel.textColor = ColorConstant.color_3
            placeholderLabel.font = SKFontConstant.font_navigationBarTitle
            placeholderLabel.sk_height =  50
            placeholderLabel.sk_centerY = self.sk_height * 0.4
            placeholderLabel.text = "无结果"
            retryButton.isHidden = true
            break       
         default:
            break
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
