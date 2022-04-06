//
//  世界地图.swift
//  WorldMap
//
//  Created by 凌嘉徽 on 2022/1/28.
//

import UIKit
import RealityKit
import ARKit
//后面去掉
import RealmSwift

extension ViewController {
    
    
    // MARK: - 主要函数
    func 指示测绘状态() {
        let 地图状态 = arView.session.currentFrame?.worldMappingStatus
        switch 地图状态 {
        case .mapped:
            提示("WorldTracking已经充分绘制了可见区域的地图")
        case .extending:
            提示("WorldTracking已经绘制了最近访问过的区域，但仍在绘制当前设备位置的地图")
        case .limited:
            提示("WorldTracking还没有充分地绘制出当前设备位置周围的区域")
        case .notAvailable:
            提示("没有可用的世界地图")
        case .none:
            printLog()
        }
    }
    // MARK: - 主要函数
    func 监控测绘状态() {
        let 地图状态 = arView.session.currentFrame?.worldMappingStatus
        switch 地图状态 {
        case .mapped:
            刚刚创建区域 = false
         default:
            printLog()
        }
    }
    
    
    // MARK: - 地图
    // MARK: - 保存地图
    func 保存世界地图(显示更新提示吗？: Bool = false,质量要求 : ARFrame.WorldMappingStatus? = .mapped) async {
        
        if Allow保存 {
            printLog("正在拍照")
            do {
                printLog("要求保存世界地图")
                if let 质量要求 = 质量要求 {
                    if  arView.session.currentFrame?.worldMappingStatus == 质量要求 {
                        let 世界地图 = try await arView.session.currentWorldMap()
                        
                        printLog("已经获取到世界地图")
                        let 范围 = 世界地图.extent
                        
                        printLog("地图体积：\(范围.x*范围.y*范围.z)")
                        
                        
                    
                            if let 输出路径 = await 持久化世界地图(世界地图) {
                                printLog("输出：\(输出路径)")
                                
                                //创建地图对象
                                let 地图 = A_Map()
                                地图.FilePath = 输出路径.lastPathComponent
                                
                                
                                if let 系列 = await self.通过ID查找地图系列(当前地图系列UUID) {
                                    if 显示更新提示吗？ {
                                        提示("区域已更新",Debug: "“\(系列.Name_Of_The_Series)”")
                                    }
                                    printLog("区域“\(系列.Name_Of_The_Series)”已更新")
                                    await 保存一张地图到(地图: 地图, 地图集合: 系列)
                                } else {
                                    let 系列 = 新建一张地图()
                                    printLog("新区域已创建")
                                    当前地图系列UUID = 系列._id
                                    
                                    Allow保存 = true
                                    Allow拍照 = true
                                    
                                    await 保存一张地图到(地图: 地图, 地图集合: 系列)
                                }
                                
                                //面向SwiftUI
                                NotificationCenter.default.post(name:NSNotification.Name(rawValue:成功保存地图通知名称), object:地图._id,userInfo:nil)
                                
                            }
                        if 调试模式 {
                            let 当前建图质量 = arView.session.currentFrame?.worldMappingStatus.rawValue
                            DebugLog("建图质量不达标：\(当前建图质量)")
                        }
                    }
                    
                }
                
                
                
                
                
                
                
                
            } catch {
                提示("请稍后再试",Debug: "多扫描一下周围的环境")
                printLog(error.localizedDescription)
            }
            
            //             arView.session.getCurrentWorldMap(completionHandler: { [self] MyARWorldMap, MyError in
            //                printLog("要求保存世界地图")
            //                //处理错误罢了
            //                if let error = MyError {
            //                    //多半是“特征不足。”
            //                    提示("请稍后再试",Debug: "多扫描一下周围的环境")
            //                    printLog(error.localizedDescription)
            //                }
            //
            //                //Handle世界地图
            //                if let 世界地图 = MyARWorldMap {
            //                    printLog("已经获取到世界地图")
            //                    let 范围 = 世界地图.extent
            //
            //                    printLog("地图体积：\(范围.x*范围.y*范围.z)")
            //
            //
            //                    do {
            //                        if let 输出路径 = 持久化世界地图(世界地图) {
            //                            printLog("输出：\(输出路径)")
            //
            //
            //
            //                            //创建地图对象
            //                            let 地图 = A_Map()
            //                            地图.FilePath = 输出路径.lastPathComponent
            //
            //
            //                            if let 系列 = 通过ID查找地图系列(当前地图系列UUID) {
            //                                if 显示更新提示吗？ {
            //                                    提示("区域已更新",Debug: "“\(系列.Name_Of_The_Series)”")
            //                                }
            //                                printLog("区域“\(系列.Name_Of_The_Series)”已更新")
            //                                保存一张地图到(地图: 地图, 地图集合: 系列)
            //                            } else {
            //                                let 系列 = 新建一张地图()
            //                                printLog("新区域已创建")
            //                                当前地图系列UUID = 系列._id
            //
            //                                Allow保存 = true
            //                                Allow拍照 = true
            //
            //                                保存一张地图到(地图: 地图, 地图集合: 系列)
            //                            }
            //
            //                            //面向SwiftUI
            //                            NotificationCenter.default.post(name:NSNotification.Name(rawValue:成功保存地图通知名称), object:地图._id,userInfo:nil)
            //
            //                        }
            //
            //                    } catch {
            //                        提示(error.localizedDescription)
            //                    }
            //
            //                }
            //            })
        } else {
            printLog("未加载地图，忽略保存")
        }
    }
    
    func 读取世界地图() {
        selectFile()//弹出文件选择器
        //地图的URL等待通知（@objc）
    }
    
    
    
    func 持久化世界地图(_ 世界地图 : ARWorldMap) async -> URL? {
        let 文件管理器 = FileManager.default
        let 根目录=NSHomeDirectory()
        
        let 名称 = "世界地图"
        创建文件夹(名称: 名称)
        
        
        do {
            let 目录位置 = 根目录+"/Documents/\(名称)"
//            let 数量 = try 文件管理器.contentsOfDirectory(atPath: 目录位置).count+1
            let 文件位置 = NSHomeDirectory()+"/Documents/世界地图/\(UUID().uuidString)"
            let 位置URL = URL(fileURLWithPath: 文件位置)
            
            try writeWorldMap(世界地图, to: 位置URL)
            return 位置URL
        } catch {
            提示(error.localizedDescription)
            return nil
        }
        
    }
    
    //通知
    @objc  func 收到世界地图的URL(info:NSNotification)  {
        let 网址 = info.object as? URL
        if let 网址 = 网址 {
            do {
                //转存地图()
                printLog("地图文件大小：\(covertToFileString(with: sizeForLocalFilePath(filePath: 网址.path)))")
                Task {
                    try await 通过世界地图运行会话(世界地图: loadWorldMap(from: 网址))
                }
            } catch {
                提示(error.localizedDescription)
            }
        }
    }
    func 通过世界地图运行会话(世界地图 : ARWorldMap) async {
        不在回忆 = false
        Allow保存 = false
        Allow拍照 = false
        
        //如果当前没有配置或当前配置不是WorldTrackingConfiguration，就New一个
        var 当前配置 : ARWorldTrackingConfiguration = arView.session.configuration as? ARWorldTrackingConfiguration ?? ARWorldTrackingConfiguration()
        
        当前配置.initialWorldMap = 世界地图
        当前配置.worldAlignment = .gravityAndHeading
        跟踪状态 += "0"//􁂚
        arView.session.run(当前配置,options: [.stopTrackedRaycasts,.resetSceneReconstruction,.removeExistingAnchors,.resetTracking])
        setupCoachingOverlay()
        提示("请扫描周围的环境",Debug: "以便系统认出区域")
        let 范围 = 世界地图.extent
        printLog("地图体积：\(范围.x*范围.y*范围.z)")
    }
    
    //内建函数
    func writeWorldMap(_ worldMap: ARWorldMap, to url: URL) throws {
        let data = try NSKeyedArchiver.archivedData(withRootObject: worldMap, requiringSecureCoding: true)
        try data.write(to: url)
        printLog("地图文件大小：\(covertToFileString(with: sizeForLocalFilePath(filePath: url.path)))")
    }
    
    
    
    
    //新建目录
    func 新建目录(_ 目录 : URL) {
        do{
            //创建指定位置上的目录
            try FileManager.default.createDirectory(atPath: 目录.path, withIntermediateDirectories: true, attributes: nil)
        }
        catch{
            提示(error.localizedDescription)
        }
    }
    //文件大小
    func sizeForLocalFilePath(filePath:String) -> UInt64 {
        do {
            let fileAttributes = try FileManager.default.attributesOfItem(atPath: filePath)
            if let fileSize = fileAttributes[FileAttributeKey.size]  {
                return (fileSize as! NSNumber).uint64Value
            } else {
                print("Failed to get a size attribute from path: \(filePath)")
            }
        } catch {
            print("Failed to get file attributes for local path: \(filePath) with error: \(error)")
        }
        return 0
    }
    func covertToFileString(with size: UInt64) -> String {
        var convertedValue: Double = Double(size)
        var multiplyFactor = 0
        let tokens = ["bytes", "KB", "MB", "GB", "TB", "PB",  "EB",  "ZB", "YB"]
        while convertedValue > 1024 {
            convertedValue /= 1024
            multiplyFactor += 1
        }
        return String(format: "%4.2f %@", convertedValue, tokens[multiplyFactor])
    }
    
    func 转存地图(网址:URL) {
        let realm = try! Realm()
        try! realm.write {
            // Add coffee shop and drink info here.
            let shop = WorldMap()
            shop.DisplayName = "地图\(realm.objects(WorldMap.self).count+1)"
            //shop.地图数据 = try! 读取Data(from: 网址)
            realm.add(shop)
        }
    }
    
    // MARK: - 加载地图
    //通知
    @objc  func 收到世界地图的UUID(info:NSNotification)  {
        printLog("收到请求")
        let 唯一标识符 = info.object as? ObjectId
        if let 唯一标识符 = 唯一标识符 {
            printLog("加载地图：\(唯一标识符)")
            printLog("转化UUID成功")
            do {
                Task {
                    if let 地图 = await 通过ID查找地图系列(唯一标识符) {
                        if let 路径 = 地图.Maps.sorted(byKeyPath: "Created_Date", ascending: false).first {
                            let 最新一张地图的路径 = 从文件名称获取路径(文件名: 路径.FilePath)
                            do {
                                let 读取对象 = try loadWorldMap(from: 最新一张地图的路径)
                                printLog("世界地图包含对象:\(读取对象.anchors)")
                                await 通过世界地图运行会话(世界地图: 读取对象)
                                当前地图系列UUID = 地图._id
                                
                            } catch {
                                printLog("读取失败")
                                提示(error.localizedDescription)
                            }
                        } else {
                            printLog("不应该的路径：加载不存在地图的区域")
                        }
                        
                    } else {
                        提示("区域文件异常", Debug: "在退出App前多扫描一下周围的环境")
                        提示("", Debug: "以便系统有机会保存")
                    }
                    //                    if let 地图数据 = await 获取地图(UUID: 唯一标识符) {
                    //                        printLog("转化地图成功")
                    //                        try await 通过世界地图运行会话(世界地图: 地图数据)
                    //                    } else {
                    //                        当前场景ID = UUID().uuidString
                    //                        提示("载入地图失败", Debug: "UUID没有匹配的地图")
                    //                    }
                }
            } catch {
                当前场景ID = UUID().uuidString
                提示(error.localizedDescription)
            }
        }
    }
    
    @objc  func 被要求保存地图(info:NSNotification)  {
        
        Task {
            await 保存世界地图()
        }
        
    }
    
    @objc  func 主动更新地图(info:NSNotification)  {
        
        Task {
            await 保存世界地图(显示更新提示吗？: true)
        }
        
    }
}
func loadWorldMap(from url: URL) throws -> ARWorldMap {
    let mapData = try Data(contentsOf: url)
    guard let worldMap = try NSKeyedUnarchiver.unarchivedObject(ofClass: ARWorldMap.self, from: mapData)
    else { throw ARError(.invalidWorldMap) }
    return worldMap
}
func 从文件名称获取路径(文件名:String) -> URL {
    let 文件管理器 = FileManager.default
    let 根目录=NSHomeDirectory()
    var 名称 = "世界地图"
    let 目录位置 = 根目录+"/Documents/\(名称)"
    let 文件位置 = NSHomeDirectory()+"/Documents/世界地图/\(文件名)"
    let 位置URL = URL(fileURLWithPath: 文件位置)
    return 位置URL
}
//创建文件夹
func 创建文件夹(名称:String) {
    let 文件位置 = NSHomeDirectory()+"/Documents/\(名称)/"
    do{
        //创建指定位置上的文件夹
        try FileManager.default.createDirectory(atPath: 文件位置, withIntermediateDirectories: true, attributes: nil)
    }
    catch{
        提示(error.localizedDescription)
        printLog(error.localizedDescription)
    }
}
