//
//  坐标.swift
//  MetaFinder
//
//  Created by 凌嘉徽 on 2022/1/27.
//

import UIKit
import RealityKit
import ARKit

extension simd_float4x4 {
    
    ///自定义转化
    var Position : SIMD3<Float> {
        let 位置 = self.columns.3
        return .init(x: 位置.x, y: 位置.y, z: 位置.z)
    }
    
    
    
}

extension ViewController {
    /**
     - Tag: ToRandomColor
     Pseudo-randomly return one of several fixed standard colors, based on this UUID's first four bytes.
     */
    func toRandomColor() -> UIColor {
        let firstFourUUIDBytesAsUInt32 = arc4random() % (100) + 0
        
        let colors: [UIColor] = [.red, .green, .blue, .yellow, .magenta, .cyan, .purple,
                                 .orange, .brown, .lightGray, .gray, .darkGray, .black, .white]
        
        let randomNumber = Int(firstFourUUIDBytesAsUInt32) % colors.count
        return colors[randomNumber]
    }
}
