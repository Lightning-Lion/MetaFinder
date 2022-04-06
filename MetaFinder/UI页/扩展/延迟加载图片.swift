import SwiftUI
import UIKit
import QuickLook
class Async图片: ObservableObject {
    @Published var 图片: UIImage
    @Published var URLs: [URL] = []
    
    init(路径:URL,第几项:  [URL] ) {
        self.URLs =  第几项
        print("正在创建")
        图片  = UIImage(contentsOfFile: 路径.path)!
        
        
    }
}
class 快速查看: ObservableObject, QLPreviewControllerDataSource  {
    
    var 对象的URLs : [URL] = []
    
    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        对象的URLs.count
    }
    
    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        
        let 图片 = 预览对象.init()
        图片.previewItemURL =  对象的URLs[index]
        图片.previewItemTitle =  "照片\(index)"
        return 图片
    }
    
    init() {
     }
}
class 预览对象: NSObject,QLPreviewItem {
    var previewItemURL: URL?
    var previewItemTitle: String?
}
