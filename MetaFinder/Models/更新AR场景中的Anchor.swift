//
//  AR对象管理.swift
//  WorldMap
//
//  Created by 凌嘉徽 on 2022/2/4.
//

import Foundation
import RealmSwift
import RealityKit

extension ViewController {
    
    func 更新AR场景中的Anchor() {///􀫮
        printLog("更新场景中的ARAnchor")
        Task(priority: .background) {
            
            
            arView.session.currentFrame?.anchors.forEach({ MyAnchor in
                if let 名字 = MyAnchor.name {
                    
                    do {
                        let realm = try Realm()//打开Realm
                        let 物体ID = try ObjectId(string: 名字.substring(from: 2))
                        //                        print(名字.substring(from: 2))
                        
                        if realm.object(ofType: A_Object.self, forPrimaryKey: 物体ID) == nil {//找不到物品才要删除
                            print("删除场景实体")
                            arView.session.remove(anchor: MyAnchor)
                            更新方向标状态()
                        }
                    } catch {
                        //无法转化ObjectId，说明这个锚不是
                    }
                    
                }
            })
        }
        Task {
            更新方向标状态()
        }
    }
    
    ///包装
    @objc  func 更新AR场景中的Anchor(info:NSNotification)  {
        printLog("更新AR场景中的Anchor")
        更新AR场景中的Anchor()
    }
    
}
// MARK: - 字符串截取
extension String {
    /// String使用下标截取字符串
    /// string[index] 例如："abcdefg"[3] // c
    subscript (i:Int)->String{
        let startIndex = self.index(self.startIndex, offsetBy: i)
        let endIndex = self.index(startIndex, offsetBy: 1)
        return String(self[startIndex..<endIndex])
    }
    /// String使用下标截取字符串
    /// string[index..<index] 例如："abcdefg"[3..<4] // d
    subscript (r: Range<Int>) -> String {
        get {
            let startIndex = self.index(self.startIndex, offsetBy: r.lowerBound)
            let endIndex = self.index(self.startIndex, offsetBy: r.upperBound)
            return String(self[startIndex..<endIndex])
        }
    }
    /// String使用下标截取字符串
    /// string[index,length] 例如："abcdefg"[3,2] // de
    subscript (index:Int , length:Int) -> String {
        get {
            let startIndex = self.index(self.startIndex, offsetBy: index)
            let endIndex = self.index(startIndex, offsetBy: length)
            return String(self[startIndex..<endIndex])
        }
    }
    // 截取 从头到i位置
    func substring(to:Int) -> String{
        return self[0..<to]
    }
    // 截取 从i到尾部
    func substring(from:Int) -> String{
        return self[from..<self.count]
    }
    
}
