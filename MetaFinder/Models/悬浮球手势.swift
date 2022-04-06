import UIKit
import SwiftUI

extension ViewController {

 
    func 添加悬浮球() {
        printLog("悬浮球被添加")
        画中画视图.layer.name = "4"
       
        addChild(控制器)
        view.addSubview(画中画视图)
        view.bringSubviewToFront(画中画视图)
        画中画视图.backgroundColor = UIColor.clear
        画中画视图 = 控制器.view
        //画中画视图.addSubview(控制器.view)
        自动布局()

        let topLeftView = 添加锚点视图()
        let leadingAnchor = view.safeAreaLayoutGuide.leadingAnchor
        
        topLeftView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: horizontalSpacing).isActive = true
        
        let topAnchor = view.safeAreaLayoutGuide.topAnchor
        
        topLeftView.topAnchor.constraint(equalTo: topAnchor, constant: verticalSpacing).isActive = true
        
        let topRightView = 添加锚点视图()
        
        let trailingAnchor = view.safeAreaLayoutGuide.trailingAnchor
        
        topRightView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -horizontalSpacing).isActive = true
        

        
        topRightView.topAnchor.constraint(equalTo: topAnchor, constant: verticalSpacing).isActive = true
        
        let bottomLeftView = 添加锚点视图()
        bottomLeftView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: horizontalSpacing).isActive = true
        
        let bottomAnchor = view.safeAreaLayoutGuide.bottomAnchor
        
        bottomLeftView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -verticalSpacing).isActive = true

        let bottomRightView = 添加锚点视图()
        bottomRightView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -horizontalSpacing).isActive = true
        bottomRightView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -verticalSpacing).isActive = true
        
        中心视图 = 添加中心锚点视图()
        DispatchQueue.main.asyncAfter(deadline: .now()) { [self] in
            
            let Pt = view.frame.width/2
            
            let Pa = 小窗口宽度/2
            
            let X位置 = Pt-Pa
            
            let Ct = view.frame.height/4
            let Ca = 小窗口高度/2
            
            let Y位置 = (Ct*3)-Ca
            let Ci = CGRect(x: X位置, y: Y位置, width: 小窗口宽度, height: 小窗口高度)
            
            中心视图.frame = Ci
        }

        
        view.addSubview(画中画视图)
        画中画视图.alpha = 0
        画中画视图.translatesAutoresizingMaskIntoConstraints = false
        画中画视图.widthAnchor.constraint(equalToConstant: 小窗口宽度).isActive = true
        画中画视图.heightAnchor.constraint(equalToConstant: 小窗口高度).isActive = true
        
        panRecognizer.addTarget(self, action: #selector(拖拽手势(recognizer:)))
        画中画视图.addGestureRecognizer(panRecognizer)
        

    }
    func 更新位置() {
        DispatchQueue.main.asyncAfter(deadline: .now()) { [self] in
            
            let Gt = view.frame.width/2
            
            let X位置 = Gt-(小窗口宽度/2)
            
            let Gp = view.frame.height/4
            
            let Y位置 = (Gp*3)-(小窗口高度/2)
            
            let Cf = CGRect(x: X位置, y: Y位置, width: 小窗口宽度, height: 小窗口高度)
            
            中心视图.frame = Cf
        }
    移动悬浮球()
    }
    @objc  func UI界面方向改变(info:NSNotification)  {
        更新位置()
      
    }
    
    func 移动悬浮球() {
        DispatchQueue.main.async { [self] in
        if let 名字 = 画中画视图.layer.name {
            if let 序号 = Int(名字) {
                        画中画视图.center = 锚点坐标集[序号]
                }
            }
        }
    }


    private func 添加锚点视图() -> UIView {
        let view = UIHostingController(rootView: 锚点可视化()).view!
        self.view.addSubview(view)
        view.backgroundColor = .clear
        锚点视图集.append(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.widthAnchor.constraint(equalToConstant: 小窗口宽度).isActive = true
        view.heightAnchor.constraint(equalToConstant: 小窗口高度).isActive = true
        view.alpha = 0
        return view
    }
    
    private func 添加中心锚点视图() -> UIView {
        let view = UIHostingController(rootView: 锚点可视化()).view!
        view.backgroundColor = .clear
        self.view.addSubview(view)
        锚点视图集.append(view)
       
        let X位置 = view.frame.width/2-小窗口宽度/2
        let Y位置 = view.frame.height/4*3-小窗口高度/2
        中心视图.frame = .init(x: X位置, y: Y位置, width: 小窗口宽度, height: 小窗口高度)
        
        return view
    }
    
    func 自动布局() {
        控制器.view.backgroundColor = .clear
        控制器.view.translatesAutoresizingMaskIntoConstraints = false
        控制器.view.topAnchor.constraint(equalTo: 画中画视图.topAnchor).isActive = true
        控制器.view.bottomAnchor.constraint(equalTo: 画中画视图.bottomAnchor).isActive = true
        控制器.view.leftAnchor.constraint(equalTo: 画中画视图.leftAnchor).isActive = true
        控制器.view.rightAnchor.constraint(equalTo: 画中画视图.rightAnchor).isActive = true
    }
    
    
    @objc private func 拖拽手势(recognizer: UIPanGestureRecognizer) {
        let touchPoint = recognizer.location(in: view)
        switch recognizer.state {
        case .began:
            正在手势 = true
            UIView.animate(withDuration: 0.3, animations: {self.锚点视图集.forEach({ item in
                item.alpha = 1
            })})
            initialOffset = CGPoint(x: touchPoint.x - 画中画视图.center.x, y: touchPoint.y - 画中画视图.center.y)
        case .changed:
         
                self.画中画视图.center = CGPoint(x: touchPoint.x - self.initialOffset.x, y: touchPoint.y - self.initialOffset.y)
            
         
        case .ended, .cancelled:
            正在手势 = false
            let decelerationRate = UIScrollView.DecelerationRate.normal.rawValue/Double.pi*3
            let velocity = recognizer.velocity(in: view)
            let projectedPosition = CGPoint(
                x: 画中画视图.center.x + project(initialVelocity: velocity.x, decelerationRate: decelerationRate),
                y: 画中画视图.center.y + project(initialVelocity: velocity.y, decelerationRate: decelerationRate)
            )
            let nearestCornerPosition = nearestCorner(to: projectedPosition)
            let relativeInitialVelocity = CGVector(
                dx: relativeVelocity(forVelocity: velocity.x, from: 画中画视图.center.x, to: nearestCornerPosition.x),
                dy: relativeVelocity(forVelocity: velocity.y, from: 画中画视图.center.y, to: nearestCornerPosition.y)
            )
            let timingParameters = UISpringTimingParameters(damping: 1, response: 0.4, initialVelocity: relativeInitialVelocity)
            let animator = UIViewPropertyAnimator(duration: 0, timingParameters: timingParameters)
            animator.addAnimations {
                self.画中画视图.center = nearestCornerPosition
            }
            animator.startAnimation()
            UIView.animate(withDuration: 0.3, animations: {self.锚点视图集.forEach({ item in
                item.alpha = 0
            })})
        default: break
        }
    }
    
    /// Distance traveled after decelerating to zero velocity at a constant rate.
    private func project(initialVelocity: CGFloat, decelerationRate: CGFloat) -> CGFloat {
        return (initialVelocity / 1000) * decelerationRate / (1 - decelerationRate)
    }
    
    /// Finds the position of the nearest corner to the given point.
    private func nearestCorner(to point: CGPoint) -> CGPoint {
        var minDistance = CGFloat.greatestFiniteMagnitude
        var closestPosition = CGPoint.zero
        for position in 锚点坐标集 {
            let distance = point.distance(to: position)
            if distance < minDistance {
                closestPosition = position
                画中画视图.layer.name = "\(锚点坐标集.firstIndex(of: position) ?? 4)"
                minDistance = distance
            }
        }
        return closestPosition
    }
    
    /// Calculates the relative velocity needed for the initial velocity of the animation.
    private func relativeVelocity(forVelocity velocity: CGFloat, from currentValue: CGFloat, to targetValue: CGFloat) -> CGFloat {
        guard currentValue - targetValue != 0 else { return 0 }
        return velocity / (targetValue - currentValue)
    }
}

