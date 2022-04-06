//
//  弹出视图控制器.swift
//  Glassur
//
//  Created by 凌嘉徽 on 2021/12/25.
//
#if canImport(UIKit)
import Foundation
import UIKit

func 从AR视图弹窗(ViewController:UIViewController) {
    let 视图控制器 = keyWindow?.rootViewController
    if let 视图控制器 = 视图控制器 {
        if 视图控制器.presentedViewController == nil{
            printLog("可以弹出")
            视图控制器.present(ViewController, animated: true, completion:  {})
            
        }
    } else {
        printLog("别用这个方法")
    }
}
func 仅限Grid使用(ViewController:UIViewController) {
    let 视图控制器 = keyWindow?.rootViewController?.presentedViewController
    if let 视图控制器 = 视图控制器 {
        if 视图控制器.presentedViewController == nil{
            printLog("可以弹出")
            视图控制器.present(ViewController, animated: true, completion:  {})
            
        }
    } else {
        printLog("别用这个方法")
    }
    
    
}

///Returns all possible ViewControllers
private func returnAvailableViewControllers() -> [UIViewController] {
    let 场景 = UIApplication.shared.connectedScenes
    
    var 存储VC : [UIViewController] = []
    UIApplication.shared.windows.forEach({ i in
        var 视图控制器 = i.rootViewController
        
        if 视图控制器 != nil {
            存储VC.append(视图控制器!)
        }
        
        
        
        var 结束没 = true
        while 结束没 {
            //Enumerate all child ViewController
            视图控制器 = 视图控制器?.presentedViewController
            if 视图控制器 != nil {
                存储VC.append(视图控制器!)
            } else {
                结束没.toggle()
            }
        }
    })
    for i in 场景 {
        
        if i.activationState == .foregroundActive {
            //Set up “foregroundActive” to give the user more control
            var 视图控制器 = (i.delegate as? UIWindowSceneDelegate)?.window??.rootViewController
            
            if 视图控制器 != nil {
                存储VC.append(视图控制器!)
            }
            
            
            
            var 结束没 = true
            while 结束没 {
                //Enumerate all child ViewController
                视图控制器 = 视图控制器?.presentedViewController
                if 视图控制器 != nil {
                    存储VC.append(视图控制器!)
                } else {
                    结束没.toggle()
                }
            }
        }
        
        
    }
    printLog(存储VC)
    return 存储VC
}


#endif


