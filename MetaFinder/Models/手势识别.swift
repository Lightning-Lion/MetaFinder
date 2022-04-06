import UIKit
import RealityKit
import ARKit
import SwiftUI
import RealmSwift
import Combine
import RKPointPin
import FocusEntity
import Drops
var 刚刚创建区域 = false

extension ViewController {
    
    // MARK: - 识别到触摸
    @objc
    func 识别到触摸(recognizer: UITapGestureRecognizer) {
        if 不在回忆 {
            
            let location = recognizer.location(in: arView)
            
            let results = arView.raycast(from: location, allowing: .estimatedPlane, alignment: .any)
            if let firstResult = results.first {
                Task {
                if let 对象 = 创建对象() {
                    成功触感()
                    let 名称 = "我的\(对象._id)"
                    let anchor = ARAnchor(name: 名称, transform: firstResult.worldTransform)
                    
                    arView.session.add(anchor: anchor)//场景中确实存在实体了再弹窗
                    print("经过")
                    中等触感()
                    安排实体(MyARAnchor: anchor,显示蓝色箭头: true)//先安排实体再弹窗，避免UI卡顿
                    if 下一个是门 {
                        Realm删除(闭包: {对象.Is_Door = true
                            对象.Display_Name = "🚪门"
                            对象.Note = "门的便利贴"})
                    } else {
                        Task {
                            重命名弹窗(操作对象: 对象)
                        }
                    }
                    
                } else {
                    if !刚刚创建区域 {
                        Drops.hideAll()
                        let drop = Drop(
                            title: "请先选择一个区域",
                            subtitle: "或新建一个区域",
                            icon: nil,
                            action: nil,
                            position: .top,
                            duration: .recommended,
                            accessibility: nil
                        )
                        
                        let 页面 = Grid页
                        self.show(页面, sender: nil)
                        
                        NotificationCenter.default.post(name:NSNotification.Name(rawValue:打开地图页), object:nil,userInfo:nil)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            NotificationCenter.default.post(name:NSNotification.Name(rawValue:打开地图页), object:nil,userInfo:nil)
                            Drops.show(drop)
                        }
                        NotificationCenter.default.post(name:NSNotification.Name(rawValue:打开地图页), object:nil,userInfo:nil)
                    } else {
                        //刚刚创建区域
                   
                        失败触感()
                        Drops.hideAll()
                        let 一条消息 = Drop(title: "请稍等\n在添加物品前", titleNumberOfLines: 2, subtitle: "扫描一下你周围的区域吧", subtitleNumberOfLines: 1, icon: nil, action: nil, position: .top, duration: .recommended, accessibility: nil)
                        Drops.show(一条消息)
//                        提示("请稍等",Debug: "在添加物品前，扫描一下你周围的区域吧")
                        快速保存()
                    }
                }}
                
                
            } else {
                提示("暂不能放置标记 视觉系统找不到表面")
            }
            
        } else {
            let drop = Drop(
                title: "请耐心等待加载完成",
                subtitle: "前往之前去过的地方",
                icon: nil,
                action: .init {
                    print("Drop tapped")
                    Drops.hideCurrent()
                },
                position: .bottom,
                duration: 5.0,
                accessibility: nil
            )
            Drops.show(drop)
            let drop1 = Drop(
                title: "点我以再试一次",
                subtitle: nil,
                icon: nil,
                action: .init { [self] in
                    
                    Allow保存 = false
                    Allow拍照 = false
                    
                    if let 配置 = arView.session.configuration as? ARWorldTrackingConfiguration {
                        跟踪状态 += "0"
                        arView.session.run(配置, options: [.stopTrackedRaycasts,.resetSceneReconstruction,.removeExistingAnchors,.resetTracking])
                        setupCoachingOverlay()
                    }
                    Drops.hideCurrent()
                },
                position: .bottom,
                duration: 5.0,
                accessibility: nil
            )
            Drops.show(drop1)
        }
    }
    func 快速保存() {
        自动保存()
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            if let AR页 = keyWindow?.rootViewController as? ViewController {
                AR页.自动保存()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 6) {
                if let AR页 = keyWindow?.rootViewController as? ViewController {
                    AR页.自动保存()
                }
            }
        }
    }
}
