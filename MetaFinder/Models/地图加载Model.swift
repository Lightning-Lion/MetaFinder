//
//  地图加载Model.swift
//  MetaFinder
//
//  Created by mac on 2022/4/3.
//

import Foundation
import SwiftUI
import RealmSwift

class LoadingModel: ObservableObject {
    static func 加载地图(_ 标识符:ObjectId) {
        跟踪状态 = "0"
        NotificationCenter.default.post(name:NSNotification.Name(rawValue:地图UUID通知名称), object:标识符,userInfo:nil)
    }
}
