//
//  StoryBoardLoadable.swift
//  Chainup
//
//  Created by liuxuan on 2019/1/11.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import Foundation

let StoryBoardNameMarket = "Market"
let StoryBoardNameOTC = "EXOTC"
let StoryBoardNameAsset = "EXAssets"

protocol StoryBoardLoadable {
    
}

extension StoryBoardLoadable {
    static func instanceFromStoryboard(name:String) -> Self {
        //identifier 为类名，在stoyboard里配置
        let identifier = String(describing:self)
        return UIStoryboard.init(name: name, bundle: nil).instantiateViewController(withIdentifier: identifier) as! Self
    }
}


