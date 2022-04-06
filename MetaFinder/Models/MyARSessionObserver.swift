import UIKit
import RealityKit
import ARKit
import RealmSwift
import Drops

var 跟踪状态 = ""//􁂚



extension ViewController: ARSessionObserver {
    func 显示地图名称() {
        let animator = UIViewPropertyAnimator()
        animator.addAnimations {
            self.SwiftUI视图.alpha = 1
        }
        animator.startAnimation()
    }
    //协议方法
    func session(_ session: ARSession,
                 cameraDidChangeTrackingState camera: ARCamera) {
        DispatchQueue.main.async { [self] in
        switch camera.trackingState {
        case .notAvailable:
            _ = 1
//            跟踪状态文本.text = "AR会话不可用"
        case .limited(.initializing):
            _ = 1
//            跟踪状态文本.text = "AR会话在初始化"
        case .limited(.relocalizing):
            跟踪状态 += "1"//􁂚
//                self.跟踪状态文本.text = "AR会话在中断后尝试恢复"
            if 跟踪状态.hasSuffix("01") {
                显示地图名称()
                
                不在回忆 = false
                Allow保存 = false
                Allow拍照 = false
                
                提示("正在加载")
                
                self.观察模型.名称 = "正在加载"
            }
        case .limited(.excessiveMotion):
            _ = 1
//            跟踪状态文本.text = "该设备移动太快，无法进行基于图像的准确位置跟踪。"
        case .limited(.insufficientFeatures):
            _ = 1
//            跟踪状态文本.text = "对于基于图像的位置跟踪，摄像机可见的场景没有包含足够的可区分特征。"
        case .limited(_):
            _ = 1
//            跟踪状态文本.text = """
//"跟踪是可行的，但结果的质量值得怀疑。 （在这种状态下，场景中锚的位置和变换（尤其是检测到的平面）从一个捕获帧到下一个捕获帧可能不准确或不一致。）
//"""
        case .normal:
            跟踪状态 += "2"//􁂚
            if 跟踪状态.hasSuffix("012") {
                
                不在回忆 = true
                Allow保存 = true
                Allow拍照 = true
                
                成功触感()
                更新地图名称()
                Drops.hideAll()
                提示("加载成功")
                printLog("世界地图包含对象:\(arView.scene.anchors)")
            }
//            跟踪状态文本.text = "相机位置跟踪提供了最佳的结果。"
            NotificationCenter.default.post(name:NSNotification.Name(rawValue:更新AR场景中的Anchor通知名称), object:nil,userInfo:nil)
        }}
    }
    //协议方法
    func sessionShouldAttemptRelocalization(_ session: ARSession) -> Bool {
        if 打开过了没 {
            return true
        } else {
            return false
        }
        
    }
}
