//
//  EXSetView.swift
//  Chainup
//
//  Created by zewu wang on 2019/3/25.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import UIKit

enum EXSettingAction {
    case lan
    case klineColor
    case theme
    case push
    case changeHost
    case none
}


class EXSetView: UIView {
    
    var pfIndex = 0
    let pfDatas : [String] = [LanguageTools.getString(key: "customSetting_action_themeDay"),
                              LanguageTools.getString(key: "customSetting_action_themeNight")]
    
    var zdIndex = 0
    let zdDatas : [String] = [LanguageTools.getString(key: "customSetting_action_global"),
                              LanguageTools.getString(key: "customSetting_action_china")]
    
    var tableViewNameDatas : [String] = [LanguageTools.getString(key: "customSetting_action_language"),
                                         LanguageTools.getString(key: "customSetting_action_kline"),
                                         LanguageTools.getString(key: "customSetting_action_theme")]
    lazy var changeHostEntity : EXSetEntity = {
        let entity = EXSetEntity()
        entity.name = "customSetting_action_changeHost".localized()
        entity.action = .changeHost
        return entity
    }()
    
    lazy var pushEntity : EXSetEntity = {
        let entity = EXSetEntity()
        entity.name = "customSetting_action_pushSetting".localized()
        entity.action = .push
        return entity
    }()
    
    var tableViewRowDatas : [EXSetEntity] = []

    lazy var tableView : UITableView = {
        let tableView = UITableView()
        tableView.extUseAutoLayout()
        tableView.extSetTableView(self, self)
        tableView.extRegistCell([EXSetTC.classForCoder()], ["EXSetTC"])
        return tableView
    }()
    
    lazy var logoutBtn : EXButton = {
        let btn = EXButton()
        btn.extUseAutoLayout()
        btn.extSetCornerRadius(1.5)
        btn.backgroundColor = UIColor.ThemeBtn.highlight
        btn.setTitle(LanguageTools.getString(key: "common_text_logout"), for: UIControlState.normal)
        btn.extSetAddTarget(self, #selector(clickLogoutBtn))
        return btn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubViews([tableView,logoutBtn])
        tableView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.bottom.equalTo(logoutBtn.snp.top)
        }
        logoutBtn.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.bottom.equalToSuperview().offset(-30 - TABBAR_BOTTOM)
            make.height.equalTo(44)
        }
        if XUserDefault.getToken() == nil{
            logoutBtn.isHidden = true
        }
        setData()
    }
    
    func rowActions()->[EXSettingAction] {
        return [.lan,.klineColor,.theme]
    }
    
    func setData(){
        
        var arr : [EXSetEntity] = []
        for (idx,str) in tableViewNameDatas.enumerated() {
            let entity = EXSetEntity()
            entity.name = str
            entity.action = rowActions()[idx]
            switch str{
            case LanguageTools.getString(key: "customSetting_action_language"):
                entity.rightName = "noun_language".localized()
            case LanguageTools.getString(key: "customSetting_action_kline"):
                entity.rightName = EXKLineManager.isGreen() ? zdDatas[0] : zdDatas[1]
            case LanguageTools.getString(key: "customSetting_action_theme"):
                entity.rightName = EXThemeManager.isNight() ? pfDatas[1] : pfDatas[0]
            default:
                break
            }
            arr.append(entity)
        }
        
        if PublicInfoEntity.sharedInstance.appPushSwitch == "1" &&
            !arr.contains(pushEntity){
            arr.append(pushEntity)
        }
        
        if let hosts = EXNetworkDoctor.sharedManager.hosts,hosts.count > 0 &&
            !arr.contains(changeHostEntity){
            arr.append(changeHostEntity)
        }
        tableViewRowDatas = arr
        
        tableView.reloadData()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension EXSetView : UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 52
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewRowDatas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let entity = tableViewRowDatas[indexPath.row]
        let cell : EXSetTC = tableView.dequeueReusableCell(withIdentifier: "EXSetTC") as! EXSetTC
        cell.setCell(entity)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let entity = tableViewRowDatas[indexPath.row]
        switch entity.action {
        case .lan:
            let vc = EXSetLanguageVC()
            self.yy_viewController?.navigationController?.pushViewController(vc, animated: true)
        case .klineColor:
            roseFallSheet(entity)
        case .theme:
            skinSheet(entity)
        case .push:
            break
        case .changeHost:
            let vc = EXChangeHostVC()
            vc.links = EXNetworkDoctor.sharedManager.hosts
            self.yy_viewController?.navigationController?.pushViewController(vc, animated: true)
            break
        case .none:
            break
        }
    }
}

extension EXSetView{
    
    //点击退出登录按钮
    @objc func clickLogoutBtn(){
        
        let view = EXNormalAlert()
        view.configAlert(title: "",message:"common_tip_logoutDesc".localized())
        view.alertCallback = {(tag) in
            if tag == 0{
                XUserDefault.removeKey(key: XUserDefault.token)
                //            UserInfoEntity.removeAllData()
                EXAlert.showSuccess(msg: LanguageTools.getString(key: "common_action_logout"))
                self.yy_viewController?.navigationController?.popToRootViewController(animated: true)
            }
        }
        EXAlert.showAlert(alertView: view)
    }
    
    func roseFallSheet(_ entity : EXSetEntity){
        let sheet = EXActionSheetView()
        sheet.actionIdxCallback = {[weak self](idx) in
            guard let mySelf = self else{return}
            if EXKLineManager.isGreen() == true{
                if idx == 0{
                    return
                }
            }else{
                if idx == 1{
                    return
                }
            }
            if let setting = EXKLineManager(rawValue: idx) {
                EXKLineManager.switchTo(theme:setting)
            }
            mySelf.zdIndex = idx
            mySelf.setData()
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now(), execute: {
                mySelf.yy_viewController?.navigationController?.popToRootViewController(animated: false)
                BusinessTools.reloadWindow()
                XHUDManager.sharedInstance.dismissWithDelay {
                    
                }
            })
        }
        var idx = 0
        for i in 0..<zdDatas.count{
            if zdDatas[i] == entity.rightName{
                idx = i
                break
            }
        }
        sheet.configButtonTitles(buttons:  zdDatas,selectedIdx: idx)
        EXAlert.showSheet(sheetView: sheet)
        
    }
    
    func skinSheet(_  entity : EXSetEntity){
        let sheet = EXActionSheetView()
        sheet.actionIdxCallback = {[weak self](idx) in
            guard let mySelf = self else{return}
            //清理抽屉单例
            ContractDrawerView.clearSharedInstance()
            SLSwapDrawerView.clearSharedInstance()
            
            if EXThemeManager.isNight() == true{
                if idx == 1{
                    return
                }
            }else{
                if idx == 0{
                    return
                }
            }
            EXThemeManager.switchNight(isToNight:(idx == 1))
            mySelf.pfIndex = idx
            mySelf.setData()
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now(), execute: {
                mySelf.yy_viewController?.navigationController?.popToRootViewController(animated: false)
                BusinessTools.reloadWindow()
                XHUDManager.sharedInstance.dismissWithDelay {
                    
                }
            })
        }
        var idx = 0
        for i in 0..<zdDatas.count{
            if pfDatas[i] == entity.rightName{
                idx = i
                break
            }
        }
        sheet.configButtonTitles(buttons:  pfDatas,selectedIdx: idx)
        EXAlert.showSheet(sheetView: sheet)
    }
}
