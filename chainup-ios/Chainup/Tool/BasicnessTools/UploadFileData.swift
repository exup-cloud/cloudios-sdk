//
//  UploadFileData.swift
//  ChoinUp-ExChange
//
//  Created by zewu wang on 2018/8/23.
//  Copyright © 2018年 zewu wang. All rights reserved.
//

import UIKit
import RxSwift
import SVProgressHUD

class UploadFileData: NSObject {

    var client = OSSClient.init()
    
    var credential = OSSStsTokenCredentialProvider.init()
    
    var array = NSMutableArray.init()
    
    //MARK:单例
    public static var sharedInstance : UploadFileData{
        struct Static {
            static let instance : UploadFileData = UploadFileData()
        }
        return Static.instance
    }
    
}

extension UploadFileData{
    
    //上传图片
    func uploadImg(_ params : [String : Any]) -> Observable<[String : Any]>{
        
        return Observable.create({ (observer) -> Disposable in
            
//            let url = NetManager.sharedInstance.url(NetDefine.http_host_url, model: NetDefine.common, action: NetDefine.upload_img)
            let url = NetManager.sharedInstance.url(EXNetworkDoctor.sharedManager.getAppAPIHost(), model: NetDefine.common, action: NetDefine.upload_img)

            let param = NetManager.sharedInstance.handleParamter(params)
            NetManager.sharedInstance.sendRequest(url, parameters: param, success: { (result, respose, nil) in
                if let result = result as? [String : Any]{
                    observer.onNext(result)
                }
                observer.onCompleted()
            }, fail: { (state, error, nil) in

            })
            
            return Disposables.create()
        })
        
    }
    
    func otcUploadImg(_ params : [String : Any]) -> Observable<[String : Any]>{
        
        return Observable.create({ (observer) -> Disposable in
            
//            let url = NetManager.sharedInstance.url(NetDefine.http_host_url, model: NetDefine.otc_upload_qrcode, action: "")
            let url = NetManager.sharedInstance.url(EXNetworkDoctor.sharedManager.getAppAPIHost(), model: NetDefine.otc_upload_qrcode, action: "")

            let param = NetManager.sharedInstance.handleParamter(params)
            NetManager.sharedInstance.sendRequest(url, parameters: param, success: { (result, respose, nil) in
                if let result = result as? [String : Any]{
                    observer.onNext(result)
                }
                observer.onCompleted()
            }, fail: { (state, error, nil) in
                
            })
            
            return Disposables.create()
        })
        
    }
    
}

extension UploadFileData{
    
    func getTokenAndUrl(_ eentity : UploadFileTokenEntity , type : String = "2") {
        self.getTokenAndUrl(eentity, rstSuccess: nil)
    }
    //type 1实名认证 2其他
    
    func getTokenAndUrl(_ eentity : UploadFileTokenEntity , type : String = "2",rstSuccess: ((Bool) -> ())?) {
        
//        ProgressHUDManager.showStatus("loading...", maskType: SVProgressHUDMaskType.clear)
        
//        let url = NetManager.sharedInstance.url(NetDefine.http_host_url, model: NetDefine.common, action: NetDefine.get_image_token)
        let url = NetManager.sharedInstance.url(EXNetworkDoctor.sharedManager.getAppAPIHost(), model: NetDefine.common, action: NetDefine.get_image_token)

        let param = NetManager.sharedInstance.handleParamter(["operate_type" : type])
        
        NetManager.sharedInstance.sendRequest(url, parameters: param, isShowLoading : false,success: {[weak self] (result, response, nil) in
            guard let mySelf = self else{return}
            if let dict = result as? [String : Any]{
                if let data1 = dict["data"] as? [String : Any]{
//                    let entity = UploadFileTokenEntity()
//                    entity.setEntityWithDict(data1)
                    eentity.setEntityWithDict(data1)
                    rstSuccess?(true)
                }
            }
        }) { (state, error, nil) in
            rstSuccess?(false)
            if (error as? NSError)?.code == 101118{
                return
            }
            ProgressHUDManager.showFailWithStatus(LanguageTools.getString(key: "common_tip_imgUploadFail"))
        }
    }
    
//    //type 1实名认证 2其他
//    func getTokenAndUrl(_ data : Data , f : @escaping (([String : Any]) -> ()) , type : String){
//
//        ProgressHUDManager.showStatus("loading...", maskType: SVProgressHUDMaskType.clear)
//
//        let url = NetManager.sharedInstance.url(NetDefine.http_host_url, model: NetDefine.common, action: NetDefine.get_image_token)
//        let param = NetManager.sharedInstance.handleParamter(["operate_type" : type])
//
//        NetManager.sharedInstance.sendRequest(url, parameters: param, isShowLoading : false,success: {[weak self] (result, response, nil) in
//            guard let mySelf = self else{return}
//            if let dict = result as? [String : Any]{
//                if let data1 = dict["data"] as? [String : Any]{
//                    let entity = UploadFileTokenEntity()
//                    entity.setEntityWithDict(data1)
//                    mySelf.uploadOSS(data , uploadFileTokenEntity: entity ,f : f)
//                }
//            }
//        }) { (state, error, nil) in
//            ProgressHUDManager.dismissWithDelay {
//                ProgressHUDManager.showFailWithStatus(LanguageTools.getString(key: "toast_upload_pic_failed"))
//            }
//        }
//
//    }

    //上传oss
    func uploadOSS(_ data : Data , uploadFileTokenEntity :UploadFileTokenEntity,f : @escaping (([String : Any]) -> ()),b : @escaping (() -> ()) ,isshowloading : Bool = false){
        if isshowloading == true{
            XHUDManager.sharedInstance.loading()
        }
        
        credential = OSSStsTokenCredentialProvider.init(accessKeyId: uploadFileTokenEntity.AccessKeyId, secretKeyId: uploadFileTokenEntity.AccessKeySecret, securityToken: uploadFileTokenEntity.SecurityToken)
        //仓库目录
        let uploadPart = OSSPutObjectRequest.init()
        uploadPart.bucketName = uploadFileTokenEntity.bucketName//
//        //图片名字
//        var arc = ""
//        for _ in 0..<6{
//            arc = arc + "\(arc4random()%10)"
//        }
        let imageName = AppService.md5(data.base64EncodedString())  + ".png"
        uploadPart.objectKey = uploadFileTokenEntity.catalog + imageName
//        uploadPart.contentType = "image/png"
        uploadPart.uploadingData = data//图片的data数据
        
        client = OSSClient.init(endpoint: uploadFileTokenEntity.ossUrl , credentialProvider: credential)
        
        let putTask = client.putObject(uploadPart)
        array.add(putTask)
        putTask.continue ({[weak self] (task) -> Any? in
            guard let mySelf = self else{return nil}
            if task.error == nil{
                DispatchQueue.main.async {
                    ProgressHUDManager.showSuccessWithStatus(LanguageTools.getString(key: "common_tip_imgUploadSuccess"))
                    var h = ""
                    if uploadFileTokenEntity.ossUrl.contains("http://"){
                        h = "http://"
                        uploadFileTokenEntity.ossUrl = uploadFileTokenEntity.ossUrl.replacingOccurrences(of: "http://", with: "")
                    }else if uploadFileTokenEntity.ossUrl.contains("https://"){
                        h = "https://"
                        uploadFileTokenEntity.ossUrl = uploadFileTokenEntity.ossUrl.replacingOccurrences(of: "https://", with: "")
                    }
                    let allImgUrl = h + uploadPart.bucketName + "." + uploadFileTokenEntity.ossUrl + uploadPart.objectKey
                    let imgUrl = uploadPart.objectKey
                    f(["imgUrl" : imgUrl , "allImgUrl" : allImgUrl])
                }
            }else{
                DispatchQueue.main.async {
                    ProgressHUDManager.showFailWithStatus(LanguageTools.getString(key: "common_tip_imgUploadFail"))
                }
                b()
            }
            if mySelf.array.contains(putTask){
                mySelf.array.remove(putTask)
            }
            return nil
        })
        
    }
    
}

class UploadFileTokenEntity: SuperEntity {
    
    var AccessKeyId = "" //账号
    var AccessKeySecret = ""//密码
    var Expiration = ""//过期时间
    var SecurityToken = ""//上传图片token
    var catalog = ""//上传图片二级目录
    var ossUrl = "" //上传图片url
    var bucketName = ""//仓库名字
    
    override func setEntityWithDict(_ dict: [String : Any]) {
        super.setEntityWithDict(dict)
        AccessKeyId = dictContains("AccessKeyId")
        AccessKeySecret = dictContains("AccessKeySecret")
        Expiration = dictContains("Expiration")
        SecurityToken = dictContains("SecurityToken")
        catalog = dictContains("catalog")
        bucketName = dictContains("bucketName")
        ossUrl = dictContains("ossUrl")
    }
    
}
