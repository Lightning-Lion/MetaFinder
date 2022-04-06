import UIKit
import RealityKit
import ARKit
import SwiftUI
import RealmSwift
import Combine
import RKPointPin
import FocusEntity
import AVKit

var 当前地图系列UUID = ObjectId()

func 更新地图名称()  {
    let AR页 = keyWindow?.rootViewController as? ViewController
    DispatchQueue.main.asyncAfter(deadline: .now()) {
        AR页?.观察模型.名称 = 通过ID查找地图系列(当前地图系列UUID)?.Name_Of_The_Series ?? "无"
    }
}

// MARK: - Allows
var 不在回忆 = true
var Allow保存 = false
var Allow拍照 = false



class ViewController: UIViewController,AVPlayerViewControllerDelegate {
    
    // MARK: - IBOutlet
    @IBOutlet var arView: ARView!
    @IBOutlet weak var 面板: UIVisualEffectView!
    @IBOutlet weak var 跟踪状态文本: UILabel!
    
    // MARK: - 变量
    
    let realm = try! Realm(configuration: Realm.Configuration(
        schemaVersion: 当前Realm数据库版本))//在第一个加载realm时，需要指定版本
    var 地图URL = "地图URL"
    let 箭头 = try! Entity.load(named: "箭头")
    let rkPin = RKPointPin()
    
    var 物品 : Entity = .init()///􀙚
    var 锚 : Entity = .init()
    var subscriptions = Set<AnyCancellable>()
    
    let coachingOverlay = ARCoachingOverlayView()
    
    var Grid页 = UIHostingController(rootView: MyGrid())
    
    // MARK: - 当前地图信息显示􀎪
    @IBOutlet weak var 当前地图UIView: UIView!
    var 观察模型 = 地图名称(名称: "无")
    
    // MARK: - 生命周期
    //最开始加载视图的一个方法
    override func loadView() {
        super.loadView()
        printLog()
        
        //被要求保存地图
        NotificationCenter.default.addObserver(self, selector:#selector(被要求保存地图(info:)), name:NSNotification.Name(rawValue:被要求保存地图通知名称), object:nil)
        
        //（用于主动更新）被要求保存地图+显示更新提示
        NotificationCenter.default.addObserver(self, selector:#selector(主动更新地图(info:)), name:NSNotification.Name(rawValue:主动更新地图通知名称), object:nil)
        
        
        //接收地图UUID，加载地图
        NotificationCenter.default.addObserver(self, selector:#selector(收到世界地图的UUID(info:)), name:NSNotification.Name(rawValue:地图UUID通知名称), object:nil)
        
        //接收地图网址，加载地图
        NotificationCenter.default.addObserver(self, selector:#selector(收到世界地图的URL(info:)), name:NSNotification.Name(rawValue:地图URL), object:nil)
        
        //接受选中的物品
        NotificationCenter.default.addObserver(self, selector:#selector(收到物品ObjectID(info:)), name:NSNotification.Name(rawValue:收到物品ObID的通知), object:nil)
        
        //􀫮更新AR场景中的Anchor
        NotificationCenter.default.addObserver(self, selector:#selector(更新AR场景中的Anchor(info:)), name:NSNotification.Name(rawValue:更新AR场景中的Anchor通知名称), object:nil)
        
        //􀫮更新AR场景中的Anchor
        NotificationCenter.default.addObserver(self, selector:#selector(更新方向标状态(info: )), name:NSNotification.Name(rawValue:更新方向标状态通知名称), object:nil)
    }
    
    //视图已经加载完成   这个也是我们常用的生命周期的方法，我们可以在这里面做创建视图，网络请求等操作
    override func viewDidLoad() {
        super.viewDidLoad()
        printLog()
        初始化1()
        
    }
    func 自动加载最近一张地图() {
        @AppStorage("打开直接加载最近一张地图") var 打开直接加载最近一张地图 = false
        let 数据 = 打开直接加载最近一张地图
        print(数据)
        if 数据 {
            do {
                let realm = try Realm()
                let 获取到的对象 = realm.objects(A_Map_Series.self)
                if let 地图 = 获取到的对象.sorted(byKeyPath: "Updated_Date", ascending: false).first {
                    let 唯一标识符 = 地图._id
                    LoadingModel.加载地图(唯一标识符)
                    提示("正在自动加载最近使用过的一张地图",Debug: "你可以去设置中禁用",systemName: "tray.and.arrow.up.fill")
                } else {
                    
                }
            } catch {
                提示(error.localizedDescription)
                
            }
        }
        
    }
    func 初始化1() {
        
        
        //设置UI
        NotificationCenter.default.addObserver(self, selector:#selector(UI界面方向改变(info:)), name:.UI界面旋转了, object:nil)
        //配置AR会话
        arView.session.delegate = self//设置代理
        
        setupCoachingOverlay()//􀒪
        
        arView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(识别到触摸(recognizer:))))
        
        Task(priority: .userInitiated) {
            //
            //下面的东西自动完成根本检查不出来
            @ObservedResults(MapShell.self) var 地图的壳
            
            //避免未初始化
            if 地图的壳.first == nil {
                $地图的壳.append(MapShell())
            }
            let 套接地图 = 地图的壳.first!
            @ObservedRealmObject var 地图: MapShell = 套接地图
            //⚠️危险
            if let 地图1 = 地图.items.last {
                if let 地图 = await 获取地图(UUID: 地图1._id) {
                    提示("正在尝试加载最新一张地图")
                    try await 通过世界地图运行会话(世界地图: 地图)
                } else {
                    提示("未能自动加载最近的一张地图")
                }
            }
            
            
        }
        Task(priority: .utility, operation: {
            rkPin.focusPercentage = 0
            arView.addSubview(rkPin)
        })
        
        //􀎪
        添加左上角窗口()
        添加悬浮球()
    }
    //视图将要出现调用
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        printLog()
    }
    
    //FirstLaunch
    @AppStorage("Shall") var 弹吗？ = false
    //可以弹出新VC
    //将要布局子视图调用
    var 当前尺寸 = CGRect()
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        移动悬浮球()
        
        if view.frame != 当前尺寸 {
            当前尺寸 = view.frame
            更新位置()
            printLog("更新中心点")
        }
        
    }
    //    let SwiftUI内容 = UIHostingController(rootView: 当前地图View(观察模型: 观察模型))
    var SwiftUI视图 = UIView()
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if !正在手势 {
            移动悬浮球()
        }
    }
    @IBOutlet weak var 覆层: UIView!
    
    //视图已经出现
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if 弹吗？ {
            弹吗？ = false
            let 控制器 = UIHostingController(rootView: EnterPage())
            控制器.modalPresentationStyle = .overFullScreen
            控制器.modalTransitionStyle = .crossDissolve
            present(控制器, animated: true, completion: nil)
        }
        Task(priority: .utility) {
            setupApperance()
        }
        //        let 子视图 = UIImageView.init(image: UIImage(systemName: "arrow.up.and.down.and.arrow.left.and.right"))
        //        子视图.frame = .init(x: 0, y: 0, width: 画中画视图.frame.width/sqrt(3), height: 画中画视图.frame.height/sqrt(3))
        //        子视图.contentMode = .scaleAspectFill
        //        子视图.center = .init(x: 画中画视图.frame.width/2, y: 画中画视图.frame.height/2)
        DispatchQueue.main.asyncAfter(deadline: .now()) { [self] in
            画中画视图.layer.name = "4"
            画中画视图.center = 锚点坐标集[4]
            //            self.画中画视图.addSubview(子视图)
            
        }
        UIApplication.shared.isIdleTimerDisabled = true
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            let animator = UIViewPropertyAnimator()
            animator.addAnimations {
                self.画中画视图.alpha = 1
            }
            animator.startAnimation()
            self.锚点视图集.forEach({ item in
                item.alpha = 0
            })
            self.SwiftUI视图.alpha = 0
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            UIView.animate(withDuration: 0.15, animations: {  self.覆层.alpha = 0})
        }
        
        //开屏自动显示锚点
        //        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
        //            UIView.animate(withDuration: 0.3, animations: {self.锚点视图集.forEach({ item in
        //                item.alpha = 0
        //            })})
        //        }
        
        printLog()
        Grid页.loadViewIfNeeded()
        检查错误报告()
        
        //计划任务
        DispatchTimer(timeInterval: 30, repeatCount: .max) { (timer, count) in
            self.自动保存()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 30/2) { [self] in
            DispatchTimer(timeInterval: 30, repeatCount: .max) { (timer, count) in
                self.自动截图()
            }
        }
        
        Task(priority: .medium) {
            setupApperance()
        }
        
        缩放比例()
        禁用特效()
        自动加载最近一张地图()
        
    }
    
    //视图将要消失
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        printLog()
        
    }
    
    //视图已经消失
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        printLog()
        
    }
    
    
    // MARK: - 交互
    @IBAction func 保存世界地图(_ sender: Any) {
        Task {
            await 保存世界地图(显示更新提示吗？: true)
        }
    }
    @IBAction func 加载世界地图(_ sender: Any) {
        读取世界地图()
    }
    @IBAction func 弹出页面(_ sender: Any) {
        let 页面 = UIHostingController(rootView: 搜索View的壳())//在APP加载时会保证groups会有一项
        show(页面, sender: nil)
    }
    @IBAction func 弹出地图选择器(_ sender: Any) {
        let 页面 = UIHostingController(rootView: 地图View的壳())
        
        show(页面, sender: nil)
    }
    @IBAction func 弹出Grid页(_ sender: Any) {
        let 页面 = Grid页
        show(页面, sender: nil)
    }
    @IBAction func 手动重启会话(_ sender: Any) {
        重启会话()
    }
    @IBAction func 看我(_ sender: Any) {
        报错()
        //        看我(物品: 物品, 锚: 锚)///􀙚
    }
    
    var focusEntity: FocusEntity?
    
    @IBAction func 开启(_ sender: Any) {
        self.focusEntity = FocusEntity(on: arView, focus: .classic)
        //        let focusSquare = FocusEntity(on: self.arView, focus: .classic)
    }
    @IBAction func 关闭(_ sender: Any) {
        self.focusEntity?.destroy()
    }
    
    @IBAction func 添加图片(_ sender: Any) {
        自动截图()
    }
    
    
    // MARK: - 悬浮球
    var 画中画视图 = UIView()
    let 控制器 = UIHostingController(rootView: 悬浮球())
    
    var 锚点视图集 = [UIView]()
    
    let panRecognizer = UIPanGestureRecognizer()
    
    var 锚点坐标集: [CGPoint] {
        return 锚点视图集.map { $0.center }
    }
    
    //默认：86
    let 小窗口宽度: CGFloat = 86
    //默认：130
    let 小窗口高度: CGFloat = 86
    
    let horizontalSpacing: CGFloat = 23
    let verticalSpacing: CGFloat = 25
    
    
    var 中心视图 : UIView = .init()
    var initialOffset: CGPoint = .zero
    var 正在手势 = false
    
    // MARK: - 结束
    var 操作对象1 : A_Object? = nil
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        
        
    }
    
    func playerViewController(_ playerViewController: AVPlayerViewController,
                              restoreUserInterfaceForPictureInPictureStopWithCompletionHandler completionHandler: @escaping (Bool) -> Void) {
        安全弹窗(基: self, 弹窗: playerViewController,动画:false,闭包:{ })
        completionHandler(true)
    }
    
}
