//
//  触感.swift
//  Experiment
//
//  Created by 凌嘉徽 on 2022/1/22.
//

import Foundation
import SwiftUI

func 轻触() {
#if os(watchOS)
    WKInterfaceDevice.current().play(.click)
#else
    UIImpactFeedbackGenerator.init(style: UIImpactFeedbackGenerator.FeedbackStyle.light).impactOccurred()
#endif
}

func 中等触感() {
#if os(watchOS)
    WKInterfaceDevice.current().play(.click)
#else
    UIImpactFeedbackGenerator.init(style: UIImpactFeedbackGenerator.FeedbackStyle.medium).impactOccurred()
#endif
}
func 成功触感() {
#if os(watchOS)
    WKInterfaceDevice.current().play(.success)
#else
    let notificationGenerator = UINotificationFeedbackGenerator()
    notificationGenerator.notificationOccurred(UINotificationFeedbackGenerator.FeedbackType.success)
#endif
}



func 失败触感() {
#if os(watchOS)
    WKInterfaceDevice.current().play(.failure)
#else
    let notificationGenerator = UINotificationFeedbackGenerator()
    notificationGenerator.notificationOccurred(UINotificationFeedbackGenerator.FeedbackType.error)
#endif
}
