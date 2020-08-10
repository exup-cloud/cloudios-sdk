//
//  TabbarModel.swift
//  Chainup
//
//  Created by zewu wang on 2019/8/28.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import UIKit

class TabbarModel: NSObject {

    var localTitle = ""
    
    var localDefaultIcon = ""
    
    var localSelectIcon = ""
    
    var onlineTitle = ""
    
    var onlineDefaultIcon = ""
    
    var onlineSelectIcon = ""
    
}

class TabbarModels : NSObject{
    
    let onlineIcon = PublicInfoEntity.sharedInstance.app_personal_icon
    
    lazy var homeModel : TabbarModel = {//首页
        let model = TabbarModel()
        model.localTitle = "mainTab_text_home".localized()
        model.localDefaultIcon = "tabbar_home_default"
        model.localSelectIcon = "tabbar_home_selected"
        model.onlineTitle = PublicInfoManager.sharedInstance.getAppTitles().home
        model.onlineDefaultIcon = EXThemeManager.isNight() == true ? onlineIcon.tabbar_home_default_night : onlineIcon.tabbar_home_default_daytime
        model.onlineSelectIcon = onlineIcon.tabbar_home_selected
        return model
    }()
    
    lazy var quotesModel : TabbarModel = {//行情
        let model = TabbarModel()
        model.localTitle = "mainTab_text_market".localized()
        model.localDefaultIcon = "tabbar_quotes_default"
        model.localSelectIcon = "tabbar_quotes_selected"
        model.onlineTitle = PublicInfoManager.sharedInstance.getAppTitles().quotes
        model.onlineDefaultIcon = EXThemeManager.isNight() == true ? onlineIcon.tabbar_quotes_default_night : onlineIcon.tabbar_quotes_default_daytime
        model.onlineSelectIcon = onlineIcon.tabbar_quotes_selected
        return model
    }()
    
    lazy var exModel : TabbarModel = {//交易页面
        let model = TabbarModel()
        model.localTitle = "assets_action_transaction".localized()
        model.localDefaultIcon = "tabbar_exchange_default"
        model.localSelectIcon = "tabbar_exchange_selected"
        model.onlineTitle = PublicInfoManager.sharedInstance.getAppTitles().exchange
        model.onlineDefaultIcon = EXThemeManager.isNight() == true ? onlineIcon.tabbar_exchange_default_night : onlineIcon.tabbar_exchange_default_daytime
        model.onlineSelectIcon = onlineIcon.tabbar_exchange_selected
        return model
    }()
    
    lazy var assetModel : TabbarModel = {//资产
        let model = TabbarModel()
        model.localTitle = "mainTab_text_assets".localized()
        model.localDefaultIcon = "tabbar_assets_default"
        model.localSelectIcon = "tabbar_assets_selected"
        model.onlineTitle = PublicInfoManager.sharedInstance.getAppTitles().assets
        model.onlineDefaultIcon = EXThemeManager.isNight() == true ? onlineIcon.tabbar_assets_default_night : onlineIcon.tabbar_assets_default_daytime
        model.onlineSelectIcon = onlineIcon.tabbar_assets_selected
        return model
    }()
    
    lazy var fiatModel : TabbarModel = {//otc
        let model = TabbarModel()
        if PublicInfoManager.sharedInstance.getFiatTradeOpen(){
            model.localTitle = "mainTab_text_otc_forotc".localized()
        }else{
            model.localTitle = "mainTab_text_otc".localized()
        }
        model.localDefaultIcon = "tabbar_fiat_default"
        model.localSelectIcon = "tabbar_fiat_selected"
        model.onlineTitle = PublicInfoManager.sharedInstance.getAppTitles().fiat
        model.onlineDefaultIcon = EXThemeManager.isNight() == true ? onlineIcon.tabbar_fiat_default_night : onlineIcon.tabbar_fiat_default_daytime
        model.onlineSelectIcon = onlineIcon.tabbar_fiat_selected
        return model
    }()
    
    lazy var contractModel : TabbarModel = {//合约
        let model = TabbarModel()
        model.localTitle = "mainTab_text_contract".localized()
        model.localDefaultIcon = "tabbar_contract_default"
        model.localSelectIcon = "tabbar_contract_selected"
        model.onlineTitle = PublicInfoManager.sharedInstance.getAppTitles().contract
        model.onlineDefaultIcon = EXThemeManager.isNight() == true ? onlineIcon.tabbar_contract_default_night : onlineIcon.tabbar_contract_default_daytime
        model.onlineSelectIcon = onlineIcon.tabbar_contract_selected
        return model
    }()
    
}
