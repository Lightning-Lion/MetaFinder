//
//  导航.swift
//  WorldMap
//
//  Created by mac on 2022/2/14.
//

import Foundation
import UIKit

func 关闭初级弹窗() {
    keyWindow?.rootViewController?.presentedViewController?.dismiss(animated: true, completion: nil)
}
