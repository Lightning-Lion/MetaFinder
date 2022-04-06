//
//  从ARAnchor创建对象.swift
//  WorldMap
//
//  Created by 凌嘉徽 on 2022/1/28.
//

import UIKit
import RealityKit
import ARKit
import RealmSwift






extension ViewController {
    
    
    func 创建对象() -> A_Object? {
        
        
        
        
        do {
            return try realm.write { () -> A_Object? in
                let 模型 = A_Object()
                if let 地图 = 可以添加物品的地图() {
                    地图.Objects.append(模型)
                    return 模型
                } else {
                    return nil
                }
                
                
            }
        } catch {
            提示("请再试一次",Debug: error.localizedDescription)
            return nil
        }
        
        
        
    }
    
    
    
    
}
