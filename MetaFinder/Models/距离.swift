import UIKit
import RealityKit
import ARKit
import SwiftUI
import RealmSwift
import Combine
import RKPointPin
import FocusEntity
import Drops

extension ViewController {
    func distanceBetweenEntities(_ a: SIMD3<Float>,
                                           and b: SIMD3<Float>) -> SIMD3<Float> {
            var distance: SIMD3<Float> = [0, 0, 0]
            distance.x = abs(a.x - b.x)
            distance.y = abs(a.y - b.y)
            distance.z = abs(a.z - b.z)
            return distance
        }
    
    func 计算最近实体() async -> (Entity,Float) {
        var 距离1 : Float = Float.greatestFiniteMagnitude
        
        var 锚 : Entity = Entity()
        
        arView.scene.anchors.forEach({ item in
            if item.name.hasPrefix("我的") {
                let 距离 = distanceBetweenEntities(item.position(relativeTo: nil), and: arView.cameraTransform.translation)
                let 长度1 = 长度(向量: 距离)
                
                if 长度1 < 距离1 {
                    距离1 = 长度1
                    锚 = item
                }
            }
        })
        return (锚,距离1)
    }
}
func AR页() -> ViewController? {
    keyWindow?.rootViewController as? ViewController
}
func 长度(向量 : SIMD3<Float>) -> Float {
    let 乘方相加 = pow(向量.x, 2)+pow(向量.y, 2)+pow(向量.z, 2)
    let 开方 = sqrt(乘方相加)
    return 开方
}
