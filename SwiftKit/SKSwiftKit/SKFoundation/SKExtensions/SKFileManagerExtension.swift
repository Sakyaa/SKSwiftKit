//
//  SKFileManagerExtension.swift
//  SwiftKit
//
//  Created by Sakya on 2018/1/30.
//  Copyright © 2018年 Sakya. All rights reserved.
//

import Foundation

extension FileManager {

    /// path
    public var skDocumentsPath: String? {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as [String]
        return paths[0]
    }
    public var skDocumentsURL: URL? {
        let url = urls(for: .documentDirectory, in: .userDomainMask)[0]
        return url
    }

    public var skCachesPath: String? {
        let paths = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true) as [String]
        return paths[0]
    }
    public var skCachesURL: URL? {
        let url = urls(for: .cachesDirectory, in: .userDomainMask)[0]
        return url
    }
    
    // file manager
   //判断文件夹是否存在
    public func sk_directoryExists(path:String) -> Bool{
        return fileExists(atPath: path)
    }
    //判断文件是否存在
    public func sk_fileExists(path:String) -> Bool{
        return sk_directoryExists(path: path)
    }
    //创建文件
//    let myFolders = baseURL.appendingPathComponent(name, isDirectory: true)
    public func sk_createDirectory(dependPath filePath:String) -> Bool{
        
        do{
            try createDirectory(atPath: filePath, withIntermediateDirectories: true, attributes: nil)
        }catch{
            return false
        }
        return true
    }
    public func sk_createDirectory(dependURL fileURL:URL) -> Bool {
        do{
            try createDirectory(at: fileURL, withIntermediateDirectories: true, attributes: nil)
        }catch{
            return false
        }
        return true
    }
    public func sk_createFile(dependURL name:String? = "", fileURL:URL) -> Bool {
        let componentURL = fileURL.appendingPathComponent(name ?? "")
        do{
            try createDirectory(at: componentURL, withIntermediateDirectories: true, attributes: nil)
        }catch{
            return false
        }
        return true
    }

    /// 删除文件 - 根据文件路径
    public func sk_deleteFile(path:String) -> Bool{
        if(!sk_fileExists(path: path)){
            return true
        }
        do{
            try removeItem(atPath: path)
        }catch{
            return false
        }
        return true
    }
    //读取文件 -（根据路径）
    public func sk_readFile(path:String) -> NSData?{
        var result:NSData?
        do{
            result = try NSData(contentsOfFile: path, options: NSData.ReadingOptions.uncached)
        }catch{
            return nil
        }
        return result
    }
    /// 写文件
    ///
    /// - Parameters:
    ///   - fileName: 文件路径
    ///   - data: 数据data
    public func sk_writeFile(filePath:String,data:NSData) -> Bool{
        return data.write(toFile: filePath, atomically: true)
    }
        //2、对指定的路径执行浅搜索，返回制定目录路径下的文件、子目录及符号链接的列表
//    let contentsOfPath = try? FileManager.default.contentsOfDirectory(atPath: cachesURL.path)
//    let hcontentsOfPath = try? FileManager.default.contentsOfDirectory(at: cachesURL, includingPropertiesForKeys: nil, options: FileManager.DirectoryEnumerationOptions.skipsHiddenFiles)
//    print(contentsOfPath,hcontentsOfPath)
    
}
