//
//  LanguageTools.swift
//  AppProject
//
//  Created by zewu wang on 2018/8/6.
//  Copyright © 2018年 zewu wang. All rights reserved.
//

import UIKit

let UserLanguage = "UserLanguage"

let AppleLanguages = "AppleLanguages"

@objcMembers class LanguageTools: NSObject {

    static let shareInstance = LanguageTools()

    let def = UserDefaults.standard

    var bundle : Bundle?

    //根据语言key获取翻译
    @objc class func getString(key:String) -> String{
        if let dlLan = XUserDefault.getVauleForKey(key: self.getDownloadLanKey()) as? [String : String] {
            if var value = dlLan[key] {
                if value.contains("%s") {
                    value = value.replacingOccurrences(of: "%s", with: "%@")
                }
                return value
            }else {
                return self.getDfString(key: key)
            }
        }else {
            return self.getDfString(key: key)
        }
    }
    
    @objc class func getDfString(key:String) -> String {
        
        let bundle = LanguageTools.shareInstance.bundle

        if let str = bundle?.localizedString(forKey: key, value: nil, table: nil){
            return str
        }
        return ""
    }

    //初始化语言
    func initUserLanguage() {

        var string:String = def.value(forKey: UserLanguage) as! String? ?? ""

//        var string = "" //现在先跟着系统走
        
        if string == "" {

            let languages = def.object(forKey: AppleLanguages) as? NSArray

            if languages?.count != 0 {

                let current = languages?.object(at: 0) as? String

                if current != nil {

                    string = current!

                    def.set(current, forKey: UserLanguage)

                    def.synchronize()

                }

            }

        }

        BTLanguageTool.sharedInstance()?.setCurrentLaunguage(EN)
        if string.range(of: "zh-Hant") != nil{
            BasicParameter.phoneLanguage = LanguageTools.el
            BTLanguageTool.sharedInstance()?.setCurrentLaunguage(CNS)
            string = "zh-Hant"
        }else if string.range(of: "zh-Hans") != nil{
            string = "zh-Hans"
            BasicParameter.phoneLanguage = LanguageTools.ch
            BTLanguageTool.sharedInstance()?.setCurrentLaunguage(CNS)
        }
//        else if string.range(of: "ru") != nil{
//            string = "ru-RU"
//            BasicParameter.phoneLanguage = LanguageTools.ru
//
//        }
//        else if string.range(of: "mn") != nil{
//            string = "mn"
//            BasicParameter.phoneLanguage = LanguageTools.mn
//
//        }
        else if string.range(of: "ko") != nil{
            string = "ko-KR"
            BasicParameter.phoneLanguage = LanguageTools.ko

        }
//
        else if string.range(of: "ja") != nil{
            string = "ja"
            BasicParameter.phoneLanguage = LanguageTools.jp

        }
        else if string.range(of:"vi") != nil{
            string = "vi"
            BasicParameter.phoneLanguage = LanguageTools.vi
        }
        else if string.range(of: "en") != nil{
            string = "en"
            BasicParameter.phoneLanguage = LanguageTools.en

        }
        else if string.range(of: "es") != nil{
            string = "es"
            BasicParameter.phoneLanguage = LanguageTools.es
        }
        
        var path = Bundle.main.path(forResource:string , ofType: "lproj")

        if path == nil {

            path = Bundle.main.path(forResource:"en" , ofType: "lproj")

        }

        bundle = Bundle(path: path!)

    }

    //设置语言
    func setLanguage(langeuage:String) {
        
        BTLanguageTool.sharedInstance()?.setCurrentLaunguage(EN)
        if langeuage == "el-GR"{
          if let  path = Bundle.main.path(forResource:"zh-Hant" , ofType: "lproj") {
           
            bundle = Bundle(path: path)
            def.set("zh-Hant", forKey: UserLanguage)
            
            def.synchronize()
            }

        }else if langeuage == "zh-CN"{
            BTLanguageTool.sharedInstance()?.setCurrentLaunguage(CNS)
            if let  path = Bundle.main.path(forResource:"zh-Hans" , ofType: "lproj") {
                
                bundle = Bundle(path: path)
                def.set("zh-Hans", forKey: UserLanguage)
                
                def.synchronize()
            }
        }
//        else if langeuage == "mn-MN"{
//
//            if let  path = Bundle.main.path(forResource:"mn" , ofType: "lproj") {
//
//                bundle = Bundle(path: path)
//                def.set("mn-MN", forKey: UserLanguage)
//
//                def.synchronize()
//            }
//
//
        else if langeuage == "ja-JP"{
            if let  path = Bundle.main.path(forResource:"ja" , ofType: "lproj") {

                bundle = Bundle(path: path)
                def.set("ja-JP", forKey: UserLanguage)

                def.synchronize()
            }
        }
        else if langeuage == "ko-KR"{
            if let  path = Bundle.main.path(forResource:"ko-KR" , ofType: "lproj") {

                bundle = Bundle(path: path)
                def.set("ko-KR", forKey: UserLanguage)

                def.synchronize()
            }
        }
//        else if langeuage == "ru-RU"{
//            if let  path = Bundle.main.path(forResource:"ru-RU" , ofType: "lproj") {
//
//                bundle = Bundle(path: path)
//                def.set("ru-RU", forKey: UserLanguage)
//
//                def.synchronize()
//            }
//        }
        else if langeuage == "vi-VN"{
            if let  path = Bundle.main.path(forResource:"vi" , ofType: "lproj") {
                
                bundle = Bundle(path: path)
                def.set("vi-VN", forKey: UserLanguage)
                
                def.synchronize()
            }
        }
        
        else if langeuage == "es-ES"{
            if let  path = Bundle.main.path(forResource:"es" , ofType: "lproj") {
                bundle = Bundle(path: path)
                def.set("es-ES", forKey: UserLanguage)
                def.synchronize()
            }
        }
        
        else if langeuage == "en-US"{
            if let  path = Bundle.main.path(forResource:"en" , ofType: "lproj") {
                bundle = Bundle(path: path)
                def.set("en-US", forKey: UserLanguage)
                def.synchronize()
            }
        }
            
        else{
            // 如果有下载的新语言,
            if let dlLan = XUserDefault.getVauleForKey(key:langeuage) as? [String : String],dlLan.count > 0 {
                bundle = nil
                
            }else {
                let path = Bundle.main.path(forResource:"en" , ofType: "lproj")
                bundle = Bundle(path: path!)
            }
            
            def.set(langeuage, forKey: UserLanguage)
            def.synchronize()
        }
        

       
        self.tryDownloadCurrentLan()
    }
    
    static func getDownloadLanKey() ->String{
        return "dl_\(BasicParameter.getPhoneLanguage())"
    }

}

extension LanguageTools{
    static let ch = "zh_CN"//中文
    
    static let ko = "ko_KR"//韩语
    
    static let mn = "mn_MN"//蒙语,废弃
    
    static let en = "en_US"//英语
    
    static let jp = "ja_JP"//日语
    
    static let ru = "ru_RU"//俄语,废弃
    
    static let el = "el_GR"//繁体
    
    static let vi = "vi_VN"//越南
    
    static let es = "es_ES" //西班牙语
    
    func localSupportsLans() -> [String] {
        return[LanguageTools.ch,LanguageTools.el,LanguageTools.ko,LanguageTools.en,LanguageTools.jp,LanguageTools.vi,LanguageTools.es]
    }
    
    func serverSupportLans() -> [String] {
        var serversupports:[String] = []
        for (key, value) in PublicInfoEntity.sharedInstance.locales {
            if value.count > 0 {
                serversupports.append(key)
            }
        }
        return serversupports
    }
    
    func supportLan(_ lankey:String) ->Bool {
        var key = lankey
        key = key.replacingOccurrences(of: "-", with: "_")
        if localSupportsLans().contains(key) {
            return true
        }
        if serverSupportLans().contains(key) {
            return true
        }
        return false
    }
}

extension LanguageTools {
    func tryDownloadCurrentLan() {
        let currentLan = BasicParameter.getPhoneLanguage()
        let downloadUrl = PublicInfoEntity.sharedInstance.locales[currentLan] as? String
        if let lanUrl = downloadUrl,lanUrl.count > 0  {
            DLServiceProvider.request(.downloadLan(url: lanUrl)) {[weak self] result in
                switch result {
                case .success:
                    self?.readLocalFile()
                case .failure(_):
                    break
                }
            }
        }
    }
    
    func readLocalFile() {
        let location = DefaultDownloadDir.appendingPathComponent(BasicParameter.getPhoneLanguage())
        let jsonData = NSData(contentsOfFile: location.path)
        do{
            let json = try JSONSerialization.jsonObject(with: jsonData! as Data, options: []) as! [String:AnyObject]
            if let lanDic = json[BasicParameter.getPhoneLanguage()] as? [String:String] {
                XUserDefault.setValueForKey(lanDic, key:LanguageTools.getDownloadLanKey())
            }
        }catch let error as NSError{
            print("解析出错: \(error.localizedDescription)")
        }
    }
}


