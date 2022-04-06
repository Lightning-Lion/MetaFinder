import SwiftUI
import AVKit
func 从主包返回URL(文件名:String,严格匹配的扩展名:String?) throws -> URL {
    if let path = Bundle.main.url(forResource: 文件名, withExtension: 严格匹配的扩展名)
    {
        return path
    } else {
        throw 错误.消息(message: "找不到文件")
    }
}
enum 错误: LocalizedError {
    
    case 消息(message: String)
    
    public var errorDescription: String? {
        switch self {
        case .消息(message: let message):
            return "抛出异常：\(message)"
        }
    }
    
}
struct CustomVideoPlayer: UIViewControllerRepresentable {
    
    let 视频URL:URL
    
    
    let delegate = Manager()
    
    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let uiViewController = AVPlayerViewController()
        let url = 视频URL
        let player1 = AVPlayer(url: url)
        uiViewController.player = player1
        uiViewController.entersFullScreenWhenPlaybackBegins = true
        uiViewController.exitsFullScreenWhenPlaybackEnds = true
        uiViewController.delegate = delegate
        return uiViewController
    }
    
    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {
        
    }
}
class Manager: NSObject, AVPlayerViewControllerDelegate {
    

    // MARK: - 画中画部分
    //即将开始
    func playerViewControllerWillStartPictureInPicture(_ playerViewController: AVPlayerViewController) {
        
    }
    
    //启动失败
    func playerViewController(_ playerViewController: AVPlayerViewController,
                              failedToStartPictureInPictureWithError error: Error) {
        
    }
    
    //正式开始
    func playerViewControllerDidStartPictureInPicture(_ playerViewController: AVPlayerViewController) {
        
    }
    
    //即将停止
    func playerViewControllerWillStopPictureInPicture(_ playerViewController: AVPlayerViewController) {
        
    }
    
    //正式停止
    func playerViewControllerDidStopPictureInPicture(_ playerViewController: AVPlayerViewController) {
        
    }
    
    //画中画被关闭，要求恢复界面：弹窗PlayerVC，不要带动画
    func playerViewController(_ playerViewController: AVPlayerViewController,
                              restoreUserInterfaceForPictureInPictureStopWithCompletionHandler completionHandler: @escaping (Bool) -> Void) {
        completionHandler(true)
    }

    

    // MARK: - 全屏部分
    //退出全屏的动画
    func playerViewController(_ playerViewController: AVPlayerViewController, willEndFullScreenPresentationWithAnimationCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        
        let player = playerViewController.player
        let 获取播放状态 = player?.isPlaying ?? true
        
        if 获取播放状态 {
            player?.play()
        }
        
        // The system pauses when returning from full screen, we need to 'resume' manually.
        coordinator.animate(alongsideTransition: nil) { transitionContext in
            if 获取播放状态 {
                player?.play()
            }
        }
    }
    
    //正式退出全屏
    func playerViewControllerRestoreUserInterfaceForFullScreenExit(_ playerViewController: AVPlayerViewController) async -> Bool {
        return true
    }

}
extension AVPlayer {
    var isPlaying: Bool {
        return rate != 0 && error == nil
    }
}
