//
//  EXHomeViewModel.swift
//  Chainup
//
//  Created by zewu wang on 2019/8/8.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import UIKit

enum EXHomeViewModelType {
    case one//第一套(中国默认saas版)
    case two//第二套(国际版)
    case three//第三套(日本版)
}

enum EXHomePageStyle {
    case saas//通用
    case king//king版本
    case momo//momo
    case bitsg//bitsg
}

class EXHomeViewModel: NSObject {

    //返回第几套首页
    class func status() -> EXHomeViewModelType{
        var status = EXHomeViewModelType.one
        if let plistpath = Bundle.main.path(forResource: "Info", ofType: "plist"){
            if let dict = NSDictionary.init(contentsOfFile: plistpath){
                if let homeViewStatus = dict["HomeViewStatus"] as? String{
                    switch homeViewStatus{
                    case "1":
                        status = .one
                    case "2":
                        status = .two
                    case "3":
                        status = .three
                    default:
                        status = .one
                        break
                    }
                }
            }
        }
        return status
    }
    
    //返回第几套首页
    class func homepageStyle() -> EXHomePageStyle{
        if let plistpath = Bundle.main.path(forResource: "Info", ofType: "plist"){
            if let dict = NSDictionary.init(contentsOfFile: plistpath){
                if let homeSettingStatus = dict["HomePageStyle"] as? String{
                    switch homeSettingStatus {
                    case "1":
                        return .saas
                    case "2":
                        return .king
                    case "3":
                        return .momo
                    case "4":
                        return .bitsg
                    default:
                        return .saas
                    }
                }
            }
        }
        return .saas
    }
    
    //1.中国默认saas版返回的白天图片名为home_personal_daytime；
    //2.King的返回是home_personal_king(黑白同一个)
    class func getHomePersonDayImage() -> String{
        var iconName = "home_personal_daytime"
        if let plistpath = Bundle.main.path(forResource: "Info", ofType: "plist"){
            if let dict = NSDictionary.init(contentsOfFile: plistpath){
                if let homeSettingStatus = dict["HomePageStyle"] as? String{
                  switch homeSettingStatus{
                  case "1":
                     iconName = "home_personal_daytime"
                  case "2":
                     iconName = "home_personal_king"
                  default:
                     iconName = "home_personal_daytime"
                     break
                 }
                }
            }
        }
        return iconName
    }
    
    //1.中国默认saas版返回夜间图片名为home_personal_night；
    //2.King的返回是home_personal_king(黑白同一个)
    class func getHomePersonNightImage() -> String{
        var iconName = "home_personal_night"
        if let plistpath = Bundle.main.path(forResource: "Info", ofType: "plist"){
            if let dict = NSDictionary.init(contentsOfFile: plistpath){
                if let homeSettingStatus = dict["HomePageStyle"] as? String{
                  switch homeSettingStatus{
                  case "1":
                     iconName = "home_personal_night"
                  case "2":
                     iconName = "home_personal_king"
                  default:
                     iconName = "home_personal_night"
                     break
                 }
                }
            }
        }
        return iconName
    }
    //1.中国默认saas版返回home_banner_default;
    //2.King(home_banner_king_default)
    class func getHomeBannerDefaultImage() -> String{
       var iconName = "home_banner_default"
        if let plistpath = Bundle.main.path(forResource: "Info", ofType: "plist"){
            if let dict = NSDictionary.init(contentsOfFile: plistpath){
                if let homeSettingStatus = dict["HomePageStyle"] as? String{
                  switch homeSettingStatus{
                  case "1":
                     iconName = "home_banner_default"
                  case "2":
                     iconName = "home_banner_king_default"
                  default:
                     iconName = "home_banner_default"
                     break
                 }
                }
            }
        }
        return iconName
    }
    
    //1.中国默认saas版返回home;
    //2.King(home_king)
    class func getHomeNoLoginDefaultImage() -> String{
       var iconName = "home"
        if let plistpath = Bundle.main.path(forResource: "Info", ofType: "plist"){
            if let dict = NSDictionary.init(contentsOfFile: plistpath){
                if let homeSettingStatus = dict["HomePageStyle"] as? String{
                  switch homeSettingStatus{
                  case "1":
                     iconName = "home"
                  case "2":
                     iconName = "home_king"
                  default:
                     iconName = "home"
                     break
                 }
                }
            }
        }
        return iconName
    }
}
