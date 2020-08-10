//
//  EXThemeManager.swift
//  Chainup
//
//  Created by liuxuan on 2019/3/30.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import UIKit
import SwiftTheme

let THEME_CHANGE_NOTI = "THEME_CHANGE_NOTI"
let KLINE_CHANGE_NOTI = "KLINE_CHANGE_NOTI"

private let lastThemeIndexKey = "lastedThemeIndex"
private let lastedKlineIndex = "lastedKlineIndex"

private let defaults = UserDefaults.standard

enum EXThemeManager: Int {
    
    case day   = 0
    case night = 1
    // MARK: -
    static var current = EXThemeManager.day
    static var before = EXThemeManager.day
    
    // MARK: - Switch Theme
    static func switchTo(theme: EXThemeManager) {
        before = current
        current = theme
        switch theme {
        case .day:
            ThemeManager.setTheme(plistName: "DayTheme", path: .mainBundle)
        case .night:
            ThemeManager.setTheme(plistName: "NightTheme", path: .mainBundle)
        }
        saveLastTheme()
        NotificationCenter.default.post(name: NSNotification.Name.init(THEME_CHANGE_NOTI),object: nil)
    }
    
    static func switchNight(isToNight: Bool) {
        switchTo(theme: isToNight ? .night : before)
    }
    
    static func isNight() -> Bool {
        return current == .night
    }
    
    static func restoreLastTheme() {
        let idx = defaults.integer(forKey: lastThemeIndexKey)
        let temptheme = EXThemeManager(rawValue: idx)
        if let themem = temptheme {
            switchTo(theme:themem)
        }else {
            switchTo(theme: .day)
        }
        EXKLineManager.restoreLastKline()
    }
    
    static func saveLastTheme() {
        defaults.set(current.rawValue, forKey: lastThemeIndexKey)
    }
}


enum EXKLineManager: Int {
    case green = 0
    case red = 1
    // MARK: -
    static var current = EXKLineManager.green
    static var before = EXKLineManager.green
    
    // MARK: - Switch Theme
    static func switchTo(theme: EXKLineManager) {
        before = current
        current = theme
        switch theme {
        case .green:
            break
        case .red:
            break
        }
        saveLastKline()
        NotificationCenter.default.post(name: NSNotification.Name.init(KLINE_CHANGE_NOTI),object: nil)
    }

    static func isGreen() -> Bool {
        return current == .green
    }
    
    static func restoreLastKline() {
        let idx = defaults.integer(forKey: lastedKlineIndex)
        let temptheme = EXKLineManager(rawValue: idx)
        if let themem = temptheme {
            switchTo(theme:themem)
        }else {
            switchTo(theme: .green)
        }
    }
    
    static func saveLastKline() {
        defaults.set(current.rawValue, forKey: lastedKlineIndex)
    }
    
}

