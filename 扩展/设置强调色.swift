//
//  设置强调色.swift
//  WorldMap
//
//  Created by 凌嘉徽 on 2022/2/4.
//

import Foundation
import UIKit
func setupApperance() {
    var MyColor = UIColor.tintColor
    
    UINavigationBar.appearance().largeTitleTextAttributes = [
        NSAttributedString.Key.foregroundColor: MyColor]
    
    UINavigationBar.appearance().titleTextAttributes = [
        NSAttributedString.Key.foregroundColor: MyColor]
    
    UIBarButtonItem.appearance().setTitleTextAttributes([
        NSAttributedString.Key.foregroundColor: MyColor], for: .normal)
    
    UIWindow.appearance().tintColor = UIColor.cyan
}
