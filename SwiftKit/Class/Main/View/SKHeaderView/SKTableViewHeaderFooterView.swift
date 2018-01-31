//
//  SKTableViewHeaderFooterView.swift
//  GZCanLian
//
//  Created by Sakya on 2017/12/25.
//  Copyright © 2017年 Sakya. All rights reserved.
//

import UIKit

enum SKHeaderViewStyle {
    case normalStyle
    ///
    case bottomViewStyle
}

class SKTableViewHeaderFooterView: UITableViewHeaderFooterView {

    var headerTitle:String = ""{
        didSet{
            headerLabel.text = headerTitle
        }
    }
    var subtitle:String = ""{
        didSet{
            subtitleLabel.text = subtitle
        }
    }
    //设置headerstyle
    var viewStyle:SKHeaderViewStyle = .normalStyle {
        didSet{
           updateViewConstraints()
        }
    }
    
    
    
    lazy var headerBackgroundView:UIView = {
        let headerBackgroundView:UIView = UIView()
        headerBackgroundView.backgroundColor = UIColor.white
        return headerBackgroundView
    }()
    lazy var headerLabel:UILabel = {
        let headerLabel:UILabel = UILabel()
        headerLabel.font = SKFontConstant.font_deputyLevelTitle
        headerLabel.textColor = ColorConstant.color_0
        return headerLabel
    }()
    lazy var subtitleLabel:UILabel = {
        let subtitleLabel:UILabel = UILabel()
        subtitleLabel.font = SKFontConstant.font_deputyLevelTitle
        subtitleLabel.textColor = ColorConstant.color_0
        return subtitleLabel
    }()
    lazy var headerImageView:UIImageView = {
        let headerImageView:UIImageView = UIImageView()
        headerImageView.image = UIImage(named:"headerView_left_icon")
        return headerImageView
    }()
    //class
    class func headerViewWithTableView(tableView:UITableView) -> UITableViewHeaderFooterView {
        let headerReuseIdentifier:String = "headerReuseIdentifier"
        var headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: headerReuseIdentifier)
        if headerView == nil {
            headerView = SKTableViewHeaderFooterView.init(reuseIdentifier: headerReuseIdentifier)
        }
        return headerView!
    }
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = color_gray_background;
        addSubview(headerBackgroundView)
        headerBackgroundView.addSubview(headerImageView)
        headerBackgroundView.addSubview(headerLabel)
        headerBackgroundView.addSubview(subtitleLabel)
        addViewConstraints()
    }
    fileprivate func addViewConstraints() {
        headerBackgroundView.snp.makeConstraints { (make) in
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.top.equalTo(0)
            make.bottom.equalTo(0)
        }
        headerImageView.snp.makeConstraints { (make) in
            make.left.equalTo(LayoutConstant.margin_level2)
            make.centerY.equalTo(headerBackgroundView)
        }
        headerLabel.snp.makeConstraints { (make) in
            make.left.equalTo(headerImageView.snp.right).offset(5)
            make.centerY.equalTo(headerBackgroundView)
        }
        subtitleLabel.snp.makeConstraints { (make) in
            make.right.equalTo(-LayoutConstant.margin_level2)
            make.centerY.equalTo(headerBackgroundView)
        }
    }
    fileprivate func updateViewConstraints() {
        switch viewStyle {
        case .bottomViewStyle:
            headerBackgroundView.snp.updateConstraints({ (make) in
                make.bottom.equalTo(-10)
            })
            
            break
        default:
            break
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    
    
}
