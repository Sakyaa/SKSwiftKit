//
//  SKLogger.swift
//  SwiftKit
//
//  Created by Sakya on 2018/1/30.
//  Copyright © 2018年 Sakya. All rights reserved.
//

import UIKit
// MARK: - log日志
public func SKLog<T>( _ message: T, file: String = #file, method: String = #function, line: Int = #line){
    #if DEBUG
        print("\((file as NSString).lastPathComponent)[\(line)], \(method): \(message)")
    #endif
}
