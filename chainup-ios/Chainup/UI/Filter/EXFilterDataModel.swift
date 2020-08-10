//
//  EXFilterDataModel.swift
//  Chainup
//
//  Created by liuxuan on 2019/4/3.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import UIKit

enum EXFoldItemType:String {
    case all = "ALL"
    case forceAll = "ForceALL"
}

class EXFilterItem:NSObject {
    @objc var valueKey:String = ""
    @objc var text:String = ""//按钮的文字，用于fold类型
    @objc var isSelected:Bool = false //按钮的选中状态，用于fold类型，只单选
    @objc var inputPlaceHolder:String = ""//输入框的内容提示，也用于一半输入、一半选择的右边内容区
    @objc var unit:String = ""//输入框单位,有的输入框里有
    
    static func getItem(titles:[String],valueKeys:[String]) -> [EXFilterItem]{
        var items:[EXFilterItem] = []
        if titles.count == valueKeys.count {
            for (idx,title) in titles.enumerated() {
                let item = EXFilterItem()
                item.text = title
                item.valueKey = valueKeys[idx]
                items.append(item)
            }
        }
        return items
    }
}

class EXFilterDataModel: NSObject {
    @objc var leftKey:String = ""// 筛选项 key,1个默认用leftkey
    @objc var rightKey:String = ""//第二个 key
    @objc var title:String = ""//cell title
    @objc var filterType:AppFilterStyle = .input
    @objc var keyBoardType:UIKeyboardType = .default
    @objc var items:[EXFilterItem] = []
    @objc var extraItems:[EXFilterItem] = [] //mix
    var forceFilterItem :Bool = false

    static func getSwitchModel(key:String,
                        title:String) ->EXFilterDataModel {
        let model = EXFilterDataModel()
        model.leftKey = key
        model.title = title
        model.filterType = .onoff
        return model
    }
    
    static func getInputModel(key:String,
                     title:String,
                     placeHolder:String,
                     unit:String?,
                     keyBoardType:UIKeyboardType = .default) ->EXFilterDataModel {
        let model = EXFilterDataModel()
        model.leftKey = key
        model.title = title
        model.filterType = .input
        model.keyBoardType = keyBoardType
        let item = EXFilterItem()
        item.inputPlaceHolder = placeHolder.localized()
        item.valueKey = key
        item.unit = unit ?? ""
        model.items = [item]
        return model
    }
    
    static func getSelectionModel(key:String,
                        title:String,
                        placeHolder:String) ->EXFilterDataModel {
        let model = EXFilterDataModel()
        model.leftKey = key
        model.title = title
        model.filterType = .selection
        let item = EXFilterItem()
        item.inputPlaceHolder = placeHolder.localized()
        item.valueKey = key
        model.items = [item]
        return model
    }
    
    static func getMixModel(title:String,
                     leftKey:String,
                     rightKey:String,
                     leftplaceHolder:String,
                     rightItems:[EXFilterItem]) -> EXFilterDataModel {
        let model = EXFilterDataModel()
        model.title = title
        model.filterType = .mix
        model.leftKey = leftKey
        model.rightKey = rightKey
        
        let leftItem = EXFilterItem()
        leftItem.inputPlaceHolder = leftplaceHolder.localized()
        
        model.items = [leftItem]
        model.extraItems = rightItems
        return model
    }
    
    
    static func getDateModel(beginDateKey:String,
                      endDateKey:String,
                      title:String) ->EXFilterDataModel {
        let model = EXFilterDataModel()
        model.leftKey = beginDateKey
        model.rightKey = endDateKey
        
        model.title = title
        model.filterType = .date
        let item = EXFilterItem()
        item.inputPlaceHolder = "filter_date_start".localized()
        item.valueKey = beginDateKey

        let itemend = EXFilterItem()
        itemend.inputPlaceHolder = "filter_date_end".localized()
        itemend.valueKey = endDateKey
        model.items = [item]
        model.extraItems = [itemend]
        return model
    }
    
    static func getFoldModel(key:String,
                     title:String,
                     contents:[EXFilterItem],
                     selectedIdx:Int = 0) -> EXFilterDataModel {
        let model = EXFilterDataModel()
        model.leftKey = key
        model.title = title
        model.filterType = .fold
        model.items = contents
        return model
    }
}
