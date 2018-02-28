//
//  SKScrollPageVIew.swift
//  RACDemo
//
//  Created by Sakya on 2017/12/18.
//  Copyright © 2017年 Sakya. All rights reserved.
//

import UIKit

class SKScrollPageView: UIView {
    static let cellId = "cellId"
    private var segmentStyle = SKSegmentStyle()
    /// 附加按钮点击响应
    public var extraBtnOnClick: ((_ extraBtn: UIButton) -> Void)? {
        didSet {
            segView.extraBtnOnClick = extraBtnOnClick
        }
    }
    
    private(set) var segView: SKScrollSegmentView!
    private(set) var contentView: SKContentView!
    private var titlesArray: [String] = []
    /// 所有的子控制器
    private var childVcs: [UIViewController] = []
    // 这里使用weak避免循环引用
    private weak var parentController: UIViewController?
    
    public init(frame:CGRect, segmentStyle: SKSegmentStyle, titles: [String], childVcs:[UIViewController], parentViewController: UIViewController) {
        self.parentController = parentViewController
        self.childVcs = childVcs
        self.titlesArray = titles
        self.segmentStyle = segmentStyle
        assert(childVcs.count == titles.count, "标题的个数必须和子控制器的个数相同")
        super.init(frame: frame)
        commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        
        backgroundColor = UIColor.white
        
        segView = SKScrollSegmentView(frame: CGRect(x: 0, y: 0, width: bounds.size.width, height: 44), segmentStyle: segmentStyle, titles: titlesArray)
        
        guard let parentVc = parentController else { return }
        contentView = SKContentView(frame: CGRect(x: 0, y: (segView.frame).maxY, width: bounds.size.width, height: bounds.size.height - 44), childVcs: childVcs, parentViewController: parentVc)
        contentView.delegate = self
        
        addSubview(segView)
        addSubview(contentView)
        // 避免循环引用
        segView.titleBtnOnClick = {[unowned self] (label: UILabel, index: Int) in
            // 切换内容显示(update content)
            self.contentView.setContentOffSet(offSet: CGPoint(x: self.contentView.bounds.size.width * CGFloat(index), y: 0), animated: self.segmentStyle.changeContentAnimated)
        }
        
        
    }
    
    deinit {
        parentController = nil
        print("\(self.debugDescription) --- 销毁")
    }
    
}

//MARK: - public helper
extension SKScrollPageView {
    
    /// 给外界设置选中的下标的方法(public method to set currentIndex)
    public func selectedIndex(selectedIndex: Int, animated: Bool) {
        // 移动滑块的位置
        segView.selectedIndex(selectedIndex: selectedIndex, animated: animated)
        
    }
    
    ///   给外界重新设置视图内容的标题的方法,添加新的childViewControllers
    /// (public method to reset childVcs)
    ///  - parameter titles:      newTitles
    ///  - parameter newChildVcs: newChildVcs
    public func reloadChildVcsWithNewTitles(titles: [String], andNewChildVcs newChildVcs: [UIViewController]) {
        self.childVcs = newChildVcs
        self.titlesArray = titles
        
        segView.reloadTitlesWithNewTitles(titles: titlesArray)
        contentView.reloadAllViewsWithNewChildVcs(newChildVcs: childVcs)
    }
}

extension SKScrollPageView: SKContentViewDelegate {
    
    public var segmentView: SKScrollSegmentView {
        return segView
    }
    
}
