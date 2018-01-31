//
//  BaseViewModel.swift
//  RACDemo
//
//  Created by Sakya on 2017/12/15.
//  Copyright © 2017年 Sakya. All rights reserved.
//

enum LoadState {
    case success(result:SuccessResult)
    case failure(error: FailureResult) ///< 失败包括失败体
}
typealias HandleLoadStatus = (_ loadState: LoadState) -> Void

struct SuccessResult {
    var isFinished:Bool = false ///< 是否还有数据 针对分页的
    var result:AnyObject? ///< 返回的数据 可以是数据模型
    var msg:String = "" ///< 返回的数据 可以是数据模型
    init(msg:String? = "",isFinished:Bool? = false,result:AnyObject? = nil) {
        self.isFinished = isFinished!
        self.result = result
        self.msg = msg!
    }
}
struct FailureResult {
    var result:AnyObject? = nil ///< 返回的数据 可以是数据模型
    var msg:String = "" ///< 返回的数据 可以是数据模型
    var errorType:ExceptionErrorType = .errorOther ///< 错误格式

    init(msg:String? = "",result:AnyObject? = nil,errorType:ExceptionErrorType? = .errorOther) {
        self.result = result
        self.msg = msg!
        self.errorType = errorType!
    }
}
enum ExceptionErrorType {
    case errorNetwork
    case errorDataFormat
    case warningData
    case errorOther
}
class BaseViewModel {
    let disposeBag = DisposeBag()
}
