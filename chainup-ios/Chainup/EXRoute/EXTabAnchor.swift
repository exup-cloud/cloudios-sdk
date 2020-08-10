//
//  EXTabAnchor.swift
//  Chainup
//
//  Created by liuxuan on 2020/5/25.
//  Copyright © 2020 zewu wang. All rights reserved.
//

import UIKit

enum EXTabAnchorType {
    case exMarket
    case slContract
    case exOtc
    case exAsset
    case exHome
    case exTransaction
}

//这个只处理

class EXTabAnchor{
    
    var currentViewController:UIViewController?
    
    static let `manager` = EXTabAnchor()
    open class var shared: EXTabAnchor {
        return manager
    }
    
    func tabAnchorTo(_ type:EXTabAnchorType, animated:Bool = false, parameters:[String:String] = [:]) {
        guard let rootTabBar = BusinessTools.getRootTabbar() else {return}
        guard let topVc = AppService.topViewController() else { return}
        
        var tabIdx:Int = 0
        switch type {
        case .exMarket:
            break
        case .slContract:
            tabIdx = rootTabBar.getVCIndex(SLSwapVc())
            break
        case .exOtc:
            break
        case .exAsset:
            let asset = EXAssetsContainerVc.instanceFromStoryboard(name: StoryBoardNameAsset)
            tabIdx = rootTabBar.getVCIndex(asset)
            break
        case .exHome:
            tabIdx = 0
            break
        case .exTransaction:
//            tabIdx = rootTabBar.getVCIndex(EXAllTradtionVC())
            break
        }
        
        //处理资产在二级页面的情况,tabIdx,没找到
        if type == .exAsset,tabIdx == 0 {
            let asset = EXAssetsContainerVc.instanceFromStoryboard(name: StoryBoardNameAsset)
            topVc.navigationController?.pushViewController(asset, animated: true)
        }else {
            rootTabBar.selectIndex(tabIdx)
            topVc.navigationController?.popToRootViewController(animated: animated)
        }
        self.currentViewController = rootTabBar.getCurrentTabbarVC()
        guard let vc = self.currentViewController else {return}
        if let protocal = vc as? EXTabActionProtocal,parameters.count > 0{
            protocal.handleParameter(parameters)
        }
        
    }
}
