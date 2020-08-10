//
//  EXCustomConfigVm.swift
//  Chainup
//
//  Created by liuxuan on 2020/4/1.
//  Copyright © 2020 zewu wang. All rights reserved.
//

import UIKit
import RxSwift

enum EXHomeFunctionDirection {
    case horizontal
    case vertical
}

class EXCustomConfigVm: NSObject {
    
    var customModel:EXCustomConfigModel = EXCustomConfigModel()
    let disposeBag = DisposeBag()

    
    class func shared() -> EXCustomConfigVm {
        return sharedConfig
    }
    
    private static var sharedConfig: EXCustomConfigVm = {
        let configManager = EXCustomConfigVm()
        if let cfgModel = EXCustomConfigModel.mj_object(withKeyValues: XUserDefault.getHomeCustomConfig()) {
            configManager.customModel  = cfgModel
        }
        return configManager
    }()
    
    func registerCustomConfig() {
        //收到接口返回成功的通知
        PublicInfo.sharedInstance.subject.asObserver().subscribe {[weak self] (event) in
            if let e = event.element , e == 1{
                guard let mySelf = self else{return}
                mySelf.updateConfig()
            }
        }.disposed(by: disposeBag)
    }
    
    private func updateConfig() {
        let cfgStr = PublicInfoManager.sharedInstance.customConfig()
        if let cfgModel = EXCustomConfigModel.mj_object(withKeyValues: cfgStr) {
            self.customModel = cfgModel
            XUserDefault.setValueForKey(cfgStr, key:XUserDefault.homeCustomConfig)
        }
    }
    
    func showAccountUI() -> Bool  {
        if self.customModel.appIndex_assets_open == "0" {
            return false
        }
        return true
    }
    
    func customAds() -> [EXAdItem] {
        return self.customModel.appIndex_ad
    }
    
    func homeFunctionDirection() -> EXHomeFunctionDirection {
        if self.customModel.home_tool_vertical == "0" {
            return .horizontal
        }
        return .vertical
    }
}
