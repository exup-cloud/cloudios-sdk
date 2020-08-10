//
//  EXRealNameOneView.swift
//  Chainup
//
//  Created by zewu wang on 2019/3/27.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import UIKit

class EXRealNameOneView: UIView {
    
    var certificateType : [String] = [LanguageTools.getString(key: "noun_user_identitycard")]
    
    lazy var tableViewNameDatas : [String] = [LanguageTools.getString(key: "kyc_text_country"),LanguageTools.getString(key: "kyc_text_certificateType"),LanguageTools.getString(key: "kyc_text_name"),LanguageTools.getString(key: "kyc_text_certificateNumber")]
    
    lazy var tableViewRowDatas : [EXRealNameEntity] = []
    
    var regionEntity = RegionEntity()
    {
        didSet{
            setDatas()
        }
    }

    lazy var tableView : UITableView = {
        let tableView = UITableView.init(frame: CGRect.zero, style: UITableViewStyle.grouped)
        tableView.extUseAutoLayout()
        tableView.extSetTableView(self, self)
        tableView.extRegistCell([EXRealNameOneTC.classForCoder()], ["EXRealNameOneTC"])
        tableView.estimatedSectionFooterHeight = 200
        return tableView
    }()
    
    lazy var tableViewFootView : UIView = {
        let view = UIView()
//            .init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: 165))
        view.backgroundColor = UIColor.ThemeView.bg
        return view
    }()
    
    lazy var warningLabel : UILabel = {
        let label = UILabel()
        label.extUseAutoLayout()
        label.font = UIFont.ThemeFont.SecondaryRegular
        label.textColor = UIColor.ThemeLabel.colorDark
        label.text = LanguageTools.getString(key: "common_text_tip")
        return label
    }()
    
    lazy var warningInfoLabel : UILabel = {
        let label = UILabel()
        label.extUseAutoLayout()
        label.font = UIFont.ThemeFont.SecondaryRegular
        label.textColor = UIColor.ThemeLabel.colorMedium
        label.text = LanguageTools.getString(key: "common_tip_safetyIdentityAuth")
        label.numberOfLines = 0
        label.layoutIfNeeded()
        return label
    }()
    
    lazy var nextBtn : EXButton = {
        let btn = EXButton()
        btn.extUseAutoLayout()
        btn.isEnabled = false
        btn.extSetAddTarget(self, #selector(clickNextBtn))
        btn.setTitle(LanguageTools.getString(key: "common_action_next"), for: UIControlState.normal)
        return btn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubViews([tableView,nextBtn])
        tableViewFootView.addSubViews([warningLabel,warningInfoLabel])
        tableView.snp.makeConstraints { (make) in
            make.left.right.top.equalToSuperview()
            make.bottom.equalTo(nextBtn.snp.top).offset(-10)
        }
        warningLabel.snp.makeConstraints { (make) in
            make.left.right.equalTo(warningInfoLabel)
            make.bottom.equalTo(warningInfoLabel.snp.top).offset(-5)
            make.height.equalTo(16)
        }
        warningInfoLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.top.equalToSuperview().offset(125)
            make.bottom.equalToSuperview()
        }
        nextBtn.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-30 - TABBAR_BOTTOM)
            make.height.equalTo(44)
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
        }
    }
    
    func setDatas(){
        //如果不是中国大陆，则
        if self.regionEntity.dialingCode != "+86"{
            tableViewNameDatas = [LanguageTools.getString(key: "kyc_text_country"),LanguageTools.getString(key: "kyc_text_certificateType"),LanguageTools.getString(key: "kyc_text_familyName"),LanguageTools.getString(key: "kyc_text_givenName"),LanguageTools.getString(key: "kyc_text_certificateNumber")]
            certificateType = [LanguageTools.getString(key: "kyc_text_passport"),LanguageTools.getString(key: "kyc_text_otherLegal"),LanguageTools.getString(key: "kyc_text_drivingLicense")]
        }
        
        for str in tableViewNameDatas{
            let entity = EXRealNameEntity()
            entity.title = str
            switch str{
            case LanguageTools.getString(key: "kyc_text_country"):
                entity.placeholder = LanguageTools.getString(key: "common_action_select")
                entity.type = "2"
                if BasicParameter.isHan() {
                    entity.text = self.regionEntity.cnName
                }else{
                    entity.text = self.regionEntity.enName
                }
                entity.info = self.regionEntity.dialingCode
                entity.numberCode = self.regionEntity.numberCode
                entity.isUserInteractionEnabled = false
            case LanguageTools.getString(key: "kyc_text_certificateType"):
                entity.placeholder = LanguageTools.getString(key: "common_action_select")
                entity.type = "1"
                if self.regionEntity.dialingCode == "+86"{
                    entity.text = certificateType[0]
                    entity.info = "noun_user_identitycard".localized()
                }else{
                    entity.text = certificateType[0]
                    entity.info = "kyc_text_passport".localized()
                }
            case LanguageTools.getString(key: "kyc_text_name"):
                entity.placeholder = LanguageTools.getString(key: "common_tip_inputRealName")
                entity.type = "2"
                entity.count = 50
            case LanguageTools.getString(key: "kyc_text_familyName"):
                entity.placeholder = LanguageTools.getString(key: "kyc_text_familyName")
                entity.type = "2"
                entity.count = 50
            case LanguageTools.getString(key: "kyc_text_givenName"):
                entity.placeholder = LanguageTools.getString(key: "kyc_text_givenName")
                entity.type = "2"
                entity.count = 50
            case LanguageTools.getString(key: "kyc_text_certificateNumber"):
                entity.placeholder = LanguageTools.getString(key: "personal_tip_inputIdnumber")
                entity.type = "2"
                entity.count = 35
            default:
                break
            }
            tableViewRowDatas.append(entity)
        }
        tableView.reloadData()
    }
    
    @objc func clickNextBtn(){
        let vc = EXRealNameTwoVC()
        vc.mainView.realNameTwoEntity.countryCode = tableViewRowDatas[0].info
        vc.mainView.realNameTwoEntity.numberCode = tableViewRowDatas[0].numberCode
        var certificateType = ""
        switch tableViewRowDatas[1].info {
        case "noun_user_identitycard".localized():
            certificateType = "1"
        case "kyc_text_passport".localized():
            certificateType = "2"
        case "kyc_text_otherLegal".localized():
            certificateType = "3"
        case "kyc_text_drivingLicense".localized():
            certificateType = "4"
        default:
            break
        }
        vc.mainView.realNameTwoEntity.certificateType = certificateType
        if tableViewRowDatas[2].info.count > 50{
            EXAlert.showFail(msg: "common_text_nameMaxLenthError".localized())
            return
        }
        //如果是中国大陆
        if self.regionEntity.dialingCode == "+86"{
            vc.mainView.realNameTwoEntity.userName = tableViewRowDatas[2].info
            vc.mainView.realNameTwoEntity.certificateNumber = tableViewRowDatas[3].info
        }else{//其他
            vc.mainView.realNameTwoEntity.familyName = tableViewRowDatas[2].info
            vc.mainView.realNameTwoEntity.name = tableViewRowDatas[3].info
            vc.mainView.realNameTwoEntity.certificateNumber = tableViewRowDatas[4].info
        }
        if tableViewRowDatas[3].info.count > 35{
            EXAlert.showFail(msg: "common_text_idMaxLenthError".localized())
            return
        }
        self.yy_viewController?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func observerTextField(){
        
        for entity in tableViewRowDatas{
            if entity.info == ""{
                nextBtn.isEnabled = false
                return
            }
        }
        nextBtn.isEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension EXRealNameOneView : UITableViewDelegate , UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return tableViewFootView
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 74
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewRowDatas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let entity = tableViewRowDatas[indexPath.row]
        let cell : EXRealNameOneTC = tableView.dequeueReusableCell(withIdentifier: "EXRealNameOneTC") as! EXRealNameOneTC
        cell.setCell(entity)
        
        cell.textfieldValueChangeBlock = {[weak self] in
            self?.observerTextField()
        }
        
        cell.clickTextBlock = {[weak self](entity,textFieldSelect) in
            guard let mySelf = self else{return}
            if entity.title == LanguageTools.getString(key: "kyc_text_country"){
                let vc = RegionVC()
                vc.clickRegionCellBlock = {rentity in
                    if BasicParameter.isHan() {
                        textFieldSelect.input.text = rentity.cnName
                    }else{
                        textFieldSelect.input.text = rentity.enName
                    }
                    entity.info = rentity.numberCode + rentity.dialingCode
                    mySelf.observerTextField()
                }
                textFieldSelect.normalStyle()
                vc.modalPresentationStyle = .fullScreen

                self?.yy_viewController?.navigationController?.present(vc, animated: true, completion: nil)
//                self?.yy_viewController?.navigationController?.pushViewController(vc, animated: true)
            }else if entity.title == LanguageTools.getString(key: "kyc_text_certificateType"){
                var index = 0
                if let idx = self?.certificateType.index(of:entity.info){
                    index = idx
                }
                let sheet = EXActionSheetView()
                sheet.actionIdxCallback = {(idx) in
                    entity.info = mySelf.certificateType[idx]
                    textFieldSelect.normalStyle()
                    textFieldSelect.input.text = mySelf.certificateType[idx]
                    mySelf.observerTextField()
                }
                sheet.actionCancelCallback =  {() in
                    textFieldSelect.normalStyle()
                }
                sheet.configButtonTitles(buttons:  mySelf.certificateType,selectedIdx: index)
                EXAlert.showSheet(sheetView: sheet)
            }
        }
        return cell
    }
}
