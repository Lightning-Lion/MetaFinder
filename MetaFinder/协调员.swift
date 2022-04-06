import UIKit
import RealityKit
import ARKit
import RealmSwift

func 保存图片(图片:UIImage,地图系列ID:ObjectId) {
    DispatchQueue.global().async {
    if let 地图系列 = 通过ID查找地图系列(地图系列ID) {
   

       

        
//        let 文件管理器 = FileManager.default
//        let 根目录=NSHomeDirectory()
        
        let 文件夹名称 = "Photos"
        
        创建文件夹(名称: 文件夹名称)
        
   
     
            let 目录位置 = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let 文件名 = UUID().uuidString
            try! 图片.pngData()!.write(to: 目录位置.appendingPathComponent("Photos").appendingPathComponent("\(文件名).png"))
            let 图片文件名  =  "\(文件名).png"
            
            let 对象 = A_Image()
            对象.Data_Path = 图片文件名
            
            do {
                let realm = try Realm()
                try realm.write {
                    地图系列.Images.append(对象)
                }
            } catch let error as NSError {
                printLog(error.localizedDescription)
            }
           
        
        
    } else {
        printLog("不存在此地图系列")
        return
    }
    
    }
    
}
class 虚假的 : Identifiable,Equatable {
    static func == (lhs: 虚假的, rhs: 虚假的) -> Bool {
        if lhs.标识符 == rhs.标识符 {
            return true
        } else {
            return false
        }
    }
    
    var 你要的 : URL?
    var 标识符 : UUID?
}
///按照时间顺序
func 加载图片(地图系列ID:ObjectId) -> [虚假的] {
    print("对了👌")
    var 返回 : [虚假的] = []
    if let 地图系列 = 通过ID查找地图系列(地图系列ID) {
        
        let 排序 = 地图系列.Images.sorted(byKeyPath: "Create_Date")
        
        地图系列.Images.forEach({ MyURLString in
            
            do {
                let 目录位置 = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                let 图片URL = 目录位置.appendingPathComponent("Photos").appendingPathComponent(MyURLString.Data_Path)
                
                let 对象 = 虚假的()
                对象.你要的 = 图片URL
                对象.标识符 = UUID()
                返回.append(对象)
                
            } catch {
                printLog("给出的Path不符合要求：\(MyURLString.Data_Path)")
            }
        })
        
        
    } else {
        printLog("不存在此地图系列")
        
    }
    return 返回.reversed()
}
func 通过ID查找地图系列(_ ID : ObjectId) -> A_Map_Series? {
    
    do {
        let realm = try Realm()
        let 获取到的对象 = realm.object(ofType: A_Map_Series.self, forPrimaryKey: ID)
        return 获取到的对象
    } catch {
        提示(error.localizedDescription)
        return nil
        
    }
}

func 新建一张地图() -> A_Map_Series {
    let 对象 = A_Map_Series()
    return 对象
}

func 可以添加物品的地图() -> A_Map? {
    if let 系列 = 通过ID查找地图系列(当前地图系列UUID) {
        if let 地图 = 系列.Maps.sorted(byKeyPath: "Created_Date", ascending: false).first {
            return 地图
        } else {
//            提示("正在保存区域，请稍后")
            if let AR页 = keyWindow?.rootViewController as? ViewController {
                AR页.自动保存()
            }
            return nil
        }
        
        
    } else {
        //2
        return nil
    }
}
extension ViewController {
    
    func 通过ID查找地图系列(_ ID : ObjectId) -> A_Map_Series? {
        let realm = try! Realm()//打开Realm
        let 获取到的对象 = realm.object(ofType: A_Map_Series.self, forPrimaryKey: ID)
        return 获取到的对象
    }
    
    
    func 通过ID查找地图系列(_ ID : ObjectId) async -> A_Map_Series? {
        let realm = try! await Realm()//打开Realm
        let 获取到的对象 = realm.object(ofType: A_Map_Series.self, forPrimaryKey: ID)
        return 获取到的对象
    }
    
    
    func 保存一张地图到(地图: A_Map , 地图集合 : A_Map_Series) async {
        
        
        do {
            let realm = try await Realm()//打开Realm
            try realm.write {
                地图集合.Updated_Date = 地图.Created_Date
                地图集合.Maps.append(地图)
                realm.add(地图集合)
            }
        } catch let error as NSError {
            // Failed to write to realm.
            // ... Handle error ...
            printLog(error.localizedDescription)
        }
    }
    
    func 当前arView存在这一件物品吗？(ID :String) -> Bool {
        var 触发过了吗 = false
        arView.session.currentFrame?.anchors.forEach({ MyAnchorEntity in
            if MyAnchorEntity.name == ID {
                触发过了吗 = true
            }
        })
        return 触发过了吗
    }
    
}

func 转存图片(_ 图片 : UIImage) async -> String? {
    
    let 文件管理器 = FileManager.default
    let 根目录=NSHomeDirectory()
    
    var 文件夹名称 = "Photos"
    
    await 创建文件夹(名称: 文件夹名称)
    
    do {
        let 目录位置 = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        let 文件名 = UUID().uuidString
        try! 图片.pngData()!.write(to: 目录位置.appendingPathComponent("Photos").appendingPathComponent("\(文件名).png"))
        return "\(文件名).png"
    } catch {
        提示(error.localizedDescription)
        printLog(error)
        return nil
    }
    
}
func Realm删除(闭包: @escaping () -> Void = {},并发:Bool = false) {

        //􁈌领域开启
        let realm = try! Realm()
        do {
            try realm.write {
                闭包()
            }
        } catch let error as NSError {
            printLog(error.localizedDescription)
        }
   

}
class 协调员 {
    static func 保存（更新）地图 (_ 延时: Double = Double.leastNonzeroMagnitude) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 延时) {
            if let AR页 = UIApplication.shared.keyWindow?.rootViewController as? ViewController {
                AR页.自动保存()
            }
        }
    }
}
