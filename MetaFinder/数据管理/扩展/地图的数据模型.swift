//
//  地图的数据模型.swift
//  WorldMap
//
//  Created by 凌嘉徽 on 2022/1/31.
//

import Foundation
import RealmSwift
import ARKit

class WorldMap: Object, ObjectKeyIdentifiable  {
    //唯一标识符
    @Persisted(primaryKey: true) var _id: ObjectId
    
    //文件名称
    @Persisted var FilePath: String? = nil
    
    //显示名称
    @Persisted var DisplayName: String = 带有日期的文件名()
    
    //􀚅
    
    //系列名称
    @Persisted var SeriesName: String  = 带有日期的文件名()
    
    
    //系列标识符
    @Persisted var SeriesID: String = UUID().uuidString {
        didSet {
            if let 找到了 = 从ID查找地图(ID: SeriesID) {
                printLog("获取到应有名称"+找到了.SeriesName)
                SeriesName = 找到了.SeriesName
            }
            
        }
    }
}

// MARK: - 壳
final class MapShell: Object, ObjectKeyIdentifiable {
    
    @Persisted(primaryKey: true) var _id: ObjectId
    
    
    @Persisted var items = RealmSwift.List<WorldMap>()
}


///throws的写法
func 从Data读取ARWorldMap(from 数据: Data) throws -> ARWorldMap {
    let mapData = 数据
    guard let worldMap = try NSKeyedUnarchiver.unarchivedObject(ofClass: ARWorldMap.self, from: mapData)
    else { throw ARError(.invalidWorldMap) }
    return worldMap
}
