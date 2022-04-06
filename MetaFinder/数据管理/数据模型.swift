import RealmSwift
import Foundation

// MARK: - 不要改名
final class A_Map_Series: Object {
    
    //这是主键，用于查询超级快（有索引）
    @Persisted(primaryKey: true) var _id: ObjectId
    
    @Persisted var Name_Of_The_Series : String = 带有日期的文件名()//默认名字
    
    @Persisted var Updated_Date : Date = Date()
    
    ///对应的照片
    @Persisted var Images = RealmSwift.List<A_Image>()
    
    @Persisted var Test_Key : String = "初始的"
    
    //所拥有的地图,可以是空集合
    @Persisted var Maps = RealmSwift.List<A_Map>()
    
}

extension 地图系列:ObjectKeyIdentifiable {
}

///一张带有日期的图片
final class A_Image: Object, ObjectKeyIdentifiable {
    
    //这是主键，用于查询超级快（有索引）
    @Persisted(primaryKey: true) var _id: ObjectId
    
    @Persisted var Create_Date : Date = Date()
    
    @Persisted var Data_Path : String = ""
    
}

///一个单独的项目。是“A_Map_Series”的一部分。
final class A_Map: Object, ObjectKeyIdentifiable {
    
    //这是主键，用于查询超级快（有索引）
    @Persisted(primaryKey: true) var _id: ObjectId
    
    //日期
    @Persisted var Created_Date : Date = Date()
    
    //文件名称
    @Persisted var FilePath: String = ""
    
    @Persisted var Test_Key : String = "初始的"
    
    /// The backlink to the `Group` this item is a part of.
    ///指向“组”的反向链接此项是的一部分。
    @Persisted(originProperty: "Maps") var Which_Series_I_Belong: LinkingObjects<A_Map_Series>//自动管理
    
    //所拥有的物品,可以是空集合
    @Persisted var Objects = RealmSwift.List<A_Object>()
}

// MARK: - 不要改名
final class A_Object: Object, ObjectKeyIdentifiable {
    
    //这是主键，用于查询超级快（有索引）
    @Persisted(primaryKey: true) var _id: ObjectId
    
    //显示名称
    @Persisted var Display_Name: String = 带有日期的文件名()
    
    //扩大探测范围
    @Persisted var Is_Door: Bool = false
    
    
    //备忘
    @Persisted var Note: String = "这是一张物品便利贴\n点击此处添加内容"
    
    
    /// The backlink to the `Group` this item is a part of.
    ///指向“组”的反向链接此项是的一部分。
    @Persisted(originProperty: "Objects") var Which_Map_I_Belong: LinkingObjects<A_Map>//自动管理
}

//不要改名！
class Things:Object {
    
    @Persisted(primaryKey: true) internal var id = UUID()
    
    @Persisted internal var title:String
    @Persisted internal var detal:String?//默认没有详情
    
    //通知时间
    @Persisted internal var notification:Date?//默认没有通知时间
    
    convenience init(_ 标题:String?) {
        self.init()
        title = 标题 ?? ""
    }
}

//包装

// MARK: - 包装
typealias 地图系列 = A_Map_Series
typealias 地图 = A_Map
typealias 照片 = A_Image

typealias 物品 = A_Object


func 更新数据库为版本6() {
    // In application(_:didFinishLaunchingWithOptions:)
    let config = Realm.Configuration(
        schemaVersion: 6, // Set the new schema version.
        migrationBlock: { migration, oldSchemaVersion in
            if oldSchemaVersion < 6 {
                // The enumerateObjects(ofType:_:) method iterates over
                // every Person object stored in the Realm file to apply the migration
                migration.enumerateObjects(ofType: A_Map_Series.className()) { oldObject, newObject in
                    newObject!["id_LS"] = UUID()
                }
            }
        }
    )

    // Tell Realm to use this new configuration object for the default Realm
    Realm.Configuration.defaultConfiguration = config

    // Now that we've told Realm how to handle the schema change, opening the file
    // will automatically perform the migration
    let realm = try! Realm()

}
