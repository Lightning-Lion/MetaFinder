//
//  Welcome.swift
//  WorldMap
//
//  Created by mac on 2022/2/14.
//
import SPPermissions
import SwiftUI
func 验证相机权限() {
    if !SPPermissions.Permission.camera.authorized {
        let permissions: [SPPermissions.Permission] = [.camera]
        let controller = SPPermissions.list(permissions)
        controller.present(on: keyWindow?.rootViewController ?? UIViewController())
    }
}
struct 主入点: View {
    
    @State var MyWindow : UIWindow? = nil//2⃣️
    
    var body: some View {
        Windowable(ContentView: {//1⃣️
            主入点1()
        }, Receiver: { GetWindow in//3⃣️
            setupApperance()
        })
    }
}
struct 主入点1: View {
    
    @State var 下一页 : Bool = false
    
    var body: some View {
        NavigationView {
           ZStack {
               VStack {
                   Image("图片1")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                   Spacer()
                       .frame(height: 66, alignment: .center)
        
//                        NavigationLink("继续", destination: {第二页()})
               }
               Color("替代背景")
                   .hidden()
                   .overlay(VStack {
                       Spacer()
                       NavigationLink(destination: 第二页()) {
                           Text("继续")
                       }.buttonStyle(.borderedProminent)
                           .padding([.bottom],66)
                   })
                   
        }
           .navigationBarTitleDisplayMode(.inline)
        }
        .navigationBarTitle("")
//            .navigationBarHidden(true)
//            .sheet(isPresented: $下一页, onDismiss: nil, content: )
            .onAppear(perform: {
//                弹窗请求通知权限()
//                setupApperance()
                if !SPPermissions.Permission.camera.authorized {
                    let permissions: [SPPermissions.Permission] = [.camera]
                    let controller = SPPermissions.list(permissions)
                    controller.present(on: keyWindow?.rootViewController ?? UIViewController())
                }
            })
    }
    func setupApperance() {
        if let MyColor = UIColor(named: "黑白") {
        
        UINavigationBar.appearance().largeTitleTextAttributes = [
            NSAttributedString.Key.foregroundColor: MyColor]
        
        UINavigationBar.appearance().titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: MyColor]
        
        UIBarButtonItem.appearance().setTitleTextAttributes([
            NSAttributedString.Key.foregroundColor: MyColor], for: .normal)
        
    }
        UIWindow.appearance().tintColor = UIColor.cyan
    }
}



import AVKit

struct 第二页: View {
    @State var 控制器 : UIViewController? = nil
    
    //先把视频放到工程中,然后定义HelloMy.MOV
   
   

    
    var body: some View {
        VStack {
           ZStack {
               VStack {
               }
           }
        } .navigationBarTitle("了解更多").navigationBarTitleDisplayMode(.large)  .toolbar(content:  {Button(action: {
            let 视图 = UIView()
            视图.frame = .init(x: -3000, y: -3000, width: 6000, height: 6000)
            视图.backgroundColor = .systemBackground
            视图.alpha = 0
            keyWindow?.rootViewController?.view.addSubview(视图)
                       UIView.animate(withDuration: 0.15, animations: {
                           视图.alpha = 1
                       })
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                if let 控制器 = 控制器 {
                    keyWindow?.rootViewController = 控制器
                } else {
                    let 强制创建 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MyID")
                    keyWindow?.rootViewController = 强制创建
                }
                   }
        }) {
            Text("完成")
        }})
   .onAppear(perform: {
            Task {
                控制器 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MyID")
                (控制器 ?? UIViewController()).loadViewIfNeeded()
            }
            
        })
    }
}
struct Welcome: View {
    
    @State var 下一页 : Bool = false
    
    var body: some View {
        NavigationView {
            LinearGradient.init(colors: [.red,.yellow], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
                .mask(    VStack(alignment: .center, spacing: 30.0) {
                    Text("这款App使用了增强现实技术")
                    Text("需要访问你的摄像头以提供服务")
                    Spacer(minLength: 130)
                    Text("所有与你相关联的数据")
                    Text("都会存储在本地并被加密")
                    Text("App不会上传任何数据")
                    Spacer(minLength: 8)
                }.minimumScaleFactor(0.5)
                            .scaledToFit()
                            .font(.system(size: 55))
//                            .compositingGroup()
//                        .luminanceToAlpha()
                ).overlay(
                    VStack {
                    Spacer()
                        NavigationLink("继续", destination: {第二页().navigationBarHidden(true)})
                    }.accentColor(.orange).buttonStyle(.borderedProminent).padding(.bottom,60))
                .navigationBarHidden(true)
                .navigationTitle("隐私说明")
        }.navigationBarHidden(true)
            .navigationViewStyle(.stack)
//            .sheet(isPresented: $下一页, onDismiss: nil, content: )
            .onAppear(perform: {
//                弹窗请求通知权限()
                setupApperance()
            })
    }
    func setupApperance() {
        if let MyColor = UIColor(named: "黑白") {
        
        UINavigationBar.appearance().largeTitleTextAttributes = [
            NSAttributedString.Key.foregroundColor: MyColor]
        
        UINavigationBar.appearance().titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: MyColor]
        
        UIBarButtonItem.appearance().setTitleTextAttributes([
            NSAttributedString.Key.foregroundColor: MyColor], for: .normal)
        
    }
        UIWindow.appearance().tintColor = UIColor.cyan
    }
}


//let keyWindow = UIApplication.shared.connectedScenes
//        .filter({$0.activationState == .foregroundActive})
//        .compactMap({$0 as? UIWindowScene})
//        .first?.windows
//        .filter({$0.isKeyWindow}).first

struct 透明: View {
    var body: some View {
        
                Color.clear
        
        .ignoresSafeArea()
                    .background(.clear)
                    .onAppear(perform: {
                        keyWindow?.rootViewController?.presentedViewController?.modalTransitionStyle = .crossDissolve
                        keyWindow?.rootViewController?.presentedViewController?.dismiss(animated: true, completion: nil)
                    })
            
        
    }
}


struct Welcome_Previews: PreviewProvider {
    static var previews: some View {
        Welcome()
    }
}
struct Windowable<Content: View>: View {
    @ViewBuilder var ContentView: Content
    
    @State var Receiver: ((UIWindow?)->())? = nil
    
    @State var MyWindow : UIWindow? = nil
    
    
    @State var ID : UUID = UUID()
    
    var body: some View {
        ContentView
            .navigationBarTitle("")
                .navigationBarHidden(true)
            .overlay(            Text("")//Add a empty view that can execute the introspect
                                    .id(ID)//Change the ID will execute the introspect
                                    .introspectViewController(customize: { VC in//A introspect used to get the window to which the View belongs
                let GetWindow = VC.view.window//Get the window to which the View belongs
                if let Receiver = Receiver {//If has a receiver
                    Receiver(GetWindow)//Passing the window back
                }
            })
                                    .onAppear(perform: {//Execute introspection by change the ID to get the window
                DispatchQueue.main.async {
                    ID = UUID()
                }
            })).navigationBarTitle("")
            .navigationBarHidden(true)
    }
}
