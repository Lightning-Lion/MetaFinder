//
//  URL与String互转.swift
//  WorldMap
//
//  Created by 凌嘉徽 on 2022/2/2.
//

import Foundation

extension URL {
    var 转换为String : String {
        return self.path
    }
    
}

extension String {
    var 转换为URL : URL {
        return URL(fileURLWithPath: self)
    }
}
