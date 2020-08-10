//
//  AppDelegateDataExt.swift
//  Chainup
//
//  Created by zewu wang on 2018/10/18.
//  Copyright © 2018年 zewu wang. All rights reserved.
//

import UIKit

class  AppDelegateData : NSObject{
    
    var timer : Timer?
    //获取汇率
    func getRate(){
        let server = EXNetworkDoctor.sharedManager.getAppAPIHost()
        timer = Timer.init(timeInterval: 60, repeats: true, block: {(timer) in
            let param = NetManager.sharedInstance.handleParamter()
            let url = NetManager.sharedInstance.url(server, model: NetDefine.common, action: NetDefine.rate)
            NetManager.sharedInstance.sendRequest(url, parameters: param, isShowLoading : false, success: { (result , response, nil) in


                if let result = result as? [String : Any]{
                    if let data = result["data"] as? [String : Any]{
                        if let rate = data["rate"] as? [String : [String : Any]]{
                            PublicInfoManager.sharedInstance.setAllCoinExchangeRate(rate)
                        }
                    }
                }
                
            }) { (state, error, nil) in
                
            }
        })
        RunLoop.main.add(timer!, forMode: RunLoopMode.commonModes)
    }
    
}
