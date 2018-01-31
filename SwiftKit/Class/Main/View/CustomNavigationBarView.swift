//
//  CustomNavigationBarView.swift
//  GZCanLian
//
//  Created by Sakya on 2017/12/20.
//  Copyright © 2017年 Sakya. All rights reserved.
//

import UIKit
import SwifterSwift

/// ios 11 style bigtitle
enum CustomNavigationBarStyle {
    //title 标题
    //isBlue返回按钮颜色isBlue blueColor default
    //addressTitle
    //rightItem
    //additionalTitle -》底部附加信息
    //rightImageView
    case isHideNavigationBar //隐藏导航条
    case normalNavigation // 正常导航条
    ///只有标题 返回按钮为绿色
    case titleNormalBackSimple
    ///date  头像  标题
    case titleDateHeader
    //标题 返回按钮为绿色 右侧文本
    case titleNormalBackRText
    //标题 返回按钮为绿色 头像 bottom描述文本
    case titleNormalBackBTextHeader
    //正常高度导航条两侧都有按钮
    case normalNavigationBothButton
      //右侧一个按钮啊 定制
    case titleBackRightButton
    //右侧两个按钮啊
    case titleBackTwoRightButton

}
///右侧按钮样式
enum CustomRightNavigationBarStyle {
    case hideRightItem
    case titleRightItem(title:String) ///< 编辑的
    case imageRightItem(imageName:String) ///< homeback  返回主页按钮
}


struct CustomNavigationBarConfig {
    //
    var title:String = ""
    var headerImageName:String = ""
    var bottomText:String = ""
    var rightText:String = ""
    var dateText:String = ""
    
    init (title: String, headerImageName: String? = nil, bottomText: String? = nil, rightText: String? = nil, dateText: String? = nil) {
        self.title = title
        if headerImageName != nil { self.headerImageName = headerImageName! }
        if bottomText != nil { self.bottomText = bottomText! }
        if rightText != nil { self.rightText = rightText! }
        if dateText != nil { self.dateText = dateText! }
    }
}


typealias NavigationBarCalculateHeightBlock = (CGFloat) -> Void

class CustomNavigationBarView: BaseView {
    struct SKNavigationBar {
        static let buttonNormalWidth = 44.0
        static let buttonHeight = 44.0
        static let buttonTitleWidth = 80.0
        static let titleDefaultHeight = 40.0
        static let margainBottom : CGFloat = 20.0
    }
    weak var delegate:CustomNavigationBarDelegate?
    var barStyle:CustomNavigationBarStyle = .isHideNavigationBar //
    var barConfiguration:CustomNavigationBarConfig!   //
//    var calculateBarHeight:NavigationBarCalculateHeightBlock?           //接收上个页面穿过来的闭包块
    public var navigationBarHeight:CGFloat = 0.0

    var rightItemStyle:CustomRightNavigationBarStyle = .imageRightItem(imageName:"web_home_navright_icon") {
        didSet {
            switch rightItemStyle {
            case .titleRightItem(let title):
                rightItemButton.isHidden = false
                rightItemButton.setTitle(title, for: .normal)
                rightItemButton.setImage(nil, for: .normal)
                break
            case .imageRightItem(let imageName):
                rightItemButton.isHidden = false
                rightItemButton.setImage(UIImage(named:imageName), for: .normal)
                rightItemButton.setTitle("", for: .normal)

                break
            default:
                rightItemButton.isHidden = true
                break
            }
        }
    }
    
    
    lazy var titleLabel:UILabel = {
        let titleLabel:UILabel = UILabel()
        titleLabel.sk_left = 15
        titleLabel.sk_width = sk_xFrom6(280)
        titleLabel.numberOfLines = 0
        titleLabel.font = SKFontConstant.font_navigationBarTitle
        titleLabel.textColor = ColorConstant.color_0
        return titleLabel
    }()
    lazy var backItemButton:UIButton = {
        let backItemButton:UIButton = UIButton(type:.custom)
        backItemButton.size = CGSize(width:SKNavigationBar.buttonTitleWidth,height:SKNavigationBar.buttonHeight)
        backItemButton.sk_top = KScreenConstant.sk_kStatusBarHeight
        backItemButton.setTitle("返回", for: .normal)
        backItemButton.setImage(UIImage(named:"navigationbar_backimage_icon"), for: .normal)
        backItemButton.setTitleColor(color_blue_system, for: .normal)
        backItemButton.titleLabel?.font = SKFontConstant.sk_font17
        backItemButton.sk_left = 15
        backItemButton.contentHorizontalAlignment = .left
        backItemButton.rx.tap.subscribe(onNext: {[weak self] _ in
            self?.delegate?.navigationBarLeftButtonAction()
        }).disposed(by: disposeBag)
        return backItemButton
    }()
    lazy var rightItemButton:UIButton = {
        let rightItemButton:UIButton = UIButton(type:.custom)
        rightItemButton.size = CGSize(width:SKNavigationBar.buttonNormalWidth,height:SKNavigationBar.buttonHeight)
        rightItemButton.sk_top = KScreenConstant.sk_kStatusBarHeight
        rightItemButton.sk_right = KScreenConstant.sk_kScreenWidth - 15
        rightItemButton.setImage(UIImage(named:"web_home_navright_icon"), for: .normal)
        rightItemButton.setTitleColor(color_blue_system, for: .normal)
        rightItemButton.titleLabel?.font = SKFontConstant.sk_font17
        rightItemButton.rx.tap.subscribe(onNext: {[weak self] _ in
            self?.delegate?.navigationBarRightButtonAction!()
        }).disposed(by: disposeBag)
        rightItemButton.isHidden = true
        return rightItemButton
    }()
    lazy var rightSecondButton:UIButton = {
        let rightSecondButton:UIButton = UIButton(type:.custom)
        rightSecondButton.size = CGSize(width:SKNavigationBar.buttonNormalWidth,height:SKNavigationBar.buttonHeight)
        rightSecondButton.sk_top = KScreenConstant.sk_kStatusBarHeight
        rightSecondButton.setTitleColor(color_blue_system, for: .normal)
        rightSecondButton.titleLabel?.font = SKFontConstant.sk_font17
        rightSecondButton.rx.tap.subscribe(onNext: {[weak self] _ in
            self?.delegate?.navigationBarSecondRightButtonAction!()
        }).disposed(by: disposeBag)
        return rightSecondButton
    }()
    lazy var dateLabel:UILabel = {
        let dateLabel:UILabel = UILabel()
        dateLabel.size = CGSize(width:200,height:SKNavigationBar.buttonHeight)
        dateLabel.textColor = ColorConstant.color_6
        dateLabel.font = SKFontConstant.sk_font16
        dateLabel.sk_left = 15
        return dateLabel
    }()
    lazy var headImageView:UIImageView = {
        let headImageView:UIImageView = UIImageView()
        headImageView.size = CGSize(width:40,height:40)
        headImageView.sk_right = KScreenConstant.sk_kScreenWidth - 15
        headImageView.isUserInteractionEnabled = true
        let tapBackground = UITapGestureRecognizer()
        tapBackground.rx.event.subscribe({[weak self] _ in
        //点击了头像啊
            self?.delegate?.navigationBarTapEventDetected!()
        }).disposed(by: disposeBag)
        headImageView.addGestureRecognizer(tapBackground)
        return headImageView
    }()
    lazy var locationImageView:UIImageView = {
        let locationImageView:UIImageView = UIImageView()
        locationImageView.image = UIImage(named:"navigationbar_location_icon")
        return locationImageView
    }()
    lazy var rightItemLabel:UILabel = {
        let rightItemLabel:UILabel = UILabel()
        rightItemLabel.textColor = ColorConstant.color_6
        rightItemLabel.numberOfLines = 0
        rightItemLabel.font = SKFontConstant.sk_font14
        return rightItemLabel
    }()
    lazy var bottomLabel:UILabel = {
        let bottomLabel:UILabel = UILabel()
        bottomLabel.size = CGSize.init(width: KScreenConstant.sk_kScreenWidth - LayoutConstant.margin_level2 * 2, height: 40)
        bottomLabel.font = SKFontConstant.sk_font15
        bottomLabel.textColor = ColorConstant.color_8
        bottomLabel.numberOfLines = 0
        bottomLabel.sk_left = 15
        return bottomLabel
    }()
    lazy var itemLabel:UILabel = {
        let itemLabel:UILabel = UILabel()
        itemLabel.textAlignment = .center
        itemLabel.font = SKFontConstant.sk_font17
        itemLabel.textColor = ColorConstant.color_3
        itemLabel.size = CGSize.init(width: KScreenConstant.sk_kScreenWidth - 80 * 2 - 15 * 2, height: 44)
        itemLabel.sk_top = KScreenConstant.sk_kStatusBarHeight
        itemLabel.isUserInteractionEnabled = true
        let tapBackground = UITapGestureRecognizer()
        tapBackground.rx.event.subscribe({[weak self] _ in
            self?.delegate?.navigationBarMidViewAction!()
        }).disposed(by: disposeBag)
        itemLabel.addGestureRecognizer(tapBackground)
        return itemLabel
    }()
    fileprivate lazy var bottomLine:CALayer = {
        let bottomLine:CALayer = CALayer()
        bottomLine.sk_width = KScreenConstant.sk_kScreenWidth - LayoutConstant.margin_level2 * 2
        bottomLine.sk_height = 0.5
        bottomLine.backgroundColor = color_gray_separatedLine?.cgColor
        bottomLine.sk_top = KScreenConstant.sk_kStatusBarHeight
        bottomLine.sk_left = 15
        return bottomLine
    }()
    
    func setBackCalculateHeight(tmpHeight:@escaping NavigationBarCalculateHeightBlock) {
//        self.calculateBarHeight = tmpHeight
    }
    
    //MARK:-- life
    convenience init(style: CustomNavigationBarStyle,configuration: CustomNavigationBarConfig ,frame: CGRect) {
        self.init(frame: frame)
        
        var navigationBarheight:CGFloat = KScreenConstant.sk_kNavigationStatusBarHeight
        navigationBarheight += (LayoutConstant.margin_level2 * 2)
        barConfiguration = configuration
        barStyle = style
        
        switch style {
        case.isHideNavigationBar:
            self.isHidden = true
            break
        case .titleNormalBackSimple:
            self.addSubview(backItemButton)
            navigationBarheight += self.customBigTitleStyle(title: configuration.title)
            
            break
        case .titleBackRightButton:
            self.addSubview(backItemButton)
            navigationBarheight += self.customBigTitleStyle(title: configuration.title)
            self.addSubview(rightItemButton)
            break
        case .titleBackTwoRightButton:
            self.addSubview(backItemButton)
            navigationBarheight += self.customBigTitleStyle(title: configuration.title)
            self.addSubview(rightItemButton)
            self.addSubview(rightSecondButton)
    
            rightSecondButton.sk_right = rightItemButton.sk_left - 10
            
            break
        case .titleDateHeader:

            self.addSubview(dateLabel)
            self.addSubview(headImageView)
            layer.addSublayer(bottomLine)
            headImageView.image = UIImage(named:configuration.headerImageName)
            dateLabel.text = configuration.dateText
            navigationBarheight += self.customBigTitleStyle(title: configuration.title)

            
            break
        case .titleNormalBackRText:

            self.addSubview(rightItemLabel)
            self.addSubview(backItemButton)
            self.addSubview(locationImageView)
            rightItemLabel.text = configuration.rightText
            navigationBarheight += self.customBigTitleStyle(title: configuration.title)
            //right label
            rightItemLabel.snp.makeConstraints({ (make) in
                make.centerY.equalTo(backItemButton)
                make.right.equalTo(-LayoutConstant.margin_level2)
                make.width.lessThanOrEqualTo(KScreenConstant.sk_kScreenWidth/2)
            })
            locationImageView.snp.makeConstraints({ (make) in
                make.centerY.equalTo(rightItemLabel)
                make.right.equalTo(rightItemLabel.snp.left)
            })

            break
        case .titleNormalBackBTextHeader:
            self.addSubview(backItemButton)
            self.addSubview(headImageView)
            self.addSubview(bottomLabel)
            bottomLabel.text = configuration.bottomText
            headImageView.image = UIImage(named:configuration.headerImageName)
            navigationBarheight += self.customBigTitleStyle(title: configuration.title)
            navigationBarheight += 40
            
            break
        case .normalNavigation:
            self.addSubview(backItemButton)
            addSubview(itemLabel)
            itemLabel.text = configuration.title
            navigationBarheight = KScreenConstant.sk_kNavigationStatusBarHeight
            break
        case .normalNavigationBothButton:
            self.addSubview(backItemButton)
            self.addSubview(rightItemButton)
            addSubview(itemLabel)
            itemLabel.text = configuration.title
            navigationBarheight = KScreenConstant.sk_kNavigationStatusBarHeight
            break

        }
        self.navigationBarHeight = navigationBarheight
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white

    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        self.manualLayoutSubviews()
    }
    private func customBigTitleStyle(title:String)->CGFloat {
        self.addSubview(titleLabel)
        titleLabel.text = title
        let titleHeight = titleLabel.requiredHeight
        titleLabel.sk_height = titleHeight
        return titleHeight
    }
    public func manualLayoutSubviews() {

        //设置布局 分布
        switch barStyle {
        case .titleNormalBackSimple:
            titleLabel.sk_bottom = self.sk_bottom - SKNavigationBar.margainBottom
            break
        case .titleBackRightButton:
            titleLabel.sk_bottom = self.sk_bottom - SKNavigationBar.margainBottom
            break
        case .titleBackTwoRightButton:
            titleLabel.sk_bottom = self.sk_bottom - SKNavigationBar.margainBottom
            break
        case .titleDateHeader:
            
            titleLabel.sk_bottom = self.sk_bottom - 10
            headImageView.size = (headImageView.image?.size)!
            headImageView.sk_top = titleLabel.sk_top
            dateLabel.sk_bottom = titleLabel.sk_top
            bottomLine.sk_bottom = sk_height - 0.5
            break
        case .titleNormalBackRText:
            
            titleLabel.sk_bottom = self.sk_bottom - 10

            
            
            break
        case .titleNormalBackBTextHeader:
            

            bottomLabel.sk_bottom = sk_bottom - 10
            titleLabel.sk_bottom = bottomLabel.sk_top - 10
            headImageView.size = (headImageView.image?.size)!
            headImageView.sk_top = titleLabel.sk_top
            bottomLine.sk_bottom = sk_bottom - 0.5
            bottomLine.sk_left = 0
            bottomLine.sk_width = KScreenConstant.sk_kScreenWidth
            break
        case .isHideNavigationBar:
            
            break
        case .normalNavigation:
            itemLabel.sk_centerX = self.sk_centerX

            break
        case .normalNavigationBothButton:
            
            itemLabel.sk_centerX = self.sk_centerX
            break
        }
        
    }
}
//MARK: -- Navigation event procotol
@objc protocol CustomNavigationBarDelegate:NSObjectProtocol {
    ///返回按钮的点击
    func navigationBarLeftButtonAction()
    ///头像点击
    @objc optional func navigationBarTapEventDetected()
    ///导航条右侧按钮点击
    @objc optional func navigationBarRightButtonAction()
    ///导航条右侧按钮点击
    @objc optional func navigationBarSecondRightButtonAction()
//    点击topitemlabel
    @objc optional func navigationBarMidViewAction()

}

