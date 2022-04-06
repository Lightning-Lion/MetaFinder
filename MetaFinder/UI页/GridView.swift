//“设置”
//“自动灭屏”
//  MyGrid.swift
//  Experiment
//
//  Created by 凌嘉徽 on 2022/1/22.
//

import SwiftUI

var 打开地图页 = "打开地图页"

var 打开过了没 = false

// MARK: - 🌟MyGrid
struct MyGrid: View {
    
    @State private var 视图宽度1: CGFloat = 298
    @State private var 缩放: CGFloat = 1
    @State private var 缩放1: CGFloat = 1
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    let 收 = NotificationCenter.default.publisher(for: NSNotification.Name(打开地图页))
    @State var 显示0 : Bool = false
    @State var 显示1 : Bool = false
    @State var 显示2 : Bool = false
    @State var 显示3 : Bool = false
    
    var body: some View {
        let gridItems = [GridItem(.adaptive(minimum: 视图宽度1,maximum: 450),spacing: 15)]//在此处定义各GridItem的间隔
        
        
        NavigationView {
            
            VStack {
                LazyVGrid(columns: gridItems,spacing: 15) {//在此处定义各Columns的间隔
                    对接按钮(内容: {HEIC大图片(名字: "使用教学")}, 跳转页面: {
                        QAPage()
                    }, 显示: $显示0)
//                    Button(action: {
//                        let controller = AVPlayerViewController()
//                        if let MyURL = URL(string: "https://ling-bucket.oss-cn-beijing.aliyuncs.com/Introduce.mov") {
//                            let MyPlayer = AVPlayer(url: MyURL)
//                            controller.player = MyPlayer
//
//                            if let AR页 = keyWindow?.rootViewController as? ViewController {
//                                controller.delegate = AR页
//                            }
//                            安全弹窗(基: keyWindow?.rootViewController, 弹窗: controller)
//                            MyPlayer.play()
//                        }
//                    }, label: {HEIC大图片(名字: "使用教学")})
                    //在这里面处理Stack样式
                    对接按钮(内容: {大图片(名字: "物品清单（长）")}, 跳转页面: {
                        物品转接层()
                    }, 显示: $显示1)//在这里面处理Stack样式
                    
                    两个(content: {小图片(名字: "区域")}, content1: {地图_入点()}, content2: {小图片(名字: "设置（短）")}, content3: {设置().navigationViewStyle(.stack)},显示1: $显示2, 显示2: $显示3)
                    
                    
                }
                .shadow(color: Color.init("阴影", bundle: .main), radius: 20)
                .padding()
                
                Spacer()
            }
            .navigationTitle("主页")
            
            .navigationBarTitleDisplayMode(.large)
            .navigationBarItems(leading: Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }) {
                Text("返回")
            })
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    打开过了没 = true
                }
                
            }
        }.navigationViewStyle(.stack)
        
            .textSelection(.enabled)
            .onReceive(收, perform: { (output) in
                显示2 = true
            })
    }
    
}



