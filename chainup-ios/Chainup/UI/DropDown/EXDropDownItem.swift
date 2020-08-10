//
//  EXDropDownItem.swift
//  Chainup
//
//  Created by liuxuan on 2019/3/14.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import UIKit

enum DropDownSectionType: Int {
    case inputStyle // 通栏的输入
    case btnSelectionStyle // 按钮选择
    case btnExpandStyle // 可展开的按钮选择
    case dateStyle // 日期
    case switchStyle // 开关
    case inputExpandMixStyle// 选择和输入的综合 ？？ 待定
}


class EXDropDownItem: NSObject {
    var key:String = ""
    var title:String = ""
    var select:String = ""
}

public struct DropDownSection {
    var sectionTitle: String
    var sectionType: DropDownSectionType
    var items: [EXDropDownItem]
    
    init (sectionTitle: String,type:DropDownSectionType, items: [EXDropDownItem]) {
        self.items = items
        self.sectionTitle = sectionTitle
        self.sectionType = type
    }
}
