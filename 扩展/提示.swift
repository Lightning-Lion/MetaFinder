//
//  提示.swift
//  WorldMap
//
//  Created by 凌嘉徽 on 2022/1/28.
//


import Drops
import SwiftUI



func 模板() {
    let drop = Drop(
        title: "Title",
        subtitle: "Subtitle",
        icon: UIImage(systemName: "star.fill"),
        action: .init {
            print("Drop tapped")
            Drops.hideCurrent()
        },
        position: .bottom,
        duration: 5.0,
        accessibility: "Alert: Title, Subtitle"
    )
    Drops.show(drop)
}

func DebugLog(_ 文本 : String?) {
    if let 文本 = 文本 {
        提示(文本)
    } else {
        提示("nil")
    }
}

func 提示(_ 文本 : String? = nil,Debug : String? =  nil,systemName:String? = nil) {
    DispatchQueue.main.async {

    
    if IsDebug {
        if let 文本 = 文本 {
            if let 副标题  = Debug {
                //有副标题
                let 图标 = UIImage(systemName: systemName ?? "")//可能为nil
                let 一条消息 = Drop(title: 文本,subtitle: 副标题,icon: 图标)
                Drops.show(一条消息)
            } else {
                //和下面一样
                let 一条消息 = Drop(title: 文本)
                Drops.show(一条消息)
            }
        } else {
            if let 副标题  = Debug {
                           //有副标题
                           let 一条消息 = Drop(title: 副标题)
                           Drops.show(一条消息)
                       }
        }
        
        
    } else {
        if let 文本 = 文本 {
        //和上面一样
        let 一条消息 = Drop(title: 文本)
        Drops.show(一条消息)
        } else {
            print("这是一条Debug消息：\(文本)\(Debug)")
        }
    }
    }
}
