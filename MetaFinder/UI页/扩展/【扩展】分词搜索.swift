//
//  File.swift
//  MySearchPage
//
//  Created by 凌嘉徽 on 2022/1/31.
//

import Foundation
import NaturalLanguage
func 分词(sentence: String) -> [String] {
    var 结果 : [String] = []
    
    //使用"单词"单位初始化令牌生成器
    let tokenizer = NLTokenizer(unit: .word)
    //设置要处理的字符串
    tokenizer.string = sentence
    //循环所有令牌并打印它们
    tokenizer.enumerateTokens(in: sentence.startIndex..<sentence.endIndex) { tokenRange, _ in
        print(sentence[tokenRange])
        let 子字符串 = sentence[tokenRange]
        let ToString = String(子字符串)
        
        结果.append(ToString)
        return true
    }
    return 结果
}

extension 新物品View {
    func 要不要这项(项目:String,词:[String]) -> Bool {
        var 要不要 = false
        for 每个 in 词 {
            if 项目.contains(每个) {
                要不要 = true
                break
            }
        }
        return 要不要
    }
}

extension 搜索页面View {
    func 要不要这项(项目:String,词:[String]) -> Bool {
        var 要不要 = false
        for 每个 in 词 {
            if 项目.contains(每个) {
                要不要 = true
                break
            }
        }
        return 要不要
    }
}

