import UIKit

var 当前UI界面方向 = UI界面方向.标准竖屏

enum UI界面方向 {
    case 标准竖屏
    ///刘海在左，Home键在右
    case 标准横屏
    ///理论上你不需要关心这个，可以当竖屏处理（因为用户界面方向不会是这个值，只有设备方向会）
    case 反向竖屏
    ///刘海在右
    case 反向横屏
}


extension AppDelegate {
    
    func 初始化屏幕旋转() {
        //不要使用陀螺仪，因为在拍摄桌面上的纸张时（作业帮/文件扫描），界面方向比陀螺仪方向更能表现用户的意图
        //既然没有锁定方向，那么启动方向应当是设备真实方向（除非用户锁定了屏幕旋转——通过是否分屏+界面长宽比来判断）
        if UIDevice.current.orientation == .portrait {
            当前UI界面方向 = .标准竖屏
        }
        if UIDevice.current.orientation == .portraitUpsideDown {
            当前UI界面方向 = .反向竖屏
        }
        if UIDevice.current.orientation == .landscapeLeft {
            当前UI界面方向 = .标准横屏
        }
        if UIDevice.current.orientation == .landscapeRight {
            当前UI界面方向 = .反向横屏
        }
    }
    //通知
    @objc  func UI界面方向改变(info:NSNotification)  {
        let 读取到的 = info.userInfo
        
        let 值 = 读取到的?["UIApplicationStatusBarOrientationUserInfoKey"] as? NSNumber

            if 值 == 1 {
                当前UI界面方向 = .标准竖屏
            }
            if 值 == 3 {
                当前UI界面方向 = .标准横屏
            }
            if 值 == 2 {
                当前UI界面方向 = .反向竖屏
            }
            if 值 == 4 {
                当前UI界面方向 = .反向横屏
            }
        NotificationCenter.default.post(name: .UI界面旋转了, object: nil, userInfo: nil)
    }
}
extension Notification.Name {
    static var UI界面旋转了 : Notification.Name = .init("2B20C8A7-660B-48A4-ABAA-345E2FFDD218")
}
