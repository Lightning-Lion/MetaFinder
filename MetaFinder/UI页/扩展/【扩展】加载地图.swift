//
//  【扩展】加载地图.swift
//  WorldMap
//
//  Created by 凌嘉徽 on 2022/1/31.
//

import Foundation
import ARKit
import RealmSwift

var 地图UUID通知名称 = "地图UUID"
var 被要求保存地图通知名称 = "被要求保存地图"
var 主动更新地图通知名称 = "主动更新地图"
var 成功保存地图通知名称 = "成功保存地图"
var 更新AR场景中的Anchor通知名称 = "更新AR场景中的Anchor"
var 更新方向标状态通知名称 = "更新方向标状态通知名称"

func 读取Data(from url: URL) throws -> Data {
    let mapData = try Data(contentsOf: url)
    return mapData
}

///核心方法
func 获取地图(UUID:ObjectId) async -> ARWorldMap? {
    do {
        let realm = try await Realm()
        let drinks = realm.objects(WorldMap.self)
        let 匹配的地图 = drinks.first(where: { OneMap in
            OneMap._id == UUID
        })
        
        if let 地图 = 匹配的地图 {
            let 路径 = 地图.FilePath
            当前场景ID = 地图.SeriesID
            printLog("读取路径：\(路径)")
            if let 路径 = 路径 {
                let URL = 从文件名称获取路径(文件名: 路径)
                printLog("URL\(URL)")
                do {
                    let 读取对象 = try loadWorldMap(from: URL)
                    return 读取对象
                    
                } catch {
                    printLog("读取失败")
                    提示(error.localizedDescription)
                    return nil
                }
                
            } else {
                return nil
            }
            
        } else {
            return nil
        }
        
    } catch {
        提示("获取地图出错", Debug: error.localizedDescription)
        return nil
    }
    
    
    
}
