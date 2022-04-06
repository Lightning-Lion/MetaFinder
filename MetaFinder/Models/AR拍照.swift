import UIKit
import RealityKit
import ARKit
import SwiftUI
import RealmSwift
import Combine
import RKPointPin
import FocusEntity

extension ViewController {
    func 拍照() async -> UIImage? {
        
        
        let Device方向 = UIDevice.current.orientation
        
        switch Device方向 {
        case UIDeviceOrientation.portrait:
            重力感应方向 = 横竖屏.标准竖屏
        case UIDeviceOrientation.portraitUpsideDown:
            重力感应方向 = 横竖屏.反向竖屏
        case UIDeviceOrientation.landscapeLeft:
            重力感应方向 = 横竖屏.标准横屏
        case UIDeviceOrientation.landscapeRight:
            重力感应方向 = 横竖屏.反向横屏
        default:
            重力感应方向 = 横竖屏.标准竖屏
        }
        
        let 捕获 = arView.session.currentFrame?.capturedImage
        
        guard let pixelBuffer = 捕获 else {
            return nil
        }
        
        let ciImage = CIImage(cvPixelBuffer: pixelBuffer)
        let context = CIContext(options: nil)
        let cgImage = context.createCGImage(ciImage, from: ciImage.extent)
        let 图像 = UIImage(cgImage: cgImage!, scale: 1, orientation: .up)
        
        switch 重力感应方向 {
        case 横竖屏.标准竖屏:
            return 图像.rotate(radians: .pi/2)
        case 横竖屏.反向横屏:
            return 图像.rotate(radians: .pi)
        case 横竖屏.反向竖屏:
            return 图像.rotate(radians: .pi*1.5)
        default:
            return 图像
        }
        
    }
    
}
