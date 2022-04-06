//
//  File.swift
//  Meta
//
//  Created by 凌嘉徽 on 2022/1/27.
//

import Foundation
import RealmSwift

//为SwiftUI扩展https://docs.mongodb.com/realm/sdk/swift/swiftui/
//在Realm中，不要命名为中文！


// MARK: - 物品数据模型
final class MyObject: Object, ObjectKeyIdentifiable {
    
    @Persisted(primaryKey: true) var _id: ObjectId
    
    //显示名称
    @Persisted var DisplayName: String = 带有日期的文件名()
    
    //唯一标识符
    @Persisted var IndividualID: String = UUID().uuidString
    
    //􀚅
    
    //系列标识符
    @Persisted var BelongingSeriesID: String = UUID().uuidString
}


// MARK: - 壳
final class ObjectShell: Object, ObjectKeyIdentifiable {
    
    @Persisted(primaryKey: true) var _id: ObjectId
    
    
    @Persisted var items = RealmSwift.List<MyObject>()
}


// MARK: - 带有日期的文件名
func 带有日期的文件名() -> String {
    let date = Date()
    var calendar = Calendar.current
    
    let 年 = calendar.component(.year, from: date)
    let 月 = calendar.component(.month, from: date)
    let 日 = calendar.component(.day, from: date)
    
    let 时 = calendar.component(.hour, from: date)
    let 分 = calendar.component(.minute, from: date)
    let 秒 = calendar.component(.second, from: date)
    
    return "\(年)年\(月)月\(日)日\(时)时\(分)分\(秒)秒"
}

// MARK: - 带有日期的文件名
func 符号化日期(_ 日期 : Date) -> String {
    let date = 日期
    var calendar = Calendar.current
    
    let 年 = calendar.component(.year, from: date)
    let 月 = calendar.component(.month, from: date)
    let 日 = calendar.component(.day, from: date)
    
    let 时 = calendar.component(.hour, from: date)
    let 分 = calendar.component(.minute, from: date)
    let 秒 = calendar.component(.second, from: date)
    
//    return "\(年)年\(月)月\(日)日\(时)时\(分)分\(秒)秒"
    return "\(月)月\(日)日\(时)时\(分)分\(秒)秒"
}

