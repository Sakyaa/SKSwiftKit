//
//  BasePageModel.swift
//  GZCanLian
//
//  Created by Sakya on 2018/1/17.
//  Copyright © 2018年 Sakya. All rights reserved.
//

import HandyJSON

class BasePageModel: HandyJSON {
    required init(){}
    var page: PageData = PageData()
    var code: Int = 0
}
class PageData: HandyJSON {
    
    required init(){}
    var pages: Int = 0
    var current: Int = 0
    var condition: String?
    var asc: Bool = false
    var total: Int = 0
    var size: Int = 0
    var offset: Int = 0
    var limit: Int = 0
    var openSort: Bool = false
    var searchCount: Bool = false
    var offsetCurrent: Int = 0
    var orderByField: String?
}
