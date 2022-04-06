import UIKit
import RealityKit
import ARKit
import SwiftUI
import RealmSwift
import Combine
import RKPointPin
import FocusEntity

extension ViewController {
    
    func 自动保存() {
        if 调试模式 {
            提示("正在自动保存")
        }
        Task(priority:.background) {
            await 保存世界地图(显示更新提示吗？: false)
        }
        
        
    }
    func 自动截图() {
        
        Task(priority:.background) {
            if Allow拍照 {
                printLog("正在保存")
                self.arView.snapshot(saveToHDR: false, completion: { image in
                    if let 图像 = image {
                    
                         if 调试模式 {
                             提示("正在自动保存")
                         }
                         保存图片(图片: 图像, 地图系列ID: 当前地图系列UUID)
                     
                    } else {
                        DebugLog("截图失败")
                    }
                 })
            } else {
                printLog("现在不允许拍照")
            }
        }
        
    }
    
    
    /// GCD定时器倒计时⏳
    ///   - timeInterval: 循环间隔时间
    ///   - repeatCount: 重复次数
    ///   - handler: 循环事件, 闭包参数： 1. timer， 2. 剩余执行次数
    public func DispatchTimer(timeInterval: Double, repeatCount:Int, handler:@escaping (DispatchSourceTimer?, Int)->())
    {
        if repeatCount <= 0 {
            return
        }
        let timer = DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.main)
        var count = repeatCount
        timer.schedule(wallDeadline: .now(), repeating: timeInterval)
        timer.setEventHandler(handler: {
            count -= 1
            DispatchQueue.main.async {
                handler(timer, count)
            }
            if count == 0 {
                timer.cancel()
            }
        })
        timer.resume()
    }
    
    /// GCD定时器循环操作
    ///   - timeInterval: 循环间隔时间
    ///   - handler: 循环事件
    public func DispatchTimer(timeInterval: Double, handler:@escaping (DispatchSourceTimer?)->())
    {
        let timer = DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.main)
        timer.schedule(deadline: .now(), repeating: timeInterval)
        timer.setEventHandler {
            DispatchQueue.main.async {
                handler(timer)
            }
        }
        timer.resume()
    }
    
    /// GCD延时操作
    ///   - after: 延迟的时间
    ///   - handler: 事件
    public func DispatchAfter(after: Double, handler:@escaping ()->())
    {
        DispatchQueue.main.asyncAfter(deadline: .now() + after) {
            handler()
        }
    }
}

