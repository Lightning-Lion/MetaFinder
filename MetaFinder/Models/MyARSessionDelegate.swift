//
//  MyARSessionDelegate.swift
//  WorldMap
//
//  Created by 凌嘉徽 on 2022/1/28.
//

import UIKit
import RealityKit
import ARKit
import RealmSwift
import Drops
import iOS

var 当前场景ID = UUID().uuidString
var 当前物体 : A_Object? = nil
extension ViewController: ARSessionDelegate {
    
    // MARK: - 常量
    func 常量() {
        let 当前帧 = arView.session.currentFrame
        
        
        let ARKit配置 = arView.session.configuration
        
        
        var ARKit锚: [ARAnchor] {
            if let 当前帧 = 当前帧 {
                return 当前帧.anchors
            } else {
                return []
            }
        }
        
        //启用光线估计
        ARKit配置?.isLightEstimationEnabled = false
//        var 光线估计 = 当前帧?.lightEstimate
        
        
    }
    
    func 带保护的当前帧(动作: @escaping (ARFrame) -> Void) {
        if let 当前帧 = arView.session.currentFrame {
            动作(当前帧)
        }
    }
    

    // MARK: - 每帧更新
    func session(_ session: ARSession,
                 didUpdate frame: ARFrame) {
        //看我(物品: 物品, 锚: 锚)///􀙚
 //更新坐标数据
        Task {
        let 计算 = await 计算最近实体()
        let 锚 = 计算.0
        if 锚.name.hasPrefix("我的") {
        let 距离 = 计算.1
            if let 物品 = realm.object(ofType: A_Object.self, forPrimaryKey: try! ObjectId(string: 锚.name.substring(from: 2))) {
                
                var 探测距离 : Float = 0.15
                
                if 物品.Is_Door {
                    探测距离 = 1
                }
                
                观察模型.第一句 = "\(物品.Display_Name)的距离是\(距离)"
                if 距离 < 探测距离 {
                    if 当前物体 != 物品 {
                        let id = SystemSoundID.init(1117)
                        SystemSounds.play(soundID: id)
                        一碰卡片.弹出(卡片: 一碰卡片(物件: 物品))
                    };当前物体 = 物品
                }
                
                
               
            }
        }
    }
    }
    
    
    // MARK: - 有锚添加
    func session(_ session: ARSession,
                 didAdd anchors: [ARAnchor]) {
        printLog("锚s来了！")
        anchors.forEach({ MyARAnchor in
            let 实体 = AnchorEntity(anchor: MyARAnchor)
            实体.name = MyARAnchor.name ?? UUID().uuidString
            arView.scene.addAnchor(实体)
        })
        
        NotificationCenter.default.post(name:NSNotification.Name(rawValue:更新AR场景中的Anchor通知名称), object:nil,userInfo:nil)
        
        printLog("有锚添加")
        更新方向标状态()
    }
    
    // MARK: - 告诉代理会话已调整一个或多个锚的属性
    func session(_ session: ARSession,
                 didUpdate anchors: [ARAnchor]) {
        //        printLog("已调整一个或多个锚的属性")
        更新方向标状态()
    }
    
    
    // MARK: - 告诉代理一个或多个锚已从会话中移除。
    func session(_ session: ARSession,
                 didRemove anchors: [ARAnchor]){
        printLog("一个或多个锚已从会话中移除")
        Task {
            更新方向标状态()
        }
        
    }
    
    
    func 安排实体(MyARAnchor : ARAnchor,显示蓝色箭头:Bool = false) {
        //准备实体
        let 网格 = MeshResource.generateBox(size: 0.02)//一个立方体
        let 材质 = SimpleMaterial(color: self.toRandomColor(), isMetallic: false)
        let 碰撞体积 = ShapeResource.generateConvex(from: 网格)//高精度碰撞体积
        
        
        //生成实体
        //        let 实体 = ModelEntity(mesh: 网格, materials: [材质])
        
        //准备AnchorEnity
        let 我的锚实体 = AnchorEntity(anchor: MyARAnchor)
        //        if let 名称 = MyARAnchor.name {
        //            我的锚实体.name = 名称
        //            实体.name = 名称
        //            print("安排实体")
        //        }//同步命名锚实体
        
        我的锚实体.addChild(箭头)
        
        
        arView.scene.subscribe(to: SceneEvents.Update.self) { [self] _ in
            箭头.billboard(targetPosition: arView.cameraTransform.translation)
            监控测绘状态()
        }.store(in: &subscriptions)
        
        
        //生成AnchorEnity
        self.arView.scene.addAnchor(我的锚实体)
        if 显示蓝色箭头 {
            rkPin.targetEntity = 我的锚实体
            rkPin.showPin()
        }
    }
    func 更新方向标状态() {
        Task(priority: .low) {
            if let 目标 = rkPin.targetEntity {
                if 当前arView存在这一件物品吗？(ID: 目标.name) == false {
                    rkPin.hidePin()
                    print("已清除箭头")
                }
            }
        }
    }
    
    ///包装
    @objc  func 更新方向标状态(info:NSNotification)  {
        printLog("更新方向标状态")
        更新方向标状态()
    }
}
func 更新方向标() {
    NotificationCenter.default.post(name:NSNotification.Name(rawValue:更新方向标状态通知名称), object:nil,userInfo:nil)
}
