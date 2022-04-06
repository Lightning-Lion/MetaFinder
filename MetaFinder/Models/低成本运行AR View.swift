//
//  低成本运行AR View.swift
//  WorldMap
//
//  Created by mac on 2022/2/13.
//

import Foundation
//拍照改为截图
//修改自动保存为异步
//怎么不丢帧呢？提高优先等级，异步AR获取画面
//后台加载View
//变量改为lazy
//优化启动（每次不一样开屏，动态开屏）
//使用Reality而不是USDZ
import UIKit
import RealityKit
import ARKit
import SwiftUI
import RealmSwift
import Combine
import RKPointPin
import FocusEntity
import Drops

extension ViewController {
    
    func 缩放比例() {
        // Capture the default value after you initialize the view.
        let defaultScaleFactor = arView.contentScaleFactor

        // Scale as needed. For example, here the scale factor is
        // set to 75% of the default value.
        arView.contentScaleFactor = 0.75 * defaultScaleFactor
    }
    func 禁用特效() {
        arView.renderOptions.insert(.disableMotionBlur)
        arView.renderOptions.insert(.disableAREnvironmentLighting)
        arView.renderOptions.insert(.disableCameraGrain)
        arView.renderOptions.insert(.disableDepthOfField)
        arView.renderOptions.insert(.disableFaceMesh)
        arView.renderOptions.insert(.disableGroundingShadows)
        arView.renderOptions.insert(.disableHDR)
        arView.renderOptions.insert(.disableMotionBlur)
        arView.renderOptions.insert(.disablePersonOcclusion)
        
        // Turn on motion blur.
//        arView.renderOptions.remove(.disableMotionBlur)
    }
    // MARK: - “设置”
    func 显示调试面板() {
        arView.debugOptions.insert(.showStatistics)
        arView.debugOptions.insert(.showFeaturePoints)
    }
    func 关闭调试面板() {
        arView.debugOptions.remove([.showStatistics,.showFeaturePoints])
    }
    
}



