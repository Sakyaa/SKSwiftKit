//
//  SKPickerToolBarView.swift
//  GZCanLian
//
//  Created by Sakya on 2017/12/25.
//  Copyright © 2017年 Sakya. All rights reserved.
//

import UIKit

class SKPickerToolBarView: UIView {
    typealias CustomClosures = (_ titleLabel: UILabel, _ cancleBtn: UIButton, _ doneBtn: UIButton) -> Void
    public typealias BtnAction = () -> Void
    public var title = "请选择" {
        didSet {
            titleLabel.text = title
        }
    }
    public var doneAction: BtnAction?
    public var cancelAction: BtnAction?
    // 用来产生上下分割线的效果
    private lazy var contentView: UIView = {
        let content = UIView()
        content.backgroundColor = UIColor.white
        return content
    }()
    // 文本框
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        label.textAlignment = .center
        return label
    }()
    
    // 取消按钮
    private lazy var cancleBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("取消", for: .normal)
        btn.setTitleColor(UIColor.black, for: .normal)
        return btn
    }()
    
    // 完成按钮
    private lazy var doneBtn: UIButton = {
        let donebtn = UIButton()
        donebtn.setTitle("完成", for: .normal)
        donebtn.setTitleColor(UIColor.black, for: .normal)
        return donebtn
    }()
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        initCustomToolbar()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func initCustomToolbar() {

        addSubview(contentView)
        contentView.addSubview(cancleBtn)
        contentView.addSubview(doneBtn)
        contentView.addSubview(titleLabel)
        
        doneBtn.addTarget(self, action: #selector(self.doneBtnOnClick(sender:)), for: .touchUpInside)
        cancleBtn.addTarget(self, action: #selector(self.cancelBtnOnClick(sender:)), for: .touchUpInside)
    }
    @objc func doneBtnOnClick(sender: UIButton) {
        doneAction?()
    }
    @objc func cancelBtnOnClick(sender: UIButton) {
        cancelAction?()
        
    }
    override public func layoutSubviews() {
        super.layoutSubviews()
        let margin = 15.0
        let contentHeight = Double(bounds.size.height) - 2.0
        contentView.frame = CGRect(x: 0.0, y: 1.0, width: Double(bounds.size.width), height: contentHeight)
        let btnWidth = contentHeight
        
        cancleBtn.frame = CGRect(x: margin, y: 0.0, width: btnWidth, height: btnWidth)
        doneBtn.frame = CGRect(x: Double(bounds.size.width) - btnWidth - margin, y: 0.0, width: btnWidth, height: btnWidth)
        let titleX = Double((cancleBtn.frame).maxX) + margin
        let titleW = Double(bounds.size.width) - titleX - btnWidth - margin
        titleLabel.frame = CGRect(x: titleX, y: 0.0, width: titleW, height: btnWidth)
    }
}
