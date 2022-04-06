//
//  可视化.swift
//  WorldMap
//
//  Created by 凌嘉徽 on 2022/1/28.
//

import UIKit
import RealityKit
import ARKit
import RealmSwift

extension ViewController {
    //通知
    @objc  func 收到物品ObjectID(info:NSNotification)  {
        let 名称 = info.object as? ObjectId
        
        var 触发过了吗 = false
        
        if let 名称 = 名称 {
            printLog("收到名称：\(名称)")
            do {
                //提示("\(名称)")
                arView.scene.anchors.forEach({ MyAnchorEntity in
                    print("实体名称：\(MyAnchorEntity.name)")
                    print("要求名称：\(名称)")
                    if MyAnchorEntity.name.hasSuffix(名称.stringValue) {
                        keyWindow?.rootViewController?.presentedViewController?.dismiss(animated: true, completion: nil)
                        let 默认矩阵 = simd_float4x4(
                            float4(1, 0, 0, 0),
                            float4(0, 1, 0, 0),
                            float4(0, 0, 1, 0),
                            float4(0, 0, 0, 1)
                        )
                        
                        //箭头.setTransformMatrix(默认矩阵, relativeTo: nil)
                        //箭头.setPosition(.init(0, 0, 0), relativeTo: MyAnchorEntity)
                        
                        
                        
                        
                        
                        MyAnchorEntity.addChild(箭头)
                        
                        物品 = 箭头
                        锚 = MyAnchorEntity///􀙚
                        
                        arView.scene.subscribe(to: SceneEvents.Update.self) { [self] _ in
                            箭头.billboard(targetPosition: arView.cameraTransform.translation)
                        }.store(in: &subscriptions)
                        
                        //添加箭头
                        rkPin.targetEntity = MyAnchorEntity
                        rkPin.showPin()
                        
                        触发过了吗 = true
                    }
                })
                
                
            } catch {
                提示(error.localizedDescription)
            }
        } else {
            print("不应该啊，通知负载未能转化成功")
        }
        if 触发过了吗 == false {
            提示("此物品暂不可用",Debug: "区域里检索不到对应物品")
        }
    }
    
    
    func 看我(物品:Entity,锚:Entity) {///􀙚
        let 领域内位置 = 物品.convert(position: arView.session.currentFrame!.camera.transform.Position, from: nil)
        物品.look(at: 领域内位置, from: 物品.position, relativeTo: 锚)
    }
}
extension Entity {
    /// Billboards the entity to the targetPosition which should be provided in world space.
    func billboard(targetPosition: SIMD3<Float>) {
        look(at: targetPosition, from: position(relativeTo: nil), relativeTo: nil)
    }
}
