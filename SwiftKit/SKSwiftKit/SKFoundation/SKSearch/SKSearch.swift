//
//  SKSearch.swift
//  GZCanLian
//
//  Created by Sakya on 2017/12/28.
//  Copyright © 2017年 Sakya. All rights reserved.
//

import UIKit

open class SKSearch: NSObject {
    var pref: UserDefaults!
    open static let shared: SKSearch = SKSearch()
    public override init() {
        pref = UserDefaults.standard
    }
    struct SKSearchDefaultsConfig {
        static var histories:String {
            get {
                return "histories"
            }
        }
    }
    open func setSearchHistories(value: [String]) {
        pref.set(value, forKey: SKSearchDefaultsConfig.histories)
    }
    open func deleteSearchHistories(index: Int) {
        guard var histories = pref.object(forKey: SKSearchDefaultsConfig.histories) as? [String] else { return }
        histories.remove(at: index)
        pref.set(histories, forKey: SKSearchDefaultsConfig.histories)
    }
    
    open func appendSearchHistories(value: String) {
        var histories = [String]()
        let localHistories = getSearchHistories() ?? [String]()
        //如果没有数据的时候则第一条添加
        if localHistories.count == 0 {
            histories.append(value)
            pref.set(histories, forKey: SKSearchDefaultsConfig.histories)
            return
        }
        //有的话插到第一个
        if !(localHistories.contains(value)) {
            if let _histories = pref.object(forKey: SKSearchDefaultsConfig.histories) as? [String] {
                histories = _histories
            }
            histories.insert(value, at: 0)
            //如果历史数据大于10个
            if histories.count > 10 {
                histories.removeLast(histories.count - 10)
            }
            pref.set(histories, forKey: SKSearchDefaultsConfig.histories)
        }
     }
    open func getSearchHistories() -> [String]? {
        guard let histories = pref.object(forKey: SKSearchDefaultsConfig.histories) as? [String] else { return nil }
        return histories
    }
    

}
