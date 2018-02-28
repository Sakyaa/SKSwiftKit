//
//  SKContentView.swift
//  RACDemo
//
//  Created by Sakya on 2017/12/18.
//  Copyright © 2017年 Sakya. All rights reserved.
//

import UIKit

public class SKContentView: UIView {
    static let cellId = "cellId"
    
    /// 所有的子控制器
    private var childVcs: [UIViewController] = []
    /// 用来判断是否是点击了title, 点击了就不要调用scrollview的代理来进行相关的计算
    private var forbidTouchToAdjustPosition = false
    /// 用来记录开始滚动的offSetX
    private var oldOffSetX:CGFloat = 0.0
    private var oldIndex = 0
    private var currentIndex = 1
    
    // 这里使用weak 避免循环引用
    private weak var parentController: UIViewController?
    public weak var delegate: SKContentViewDelegate?
    
    private(set) lazy var collectionView: UICollectionView = {[weak self] in
        let flowLayout = UICollectionViewFlowLayout()
        
        let collection = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
        
        if let strongSelf = self {
            flowLayout.itemSize = strongSelf.bounds.size
            flowLayout.scrollDirection = .horizontal
            flowLayout.minimumLineSpacing = 0
            flowLayout.minimumInteritemSpacing = 0
            
            collection.scrollsToTop = false
            collection.bounces = false
            collection.showsHorizontalScrollIndicator = false
            collection.frame = strongSelf.bounds
            collection.collectionViewLayout = flowLayout
            collection.isPagingEnabled = true
            // 如果不设置代理, 将不会调用scrollView的delegate方法
            collection.delegate = strongSelf as UICollectionViewDelegate
            collection.dataSource = strongSelf as UICollectionViewDataSource
            collection.register(UICollectionViewCell.self, forCellWithReuseIdentifier: SKContentView.cellId)
            
        }
        return collection
        }()
    
    //MARK:- life cycle
    public init(frame:CGRect, childVcs:[UIViewController], parentViewController: UIViewController) {
        self.parentController = parentViewController
        self.childVcs = childVcs
        super.init(frame: frame)
        commonInit()
        
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("不要使用storyboard中的view为contentView")
    }
    
    
    private func commonInit() {
        
        // 不要添加navigationController包装后的子控制器
        for childVc in childVcs {
            if childVc.isKind(of:UINavigationController.self) {
                fatalError("不要添加UINavigationController包装后的子控制器")
            }
            parentController?.addChildViewController(childVc)
        }
        collectionView.backgroundColor = UIColor.clear
        collectionView.frame = bounds
        
        // 在这里调用了懒加载的collectionView, 那么之前设置的self.frame将会用于collectionView,如果在layoutsubviews()里面没有相关的处理frame的操作, 那么将导致内容显示不正常
        addSubview(collectionView)
        
        // 设置naviVVc手势代理, 处理pop手势
        if let naviParentViewController = self.parentController?.parent as? UINavigationController, let popGesture = naviParentViewController.interactivePopGestureRecognizer {
            if naviParentViewController.viewControllers.count == 1 { return }// 如果是第一个不要设置代理
            naviParentViewController.interactivePopGestureRecognizer?.delegate = self as UIGestureRecognizerDelegate
            // 优先执行naviParentViewController.interactivePopGestureRecognizer的手势
            // 在代理方法中会判断是否真的执行, 不执行的时候就执行scrollView的滚动手势
            collectionView.panGestureRecognizer.require(toFail: popGesture)
            
        }
    }
    
    // 发布通知
    private func addCurrentShowIndexNotification(index: Int) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: ScrollPageViewDidShowThePageNotification), object: nil, userInfo: ["currentIndex": index])
        
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = bounds
        
    }
    
    deinit {
        parentController = nil
        print("\(self.debugDescription) --- 销毁")
    }
    
}

//MARK: - public helper
extension SKContentView {
    
    // 给外界可以设置ContentOffSet的方法(public method to set contentOffSet)
    public func setContentOffSet(offSet: CGPoint , animated: Bool) {
        // 不要执行collectionView的scrollView的滚动代理方法
        self.forbidTouchToAdjustPosition = true
        //这里开始滚动
        delegate?.contentViewDidBeginMove(scrollView: collectionView)
        self.collectionView.setContentOffset(offSet, animated: animated)
        
    }
    
    // 给外界刷新视图的方法(public method to reset childVcs)
    public func reloadAllViewsWithNewChildVcs(newChildVcs: [UIViewController] ) {
        
        // removing the old childVcs
        childVcs.forEach { (childVc) in
            childVc.willMove(toParentViewController: nil)
            childVc.view.removeFromSuperview()
            childVc.removeFromParentViewController()
        }
        // setting the new childVcs
        self.childVcs = newChildVcs
        
        // don't add the childVc that wrapped by the navigationController
        // 不要添加navigationController包装后的子控制器
        for childVc in childVcs {
            if childVc.isKind(of: UINavigationController.self) {
                fatalError("不要添加UINavigationController包装后的子控制器")
            }
            // add childVc
            parentController?.addChildViewController(childVc)
            
        }
        
        // refreshing
        collectionView.reloadData()
        
    }
}



//MARK:- UICollectionViewDelegate, UICollectionViewDataSource
extension SKContentView: UICollectionViewDelegate, UICollectionViewDataSource {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return childVcs.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SKContentView.cellId, for: indexPath as IndexPath)
        // 避免出现重用显示内容出错 ---- 也可以直接给每个cell用不同的reuseIdentifier实现
        // avoid to the case that shows the wrong thing due to the collectionViewCell's reuse
        for subview in cell.contentView.subviews {
            subview.removeFromSuperview()
        }
        let vc = childVcs[indexPath.row]
        
        
        vc.view.frame = bounds
        cell.contentView.addSubview(vc.view)
        // finish buildding the parent-child relationship
        vc.didMove(toParentViewController: parentController)
        // 发布将要显示的index
        addCurrentShowIndexNotification(index: indexPath.row)
        return cell
    }
    
}


// MARK: - UIScrollViewDelegate
extension SKContentView: UIScrollViewDelegate {
    // update UI
    final public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let currentIndex = Int(floor(scrollView.contentOffset.x / bounds.size.width))
        //        print("减速完成")
        //        if self.currentIndex == currentIndex {// finish scrolling to next page
        //
        //            addCurrentShowIndexNotification(currentIndex)
        //
        //        }
        delegate?.contentViewDidEndDisPlay(scrollView: collectionView)
        // 保证如果滚动没有到下一页就返回了上一页
        // 通过这种方式再次正确设置 index(still at oldPage )
        delegate?.contentViewDidEndMoveToIndex(fromIndex: self.currentIndex, toIndex: currentIndex)
        
        
    }
    
    // 代码调整contentOffSet但是没有动画的时候不会调用这个
    final public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        delegate?.contentViewDidEndDisPlay(scrollView: collectionView)
        
        
    }
    
    final public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let currentIndex = Int(floor(scrollView.contentOffset.x / bounds.size.width))
        
        delegate?.contentViewDidEndDrag(scrollView: scrollView)
        print(scrollView.contentOffset.x)
        //快速滚动的时候第一页和最后一页(scroll too fast will not call 'scrollViewDidEndDecelerating')
        if scrollView.contentOffset.x == 0 || scrollView.contentOffset.x == scrollView.contentSize.width - scrollView.bounds.width{
            if self.currentIndex != currentIndex {
                delegate?.contentViewDidEndMoveToIndex(fromIndex: self.currentIndex, toIndex: currentIndex)
            }
        }
    }
    
    // 手指开始拖的时候, 记录此时的offSetX, 并且表示不是点击title切换的内容(remenber the begin offsetX)
    final public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        /// 用来判断方向
        oldOffSetX = scrollView.contentOffset.x
        delegate?.contentViewDidBeginMove(scrollView: scrollView)
        
        forbidTouchToAdjustPosition = false
    }
    
    // 需要实时更新滚动的进度和移动的方向及下标 以便于外部使用 (compute the index and progress)
    final public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offSetX = scrollView.contentOffset.x
        // 如果是点击了title, 就不要计算了, 直接在点击相应的方法里就已经处理了滚动
        if forbidTouchToAdjustPosition {
            return
        }
        
        let temp = offSetX / bounds.size.width
        var progress = temp - floor(temp)
        
        if offSetX - oldOffSetX >= 0 {// 手指左滑, 滑块右移
            oldIndex = Int(floor(offSetX / bounds.size.width))
            currentIndex = oldIndex + 1
            if currentIndex >= childVcs.count {
                currentIndex = oldIndex - 1
            }
            
            if offSetX - oldOffSetX == scrollView.bounds.size.width {// 滚动完成
                progress = 1.0;
                currentIndex = oldIndex;
            }
            
        } else {// 手指右滑, 滑块左移
            currentIndex = Int(floor(offSetX / bounds.size.width))
            oldIndex = currentIndex + 1
            progress = 1.0 - progress
            
        }
        
        //        print("\(progress)------\(oldIndex)----\(currentIndex)")
        
        delegate?.contentViewMoveToIndex(fromIndex: oldIndex, toIndex: currentIndex, progress: progress)
        
        
        
    }
    
    
}

// MARK: - UIGestureRecognizerDelegate
extension SKContentView: UIGestureRecognizerDelegate {
    public override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        // handle the navigationController's pop gesture
        if let naviParentViewController = self.parentController?.parent as? UINavigationController, naviParentViewController.visibleViewController == parentController { // 当显示的是ScrollPageView的时候 只在第一个tag处执行pop手势
            return collectionView.contentOffset.x == 0
        }
        return true
    }
}

public protocol SKContentViewDelegate: class {
    /// 有默认实现, 不推荐重写(override is not recommoned)
    func contentViewMoveToIndex(fromIndex: Int, toIndex: Int, progress: CGFloat)
    /// 有默认实现, 不推荐重写(override is not recommoned)
    func contentViewDidEndMoveToIndex(fromIndex: Int , toIndex: Int)
    
    func contentViewDidBeginMove(scrollView: UIScrollView)
    
    func contentViewIsScrolling(scrollView: UIScrollView)
    func contentViewDidEndDisPlay(scrollView: UIScrollView)
    
    func contentViewDidEndDrag(scrollView: UIScrollView)
    /// 必须提供的属性
    var segmentView: SKScrollSegmentView { get }
}

// 由于每个遵守这个协议的都需要执行些相同的操作, 所以直接使用协议扩展统一完成,协议遵守者只需要提供segmentView即可
extension SKContentViewDelegate {
    public func contentViewDidEndDrag(scrollView: UIScrollView) {
        
    }
    public func contentViewDidEndDisPlay(scrollView: UIScrollView) {
        
    }
    public func contentViewIsScrolling(scrollView: UIScrollView) {
        
    }
    // 默认什么都不做
    public func contentViewDidBeginMove(scrollView: UIScrollView) {
        
    }
    
    // 内容每次滚动完成时调用, 确定title和其他的控件的位置
    public func contentViewDidEndMoveToIndex(fromIndex: Int , toIndex: Int) {
        segmentView.adjustTitleOffSetToCurrentIndex(currentIndex: toIndex)
        segmentView.adjustUIWithProgress(progress: 1.0, oldIndex: fromIndex, currentIndex: toIndex)
    }
    
    // 内容正在滚动的时候,同步滚动滑块的控件
    public func contentViewMoveToIndex(fromIndex: Int, toIndex: Int, progress: CGFloat) {
        segmentView.adjustUIWithProgress(progress: progress, oldIndex: fromIndex, currentIndex: toIndex)
    }
}

