import UIKit
import RealityKit
import ARKit
import SwiftUI
import RealmSwift
import Combine
import RKPointPin
import FocusEntity

extension ViewController {
    
    func 添加左上角窗口() {
        
        let SwiftUI内容 = UIHostingController(rootView: 当前地图View(观察模型: 观察模型))
        self.SwiftUI视图 = SwiftUI内容.view!
        self.SwiftUI视图.alpha = 0
        隐藏(目标: 当前地图UIView)
        self.addChild(SwiftUI内容)
        
        view.addSubview(SwiftUI视图)
        对齐(源: SwiftUI视图, 目标: 当前地图UIView)
    }
    
    // MARK: - 布局便利
    func 隐藏(目标:UIView) {
        目标.isOpaque = true
        目标.alpha = 0
        目标.backgroundColor = .clear
        目标.isHidden = true
    }
    func 对齐(源:UIView,目标:UIView) {
        源.backgroundColor = .clear
        源.translatesAutoresizingMaskIntoConstraints = false
        源.topAnchor.constraint(equalTo: 目标.topAnchor).isActive = true
        源.bottomAnchor.constraint(equalTo: 目标.bottomAnchor).isActive = true
        源.leftAnchor.constraint(equalTo: 目标.leftAnchor).isActive = true
        源.rightAnchor.constraint(equalTo: 目标.rightAnchor).isActive = true
    }
}
