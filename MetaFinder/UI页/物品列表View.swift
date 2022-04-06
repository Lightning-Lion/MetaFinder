import SwiftUI
import RealmSwift
import Introspect


// MARK: - 新版
struct 新物品View: View {
    
    
    //数据交换
    @Binding var 列表 : [A_Object]
    @State var realm = try! Realm()
    
    //重命名功能
    @Binding var 更新 : String
    
    //搜索功能
    @State var 搜索词 : String = ""
    @State var 搜索结果列表 : [A_Object] = []
    @State var AI搜索结果列表 : [A_Object] = []
    
    //删除功能
    @State var 删除 : [A_Object] = []
    
    let 收 = NotificationCenter.default.publisher(for: NSNotification.Name("删除我"))
    
    
    var body: some View {
        VStack {
            List {
                
                if 搜索词 == "" {
                    
                    ForEachWithIndex(列表) { index, item in
                        单元格(item: item)
                    }.onDelete(perform: { MySet in 删除(MySet: MySet)})
                    
                    Button("添加物品") {添加物品按钮()}.enable(with:不在回忆)
                    
                } else {搜索时候的UI()}
            }
//            .listStyle(.sidebar)
        }
        //其它东西
        .onReceive(收, perform: { (output) in
            let 信息 = output.object as! Int
            
            删除(MySet: .init(integer: 信息))
            
        })
        //列表样式
        .listStyle(.insetGrouped)//现代化、层次感的风格
        .navigationBarTitle("📦物品", displayMode: .large)
        .navigationBarItems(trailing: EditButton())
        
        //增加搜索功能
        .searchable(text: $搜索词, placement: .navigationBarDrawer(displayMode: .always))
        .onSubmit(of: .search) {
            提示("点击“取消”以隐藏键盘")
        }
        .onChange(of: 搜索词) { My搜索词 in
            
            搜索结果列表 = 列表.filter { 一项 in
                一项.Display_Name.contains(My搜索词)}
            
            let 分词结果 = 分词(sentence: My搜索词)
            
            AI搜索结果列表 = 列表.filter { 一项 in
                要不要这项(项目: 一项.Display_Name, 词: 分词结果)}
        }
        
        .onAppear(perform: {
            do {
                realm = try Realm()
            } catch let error as NSError {
                printLog(error.localizedDescription)
            }
            
        })
        .onChange(of: 列表, perform: { _ in
            NotificationCenter.default.post(name:NSNotification.Name(rawValue:更新AR场景中的Anchor通知名称), object:nil,userInfo:nil)
        })
        .onDisappear(perform: {
            printLog("页面隐藏")
        })
        .onChange(of: 删除, perform: { item in
            Realm删除(闭包: {realm.delete(item)}) })
    }
    
    
    
    // MARK: - 拆分
    
    func 搜索时候的UI() -> some View {
        let 视图 = Group {Section(header: Text("搜索结果")) {
            ForEach(搜索结果列表) { 搜索结果 in
                
                Button(action: {
                    NotificationCenter.default.post(name:NSNotification.Name(rawValue:收到物品ObID的通知), object:搜索结果._id,userInfo:nil)
                }) {
                    Text(搜索结果.Display_Name)
                }.transition(.opacity.animation(.easeInOut))
            }
        }
            Section(header: Text("联想搜索")) {
                ForEach(AI搜索结果列表) { 搜索结果 in
                    
                    Button(action: {NotificationCenter.default.post(name:NSNotification.Name(rawValue:收到物品ObID的通知), object:搜索结果._id,userInfo:nil)
                    }) {
                        Text(搜索结果.Display_Name)
                    }.transition(.opacity.animation(.easeInOut))
                }
            }}
        return 视图
    }
    
    
    func 单元格(item:A_Object) -> some View {
        let 视图 = HStack {
            let 可用吗 = item.Which_Map_I_Belong.first?.Which_Series_I_Belong.first?._id == 当前地图系列UUID//ID不符合就禁用
            
            Button(action: {
                let 唯一标识符 = item._id
                NotificationCenter.default.post(name:NSNotification.Name(rawValue:收到物品ObID的通知), object:唯一标识符,userInfo:nil)
                printLog("加载物品: \(唯一标识符)")
            }) {
                VStack(alignment: .leading) {
                    Text(item.Display_Name)
                        .font(.title)
                        .id(更新)
                    if !可用吗 {
                        let 区域名称 = item.Which_Map_I_Belong.first?.Which_Series_I_Belong.first?.Name_Of_The_Series
                        Text(区域名称 != nil ? "属于区域“\(区域名称!)”" : "它所属的区域已被删除")
                            .font(.subheadline)
                            .id(更新)
                    }
                }.padding([.leading])
                //.border(.yellow)
            }.enable(with:可用吗)
            Spacer()
            菜单(item: item)
            
        }  .listRowInsets(EdgeInsets())
        return 视图
    }
    func 菜单(item:A_Object) -> some View {
        let 视图 =          Menu {
            Button(action: {
                keyWindow?.rootViewController?.presentedViewController?.present(UIHostingController(rootView: 物品重命名窗口(item: item)), animated: true, completion: {})
            }) {
                Label("重命名",systemImage: "pencil")
            }
            Button(role: .destructive, action: {
                printLog("手动删除物品")
                删除.append(item)
                if let 序号 = 列表.firstIndex(of: item) {
                    列表.remove(at: 序号)
                }
                
            }) {
                Label("删除",systemImage: "delete.backward.fill")
            }
//            Button(action: {}) {
//                Label("更多信息",systemImage: "clock.fill")
//            }
        } label: {
            
            
            Image(systemName: "ellipsis")
                .padding(20)
                .padding([.vertical],10)
            //.border(.gray)
            
        }
        return 视图
    }
    
    // MARK: - 方法
    func  添加物品按钮() {
        
        提示("在画面上点击你想要的物品")
        关闭初级弹窗()
    }
    // MARK: - Properties
    func moveTopic(from source: IndexSet, to destination: Int) {
        列表.move(fromOffsets: source, toOffset: destination)
    }
    func 删除(MySet:IndexSet) {
        
        do {
            // Open a thread-safe transaction.
            try realm.write {
                let 对象 = MySet.map({ Each in
                    return 列表[Each]
                })
                
                
                realm.delete(对象)
                // Make any writes within this code block.
                // Realm automatically cancels the transaction
                // if this code throws an exception. Otherwise,
                // Realm automatically commits the transaction
                // after the end of this code block.
                列表.remove(atOffsets: MySet)
                更新方向标()
            }
        } catch let error as NSError {
            printLog(error.localizedDescription)
        }
        
        
        
        
        
    }
}
struct 物品转接层: View {
    
    
    @State var 所有对象 : [A_Object] = []
    @State var notificationToken: NotificationToken?
    @State var realm : Realm? = nil
    
    @State var 更新 = UUID().uuidString
    
    var body: some View {
        新物品View(列表: $所有对象, 更新: $更新)
            .animation(.spring(),value:所有对象)
            .onAppear(perform: {
                notificationToken?.invalidate()
                Task(priority: .userInitiated) {
                    
                    do {
                        realm = await try Realm()
                    } catch let error as NSError {
                        printLog(error.localizedDescription)
                    }
                    
                    // Show initial tasks
                    func updateList() {
                        if let realm = realm {
                            let list : [A_Object] = Array(realm.objects(A_Object.self).sorted(byKeyPath: "Display_Name", ascending: false))
                            //这个转换可能会很慢，所以这是一个后台Task；尽量在还是result时进行排序、筛选
                            
                            self.所有对象 = list
                        } else {
                            printLog("realm未加载")
                        }
                        
                    }
                    
                    updateList()
                    
                    if let realm = realm {
                        // Notify us when Realm changes
                        self.notificationToken = realm.observe { _,_ in
                            print("数据库变了")
                            updateList()
                            更新 = UUID().uuidString
                        }
                    } else {
                        printLog("realm未加载")
                    }
                    
                    
                }
            })
    }
}
/// Represents an Item in a list.
struct 物品重命名窗口: View {
    @State var item: A_Object
    var body: some View {
        NavigationView {
            物品重命名窗口1(item: item, 原先名称: item.Display_Name, 新名称: item.Display_Name)
            
            
        }.navigationViewStyle(.stack)
    }
}

/// Represents an Item in a list.
struct 物品重命名窗口1: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State var item: A_Object
    @State var 原先名称 : String
    
    @State var 新名称 : String
    
    
    @State var 保存吗？: Bool = true
    var body: some View {
        
        VStack {
            Form {
                TextField("不修改", text: $新名称)
                    .introspectTextField(customize: {
                        $0.clearButtonMode = .always
                    })
                    .keyboardType(.default)
                    .textInputAutocapitalization(.characters)
                    .disableAutocorrection(false)
                    .onSubmit {
                        if 新名称 == "" {
                            
                            
                            
                            
                            
                        } else {
                            // Open the default realm.
                            let realm = try! Realm()
                            
                            // Prepare to handle exceptions.
                            do {
                                // Open a thread-safe transaction.
                                try realm.write {
                                    item.Display_Name = 新名称
                                    // Make any writes within this code block.
                                    // Realm automatically cancels the transaction
                                    // if this code throws an exception. Otherwise,
                                    // Realm automatically commits the transaction
                                    // after the end of this code block.
                                }
                            } catch let error as NSError {
                                // Failed to write to realm.
                                // ... Handle error ...
                                printLog(error.localizedDescription)
                            }
                            
                            
                            
                            
                            
                        }
                        self.presentationMode.wrappedValue.dismiss()
                    }
                    .introspectTextField { textField in
                        textField.becomeFirstResponder()
                    }
                
            }
        }  .navigationBarItems(leading:
                                Button(action: {
            self.保存吗？ = false
            self.presentationMode.wrappedValue.dismiss()
        }) {
            Text("取消")
        }, trailing:
                                Button(action: {
            self.presentationMode.wrappedValue.dismiss()
        }) {
            Text("完成")
        })
        
            .onWillDisappear{
                if 新名称 == "" {
                    
                    
                    
                    
                    
                } else {
                    // Open the default realm.
                    let realm = try! Realm()
                    
                    // Prepare to handle exceptions.
                    do {
                        // Open a thread-safe transaction.
                        try realm.write {
                            item.Display_Name = 新名称
                            // Make any writes within this code block.
                            // Realm automatically cancels the transaction
                            // if this code throws an exception. Otherwise,
                            // Realm automatically commits the transaction
                            // after the end of this code block.
                        }
                    } catch let error as NSError {
                        // Failed to write to realm.
                        // ... Handle error ...
                        printLog(error.localizedDescription)
                    }
                    
                    
                    
                    
                    
                }
            }
    }
}
struct 启用: ViewModifier {
    var 条件: Bool
    
    func body(content: Content) -> some View {
        content
            .disabled(!条件)
        
    }
}

extension View {
    func enable(with 条件: Bool) -> some View {
        self.modifier(启用(条件: 条件))
    }
}
