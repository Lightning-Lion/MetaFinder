import SwiftUI
import QuickLook

class QuickLook数据源: ObservableObject, QLPreviewControllerDataSource  {
    
    var 对象的URLs : [URL]
    
    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        对象的URLs.count
    }
    
    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        let 图片 = 预览对象.init()
        图片.previewItemURL =  对象的URLs[index]
        图片.previewItemTitle =  "照片\(index)"
        return 图片
    }
    
    init(对象的URLs: [URL]) {
        self.对象的URLs = 对象的URLs
     }
}

class QuickLook对象: NSObject,QLPreviewItem {
    var previewItemURL: URL?
    var previewItemTitle: String?
}


