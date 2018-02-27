//
//  SKLogger.swift
//  SwiftKit
//
//  Created by Sakya on 2018/1/30.
//  Copyright © 2018年 Sakya. All rights reserved.
//

import UIKit

//日志级别
public enum SKLogLevel: Int {
    
    case None = 0
    case Info = 1
    case Warning = 2
    case Error = 3
    case Http = 4
    
    var name: String {
        switch self {
        case .None:
            return "None"
        case .Info:
            return "Info"
        case .Warning:
            return "Warning"
        case .Error:
            return "Error"
        case .Http:
            return "HTTP"
        }
    }
}

public class SKLogger: NSObject {
    
    #if DEBUG
    static var logLevel = SKLogLevel.Http
    #else
    static var logLevel = SKLogLevel.Warning
    #endif
    struct SKLoggerConfig {
        ///是否在本地保存日志
        static var logFile:Bool = false
    }
    static var dateFormatter: DateFormatter {
        struct Statics {
            static var dateFormatter: DateFormatter = {
                let defaultDateFormatter = DateFormatter()
                defaultDateFormatter.locale = NSLocale.current
                defaultDateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
                return defaultDateFormatter
            }()
        }
        return Statics.dateFormatter
    }
    public class func logHttp<T>(message: T, functionName: StaticString,
                              fileName: StaticString, lineNumber: Int) {
        log(message: message, logLevel: .Http, functionName: functionName, fileName: fileName, lineNumber: lineNumber)
    }
    public class func logError<T>(message: T, functionName: StaticString,
                               fileName: StaticString, lineNumber: Int) {
        log(message: message, logLevel: .Error, functionName: functionName, fileName: fileName, lineNumber: lineNumber)
    }
    public class func logWarning<T>(message: T, functionName: StaticString,
                                 fileName: StaticString, lineNumber: Int) {
        log(message: message, logLevel: .Warning, functionName: functionName, fileName: fileName, lineNumber: lineNumber)
    }
    public class func logInfo<T>(message: T, functionName: StaticString,
                              fileName: StaticString, lineNumber: Int) {
        log(message: message, logLevel: .Info, functionName: functionName, fileName: fileName, lineNumber: lineNumber)
    }
    //在文件末尾追加新内容
    public class func appendText(fileURL: URL, string: String) {
        do {
            //如果文件不存在则新建一个
            if !FileManager.default.fileExists(atPath: fileURL.path) {
                FileManager.default.createFile(atPath: fileURL.path, contents: nil)
            }
            let fileHandle = try FileHandle(forWritingTo: fileURL)
            let stringToWrite = "\n" + string
            //找到末尾位置并添加
            fileHandle.seekToEndOfFile()
            fileHandle.write(stringToWrite.data(using: String.Encoding.utf8)!)
        } catch let error as NSError {
            print("failed to append: \(error)")
        }
    }
}
fileprivate extension SKLogger {
    
    fileprivate class func log<T>(message: T, logLevel: SKLogLevel,
                               functionName: StaticString,
                               fileName: StaticString, lineNumber: Int) {
        if logLevel.rawValue <= SKLogger.logLevel.rawValue {
            let dateStr = dateFormatter.string(from: Date())
            let funcName = String(describing: functionName)
            let filename = (String(describing: fileName) as NSString).lastPathComponent
            let log:String = "\(dateStr) [\(logLevel.name)] [\(filename):\(lineNumber)] \(funcName) > \(message)"
            print(log)
            ///本地保存日志
            if (SKLoggerConfig.logFile) {
                //日志保存到本地
                let cachePath = FileManager.default.urls(for: .cachesDirectory,
                                                         in: .userDomainMask)[0]
                let logURL = cachePath.appendingPathComponent("log.txt")
                print(logURL.absoluteString)
                appendText(fileURL: logURL, string: log)
            }
        }
    }
}

//// MARK: - log日志
//public func SKLog<T>( _ message: T, file: String = #file, method: String = #function, line: Int = #line) {
//    #if DEBUG
//        print("\((file as NSString).lastPathComponent)[\(line)], \(method): \(message)")
//    #endif
//}
public func SKInfoLog<T>( _ message: T ..., file: StaticString = #file, method: StaticString = #function, line: Int = #line) {
    SKLogger.logInfo(message: message, functionName: method, fileName: file, lineNumber: line)
}
public func SKErrorLog<T>( _ message: T ..., file: StaticString = #file, method: StaticString = #function, line: Int = #line) {
    SKLogger.logError(message: message, functionName: method, fileName: file, lineNumber: line)
}
public func SKWarningLog<T>( _ message: T ..., file: StaticString = #file, method: StaticString = #function, line: Int = #line) {
    SKLogger.logWarning(message: message, functionName: method, fileName: file, lineNumber: line)
}
public func SKHttpLog<T>( _ message: T ..., file: StaticString = #file, method: StaticString = #function, line: Int = #line) {
    SKLogger.logHttp(message: message, functionName: method, fileName: file, lineNumber: line)
}

