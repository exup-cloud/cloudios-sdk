//
//  NetWorkService.swift
//  Chainup
//
//  Created by liuxuan on 2019/1/21.
//  Copyright © 2019 zewu wang. All rights reserved.
//
import Moya
import RxSwift
import Alamofire

class NetWorkService<Target> : MoyaProvider<Target> where Target : TargetType {
    
    var plugin:MoyaLoadingPlugin?
    
    init(
        endpointClosure: @escaping MoyaProvider<Target>.EndpointClosure = MoyaProvider.defaultEndpointMapping,
        requestClosure: @escaping MoyaProvider<Target>.RequestClosure,
        stubClosure: @escaping MoyaProvider<Target>.StubClosure = MoyaProvider.neverStub,
        manager: Manager = exCustomAlamofireManager(),
        plugins: [PluginType] = [MoyaLoadingPlugin() as PluginType]
        ) {
        
        super.init(endpointClosure: endpointClosure,
                   requestClosure: requestClosure,
                   stubClosure: stubClosure,
                   manager: manager,
                   plugins: plugins)
        plugin = plugins[0] as? MoyaLoadingPlugin
    }
    
    func hideAutoLoading() {
        
        plugin?.noloading()
    }
}



 func exCustomAlamofireManager() -> SessionManager{

    var policies = [String:ServerTrustPolicy]()
    
    //设置验证策略为pinCertificates，会遍历项目中所有证书进行验证
    for item in EXNetworkDoctor.sharedManager.allApis() {
        
        if let host = URL(string: item)?.host {
            
            policies[host] =  .pinCertificates(
                certificates: ServerTrustPolicy.certificates(),
                validateCertificateChain: false,
                validateHost: true)
            #if DEBUG
            
            policies = [
                host:.disableEvaluation
            ]
            #else
            
            #endif
        }
    }
    let sesionManager = SessionManager(serverTrustPolicyManager: ServerTrustPolicyManager(policies: policies))
    return sesionManager
}

private let requestClosure: MoyaProvider<AppAPIEndPoint>.RequestClosure = {( endpoint: Endpoint, closure: MoyaProvider.RequestResultClosure) in
    do {
        let urlRequest = try endpoint.urlRequest()
        closure(.success(urlRequest))
    }
    catch {
        
    }
}

let appApiEndpointClosure = { (target: AppAPIEndPoint) -> Endpoint in
    let sampleResponseClosure = { return EndpointSampleResponse.networkResponse(200, target.sampleData) }
    let url = target.baseURL.appendingPathComponent(target.path).absoluteString
    let method = target.method
    
    return Endpoint(url: url, sampleResponseClosure: sampleResponseClosure, method: target.method, task: target.task, httpHeaderFields: target.headers)
}

let contractApiEndpointClosure = { (target: ContractAPIEndPoint) -> Endpoint in
    let sampleResponseClosure = { return EndpointSampleResponse.networkResponse(200, target.sampleData) }
    let url = target.baseURL.appendingPathComponent(target.path).absoluteString
    let method = target.method
    
    return Endpoint(url: url,
                    sampleResponseClosure: sampleResponseClosure,
                    method: target.method,
                    task: target.task,
                    httpHeaderFields: target.headers)
}





let appApi = NetWorkService(endpointClosure: appApiEndpointClosure, requestClosure: requestClosure)

let contractApi = NetWorkService(endpointClosure: contractApiEndpointClosure, requestClosure: requestClosure)

let domainSpeedTestApi = NetWorkService<EXDomainSpeedTestEndPoint>(requestClosure: requestClosure)
