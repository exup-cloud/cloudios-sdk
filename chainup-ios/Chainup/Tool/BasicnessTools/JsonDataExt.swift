//
//  JsonDataExt.swift
//  Chainup
//
//  Created by zewu wang on 2018/8/31.
//  Copyright © 2018年 zewu wang. All rights reserved.
//

import UIKit

extension JSONSerialization{
    
    //将字典转成json字符串
    class func jsonDataFromDictToString(_ dict : [String : Any]) -> String{
        do{
            let jsonData = try JSONSerialization.data(withJSONObject: dict, options: JSONSerialization.WritingOptions.prettyPrinted)
            if let jsonStr = String.init(data: jsonData, encoding: String.Encoding.utf8){
                return jsonStr
            }
        }catch _ {
            
        }
        return ""
    }
    
}
