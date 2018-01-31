//
//  SKAlertView.swift
//  GZCanLian
//
//  Created by Sakya on 2017/12/24.
//  Copyright © 2017年 Sakya. All rights reserved.
//

import UIKit

enum SKAlertViewStyle {
    case normal(title:String)  ///正常多按钮风格饿
    case prominent(title:String)  ///只有一个按钮的风格啊
}
enum SKAlertViewAction {
    case cancelAction(title:String), defaultAction(title:String)
}
struct SKAlertViewLayout {
    
    static let viewNormalWidth:CGFloat = sk_xFrom6(300)
    static let viewProminentWidth:CGFloat = sk_xFrom6(300)
    static let viewTitleHeight:CGFloat =  60
    static let viewMargin:CGFloat =  15
    static let contentMargin:CGFloat =  sk_xFrom6(30)
    static let contentTopOrBottomMargin:CGFloat =  sk_xFrom6(40)
    static let contentInternalMargin:CGFloat =  sk_xFrom6(15)
    static let buttonHeight:CGFloat =  45
    static let contentFont:UIFont = UIFont.systemFont(ofSize: 17)
    static let contentImageSize:CGSize = CGSize.init(width: sk_xFrom6(55), height: sk_xFrom6(55))
    static let prominentLabelHeight:CGFloat = 30
}
class SKAlertView: UIView {
    
    typealias alertActionBlock = (_ sender: UIButton) -> Void//声明
    var actionBlock: alertActionBlock?//持有
    
    lazy var backgoundView:UIView = {
        let backgoundView:UIView = UIView()
        backgoundView.backgroundColor = UIColor.white
        backgoundView.clipsToBounds = true
        backgoundView.layer.cornerRadius = skCornerRadius
        return backgoundView
    }()
    lazy var toolbarView:UIView = {
        let toolbarView:UIView = UIView()
        toolbarView.backgroundColor = UIColor.white
        return toolbarView
    }()
    
    lazy var contentView:SKAlertMainView = {
        let contentView:SKAlertMainView = SKAlertMainView.init(frame: CGRect.init(x: 0, y: 0, width: backgoundView.sk_width, height: backgoundView.height - toolbarView.sk_height),content:alertViewContent,title:alertViewTitle)
        if !proimageName.isEmpty {contentView.imageView.image = UIImage.init(named: proimageName)}
        return contentView
    }()
    lazy var contentLabel:UILabel = {
        let contentLabel:UILabel = UILabel()
        contentLabel.numberOfLines = 0
        contentLabel.sk_width = backgoundView.width - SKAlertViewLayout.contentMargin * 2
        contentLabel.sk_left = SKAlertViewLayout.contentMargin
        contentLabel.sk_top = SKAlertViewLayout.contentTopOrBottomMargin
        contentLabel.textAlignment = .center
        return contentLabel
    }()
    var buttons:[UIButton] = [UIButton]()
    fileprivate var alertViewContent:String = ""
    fileprivate var alertViewTitle:String = ""
    var proimageName:String = ""
    var buttonActions:[SKAlertViewAction] = [SKAlertViewAction]()
    var viewStyle:SKAlertViewStyle = .normal(title: "")
    
    ///
    /// - Parameters:
    ///   - style: 弹窗风格
    ///   - actions: 主要为了多按钮区别
    ///   - content: 内容
    ///   - title: 标题选择
    convenience init(style:SKAlertViewStyle,actions:[SKAlertViewAction],content:String,title:String? = "",imageName:String? = "") {
        self.init(frame: KScreenConstant.sk_kScreenBounds)
        buttonActions = actions
        viewStyle = style
        alertViewContent = content
        alertViewTitle = title!
        if !(imageName?.isEmpty)! {
            proimageName = imageName!
        }
        setUpCustomView()
    }
    fileprivate func setUpCustomView() {
        addSubview(backgoundView)
        switch viewStyle {
        case .normal(_):
            backgoundView.sk_width = SKAlertViewLayout.viewNormalWidth
            toolbarView.sk_width = backgoundView.sk_width
            //需要计算正常
            //计算content高度啊
            let contentHeight:CGFloat = alertViewContent.heightText(font: SKAlertViewLayout.contentFont, width: contentLabel.sk_width)
            
            backgoundView.sk_height = contentHeight +  SKAlertViewLayout.contentTopOrBottomMargin * 2  + SKAlertViewLayout.buttonHeight
            contentLabel.sk_height = contentHeight
            toolbarView.sk_height = SKAlertViewLayout.buttonHeight
            backgoundView.addSubview(contentLabel)
            contentLabel.text = alertViewContent
            break
        case .prominent(let title):
            alertViewTitle = title
            backgoundView.sk_width = SKAlertViewLayout.viewProminentWidth
            let contentLabelHeight:CGFloat = alertViewContent.heightText(font: SKFontConstant.sk_font17, width: (backgoundView.sk_width-SKAlertViewLayout.viewMargin * 2))
            let mainContentHeight = SKAlertViewLayout.contentMargin + SKAlertViewLayout.contentImageSize.height + SKAlertViewLayout.contentInternalMargin * 3 + SKAlertViewLayout.prominentLabelHeight + contentLabelHeight
            //高度计算啊
            toolbarView.sk_height = SKAlertViewLayout.buttonHeight + SKAlertViewLayout.viewMargin * 2
            backgoundView.sk_height = mainContentHeight +  toolbarView.sk_height
            
            toolbarView.sk_width = backgoundView.sk_width
            backgoundView.addSubview(contentView)
            break
        }
        backgoundView.center = self.center
        toolbarView.sk_bottom = backgoundView.sk_height
        backgoundView.addSubview(toolbarView)
        setUpToolbarButton()
    }
    
    
    ///创建button
    fileprivate func setUpToolbarButton() {
        
        switch viewStyle {
        case .normal( _):
            
            let buttonWidth = backgoundView.sk_width/CGFloat(buttonActions.count)
            for action in buttonActions {
                let button = UIButton.init(type: .custom)
                button.sk_left = buttonWidth * CGFloat(buttons.count)
                button.height = SKAlertViewLayout.buttonHeight
                button.sk_bottom = toolbarView.sk_height
                button.width = buttonWidth
                button.tag = buttons.count
                button.titleLabel?.font = SKFontConstant.sk_font15
                
                button.addTarget(self, action: #selector(buttonActionDetected(sender:)), for: .touchUpInside)
                toolbarView.addSubview(button)
                buttons.append(button)
                switch action {
                case .cancelAction(let title):
                    button.setTitleColor(ColorConstant.color_6, for: .normal)
                    button.backgroundColor = UIColor.white
                    button.setTitle(title, for: .normal)
                    //创建顶部线条
                    let lineLayer:CALayer = CALayer()
                    lineLayer.sk_width = button.sk_width
                    lineLayer.sk_height = 0.5
                    lineLayer.backgroundColor = color_gray_disable?.cgColor
                    button.layer.addSublayer(lineLayer)
                    break
                case .defaultAction(let title):
                    button.setTitleColor(UIColor.white, for: .normal)
                    button.backgroundColor = color_blue_system
                    button.setTitle(title, for: .normal)
                    
                    break
                }
            }
            
            break
        case .prominent( _):
            let actions:SKAlertViewAction = buttonActions.first!
            let button = UIButton.init(type: .custom)
            button.layer.cornerRadius = skCornerRadius
            button.height = SKAlertViewLayout.buttonHeight
            button.sk_bottom = toolbarView.sk_height - SKAlertViewLayout.viewMargin
            button.sk_width = toolbarView.sk_width - SKAlertViewLayout.viewMargin * 4
            button.sk_centerX = toolbarView.sk_centerX
            button.titleLabel?.font = SKFontConstant.sk_font15
            
            switch actions {
            case .cancelAction(_):
                
                break
            case .defaultAction(let title):
                
                button.sk_viewColorWithGradientStyle(gradientStyle: .leftToRight, colors: [color_blue_gradientLight!,color_blue_gradientDark!])
                button.setTitle(title, for: .normal)
                break
            }
            button.addTarget(self, action: #selector(buttonActionDetected(sender:)), for: .touchUpInside)
            toolbarView.addSubview(button)
            buttons.append(button)
            
            break
        }
    }
    @objc fileprivate func buttonActionDetected(sender: UIButton) {
        self.viewHide()
        self.actionBlock?(sender)
    }
    public func viewShow() {
        
        let window = UIApplication.shared.keyWindow
        window?.endEditing(true)
        guard let currentWindow = window else { return }
        currentWindow.addSubview(self)
        UIView.animate(withDuration: 0.25, animations: { [unowned self] in
            self.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.4)
            
            }, completion: nil)
        
    }
    public func viewHide() {
        UIView.animate(withDuration: 0.25, animations: {
            
        }) {[unowned self] (_) in
            self.removeFromSuperview()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
//有图片的时候
class SKAlertMainView: UIView {
    
    lazy var contentLabel:UILabel = {
        let contentLabel:UILabel = UILabel()
        contentLabel.font = SKFontConstant.sk_font17
        contentLabel.numberOfLines = 0
        contentLabel.textColor = ColorConstant.color_3
        contentLabel.textAlignment = .center
        return contentLabel
    }()
    lazy var titleLabel:UILabel = {
        let titleLabel:UILabel = UILabel()
        titleLabel.font = SKFontConstant.sk_font20
        titleLabel.numberOfLines = 0
        
        titleLabel.textColor = color_blue_system
        titleLabel.textAlignment = .center
        return titleLabel
    }()
    lazy var imageView:UIImageView = {
        let imageView:UIImageView = UIImageView()
        
        imageView.image = UIImage.init(named: "alert_prompt_iocn")
        
        return imageView
    }()
    convenience init(frame: CGRect,content:String,title:String? = "") {
        self.init(frame: frame)
        
        addSubview(imageView)
        addSubview(contentLabel)
        addSubview(titleLabel)
        contentLabel.text = content
        titleLabel.text = title
    }
    override init(frame: CGRect) {
        super.init(frame: frame )
    }
    override func layoutSubviews() {
        
        
        imageView.size = SKAlertViewLayout.contentImageSize
        imageView.sk_top = SKAlertViewLayout.contentMargin
        imageView.sk_centerX = self.sk_width/2
        
        titleLabel.sk_width = self.sk_width - SKAlertViewLayout.viewMargin * 2
        titleLabel.sk_centerX = self.sk_centerX
        titleLabel.sk_height = SKAlertViewLayout.prominentLabelHeight
        titleLabel.sk_top = imageView.sk_bottom + SKAlertViewLayout.contentInternalMargin
        
        contentLabel.sk_width = self.sk_width - SKAlertViewLayout.viewMargin * 2
        contentLabel.sk_centerX = self.sk_centerX
        contentLabel.sk_height = self.sk_height - titleLabel.sk_bottom - SKAlertViewLayout.contentInternalMargin * 2
        contentLabel.sk_bottom = self.sk_height - SKAlertViewLayout.contentInternalMargin
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


