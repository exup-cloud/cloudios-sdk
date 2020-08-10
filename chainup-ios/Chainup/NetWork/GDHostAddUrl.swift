//
//  GDHostAddUrl.swift
//  Chainup
//
//  Created by cong.lian on 2020/3/23.
//  Copyright © 2020 zewu wang. All rights reserved.
//

import UIKit

class GDHostAddUrl: NSObject {

    // host
    // 测试static let selfhttp_host_url = "https://chainupapi.1trade.vip"
    static let selfhttp_host_url = "https://chainupapi.1trade.vip"
    // pro
    static let http_host_url = NetDefine.http_host_url + "out/follow"
    // 链上
    static let kol_list =  http_host_url+"/chainup/kol/list"//kol列表
    
    static let api_options_url = http_host_url+"/chainup/follow/options"//
    
    static let follow_info_url = http_host_url+"/chainup/follow/profit"//跟单头部
    
    static let follow_list_url = http_host_url+"/chainup/follow/list"//跟单列表

    static let follow_detail_url = http_host_url+"/chainup/follow/detail"//跟单详情
    
    static let follow_share_url =  http_host_url+"/chainup/follow/share"//分享
    
    static let follow_trend_url =  http_host_url+"/chainup/follow/trend"//收益走势
    
    // self
    
    static let api_kolStyle_url = selfhttp_host_url+"/api/kol/style"//风格列表
    
    static let api_Kolcoinlist_url = selfhttp_host_url+"/api/kol/currencylist"//风格列表

    static let api_livelist_url = selfhttp_host_url+"/api/live/apilist"//实盘列表

    static let api_liveinfo_url = selfhttp_host_url+"/api/live/info"//实盘列表

    static let kol_info =  selfhttp_host_url+"/api/kol/info"//用户信息
    
    static let follow_usdt_url =  selfhttp_host_url+"/api/follow/usdt"//转-ustd
    
    static let common_dialog_url =  selfhttp_host_url+"/api/common/dialog"//弹框
    
    static let rsa_publicKey_url =  selfhttp_host_url+"/api/rsa/publicKey"//key

    
}
