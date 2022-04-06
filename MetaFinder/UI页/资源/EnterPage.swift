import SwiftUI
import Drops

struct EnterPage: View {
    @State var 选中项目 = 1
    var body: some View {
        NavigationView {
            TabView(selection: $选中项目) {
                欢迎图片().tabItem { /*@START_MENU_TOKEN@*/Text("Tab Label 1")/*@END_MENU_TOKEN@*/ }.tag(1)
                网页().tabItem { /*@START_MENU_TOKEN@*/Text("Tab Label 2")/*@END_MENU_TOKEN@*/ }.tag(2)
                视频().tabItem { /*@START_MENU_TOKEN@*/Text("Tab Label 2")/*@END_MENU_TOKEN@*/ }.tag(3)
            }.tabViewStyle(.page(indexDisplayMode: .never))
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("上一页") {
                            withAnimation(.default, {
                                选中项目 -= 1
                            })
                        }.disabled(选中项目 <= 1)//如果不因为开屏，直接仿造下面的写就行
                    }
                    
                    ToolbarItem(placement: .navigationBarTrailing) {
                        let 是否完成 = 选中项目 >= 3
                        let 标题 = 是否完成 ? "完成" : "下一页"
                        Button(标题) {
                            withAnimation(.default, {
                                选中项目 += 1
                            })
                            if 是否完成 {
                                结束()
                            }
                        }
                    }
                }.navigationBarTitleDisplayMode(.inline)
        }.navigationViewStyle(.stack)
        
    }
    func 结束() {
            let 视图 = UIView()
            视图.frame = .init(x: -3000, y: -3000, width: 6000, height: 6000)
            视图.backgroundColor = .systemBackground
            视图.alpha = 0
            keyWindow?.rootViewController?.view.addSubview(视图)
            UIView.animate(withDuration: 0.15, animations: {
                视图.alpha = 1
            },completion: { _ in
                let 强制创建 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MyID")
                keyWindow?.rootViewController = 强制创建
            })
        let 水滴 = Drop(title: "操作指引", titleNumberOfLines: 1, subtitle: "轻触查看", subtitleNumberOfLines: 1, icon: .init(systemName: "book.closed.fill"), action: .init(handler: {
            //显示Q&A页面
            找到最上层Present()?.show(UIHostingController(rootView: MyGrid(显示0:true)), sender: nil)
            
        }), position: .top, duration: .seconds(10), accessibility: nil)
        Drops.show(水滴)
    }
    func 找到最上层Present() -> UIViewController? {
        let 根 = keyWindow?.rootViewController
        var 当前指针 = 根
        while (当前指针?.presentedViewController != nil) {
            当前指针 = 当前指针?.presentedViewController
        }
        return 当前指针
    }

}

struct 欢迎图片: View {
    var body: some View {
        Image("欢迎Image")
            .resizable()
            .aspectRatio(contentMode: .fit)
    }
}
struct 视频: View {
    var body: some View {
        CustomVideoPlayer(视频URL: Bundle.main.url(forResource: "Introduce.mov", withExtension: nil)!)
    }
}

struct 网页: View {
    @State var 隐藏 = false
    var body: some View {
        Bro(网页: URL(string: "https://www.craft.do/s/ubmIyurhlSqnVi")!)
    }
}


