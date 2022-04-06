//
//  Debug优化.swift
//  Glassur
//
//  Created by 凌嘉徽 on 2021/12/26.
//

import Foundation


// MARK: - 汉化
public func 打印(_ 内容:Any?) {
    if 内容 != nil {
        print(内容!)
    } else {
        print("空值")
    }
    
}

// MARK: - 打印Log
public func printLog(_ items: Any? = nil, separator: String = " ", terminator: String = "\n", file: String = #file, 函数名: String = #function, 行数: Int = #line) {
    
    if let 运算结果 = items {
        let 文件名 = (file as NSString).lastPathComponent
        let 时间 = Log扩展.dateToString(Date(), dateFormat: "yyyy/MM/dd HH:mm:ss")
        
        let 简洁版 = "\(文件名)[\(函数名)]\(运算结果)"
        let 完整版 = "[\(时间)][\(文件名)][\(函数名)][\(行数)]\(运算结果)"
        
        Swift.print(简洁版, terminator: terminator)
    } else {
        let 文件名 = (file as NSString).lastPathComponent
        let 时间 = Log扩展.dateToString(Date(), dateFormat: "yyyy/MM/dd HH:mm:ss")
        
        let 简洁版 = "\(文件名)[\(函数名)]"
        let 完整版 = "[\(时间)][\(文件名)][\(函数名)][\(行数)]"
        
        Swift.print(简洁版, terminator: terminator)
    }
    
    
    
}

public struct Log扩展 {
    static func stringToDate(_ string: String, dateFormat: String = "yyyyMMdd") -> Date? {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(identifier: "Asia/Tokyo")
        formatter.dateFormat = dateFormat
        let date = formatter.date(from: string)
        return date
    }
    
    static func dateToString(_ date: Date, dateFormat: String = "yyyy/MM/dd") -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(identifier: "Asia/Tokyo")
        formatter.dateFormat = dateFormat
        let date = formatter.string(from: date)
        return date
    }
    
    static func stringToDateString(_ string: String, fromFormat: String = "yyyyMMdd", toFormat: String = "yyyy/MM/dd") -> String {
        let fromFormatter = DateFormatter()
        fromFormatter.locale = Locale(identifier: "en_US_POSIX")
        fromFormatter.timeZone = TimeZone(identifier: "Asia/Tokyo")
        fromFormatter.dateFormat = fromFormat
        let date = fromFormatter.date(from: string)
        
        let toFormatter = DateFormatter()
        toFormatter.locale = Locale(identifier: "en_US_POSIX")
        toFormatter.timeZone = TimeZone(identifier: "Asia/Tokyo")
        toFormatter.dateFormat = toFormat
        
        let dateStr = toFormatter.string(from: date ?? Date())
        return dateStr
    }
}
