//
//  MoyaLoadingPlugin.swift
//  Chainup
//
//  Created by liuxuan on 2019/1/21.
//  Copyright © 2019 zewu wang. All rights reserved.
//
import Foundation
import Moya
import Result

public final class MoyaLoadingPlugin: PluginType {
    
    private var loadings :Array<LoadingStatusModel> = []
    var needLoading:Bool = true

    func backgroudLoadingList()-> [String] {
        return [ContractPath.userposition,
                ContractPath.liquidation,
                ContractPath.orderlist,
                ContractPath.tagprice,
                ContractPath.takeinitorder]
    }
    
    func noloading() {
        needLoading = false
    }
    
    func backgroudLoadingList(path:String) -> Bool {
        if backgroudLoadingList().contains(path) {
            return true
        }
        return false
    }
    
    public func willSend(_ request: RequestType, target: TargetType) {
        
        if self.needLoading {
            if !self.backgroudLoadingList(path: target.path) {
                let model = LoadingStatusModel()
                model.identifer = target.baseURL.absoluteString+target.path
                loadings.append(model)
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                    if self.loadings.contains(model){
                        model.loading = true
                        XHUDManager.sharedInstance.loading()
                    }
                }
            }
        }
    }
    
    public func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
        self.needLoading = true
        if !self.backgroudLoadingList(path: target.path) {
            var rmIdx = -1
            for (index,model) in loadings.enumerated() {
                let iden = target.baseURL.absoluteString+target.path
                if model.identifer == iden {
                    rmIdx = index
                    break
                }
            }
            if rmIdx >= 0,loadings.count > rmIdx {
                loadings.remove(at:rmIdx)
            }
            XHUDManager.sharedInstance.dismissWithDelay {}
        }
    }
}
