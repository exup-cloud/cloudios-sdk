//
//  HomeFunctionEntity.swift
//  Chainup
//
//  Created by zewu wang on 2018/11/19.
//  Copyright © 2018 zewu wang. All rights reserved.
//

import UIKit

class HomeFunctionEntity: SuperEntity {

    var type = ""//0.webView 1.coinmap_market 行情 2.coinmap_trading 币对交易页 3.coinmap_details 币对详情页 4.otc_buy 场外交易-购买 5.otc_sell 场外交易-出售 6.order_record 订单记录 7.account_transfer 账户划转 8.otc_account 资产-场外账户 9.coin_account 资产-币币账户 10.safe_set 安全设置 11.safe_money 安全设置-资金密码 12.personal_information 个人资料 13.personal_invitation 个人资料-邀请码 14.collection_way 收款方式 15.real_name 实名认证
    
    var id = ""//
    
    var title = "测试测试测试测试测试"//
    
    var subhead = "测试测试测试测试测试测试测试测试测试测试测试"//
    
    var lang = ""//语言
    
    var httpUrl = ""//http链接
    
    var imageUrl = ""//图片地址
    
    var sort = 0//排序
    
    var nativeUrl = ""//原生路由
    
    override func setEntityWithDict(_ dict: [String : Any]) {
        super.setEntityWithDict(dict)
        id = dictContains("id")
        type = dictContains("type")
        title = dictContains("title")
        subhead = dictContains("subhead")
        lang = dictContains("lang")
        httpUrl = dictContains("httpUrl")
        if let s = Int(dictContains("sort")){
            sort = s
        }
        imageUrl = dictContains("imageUrl")
        nativeUrl = dictContains("nativeUrl")
        
    }
    
}


