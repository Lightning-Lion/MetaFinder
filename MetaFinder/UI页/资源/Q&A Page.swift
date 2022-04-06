import SwiftUI

struct QAPage: View {
    @State var 选中项目 = 1
    var body: some View {
            TabView(selection: $选中项目) {
                
                let mediaUrl = Bundle.main.url(forResource: "Course.mov", withExtension: nil)!
                let url = URL(string: "https://www.craft.do/s/SgB0KusCzr78FN")!
                
                CustomVideoPlayer(视频URL: mediaUrl).tabItem { Image(systemName: "rectangle.lefthalf.filled")
                    Text("使用教程") }.tag(1)
                Bro(网页: url).tabItem {
                    Image(systemName: "rectangle.trailinghalf.filled")
                    Text("Q & A") }.tag(2)
            }
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                            let 是否返回 = (选中项目 >= 2)
                            let 标题 = 是否返回 ? "上一页" : "下一页"
                        Button(标题) {
                            withAnimation(.default, {
                                if 是否返回 {
                                    选中项目 -= 1
                                } else {
                                    选中项目 += 1
                                }
                            })
                        }
                    }
                }.navigationBarTitleDisplayMode(.inline)
        .navigationViewStyle(.stack)
        
    }
}
