//
//  UserSysmbolsVM.swift
//  Chainup
//
//  Created by lcus on 2019/9/19.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import UIKit
import RxSwift

class UserSymbolsVM: NSObject {

    let disposBag = DisposeBag()
    
    typealias completeCallBacK = ()->()
    var didComplete:completeCallBacK?
    
    func handSysmbols(operationType:String,symbols:String) {
        if XUserDefault.getToken() == nil { return }
        appApi.rx.request(.update_symbol(operationType: operationType, symbols:symbols))
            .subscribe(onSuccess: { (response) in
            
//            print("修改消息--",response)
        }).disposed(by: disposBag)
        
    }
    
    func syncUserSysmbols()  {
        
        if XUserDefault.getToken() == nil { return }
         appApi.rx.request(.listSymbal).subscribe(onSuccess: { [weak self] (Response) in
        
            let json = try? JSONSerialization.jsonObject(with: Response.data, options: .allowFragments)
                as! [String: Any]
            
            if let data = json?["data"] as? [String:Any]{
                
                let symbols = data["symbols"] as? [String]
                
                if let sync_status = data["sync_status"] as? String {
                    
                    if sync_status == "0" {
                        self?.storeUserSymbolList(data: symbols ?? [])
                    }else if sync_status == "1" {
                        
                        self?.overlayLocaldata(data: symbols ?? [])
                    }
                }
            }
         
            },onError:{(error) in
                print("error--",error)
         }).disposed(by: disposBag)
    }
    
    private func overlayLocaldata (data:[String]) {
        // 覆盖本地数据
        let isNeed  = isEqual(data: data)
        if isNeed == true { return }
        
        let originInfo = getOriginCoininfos(data: data)
        
        let originNamesSet = Set(originInfo.map{$0.name})
        
        XUserDefault.setValueForKey(Array(originNamesSet), key: XUserDefault.collectionCoinMap)
        
        if didComplete != nil {
             didComplete!()
        }
    }
    private func storeUserSymbolList(data:[String]) {
        //同步一次本地 diff 以后不在同步
        
        let localInfo = getlocalSymbols()

        let originInfo = getOriginCoininfos(data: data)
    
        let originNamesSet = Set(originInfo.map{$0.name})
        let loacalNames = Set(localInfo.localNames)
        let originSymbolSet = Set(originInfo.map{$0.symbol})
        let localSymbolsSet = Set(localInfo.localSymbols)
        let storeInfo = loacalNames.union(originNamesSet)
        
        XUserDefault.setValueForKey(Array(storeInfo), key: XUserDefault.collectionCoinMap)
        if didComplete != nil {
            didComplete!()
        }
        let postInfo = localSymbolsSet.subtracting(originSymbolSet)
       
        let symbols = postInfo.count == 0 ? "" : postInfo.joined(separator: ",")

        appApi.rx.request(.update_symbol(operationType: "0", symbols:symbols))
                        .subscribe(onSuccess: { (Response) in
                    print("itmes",Response)
                }).disposed(by: disposBag)
        

    }
    // 或许本地存储币对名字 map出所有信息 取symblos 返回元组
    func getlocalSymbols() -> (localNames:[String],localSymbols:[String]) {
        
        let localNames:[String] = XUserDefault.getCollectionCoinMap()
        
        let localCoinMapEntity: [CoinMapEntity] =  PublicInfoManager.sharedInstance.getCollectionCoinMapList(localNames)
        let localSymbols = localCoinMapEntity.map{$0.symbol}
        
        return (localNames:localNames,localSymbols:localSymbols)
    }
    // 根据远程返回syms map 所有币对信息
    func getOriginCoininfos(data:[String]) -> [CoinMapEntity] {
        var array = [CoinMapEntity]()
        
        for item in data {
        
            let tempItem = PublicInfoManager.sharedInstance.getCoinMapInfoWithSymbol(item)
            
            array.append(tempItem)
            
        }
        return array;
       
    }
    
    func isEqual(data:[String]) -> Bool {
        
        let localInfo = getlocalSymbols()
        let originInfo = getOriginCoininfos(data: data)
        
        let originSymbolSet = Set(originInfo.map{$0.symbol})
        let localSymbolsSet = Set(localInfo.localSymbols)
        
        return originSymbolSet == localSymbolsSet
    }
    
}
