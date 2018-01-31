//
//  BaseModel.swift
//  GZCanLian
//
//  Created by Sakya on 2018/1/2.
//  Copyright © 2018年 Sakya. All rights reserved.
//

import HandyJSON

class BaseModel: HandyJSON {
    required init(){}
    var code: Int = 999  ///<用code判断数据问题
    var msg: String = ""  ///错误的时候的描述啊
}



