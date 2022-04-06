//
//  【扩展】Grid.swift
//  MetaFinder
//
//  Created by 凌嘉徽 on 2022/2/2.
//

import SwiftUI
import SafariServices
///必须提供View，不要提供空闭包
struct 更好的导航视图<content: View>: View {
    
    @ViewBuilder var Content: content
    
    
    @Environment(\.presentationMode) private var presentationMode
    @Environment(\.verticalSizeClass) var horizontalSizeClass
    var body: some View {
        
        
        Content
        
            .toolbar(content: {
                if horizontalSizeClass == .compact {
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("完成")
                    }
                }
            })
            .navigationViewStyle(.stack)//在这里处理Stack样式
        
        
    }
}

struct 左侧按钮<Content: View,Content1: View,Content2: View>: View {
    
    
    
    @ViewBuilder var 内容（左）: Content
    @ViewBuilder var 跳转到: Content1
    @ViewBuilder var 占位内容: Content2
    
    
    var body: some View {
        
        HStack(spacing: 15) {
            宽按钮.init(内容: {
                内容（左）
            }, 跳转页面: {
                跳转到
            })
            //小图片(名字: "占位小图片")
            占位内容
            
        }
        
    }
}

struct 两个<Content: View,Content1: View,Content2: View,Content3: View>: View {
    
    
    @ViewBuilder var content: Content
    @ViewBuilder var content1: Content1
    @ViewBuilder var content2: Content2
    @ViewBuilder var content3: Content3
    
    @Binding var 显示1 : Bool
    @Binding var 显示2 : Bool
    var body: some View {
        
        HStack(spacing: 15) {
            对接按钮(内容: {
                LazyVStack {
                    content
                }
            }, 跳转页面: {
                content1
            }, 显示: $显示1)
            对接按钮(内容: {
                LazyVStack {
                    content2
                }
            }, 跳转页面: {
                content3
            }, 显示: $显示2)
        }
        
    }
}

struct 对接按钮<Content: View,Content1: View>: View {
    @ViewBuilder var 内容: Content
    @ViewBuilder var 跳转页面: Content1
    
    @State private var tapped1 = false
    
    @State private var tapped = false
    @State private var 缩放: CGFloat = 1
    
    @Binding var 显示 : Bool
    var body: some View {
        NavigationLink(destination: 跳转页面
        ,isActive: $显示) {
            LazyVStack {
                内容
            }
            //                .scaleEffect(缩放, anchor: .center)
            //                ._onButtonGesture(pressing: { i in
            //                    if i {
            //                        轻触()
            //                        withAnimation(.easeOut, {
            //                            缩放 = 1/Double.pi*3
            //                        })
            //                    } else {
            //                        withAnimation(.easeOut, {
            //                                     缩放 = 1
            //                        })
            //                    }
            //                }, perform: {})
            //                .buttonStyle(.borderless)
        }
        
        
        
        
    }
}
struct 宽按钮<Content: View,Content1: View>: View {
    @ViewBuilder var 内容: Content
    @ViewBuilder var 跳转页面: Content1
    
    @State private var tapped1 = false
    
    @State private var tapped = false
    @State private var 缩放: CGFloat = 1
    
    var body: some View {
        
        内容
            .scaleEffect(缩放, anchor: .center)
            ._onButtonGesture(pressing: { i in
                if i {
                    轻触()
                    withAnimation(.easeOut, {
                        缩放 = 1/Double.pi*3
                    })
                } else {
                    withAnimation(.easeOut, {
                        缩放 = 1
                    })
                }
            }, perform: {tapped1.toggle()})
            .buttonStyle(.borderless)
            .sheet(isPresented: $tapped1, onDismiss: nil, content: {跳转页面})
        
        
    }
}

extension View {
    func 按下效果() -> some View {
        modifier(OnTouchDownGestureModifier())
    }
}

private struct OnTouchDownGestureModifier: ViewModifier {
    @State private var tapped = false
    @State private var 缩放: CGFloat = 1
    func body(content: Content) -> some View {
        content
            .scaleEffect(缩放, anchor: .center)
            ._onButtonGesture(pressing: { i in
                if i {
                    withAnimation(.easeOut, {
                        缩放 = 1/Double.pi*3
                    })
                } else {
                    withAnimation(.easeOut, {
                        缩放 = 1
                    })
                }
            }, perform: {
                print("???")
            })
    }
}

private struct 按下打开视图: ViewModifier {
    @State private var tapped = false
    
    func body(content: Content) -> some View {
        Button(action: {}) {
            content
                .font(.largeTitle)
                .foregroundColor(.white)
                .padding()
                .background(Color.blue)
                .clipShape(RoundedRectangle(cornerRadius: .infinity))
                .navigationTitle("测试")
            
        }.sheet(isPresented: $tapped, onDismiss: nil, content: {
            Text("")
        })
    }
}




struct HEIC大图片: View {
    var 名字:String
    var body: some View {
                let 网址 = URL(fileURLWithPath: Bundle.main.path(forResource: 名字, ofType: "heic")!)
                
                AsyncImage(url: 网址) { image in
                    image.resizable()
                        .aspectRatio(contentMode: .fit)
                        .cornerRadius(20)
                } placeholder: {
                    ProgressView()
                }
                
    }
}

struct 大图片: View {
    var 名字:String
    var body: some View {
                let 网址 = URL(fileURLWithPath: Bundle.main.path(forResource: 名字, ofType: "jpeg")!)
                
                AsyncImage(url: 网址) { image in
                    image.resizable()
                        .aspectRatio(contentMode: .fit)
                        .cornerRadius(20)
                } placeholder: {
                    ProgressView()
                }
                
    }
}

struct 小图片: View {
    var 名字:String
    
    var body: some View {
        
        let 网址 = URL(fileURLWithPath: Bundle.main.path(forResource: 名字, ofType: "heic")!)
        AsyncImage(url: 网址) { image in
            image.resizable()
                .aspectRatio(contentMode: .fit)
                .cornerRadius(20)
        } placeholder: {
            ProgressView()
        }
        
        
        
        
    }
}

struct 物品列表: View {
    var body: some View {
        VStack {
            List {
                Text("A List Item")
                Text("A Second List Item")
                Text("A Third List Item")
            }
        }.navigationTitle("物品列表")
    }
}

var 下一个是门 = false


struct 图片: View {
    var body: some View {
                Image("桌面")
                    .resizable()
        
        .ignoresSafeArea()
                    .scaledToFill()
    }
}
struct 设置: View {
    
    @AppStorage("打开直接加载最近一张地图") var vibrateOnRing = false
    

    @State var 展开 : Bool = false

    var body: some View {
        
        
        List {
            Button("关于") {
                let 控制器 = SFSafariViewController(url: URL(string: "https://www.craft.do/s/TBfU1d5jNj4kHM")!)
                keyWindow?.rootViewController?.presentedViewController?.show(控制器, sender: nil)
                if let AR页 = keyWindow?.rootViewController as? ViewController {
                    AR页.自动保存()
                }
            }
            Toggle(isOn: $vibrateOnRing) {
                    Text("启动时自动加载最近使用的区域")
                }
            DisclosureGroup("高级设置",isExpanded: $展开) {
//            Button("添加门") {
//                下一个是门 = true
//            }
            Button("再次显示欢迎页面（重启生效）") {
                let 对象 = UIApplication.shared.delegate as? AppDelegate
                对象?.第一次启动 = true
            }
//                Button(action: {let 页 = UIHostingController(rootView: 图片())
//                    页.modalPresentationStyle = .fullScreen
//                    keyWindow?.rootViewController?.presentedViewController?.present(页, animated: true, completion: nil)}, label: {Text("显示桌面背景")})
                
            }
      
        }
//        .listStyle(.grouped)
            .navigationBarTitle("设置", displayMode: .large)
    }
}
    func 弹窗请求通知权限() {
        let 要求 = UNAuthorizationOptions.init(arrayLiteral: .alert, .badge, .sound)
        let userNotificationCenter = UNUserNotificationCenter.current()
        userNotificationCenter.requestAuthorization(options: 要求) { (success, error) in
            print("是否允许通知：\(success)")
            if let error = error {
                print("Error: ", error.localizedDescription)
            }
        }
    }

struct MyGrid_Previews: PreviewProvider {
    static var previews: some View {
        MyGrid()
    }
}
