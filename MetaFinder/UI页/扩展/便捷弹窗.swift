//
//  便捷弹窗.swift
//  WorldMap
//
//  Created by 凌嘉徽 on 2022/1/31.
//

import SwiftUI

struct 便捷导航<Content: View,Content1: View>: View {
    @ViewBuilder var 内容: Content
    @ViewBuilder var 跳转页面: Content1
    
    var body: some View {
        
        Button(action: {
            printLog()
            tapped.toggle()}) {
                内容
            }
            .sheet(isPresented: $tapped, onDismiss: nil, content: {跳转页面})
    }
    @State private var tapped = false
}


