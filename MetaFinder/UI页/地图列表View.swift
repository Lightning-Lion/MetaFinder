//
//  地图列表.swift
//  WorldMap
//
//  Created by 凌嘉徽 on 2022/1/31.
//

import SwiftUI
import RealmSwift
import Introspect
//import SDWebImage
//import SDWebImageSwiftUI
import Drops
import QuickLook

// MARK: - 地图
struct 新地图View: View {
    @Binding var 列表 : [地图系列]
    
    @State var realm = try! Realm()
    
    //重命名功能
    
    @Binding var 更新 : String
    //删除功能
    @State var 待删除 : [地图系列] = []
    
    var body: some View {
        
        VStack {
            List {
                
                ForEach(列表) { item in
                    
                    Button(action:{
                        if 当前地图系列UUID != item._id {
                            let 唯一标识符 = item._id
                            NotificationCenter.default.post(name:NSNotification.Name(rawValue:地图UUID通知名称), object:唯一标识符,userInfo:nil)
                            printLog("加载地图: \(唯一标识符)")
                        }
                        keyWindow?.rootViewController?.presentedViewController?.dismiss(animated: true, completion: nil)
                    }) {
                        HStack {
                            VStack(alignment: .leading) {
                                
                                一行图片(ID: item._id)
                                
                                Text(item.Name_Of_The_Series)
                                    .font(.title)
                                    .id(更新)
                                Text("更新于"+符号化日期(item.Updated_Date))
                                    .font(.subheadline)
                                    .id(更新)
                                if 当前地图系列UUID == item._id {
                                    Label("正在使用", systemImage: "bolt.fill")
                                        .font(.body)
                                        .id(更新)
                                }
                            }
                            
                            Spacer()
                            VStack {
                                菜单(item: item)
                            }
                        }
                    }
                }.onDelete(perform: { MySet in
                    MySet.forEach({ item in
                        if 列表[item]._id == 当前地图系列UUID {
                            if let AR页 = keyWindow?.rootViewController as? ViewController {
                                AR页.重启会话()
                            }
                        }
                    })
                    删除(MySet: MySet)})
                //                    .onMove(perform: {moveTopic(from: $0, to: $1)})
                Button(action:{
                    if let AR页 = keyWindow?.rootViewController as? ViewController {
                        if AR页.通过ID查找地图系列(当前地图系列UUID) != nil {
                            AR页.重启会话()
                        }
                    }
                    if let AR页 = keyWindow?.rootViewController as? ViewController {
                                   let 页面 = AR页.显示地图名称()
                               }
                    let 系列 = 新建一张地图()
                    系列.Name_Of_The_Series = "新区域"
                    if !不在回忆 {
                        if let AR页 = keyWindow?.rootViewController as? ViewController {
                            AR页.重启会话()
                        }
                    }
                    do {
                        let realm = try Realm()
                        try realm.write {
                            realm.add(系列)
                            
                            当前地图系列UUID = 系列._id
                            Allow保存 = true
                            Allow拍照 = true
                            不在回忆 = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                if let AR页 = keyWindow?.rootViewController as? ViewController {
                                    AR页.自动保存()
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 6) {
                                    if let AR页 = keyWindow?.rootViewController as? ViewController {
                                        AR页.自动保存()
                                    }
                                }
                            }
                            刚刚创建区域 = true
                        }
                    } catch {
                        提示(error.localizedDescription)
                    }
                    Drops.hideAll()
                    提示("新区域已创建")
                }) {
                    HStack {
                        Text("新建区域")
                    }
                }
                //更新地图
                Button(通过ID查找地图系列(当前地图系列UUID)?.Name_Of_The_Series == nil ? "更新地图（请先选择一张现有地图）" : "更新地图“\(通过ID查找地图系列(当前地图系列UUID)?.Name_Of_The_Series ?? "")”") {
                    Task(priority: .medium) {
                        if let AR页 = UIApplication.shared.keyWindow?.rootViewController as? ViewController {
                            await AR页.保存世界地图(显示更新提示吗？: true)
                        }
                    }
                }.disabled(通过ID查找地图系列(当前地图系列UUID)?.Name_Of_The_Series == nil)
                
                    .listStyle(.sidebar)
                
                
            }
            
            
        }            .onAppear(perform: {
            if let AR页 = UIApplication.shared.keyWindow?.rootViewController as? ViewController {
                AR页.自动保存()
            }
        })
            .navigationBarTitle("🗺区域", displayMode: .large)
            .navigationBarItems(trailing: EditButton())
        //
            .onChange(of: 待删除, perform: { item in Realm删除(闭包: {realm.delete(item)}, 并发: true) })//后台删除
    }
    
    
    func 菜单(item:A_Map_Series) -> some View {
        let 视图 =  Menu {
            Button(action: {
                keyWindow?.rootViewController?.presentedViewController?.present(UIHostingController(rootView: 地图重命名窗口(item: item)), animated: true, completion: {})
            }) {
                Label("重命名",systemImage: "pencil")
            }
            Button(role: .destructive, action: {
                
                printLog("手动删除物品")
                if item._id == 当前地图系列UUID {
                    if let AR页 = keyWindow?.rootViewController as? ViewController {
                        AR页.重启会话()
                    }
                }
                
                待删除.append(item)
                
                if let 序号 = 列表.firstIndex(of: item) {
                    列表.remove(at: 序号)
                }
               
                //                                        提示("右滑列表项目来删除它")
                
            }) {
                Label("删除",systemImage: "delete.backward.fill")
            }
//            Button(action: {}) {
//                Label("历史版本",systemImage: "clock.fill")
//            }
        } label: {
            ZStack {
                Circle()
                    .foregroundColor(Color(UIColor(named:"次级颜色")!))
                    .frame(width: 40, height: 40, alignment: .center)
                    .overlay(Image(systemName: "ellipsis").shadow(radius: 20))
                
            }
        }
        return 视图
    }
    
    func moveTopic(from source: IndexSet, to destination: Int) {
        列表.move(fromOffsets: source, toOffset: destination)
    }
    func 删除(MySet:IndexSet) {
        
        
        do {
            let realm = try Realm()
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
            }
        } catch let error as NSError {
            printLog(error.localizedDescription)
        }
    }
}


// MARK: - 套接层
struct 地图_入点: View {
    
    
    @State var 所有对象 : [地图系列] = []
    @State var notificationToken: NotificationToken?
    @State var realm : Realm? = nil
    
    @State var 更新 = UUID().uuidString
    
    var body: some View {
        新地图View(列表: $所有对象, 更新: $更新)
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
                            let list : [A_Map_Series] = Array(realm.objects(A_Map_Series.self).sorted(byKeyPath: "Updated_Date", ascending: false))
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
                            更新地图名称()
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

struct 一行图片: View {
    @ObservedObject var 观察模型 = QuickLook数据源(对象的URLs: [])
    @State var ID : ObjectId
    @State var QVC = QLPreviewController()
    
    @State var 是否激活 = false
    @State var 第几项 = 0
    
    var body: some View {
        //图片橱窗
        ScrollView(.horizontal) {
            let 图片的URLs = 加载图片(地图系列ID: ID)
            LazyHStack {
                let 最大接受序号 = 20//（+1张地图）
                ForEach(图片的URLs) { url in
                    let 当前序号 = 图片的URLs.firstIndex(of: url) ?? 0
                    
                    if 当前序号 < 最大接受序号 {
                        AsyncImage(url: url.你要的) { image in
                            image.resizable()
                                .aspectRatio(contentMode: .fit)
                                .cornerRadius(10)
                        } placeholder: {
                            ProgressView()
                                .frame(width: 300, height: 300, alignment: .center)
                        }
                        
                        //                        一张异步图片(URL要求: url)
                        //                        橱窗图片(图片: UIImage(contentsOfFile: url.path),isActive: $是否激活, Index: $第几项, 我的Index: 当前序号)
                    }
                }
//                .transition(.opacity.animation(.easeInOut))
                    .onAppear(perform: {
                        //                        观察模型.对象的URLs = 图片的URLs
                        //                        QVC.dataSource = 观察模型
                    })
                if !图片的URLs.isEmpty {
                    //                    点击查看更多(链接s: 图片的URLs).cornerRadius(10)
                }
                
            }
        }
        .frame(maxHeight: 300)
        .shadow(radius: 6, x: 6, y: 6)
        .onChange(of: 是否激活, perform: { i in
            if i {
                if let AR页 = keyWindow?.rootViewController as? ViewController {
                    if AR页.presentedViewController?.presentedViewController == nil {
                        QVC.currentPreviewItemIndex = 第几项
                        printLog("当前Index\(QVC.currentPreviewItemIndex)")
                        是否激活 = false
                        AR页.show(QVC, sender: nil)
                    }
                }
            }
        })
    }
}



//struct 一张异步图片: View, Equatable {
//    @State var URL要求 : URL
//    var body: some View {
////        WebImage(url: URL要求)
//            .resizable()// Placeholder Image
//        // Supports ViewBuilder as well
//            .placeholder {
//                Image(systemName: "photo").foregroundColor(.gray)
//                    .frame(width: 300, height: 300, alignment: .center)
//            }
//            .indicator(.activity) // Activity Indicator
//            .transition(.fade(duration: 0.5)) // Fade Transition with duration
//            .scaledToFit()
//            .cornerRadius(10)
//    }
//    
//    static func == (lhs: 一张异步图片, rhs: 一张异步图片) -> Bool {
//        return lhs._URL要求 == rhs._URL要求
//    }
//}
//import WaterfallGrid
struct 图片展柜: View {
    
    
    
    var gridItemLayout = [GridItem(.adaptive(minimum: 100))]
    
    @State var 图片URLs : [URL]
    var body: some View {
        ScrollView {
//            WaterfallGrid(图片URLs) { rectangle in
                VStack {
//                    WebImage(url: rectangle)
//                        .resizable()
                    //                .scaledToFill()
                    //                .frame(minWidth: 0, maxWidth: .infinity)
                    //                .aspectRatio(1, contentMode: .fill)
                    //                .clipped()
                }
            }
        
    }
    
}

struct 橱窗图片: View {
    @State var 图片 : UIImage?
    
    @Binding var isActive : Bool
    @Binding var Index : Int
    
    @State var 我的Index : Int
    var body: some View {
        if let 图片 = 图片 {
            Button(action: {
                Index = 我的Index
                printLog("选中Index\(Index)")
                isActive = true
                
            }) {
                Image(uiImage: 图片)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(10)
            }.onAppear(perform: {
                printLog("要求加载\(我的Index)")
            })
        }
        
    }
}

struct 点击查看更多: View {
    //    @Binding var isActive : Bool
    //    @Binding var Index : Int
    //    @State var 最大Index : Int
    
    @State var 链接s : [URL]
    var body: some View {
        Button(action: {
            if let AR页 = keyWindow?.rootViewController as? ViewController {
                AR页.show(UIHostingController(rootView: 图片展柜(图片URLs:链接s)), sender: nil)
            }
        }) {
            Rectangle()
                .fill(Color("查看更多"))
                .aspectRatio(0.5, contentMode: .fit)
                .overlay(Text("点击查看更多")    .foregroundColor(Color("黑白"))       //自适应缩放
                         //优先缩放
                            .minimumScaleFactor(Double.pi*2)
                            .scaledToFill()
                         //如果缩放到最小还不够，显示多行
                            .lineLimit(.max)
                         //缩放+多行还不够，省略号
                            .truncationMode(.middle))
            
        }
        
    }
}



struct MyLocalImage: View {
    
    @ObservedObject var 观察模型: Async图片
    @ObservedObject var 观察模型1 = 快速查看()
    
    let quickLookViewController = QLPreviewController()
    
    var body: some View {
        Button(action: {keyWindow!.rootViewController!.presentedViewController!.present(quickLookViewController, animated: true, completion: nil)})
        {
            Image(uiImage: 观察模型.图片)
                .resizable()
                .aspectRatio(contentMode: .fit)
        }.onAppear(perform: {
            print("开始加载")
            观察模型1.对象的URLs = 观察模型.URLs
            print(观察模型.URLs)
            quickLookViewController.dataSource = 观察模型1
            quickLookViewController.modalPresentationStyle = .overFullScreen//.init(rawValue: Int(文本框.text!)!)!
            quickLookViewController.loadViewIfNeeded()
            print("加载完成")
        })
        
    }
}
// MARK: - 旧版
struct 地图View的壳: View {
    
    let realm = try! Realm()
    
    
    @ObservedResults(MapShell.self) var 地图的壳
    
    var body: some View {
        
        if  let 地图们 = 地图的壳.first {
            // Pass the Group objects to a view further
            // down the hierarchy
            地图列表View(地图们: 地图们)
        } else {
            ProgressView().onAppear {
                $地图的壳.append(MapShell())
            }
        }
    }
}


struct 地图列表View: View {
    
    
    @ObservedRealmObject var 地图们: MapShell
    //@State var 地图们 = realm.objects(OneWorldMap.self)
    
    
    
    //接收地图创建完成
    @State var ID = "初始"
    
    let 发送者 = NotificationCenter.default
        .publisher(for: .init(rawValue: 成功保存地图通知名称))
    
    //重命名功能
    @State var 重命名窗口 = false
    var body: some View {
        
        
        List {
            if !$地图们.items.isEmpty {
                ForEach(地图们.items.sorted(byKeyPath: "SeriesName", ascending: false)) { item in
                    
                    Button(action: {
                        let 唯一标识符 = item._id
                        NotificationCenter.default.post(name:NSNotification.Name(rawValue:地图UUID通知名称), object:唯一标识符,userInfo:nil)
                        printLog("加载地图: \(唯一标识符)")
                    }) {
                        
                        VStack(alignment: .leading) {
                            Text(item.SeriesName)
                                .font(.title)
                            
                            Text(item.DisplayName)
                                .font(.subheadline)
                        }
                        .transition(.opacity.animation(.easeInOut))
                        
                    }.transition(.opacity.animation(.easeInOut))
                    //                        .sheet(isPresented: $重命名窗口, onDismiss: {ID = UUID().uuidString}, content: {地图重命名窗口(item: item)})
                        .contextMenu {
                            Button("重命名") {
                                重命名窗口.toggle()
                            }
                            
                        }
                }
                .onDelete(perform: { MyIndexSet in
                    MyIndexSet.forEach({ MyIndex in
                        do {
                            let realm = try! Realm()
                            try realm.write {
                                
                                let fileManger = FileManager.default
                                do{
                                    if let 文件名 = 地图们.items[MyIndex].FilePath {
                                        //危险，可能崩溃
                                        let 所有对象 = realm.objects(MapShell.self).first!
                                        let 目标对象 = 所有对象.items.where { i in
                                            i._id == 地图们.items[MyIndex]._id
                                        }.first!
                                        realm.delete(目标对象)
                                        try fileManger.removeItem(at: 从文件名称获取路径(文件名: 文件名))
                                        print("成功删除文件")
                                    }
                                }catch{
                                    printLog("无法删除文件：\n\(error.localizedDescription)")
                                }
                                
                                
                            }
                        } catch {
                            提示(error.localizedDescription)
                        }
                        
                    })
                    ID = UUID().uuidString
                })
                .transition(.opacity.animation(.easeInOut))
                
                
                
                
            } else {
                Text("点击按钮新建地图")
            }
            Button("🆕新建地图") {
                NotificationCenter.default.post(name:NSNotification.Name(rawValue:被要求保存地图通知名称), object:nil,userInfo:nil)
            }
        }.transition(.opacity.animation(.easeInOut))
            .id(ID)
        //在NavigationView内设置列表样式
            .listStyle(.insetGrouped)//现代化、层次感的风格
            .navigationBarTitle("🗺地图", displayMode: .large)
            .navigationBarBackButtonHidden(false)
            .navigationBarItems(trailing: EditButton())
        
            .onReceive(发送者, perform: { i in
                ID = UUID().uuidString
            })
        
        //在NavigationView外设置导航样式
            .navigationBarTitleDisplayMode(.large)
            .navigationViewStyle(.stack)
        
    }
    
}

/// Represents an Item in a list.
struct 地图重命名窗口: View {
    @State var item: A_Map_Series
    
    //    @Environment(\.presentationMode) private var presentationMode
    
    var body: some View {
        NavigationView {
            地图重命名窗口1(item: item, 原先名称: item.Name_Of_The_Series, 新名称: item.Name_Of_The_Series)
            
            
        }.navigationViewStyle(.stack)
    }
}

/// Represents an Item in a list.
struct 地图重命名窗口1: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State var item: A_Map_Series
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
                                    item.Name_Of_The_Series = 新名称
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
        }    .navigationBarItems(leading:
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
                if 保存吗？ {
                    if 新名称 == "" {
                        
                        
                        
                        
                        
                    } else {
                        // Open the default realm.
                        let realm = try! Realm()
                        
                        // Prepare to handle exceptions.
                        do {
                            // Open a thread-safe transaction.
                            try realm.write {
                                item.Name_Of_The_Series = 新名称
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
}

struct 地图列表_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
extension String: Identifiable {
    public var id: UUID { UUID() }
}

extension Double: Identifiable {
    public var id: UUID { UUID() }
}
struct WillDisappearHandler: UIViewControllerRepresentable {
    func makeCoordinator() -> WillDisappearHandler.Coordinator {
        Coordinator(onWillDisappear: onWillDisappear)
    }
    
    let onWillDisappear: () -> Void
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<WillDisappearHandler>) -> UIViewController {
        context.coordinator
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<WillDisappearHandler>) {
    }
    
    typealias UIViewControllerType = UIViewController
    
    class Coordinator: UIViewController {
        let onWillDisappear: () -> Void
        
        init(onWillDisappear: @escaping () -> Void) {
            self.onWillDisappear = onWillDisappear
            super.init(nibName: nil, bundle: nil)
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
            onWillDisappear()
        }
    }
}

struct WillDisappearModifier: ViewModifier {
    let callback: () -> Void
    
    func body(content: Content) -> some View {
        content
            .background(WillDisappearHandler(onWillDisappear: callback))
    }
}

extension View {
    func onWillDisappear(_ perform: @escaping () -> Void) -> some View {
        self.modifier(WillDisappearModifier(callback: perform))
    }
}
func 保存地图() {
    NotificationCenter.default.post(name:NSNotification.Name(rawValue:被要求保存地图通知名称), object:nil,userInfo:nil)
}
extension UIImage: Identifiable {
    public var id: UUID { UUID() }
}
extension URL: Identifiable {
    public var id: UUID { UUID() }
}
extension UIImage {
    func rotate(radians: Float) -> UIImage? {
        var newSize = CGRect(origin: CGPoint.zero, size: self.size).applying(CGAffineTransform(rotationAngle: CGFloat(radians))).size
        // Trim off the extremely small float value to prevent core graphics from rounding it up
        newSize.width = floor(newSize.width)
        newSize.height = floor(newSize.height)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, self.scale)
        let context = UIGraphicsGetCurrentContext()!
        
        // Move origin to middle
        context.translateBy(x: newSize.width/2, y: newSize.height/2)
        // Rotate around middle
        context.rotate(by: CGFloat(radians))
        // Draw the image at its center
        self.draw(in: CGRect(x: -self.size.width/2, y: -self.size.height/2, width: self.size.width, height: self.size.height))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
}
