//
//  LanguageBase.swift
//  Chainup
//
//  Created by zewu wang on 2018/8/7.
//  Copyright © 2018年 zewu wang. All rights reserved.
//

import UIKit
import RxSwift

class LanguageBase: NSObject {

    public var subject : BehaviorSubject<Int> = BehaviorSubject.init(value: 0)
    
    var items : [(Any,Selector)] = []
    
    //MARK:单例
    public static var sharedInstance : LanguageBase{
        struct Static {
            static let instance : LanguageBase = LanguageBase()
        }
        return Static.instance
    }
    
    //订阅，会更改语言的热信号
    class func getSubjectAsobsever() -> BehaviorSubject<Int>{
        return LanguageBase.sharedInstance.subject.asObserver()
    }
    
}
