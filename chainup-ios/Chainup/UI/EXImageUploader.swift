//
//  EXImageUploader.swift
//  Chainup
//
//  Created by liuxuan on 2019/4/16.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

enum ExUploadImgType {
    case direct
    case oss
}

class EXImageUploader: NSObject {
    
    let disposeBag = DisposeBag()
    var ossEntity = UploadFileTokenEntity()
    var image = UIImage()
    
    var rx_imgUrl = BehaviorRelay<String>(value:"")
    var rx_img = BehaviorRelay<UIImage>(value:UIImage())
    var imgUrl:String {
        get {
            return rx_imgUrl.value
        }
        set {
            rx_imgUrl.accept(newValue)
            rx_img.accept(self.image)
        }
    }

    //imgUrlType : all 全路径 half 半路径
    func uploadImage(img:UIImage,useBase64:Bool = false,type:String = "2" , imgUrlType : String = "all") {
      
        let useUploadType:ExUploadImgType = PublicInfoManager.sharedInstance.getUploadImgType()
        let data = img.compressImage()
        let param : [String : Any] = ["imageData" : data.base64EncodedString()]
        self.image = img
        
        if useUploadType == .direct {
            //使用base64接口传，用在法币的收款方式传图接口
            if useBase64 {
                UploadFileData.sharedInstance.otcUploadImg(param)
                    .subscribe(onNext: {[weak self] (dict) in
                        guard let mySelf = self else{return}
                        guard let data = dict["data"] as? [String : Any] else{return}
                        mySelf.imgUrl = mySelf.getImageFileName(type: .direct, imgData: data , imgUrlType : imgUrlType)
                    }).disposed(by: self.disposeBag)
            }else {
                UploadFileData.sharedInstance.uploadImg(param)
                    .subscribe(onNext: {[weak self] (dict) in
                        guard let mySelf = self else{return}
                        guard let data = dict["data"] as? [String : Any] else{return}
                        mySelf.imgUrl = mySelf.getImageFileName(type: .direct, imgData: data, imgUrlType: imgUrlType)
                    }).disposed(by: self.disposeBag)
            }
        }else {
            if self.ossEntity.SecurityToken.count > 0 {
                UploadFileData.sharedInstance
                    .uploadOSS(data, uploadFileTokenEntity: self.ossEntity,
                               f: {[weak self] (dict) in
                                guard let mySelf = self else{return}
                                if imgUrlType == "all"{//全路径
                                    if let imgUrl = dict["allImgUrl"] as? String{
                                        mySelf.imgUrl = imgUrl
                                    }
                                }else{//半路径
                                    if let imgUrl = dict["imgUrl"] as? String{
                                        mySelf.imgUrl = imgUrl
                                    }
                                }
                        },
                               b: {[weak self] () in
                                guard let mySelf = self else{return}
                                //token 失效了,刷新一下
                                mySelf.getTokenAndURL(type)
                        },
                               isshowloading : true)
            }else {
                //刷新token并上传
                self.getTokenAndUpload(img,type, imgUrlType : imgUrlType)
            }
        }
    }
    
    func getImageFileName(type:ExUploadImgType,imgData:[String:Any] , imgUrlType : String)->String {
        if type == .direct {
            guard let filename = imgData["filename"] as? String else{
                ProgressHUDManager.showFailWithStatus(LanguageTools.getString(key: "common_tip_imgUploadFail"))
                return ""
            }
            guard let base_image_url = imgData["base_image_url"] as? String else{
                ProgressHUDManager.showFailWithStatus(LanguageTools.getString(key: "common_tip_imgUploadFail"))
                return ""
            }
            if let filenameStr = imgData["filenameStr"] as? String , filenameStr.count != 0{
                if imgUrlType == "all"{
                    return base_image_url + filenameStr
                }else{
                    return filenameStr
                }
            }
            if imgUrlType == "all"{
                return base_image_url + filename
            }else{
                return filename
            }
        }
        return ""
    }
    
    /*
     type = 1 为身份认证
     2 其他
     */
    func getTokenAndURL(_ type:String) {
        UploadFileData.sharedInstance.getTokenAndUrl(self.ossEntity,type: type)
    }
    
    func getTokenAndUpload(_ needUploadImg:UIImage,_ type:String , imgUrlType : String) {
        UploadFileData.sharedInstance.getTokenAndUrl(self.ossEntity,type: type) {[weak self] (success) in
            if success {
                self?.uploadImage(img: needUploadImg , imgUrlType : imgUrlType)
            }
        }
    }
    
}
