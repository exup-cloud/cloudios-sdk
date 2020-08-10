//
//  EXNetworkDoctor.swift
//  Chainup
//
//  Created by liuxuan on 2019/11/6.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

//永久不会挂的请求 https://saas-oss.oss-cn-hongkong.aliyuncs.com/update.json

enum EXApiType:String {
    case appApi = "appApiHost"
    case otcApi = "otcApiHost"
    case contractApi = "contractApiHost"
    case redPackAPi = "redPackApiHost"
}

enum EXCerPlan:String {
    case cer = "ioscer"//对应cer
    case cerPlanB = "lcuiww"// 对应cer1
    case cerPlanC = "xtgta"// 对应cer2
    case cerPlanD = "mrzkjc"// 对应cer2
}

class EXNetworkDoctor: NSObject {
    /*
     static let wss_host_url = "wss://ws.mpuuss.top/kline-api/ws"//币币ws
     static let wss_host_url2 = "wss://ws2.mpuuss.top/otc-chat/chatServer/"//otc聊天ws
     static let wss_host_contract = "ws://dev3ws3.chaindown.com/contract-kline-api/ws"//合约ws
     */
    
    /*
     ioscer.cer,ioscer1.cer,ioscer2.cer
     准备了3个cer证书，备用，日常用cer，进入切换后，切换到cer1、cer2
     */
    private var appApihost :String = NetDefine.http_host_url
    private var otcApi :String = NetDefine.http_host_url_otc
    private var contractApi :String = NetDefine.http_host_url_contract
    private var redpackApi :String = NetDefine.http_host_url_redpacket
    private var wsKline :String = NetDefine.wss_host_url
    private var wsTalk :String = NetDefine.wss_host_url2
    private var wsContract :String = NetDefine.wss_host_contract
    
    let disposebag = DisposeBag()
    
    var hosts:[String]?
    var currentHost:String = ""
    var currentCer:String = ""
    let assetName = "update.json"
    let regexStr = "\\d{7,}"
    let downloadCer = "ioscer.cer"
    var useDownload :Bool = false
    var downloadCerData :NSData?

    private var ud: UserDefaults {
        return UserDefaults.standard
    }
    
    static let `manager` = EXNetworkDoctor()
    open class var sharedManager: EXNetworkDoctor {
        return manager
    }
    
    func configNetWork() {
        if let historyDomain = self.ud[.domainCfg],
            let historyCer = self.ud[.cerCfg],
            let historyRoot = self.ud[.useRootCfg],
            let isDownloadType = self.ud[.isDownloadType]
        {
            self.currentHost = historyDomain
            self.currentCer = historyCer
            self.useDownload = (isDownloadType == "1")
            let location = DefaultDownloadDir.appendingPathComponent(downloadCer)
            if let cerdata = NSData(contentsOfFile: location.path) {
                self.downloadCerData = cerdata
            }
            print("使用历史记录域名和证书,域名是:\(currentHost),证书是\(historyCer)")
            if historyRoot == "1" {
                self.updateALlApi(useRoot: true)
            }else if historyRoot == "0" {
                self.updateALlApi(useRoot: false)
            }
        }else {
            self.currentHost = NetDefine.http_host_url.hostStr()
            self.currentCer = EXCerPlan.cerPlanB.rawValue
        }
        //saas开始下载配置
        self.startScanNetwork()
    }
    
    //如果网络通畅，进行下一步校验
    func startScanNetwork() {
        if self.checkIsSaas() {
            self.checkIsConnectedToNetwork {[weak self] success in
                if success {
                    DispatchQueue.main.async {
                        self?.getConfigs()
                    }
                }
            }
        }
    }

    func checkIsConnectedToNetwork( isConnected: @escaping((Bool) -> Void)) {
        let status = BasicParameter.getNetStatus()
        if status == "NONE" {
            isConnected(false)
        }else {
            isConnected(true)
        }
    }
    
    private func getConfigs() {
        DLServiceProvider.request(.downloadAsset(assetName: assetName)) {[weak self] result in
            switch result {
            case .success:
                self?.readLocalFile()
            case .failure(_):
                break
            }
        }
    }
    
    func readLocalFile() {
        let location = DefaultDownloadDir.appendingPathComponent(assetName)
        let jsonData = NSData(contentsOfFile: location.path)
        do{
            let json = try JSONSerialization.jsonObject(with: jsonData! as Data, options: []) as! [String:AnyObject]
            if let model = EXNetworkHostsModel.mj_object(withKeyValues: json) {
                self.updateHostConfigure(model)
            }
        }catch let error as NSError{
            print("解析出错: \(error.localizedDescription)")
        }
    }
    
    private func updateHostConfigure(_ model:EXNetworkHostsModel) {
        if model.ios_on == false {
            self.ud.remove(key: .cerCfg)
            self.ud.remove(key: .domainCfg)
            self.ud.remove(key: .useRootCfg)
            self.ud.remove(key: .isDownloadType)
            return
        }
        // 1 .检查当前host是否存在特殊列表里
        let original = NetDefine.http_host_url
        var regex: NSRegularExpression = NSRegularExpression.init()
        //构造正则表达式
        do {
            regex = try NSRegularExpression.init(pattern: regexStr, options: NSRegularExpression.Options.caseInsensitive)
        } catch {
            
        }
        let res = regex.matches(in: original, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, original.count))
        var company_id = ""
        if res.count == 1 {
            let resRst = res[0]
            company_id = (original as NSString).substring(with: resRst.range)
        }
        if company_id.count > 0 {
            var specialModel:EXSpecialModel?
            for item in model.special_list {
                let res = regex.matches(in: item.host, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, item.host.count))
                if res.count == 1 {
                    let specialRst = res[0]
                    let special_company_id = (item.host as NSString).substring(with: specialRst.range)
                    //如果和特殊列表里的相等
                    if company_id == special_company_id {
                        specialModel = item
                        break
                    }
                }
            }
            var testModel:EXTestModel?
            
            for item in model.test_list {
                let res = regex.matches(in: item.host, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, item.host.count))
                if res.count == 1 {
                    let specialRst = res[0]
                    let special_company_id = (item.host as NSString).substring(with: specialRst.range)
                             //如果和特殊列表里的相等
                    if company_id == special_company_id {
                        testModel = item
                        break
                    }
                }
            }
            
            if specialModel == nil {
                hosts = model.links.map({ $0.hostName}).filter{$0.count>0}
            }
            
            if let specialM = specialModel {
                //特殊列表
                self.changeApiToRoot(model: specialM)
            }else if let testM = testModel {
                self.changeApiToSpeedUP(withDomain: testM.saas_domain, cer: testM.saas_cer_fileName)
                
            }else {
                //有本地选择的domain,并且在hosts中那么就不更新
                guard let localChoiceDomain = self.ud[.localChoiceDomainCfg], let hostlist = hosts, hostlist.contains(localChoiceDomain) else {
                    
                    //saas一般用户
                    self.changeApiToSpeedUP(withDomain: model.saas_domain, cer: model.saas_cer_fileName)
                    return
                }
            }
            
        }
    }
    
    private func changeApiToRoot(model:EXSpecialModel) {
        self.currentHost = model.force_domain
        self.currentCer = model.cer
        if model.cer != EXCerPlan.cerPlanB.rawValue,
            model.cer != EXCerPlan.cerPlanC.rawValue,
            model.cer != EXCerPlan.cerPlanD.rawValue{
            self.currentCer = EXCerPlan.cer.rawValue
        }
        self.updateALlApi(useRoot: true)
    }
    
    func handleDownloadSuccess(_ domain:String) {
        let location = DefaultDownloadDir.appendingPathComponent(downloadCer)
        let downloadData = NSData(contentsOfFile: location.path)
        do{
            if let cerData = downloadData  {
                self.downloadCerData = cerData
                self.currentHost = domain
                self.currentCer = location.path
                self.updateALlApi(useRoot: false)
                self.ud[.isDownloadType] = "1"
                self.useDownload = true
            }
        }catch let error as NSError{
            print("解析出错: \(error.localizedDescription)")
        }
    }
    
    
    private func changeApiToSpeedUP(withDomain:String,cer:String) {
        if withDomain.count > 0,cer.count > 0 {
            if cer == "download" {
                DLServiceProvider.request(.downloadAsset(assetName: downloadCer)) {[weak self] result in
                    switch result {
                    case .success:
                        self?.handleDownloadSuccess(withDomain)
                    case .failure(_):
                        break
                    }
                }
            }else {
                self.ud[.isDownloadType] = "0"
                self.currentHost = withDomain
                self.currentCer = cer
                print("使用下载域名和证书,域名是:\(withDomain),证书是\(cer)")
                if cer != EXCerPlan.cerPlanB.rawValue,
                    cer != EXCerPlan.cerPlanC.rawValue,
                    cer != EXCerPlan.cerPlanD.rawValue{
                    self.currentCer = EXCerPlan.cer.rawValue
                }
                self.updateALlApi(useRoot: false)
            }
        }
    }
    
    func changeCurrentHost(selectedHost:String) {
        
        if selectedHost != self.currentHost, let hostList = hosts, hostList.contains(selectedHost) {
            self.currentHost = selectedHost
            updateALlApi(useRoot: false)
            self.ud[.localChoiceDomainCfg] = selectedHost
        }
    }
    
    func updateALlApi(useRoot:Bool) {
        if useRoot {
             self.appApihost = "https://appapi." + currentHost + "/"
             self.otcApi = "https://otcappapi." + currentHost + "/"
             self.contractApi = "https://coappapi." + currentHost + "/"
             self.redpackApi = "https://service." + currentHost + "/hongbao/"
             self.wsKline = "wss://ws." + currentHost + "/kline-api/ws"
             self.wsTalk = "wss://ws2." + currentHost + "/otc-chat/chatServer/"
             self.wsContract = "wss://ws3." + currentHost + "/wsswap/realTime/"
         }else {
            let oldDomain = self.appApihost.hostStr()
             self.appApihost = appApihost.replacingOccurrences(of: oldDomain, with: currentHost)
             self.otcApi = otcApi.replacingOccurrences(of: oldDomain, with: currentHost)
             self.contractApi = contractApi.replacingOccurrences(of: oldDomain, with: currentHost)
             self.redpackApi = redpackApi.replacingOccurrences(of: oldDomain, with: currentHost)
             self.wsKline = wsKline.replacingOccurrences(of: oldDomain, with: currentHost)
             self.wsTalk = wsTalk.replacingOccurrences(of: oldDomain, with: currentHost)
             self.wsContract = wsContract.replacingOccurrences(of: oldDomain, with: currentHost)
         }
         self.synchronize(useRoot: useRoot)
    }
    
    private func synchronize(useRoot:Bool) {
        
        self.ud[.domainCfg] = self.currentHost
        self.ud[.cerCfg] = self.currentCer
        self.ud[.useRootCfg] = useRoot ? "1" : "0"
        self.ud.synchronize()
    }
    
    
    func allApis() ->[String] {
        return [appApihost,otcApi,contractApi,redpackApi,wsKline,wsTalk,wsContract]
    }
    

    static func doctorHost() ->String {
        //https://chainup-ui.oss-cn-beijing.aliyuncs.com/update.json
        //https://saas-app.hiotc.pro/update.json   https的吧
        return "https://chainup.oss-accelerate.aliyuncs.com/"
    }
    
    func getCurrentCerName() ->String {
        if checkIsSaas() {
            return self.currentCer
        }else {
            return EXCerPlan.cer.rawValue
        }
    }
    
}

extension EXNetworkDoctor {
    
    private func checkIsSaas() -> Bool {
        if let plistpath = Bundle.main.path(forResource: "Info", ofType: "plist"){
            if let dict = NSDictionary.init(contentsOfFile: plistpath){
                if let homeViewStatus = dict["appswitchsaas"] as? String{
                    switch homeViewStatus{
                    case "1":
                        return true
                    case "0":
                        return false
                    default:
                        return true
                        
                    }
                }
            }
        }
        return true
        
//        let validate = NetDefine.http_host_url
//        var regex: NSRegularExpression = NSRegularExpression.init()
//        let linkPattern: String = regexStr
//        //构造正则表达式
//        do {
//            regex = try NSRegularExpression.init(pattern: linkPattern, options: NSRegularExpression.Options.caseInsensitive)
//        } catch {
//        }
//        let res = regex.matches(in: validate, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, validate.count))
//        for _ in res
//        {
//            return true
//        }
//        return false
    }
    
    //非saas直接返回配置好的api host
    func getAppAPIHost() -> String {
        if checkIsSaas() {
            return self.appApihost
        }else {
            return NetDefine.http_host_url
        }
    }
    
    func getOtcAPIHost() -> String {
        if checkIsSaas() {
            return self.otcApi
        }else {
            return NetDefine.http_host_url_otc
        }
    }
    
    func getContractAPIHost() -> String {
        if checkIsSaas() {
            return self.contractApi
        }else {
            return NetDefine.http_host_url_contract
        }
    }
    
    func getRedPackAPIHost() -> String {
        if checkIsSaas() {
            return self.redpackApi
        }else {
            return NetDefine.http_host_url_redpacket
        }
    }
    
    func getKlineWs() -> String {
        if checkIsSaas() {
            return self.wsKline
        }else {
            return NetDefine.wss_host_url
        }
    }
    
    func getTalkWs() -> String {
        if checkIsSaas() {
            return self.wsTalk
        }else {
            return NetDefine.wss_host_url2
        }
    }
    
    func getContractWs() -> String {
        if checkIsSaas() {
            return self.wsContract
        }else {
            return NetDefine.wss_host_contract
        }
    }
       
}
