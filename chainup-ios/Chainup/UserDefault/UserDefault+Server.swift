//
//  UserDefault+Server.swift
//  Chainup
//
//  Created by liuxuan on 2019/11/7.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import UIKit

enum ServerDefaults_Keys: String {
    case domainCfg = "kServerDomainCfg"
    case cerCfg = "kCerCfg"
    case useRootCfg = "kuseRootCfg"
    case isDownloadType = "kIsDownloadType"
    case downloadCerData = "kdownloadCerData"
    case localChoiceDomainCfg = "kLocalChoiceDomainCfg"
}

class EXDefaultKeys {
    fileprivate init() { }
}

class EXDefaultKey<ValueType>: EXDefaultKeys {
    public let key: String
    init(_ key: String) {
        self.key = key
    }
}

extension EXDefaultKeys {
    static let domainCfg = EXDefaultKey<String>(ServerDefaults_Keys.domainCfg.rawValue)
    static let cerCfg = EXDefaultKey<String>(ServerDefaults_Keys.cerCfg.rawValue)
    static let useRootCfg = EXDefaultKey<String>(ServerDefaults_Keys.useRootCfg.rawValue)
    static let isDownloadType = EXDefaultKey<String>(ServerDefaults_Keys.isDownloadType.rawValue)
    static let localChoiceDomainCfg = EXDefaultKey<String>(ServerDefaults_Keys.localChoiceDomainCfg.rawValue)
}


extension UserDefaults {
    
    subscript(key: EXDefaultKey<String>) -> String? {
        set {
            set(newValue, forKey: key.key)
        }
        get {
            return string(forKey: key.key)
        }
    }
    
    func remove(key: ServerDefaults_Keys) {
        removeObject(forKey: key.rawValue)
        self.synchronize()
    }
    
}
