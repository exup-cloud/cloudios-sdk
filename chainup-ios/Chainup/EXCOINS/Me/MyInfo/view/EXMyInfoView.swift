//
//  EXMyInfoView.swift
//  Chainup
//
//  Created by zewu wang on 2019/3/25.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import UIKit
import RxSwift

class EXMyInfoView: UIView {
    
    var tableViewNameDatas : [String] = [LanguageTools.getString(key: "otcSafeAlert_action_nickname"),LanguageTools.getString(key: "userinfo_text_account"),LanguageTools.getString(key: "userinfo_text_accountState"),LanguageTools.getString(key: "otcSafeAlert_action_identify")]
//    LanguageTools.getString(key: "头像"),
    
    var tableViewRowDatas : [EXMyInfoEntity] = []

    lazy var tableView : UITableView = {
        let tableView = UITableView()
        tableView.extUseAutoLayout()
        tableView.extSetTableView(self, self)
        tableView.extRegistCell([EXMyInfoTC.classForCoder()], ["EXMyInfoTC"])
        return tableView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
//        setData()
    }
    
    func setData(){
        var arr : [EXMyInfoEntity] = []
        for str in tableViewNameDatas{
            let entity = EXMyInfoEntity()
            entity.name = str
            switch str{
            case LanguageTools.getString(key: "noun_account_avatar"):
                entity.rightImgName = "1"
            case LanguageTools.getString(key: "otcSafeAlert_action_nickname"):
                entity.rightBtnBool = false
                var nickName = LanguageTools.getString(key: "personal_text_setNickname")
                if UserInfoEntity.sharedInstance().nickName.ch_length > 0{
                    nickName =  UserInfoEntity.sharedInstance().nickName
                }
                entity.rightInfo = nickName
            case LanguageTools.getString(key: "userinfo_text_account"):
                entity.rightInfo = UserInfoEntity.sharedInstance().userAccount
            case LanguageTools.getString(key: "userinfo_text_accountState"):
                var accountStatus = ""
                switch  UserInfoEntity.sharedInstance().accountStatus{
                case "0":
                    accountStatus = LanguageTools.getString(key: "noun_account_normal")
                case "1":
                    accountStatus = LanguageTools.getString(key: "noun_account_freezeAll")
                case "2":
                    accountStatus = LanguageTools.getString(key: "noun_account_freezeTransaction")
                case "3":
                    accountStatus = LanguageTools.getString(key: "noun_account_freezeWithdraw")
                default:
                    break
                }
                entity.rightInfo = accountStatus
            case LanguageTools.getString(key: "otcSafeAlert_action_identify"):
                var authLevel = ""
                switch  UserInfoEntity.sharedInstance().authLevel{
                case "0":
                    entity.rightBtnBool = false
                    authLevel = LanguageTools.getString(key: "noun_login_pending")
                case "1":
                    authLevel = LanguageTools.getString(key: "personal_text_verified")
                default:
                    entity.rightBtnBool = false
                    authLevel = LanguageTools.getString(key: "personal_text_unverified")
                    break
                }
                entity.rightInfo = authLevel
            case "register_text_inviteCode".localized():
                entity.rightInfo = UserInfoEntity.sharedInstance().inviteCode
            default:
                break
            }
            arr.append(entity)
        }
        tableViewRowDatas = arr
        tableView.reloadData()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension EXMyInfoView : UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 52
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewRowDatas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let entity = tableViewRowDatas[indexPath.row]
        let cell : EXMyInfoTC = tableView.dequeueReusableCell(withIdentifier: "EXMyInfoTC") as! EXMyInfoTC
        cell.setCell(entity)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let entity = tableViewRowDatas[indexPath.row]
        switch entity.name{
        case LanguageTools.getString(key: "头像"):
            break
        case LanguageTools.getString(key: "otcSafeAlert_action_nickname"):
            updateNickName()
        case LanguageTools.getString(key: "userinfo_text_account"):
            break
        case LanguageTools.getString(key: "userinfo_text_accountState"):
            break
        case LanguageTools.getString(key: "otcSafeAlert_action_identify"):
            /**
             * 认证类型
             *  认证状态 0、审核中，1、通过，2、未通过  3未认证
             */
            switch  UserInfoEntity.sharedInstance().authLevel{
            case "0":
               gotoRealNameWait()
//                EXAlert.showWarning(msg: "审核中")
                break
            case "1":
                EXAlert.showWarning(msg: "personal_text_verified".localized())
                break
            case "2":
                gotoRealNameCertification()
                break
            default:
                gotoRealNameCertification()
                break
            }
        default:
            break
        }
    }
}

extension EXMyInfoView{
    
    func updateNickName(){
        let sheet = EXActionSheetView()
        sheet.configTextfields(title: LanguageTools.getString(key: "userinfo_text_nickname"), itemModels:self.models())
        sheet.actionFormCallback = {[weak self] formDic in
            guard let mySelf = self else{return}
            if formDic["nickname"] == ""{
                EXAlert.showFail(msg: LanguageTools.getString(key: "personal_tip_inputNickname"))
                return
            }
            if let nickname = formDic["nickname"] , nickname.count > 10{
                EXAlert.showFail(msg: "userinfo_tip_inputNickname".localized())
                return
            }
            appApi.rx.request(AppAPIEndPoint.updateNickname(nickname: formDic["nickname"] ?? "")).MJObjectMap(EXVoidModel.self).subscribe(onSuccess: {(m) in
                UserInfoEntity.sharedInstance().nickName = formDic["nickname"] ?? ""
                UserInfoEntity.setTmpDict()
                mySelf.setData()
                }, onError: { (error) in
                    
            }).disposed(by: mySelf.disposeBag)
            print(formDic)
        }
        EXAlert.showSheet(sheetView:sheet)
    }
    
    func models()->[EXInputSheetModel] {
        let model = EXInputSheetModel.setModel(withTitle:"",key:"nickname",placeHolder: "userinfo_tip_inputNickname".localized(), type: .input)
        return[model]
    }
    
    func gotoRealNameCertification(){
        let vc = EXRealNameCertificationChooseVC()
        self.yy_viewController?.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func gotoRealNameWait(){
        let vc = EXRealNameThreeVC()
        self.yy_viewController?.navigationController?.pushViewController(vc, animated: true)
    }
    
}
