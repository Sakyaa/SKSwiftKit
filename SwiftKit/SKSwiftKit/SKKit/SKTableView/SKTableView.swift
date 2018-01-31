//
//  SKTableView.swift
//  GZCanLian
//
//  Created by Sakya on 2018/1/18.
//  Copyright © 2018年 Sakya. All rights reserved.
//

import MJRefresh

typealias SKTableViewBlock = ()->()

class SKTableView: UITableView {
    
    
    var headerBlock:SKTableViewBlock?
    var footerBlock:SKTableViewBlock?

    
    var showFooterView:Bool = false {
        didSet{
            if showFooterView {
                if self.mj_footer == nil {
                    self.mj_footer = MJRefreshAutoNormalFooter.init(refreshingBlock: {[weak self] in
                        guard let `self` = self else { return }
                        self.loadHeaderData(isHeader: false)
                    })
                }
            } else {
                self.mj_footer = nil
            }
        }
    }
    var showHeaderView:Bool = false {
        didSet{
            if showHeaderView {
                if self.mj_header == nil {
                    self.mj_header = MJRefreshNormalHeader.init(refreshingBlock: {[weak self] in
                        guard let `self` = self else { return }
                        self.loadHeaderData(isHeader: true)
                    })
                }
            } else {
                self.mj_header = nil
            }
        }
    }
    func loadHeaderData(isHeader:Bool) {
        if isHeader {
            self.headerBlock!()
        } else {
            self.footerBlock!()
        }
    }
    //    endRefreshing
    func headerEndRefresh() {
        if self.mj_header != nil {
            self.mj_header.endRefreshing()
        }
    }
    func footerEndRefresh() {
        if self.mj_footer != nil {
            self.mj_footer.endRefreshing()
        }
    }
    
    
}
