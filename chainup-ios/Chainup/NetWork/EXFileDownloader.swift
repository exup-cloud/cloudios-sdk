//
//  EXFileDownloader.swift
//  Chainup
//
//  Created by liuxuan on 2020/2/4.
//  Copyright © 2020 zewu wang. All rights reserved.
//

import UIKit
import Moya

/*
用法
   func testDownload() {
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
        }catch let error as NSError{
            print("解析出错: \(error.localizedDescription)")
        }
    }
*/
 
//初始化请求的provider
let DLServiceProvider = MoyaProvider<DLService>()
 
//请求分类
public enum DLService {
    case downloadAsset(assetName:String) //下载文件
    case downloadLan(url:String)
}
 
//请求配置
extension DLService: TargetType {
    //服务器地址
    public var baseURL: URL {
        switch self {
        case .downloadLan(let url):
            return URL(string: url)!
        default:
            return URL(string:EXNetworkDoctor.doctorHost())!
        }
    }
     
    //各个请求的具体路径
    public var path: String {
        switch self {
        case let .downloadAsset(assetName):
            return "\(assetName)"
        case .downloadLan:
            return ""
        }
    }
     
    //请求类型
    public var method: Moya.Method {
        return .get
    }
     
    //请求任务事件（这里附带上参数）
    public var task: Task {
        switch self {
        case .downloadAsset(_):
            return .downloadDestination(DefaultDownloadDestination)
        case .downloadLan(_):
            return .downloadDestination(LanDownloadDestination)
        }
    }
     
    //是否执行Alamofire验证
    public var validate: Bool {
        return false
    }
     
    //这个就是做单元测试模拟的数据，只会在单元测试文件中有作用
    public var sampleData: Data {
        return "{}".data(using: String.Encoding.utf8)!
    }
     
    //请求头
    public var headers: [String: String]? {
        return nil
    }
}
 
//定义下载的DownloadDestination
private let DefaultDownloadDestination: DownloadDestination = { temporaryURL, response in
    return (DefaultDownloadDir.appendingPathComponent(response.suggestedFilename!), [.removePreviousFile])
}

private let LanDownloadDestination: DownloadDestination = { temporaryURL, response in
    return (DefaultDownloadDir.appendingPathComponent(BasicParameter.getPhoneLanguage()), [.removePreviousFile])
}

//默认下载保存地址（用户文档目录）
let DefaultDownloadDir: URL = {
    let directoryURLs = FileManager.default.urls(for: .documentDirectory,
                                                 in: .userDomainMask)
    return directoryURLs.first ?? URL(fileURLWithPath: NSTemporaryDirectory())
}()
