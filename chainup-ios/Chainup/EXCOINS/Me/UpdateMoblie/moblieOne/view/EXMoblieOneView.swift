//
//  EXMoblieOneView.swift
//  Chainup
//
//  Created by zewu wang on 2019/4/13.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import UIKit

class EXMoblieOneView: UIView {
    
    var tableViewRowDatas : [EXBindingBaseEntity] = [EXBindingBaseEntity(),EXBindingBaseEntity()]
    
    lazy var tableView : UITableView = {
        let tableView = UITableView()
        tableView.extUseAutoLayout()
        tableView.extSetTableView(self, self)
        tableView.extRegistCell([EXBindingBaseTC.classForCoder()], ["EXBindingBaseTC"])
        return tableView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        setData()
    }
    
    func setData(){
        for i in 0..<tableViewRowDatas.count{
            let entity = tableViewRowDatas[i]
            switch i {
            case 0:
                entity.type = "0"
                entity.name = LanguageTools.getString(key: "safety_action_activePhone")
                entity.switchType = UserInfoEntity.sharedInstance().isOpenMobileCheck
            case 1:
                entity.type = "1"
                entity.name = UserInfoEntity.sharedInstance().mobileNumber
                entity.rightName = LanguageTools.getString(key: "common_action_edit")
            default:
                break
            }
        }
        tableView.reloadData()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension EXMoblieOneView : UITableViewDelegate , UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 47
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewRowDatas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let entity = tableViewRowDatas[indexPath.row]
        let cell : EXBindingBaseTC = tableView.dequeueReusableCell(withIdentifier: "EXBindingBaseTC") as! EXBindingBaseTC
        cell.setCell(entity)
        cell.tag = 1000 + indexPath.row
        cell.valueChangeCallback = {[weak self](tag , b) in
            guard let mySelf = self else{return}
            if tag == 1000{
                mySelf.switchmoblievalidation(b)
                cell.switchV.setOn(isOn: !b)
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 1{
            let vc = EXMoblieBindingVC()
            self.yy_viewController?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}

extension EXMoblieOneView{
    
    //启用和关闭手机验证
    func switchmoblievalidation(_ b : Bool){
        //开启
        if b == true{
            //直接开启 需要接口
            appApi.rx.request(.openMoblieValidation()).MJObjectMap(EXVoidModel.self).subscribe(onSuccess: {[weak self] (model) in
                UserInfoEntity.sharedInstance().isOpenMobileCheck = "1"
                UserInfoEntity.setTmpDict()
                self?.tableViewRowDatas[0].switchType = "1"
                self?.tableView.reloadData()
                self?.setData()
            }) { (error) in
                
            }.disposed(by: disposeBag)
        }else{//关闭
            if UserInfoEntity.sharedInstance().googleStatus == "0"{
                EXAlert.showFail(msg: LanguageTools.getString(key: "personal_tip_pleaseOpenGoogleFirst"))
                setData()
                return
            }
            validation()
        }
    }
    
    //二次验证
    func validation(){
        let sheet = EXActionSheetView()
        sheet.autoDismiss = false
        sheet.configTextfields(title: "common_text_safetyAuth".localized(), itemModels:self.models())
        sheet.actionFormCallback = {[weak self] formDic in
            guard let mySelf = self else{return}
            guard let googleCode = formDic["googleCode"]else{return}
            guard let smsAuthCode = formDic["smsAuthCode"] else{return}
            if googleCode == "" && smsAuthCode == ""{
                EXAlert.showFail(msg: LanguageTools.getString(key: "login_tip_inputCode"))
                return
            }
            //关闭手机验证
            appApi.rx.request(AppAPIEndPoint.closeMoblie(smsValidCode: smsAuthCode, googleCode: googleCode)).MJObjectMap(EXVoidModel.self).subscribe(onSuccess: { (model) in
                EXAlert.showSuccess(msg: LanguageTools.getString(key: "common_text_phoneAuthOff"))
                UserInfoEntity.sharedInstance().isOpenMobileCheck = "0"
                UserInfoEntity.setTmpDict()
                self?.setData()
                sheet.dismiss()
            }, onError: { (error) in
                
            }).disposed(by: mySelf.disposeBag)
        }
        sheet.itemBtnCallback = {[weak self]key in
            switch key {
            case "smsAuthCode":
                self?.getsmsValidCode()
                break
            default:
                break
            }
        }
        EXAlert.showSheet(sheetView:sheet)
    }
    
    func models()->[EXInputSheetModel] {
        var models : [EXInputSheetModel] = []
        let model1 = EXInputSheetModel.setModel(withTitle:"personal_text_googleCode".localized(),key:"googleCode",placeHolder: "common_tip_googleAuth".localized(), type: .paste , keyBoard:.numberPad)
        let model2 = EXInputSheetModel.setModel(withTitle:"personal_text_phoneCode".localized(),key:"smsAuthCode",placeHolder: "personal_tip_inputPhoneCode".localized(), type: .sms)
        models.append(model2)
        models.append(model1)
        return models
    }
    
    //获取手机验证码
    func getsmsValidCode(){
        appApi.rx.request(.getsmsValidCode(token: XUserDefault.getToken() ?? "", operationType: EXSendVerificationCode.closegoogleAndmoblie, countryCode: "", mobile: "")).MJObjectMap(EXVoidModel.self).subscribe(onSuccess: { (m) in
        }) { (erro) in
            
            }.disposed(by: disposeBag)
    }
    
}
