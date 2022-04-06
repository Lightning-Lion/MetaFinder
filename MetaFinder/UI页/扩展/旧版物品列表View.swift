//
//  SwiftUIView.swift
//  WorldMap
//
//  Created by 凌嘉徽 on 2022/1/28.
//

import SwiftUI
import RealmSwift
import Introspect

var 收到物品ObID的通知 = "名称（通知）"


struct 搜索View的壳: View {
    
    let realm = try! Realm()
    
    @ObservedResults(ObjectShell.self) var 物品的壳
    
    //跳转
    var body: some View {
        
        if let 物品们 = 物品的壳.first {
            搜索页面View(对接Realm: 物品们)
        } else {
            ProgressView().onAppear {
                $物品的壳.append(ObjectShell())
            }
        }
        
    }
}

struct 搜索页面View: View {
    
    
    @State var 搜索词 : String = ""
    @ObservedRealmObject var 对接Realm: ObjectShell
    @State var 搜索结果列表 : [MyObject] = []
    @State var AI搜索结果列表 : [MyObject] = []
    
    @State var 重命名窗口 = false
    
    @State var ID = "初始"
    var body: some View {
        
        
        
        
        
        
        
        List {
            if 搜索词 == "" {
                if !$对接Realm.items.isEmpty {
                    ForEach(对接Realm.items) { i in
                        
                        Button(action: {
                            NotificationCenter.default.post(name:NSNotification.Name(rawValue:收到物品ObID的通知), object:i.IndividualID,userInfo:nil)
                            
                        }) {
                            Text(i.DisplayName)
                            
                        }
                        .id(ID)
                        .sheet(isPresented: $重命名窗口, onDismiss: {}, content: {物品列表的重命名窗口(item: i)})
                        .contextMenu {
                            Button("重命名") {
                                重命名窗口.toggle()
                            }
                            
                        }
                        
                        
                    }
                    .onDelete(perform: $对接Realm.items.remove)
                    .onMove(perform: $对接Realm.items.move)
                } else {
                    Text("点击相机画面来添加物品")
                }
            } else {
                Section(header: Text("搜索结果")) {
                    ForEach(搜索结果列表) { i in
                        
                        Button(action: {
                            NotificationCenter.default.post(name:NSNotification.Name(rawValue:收到物品ObID的通知), object:i.IndividualID,userInfo:nil)
                        }) {
                            Text(i.DisplayName)
                        }
                    }
                }
                Section(header: Text("AI搜索")) {
                    ForEach(AI搜索结果列表) { i in
                        
                        Button(action: {NotificationCenter.default.post(name:NSNotification.Name(rawValue:收到物品ObID的通知), object:i.IndividualID,userInfo:nil)
                        }) {
                            Text(i.DisplayName)
                        }
                    }
                }.transition(.opacity.animation(.easeInOut))
                
            }
            
            
        }
        
        //列表样式
        .listStyle(.insetGrouped)//现代化、层次感的风格
        .navigationBarTitle("🔍搜索", displayMode: .large)
        .navigationBarItems(trailing: EditButton())
        
        
        //增加搜索功能
        .searchable(text: $搜索词, placement: .navigationBarDrawer(displayMode: .always))
        .onSubmit(of: .search) {
            提示("点击“取消”以隐藏键盘")
        }
        .onChange(of: 搜索词) { My搜索词 in
            
            搜索结果列表 = 对接Realm.items.filter { 一项 in
                一项.DisplayName.contains(My搜索词)}
            
            let 分词结果 = 分词(sentence: My搜索词)
            
            AI搜索结果列表 = 对接Realm.items.filter { 一项 in
                要不要这项(项目: 一项.DisplayName, 词: 分词结果)}
        }
        .onChange(of: 对接Realm.items, perform: { _ in
            NotificationCenter.default.post(name:NSNotification.Name(rawValue:更新AR场景中的Anchor通知名称), object:nil,userInfo:nil)
        })
        
        
        
        
        
        
        
        
    }
    
}


/// Represents an Item in a list.
struct 物品列表的重命名窗口: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @FocusState var isNameFocused:Bool
    @ObservedRealmObject var item: MyObject
    var body: some View {
        
        VStack {
            Form {
                TextField("不建议留空", text: $item.DisplayName)
                
                    .onChange(of: isNameFocused, perform: {print($0)})
                    .onSubmit {
                        self.presentationMode.wrappedValue.dismiss()
                    }
                    .introspectTextField { textField in
                        textField.becomeFirstResponder()
                    }
                
            }
        }
    }
}


enum 从ID查找目标失败: Error {
    case 重命名失败
}
func 从ID查找目标(ID:String) throws -> MyObject {
    let realm = try! Realm()
    let drinks = realm.objects(MyObject.self)
    let 目标 = drinks.first { i in
        i.IndividualID == ID
    }
    if let 目标 = 目标 {
        return 目标
    } else {
        throw 从ID查找目标失败.重命名失败
    }
    
}

func 从ID查找地图(ID:String) -> WorldMap? {

    //下面的东西自动完成根本检查不出来
    @ObservedResults(MapShell.self) var 地图的壳
    
    //避免未初始化
    if 地图的壳.first == nil {
        $地图的壳.append(MapShell())
    }
    let 套接地图 = 地图的壳.first!
    @ObservedRealmObject var 地图: MapShell = 套接地图
    //⚠️危险
    if let 有对象 = 地图.items.where({ i in
        i.SeriesID == ID
    }).last {
        return 有对象
    } else {
        return nil
    }
    
}

