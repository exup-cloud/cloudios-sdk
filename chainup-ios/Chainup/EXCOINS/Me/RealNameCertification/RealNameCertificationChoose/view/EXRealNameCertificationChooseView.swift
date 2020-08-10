//
//  EXRealNameCertificationChooseView.swift
//  Chainup
//
//  Created by zewu wang on 2019/7/30.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import UIKit
import RxSwift

class EXRealNameCertificationChooseView: UIView {
    
    lazy var tableViewNameDatas : [String] = [LanguageTools.getString(key: "kyc_text_country")]
    
    lazy var tableViewRowDatas : [EXRealNameEntity] = []
    
    var regionEntity = RegionEntity()
    {
        didSet{
            if tableViewRowDatas.count > 0{
                if BasicParameter.isHan() {
                    tableViewRowDatas[0].text = regionEntity.cnName
                }else{
                    tableViewRowDatas[0].text = regionEntity.enName
                }
                tableViewRowDatas[0].info = regionEntity.dialingCode
                tableViewRowDatas[0].numberCode = regionEntity.numberCode
                tableView.reloadData()
            }
        }
    }

    lazy var tableView : UITableView = {
        let tableView = UITableView()
        tableView.extUseAutoLayout()
        tableView.extSetTableView(self, self)
        tableView.extRegistCell([EXRealNameOneTC.classForCoder()], ["EXRealNameOneTC"])
        return tableView
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
        tableView.snp.makeConstraints { (make) in
            make.left.right.top.equalToSuperview()
            make.bottom.equalTo(nextBtn.snp.top).offset(-10)
        }
        nextBtn.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-30 - TABBAR_BOTTOM)
            make.height.equalTo(44)
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
        }
        setDatas()
    }
    
    func setDatas(){
        for str in tableViewNameDatas{
            let entity = EXRealNameEntity()
            entity.title = str
            switch str{
            case LanguageTools.getString(key: "kyc_text_country"):
                entity.placeholder = LanguageTools.getString(key: "common_action_select")
                entity.type = "1"
                if let rentity = CountryList.getRegion(UserInfoEntity.sharedInstance().countryCode){
                    regionEntity = rentity
                    if BasicParameter.isHan() {
                        entity.text = regionEntity.cnName
                    }else{
                        entity.text = regionEntity.enName
                    }
                    entity.info = regionEntity.dialingCode
                    entity.numberCode = regionEntity.numberCode
                }else if let rentity = CountryList.getRegionWithNumber(PublicInfoEntity.sharedInstance.default_country_code_real){
                    regionEntity = rentity
                    if BasicParameter.isHan() {
                        entity.text = regionEntity.cnName
                    }else{
                        entity.text = regionEntity.enName
                    }
                    entity.info = regionEntity.dialingCode
                    entity.numberCode = regionEntity.numberCode
                }else if let rentity = CountryList.getRegion(PublicInfoEntity.sharedInstance.default_country_code){
                    regionEntity = rentity
                    if BasicParameter.isHan() {
                        entity.text = regionEntity.cnName
                    }else{
                        entity.text = regionEntity.enName
                    }
                    entity.info = regionEntity.dialingCode
                    entity.numberCode = regionEntity.numberCode
                }
            default:
                break
            }
            tableViewRowDatas.append(entity)
        }
        tableView.reloadData()
        observerTextField()
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
    
    //获取数据
    func getData(){
        appApi.hideAutoLoading()
        appApi.rx.request(AppAPIEndPoint.kycGetToken).MJObjectMap(EXRealNameModel.self).subscribe(onSuccess: {[weak self] (model) in
            EXRealNameModelManager.sharedInstance.model = model
            self?.gotoNext()
        }) {[weak self] (error) in
            self?.gotoNext()
            }.disposed(by: disposeBag)
    }
    
    //获取文案
    func getLanguage(){
        appApi.hideAutoLoading()
        appApi.rx.request(AppAPIEndPoint.kycGetWriting).MJObjectMap(EXRealNameWriteModel.self).subscribe(onSuccess: { (model) in
            EXRealNameModelManager.sharedInstance.model.language = model.language
        }) { (error) in
            
            }.disposed(by: disposeBag)
    }
    
    //点击下一步
    @objc func clickNextBtn(){
        nextBtn.showLoading()
        //如果设置打开，并且选择的是中国+86
        if PublicInfoEntity.sharedInstance.interfaceSwitch == "1" && self.regionEntity.dialingCode == "+86"{
            getData()
        }else{
            gotoNext()
        }
    }
    
    //进入下一步
    func gotoNext(){
        nextBtn.hideLoading()
        if EXRealNameModelManager.sharedInstance.model.openAuto == "1" && self.regionEntity.dialingCode == "+86" && EXRealNameModelManager.sharedInstance.model.limitFlag != "1"{//如果有kyc且为中国大陆且没有超过限制,则进入kyc验证,
            self.yy_viewController?.navigationController?.popViewController(animated: false)
            guard let appDelegate = UIApplication.shared.delegate else {
                return
            }
            let vc = WebVC()
            vc.modalPresentationStyle = .fullScreen
            vc.loadUrl(EXRealNameModelManager.sharedInstance.model.toKenUrl)
            appDelegate.window??.rootViewController?.present(vc, animated: true, completion: nil)
            return
        }
        
        appApi.rx.request(AppAPIEndPoint.kycConfig).MJObjectMap(EXKYCConfigModel.self,false).subscribe(onSuccess: {[weak self] (model) in
            guard let mySelf = self else{return}
             //如果singpass开启 则singpass，如果没开但是选择了模板2 也要跳转
            if model.openSingPass == "1" || model.verfyTemplet == "2"{
                var url = ""
                if model.openSingPass == "1"{//singpass的url
                    url = model.h5_singpass_url
                }else{//模板2的url
                    url = model.h5_templet2_url
                }
                let country = mySelf.regionEntity.numberCode
                let countryKeyCode = mySelf.regionEntity.dialingCode.replacingOccurrences(of: "+", with: "")
                RegionManager.sharedInstance.regionEntity = mySelf.regionEntity
                if let url1 = URL.init(string: url){
                    if let _ = url1.query {
                        url = url + "&country=" + country + "&countryKeyCode=" + countryKeyCode
                    }else {
                        url = url + "?country=" + country + "&countryKeyCode=" + countryKeyCode
                    }
                }
                self?.yy_viewController?.navigationController?.popViewController(animated: false)
                guard let appDelegate = UIApplication.shared.delegate else {
                    return
                }
                let vc = WebVC()
                vc.modalPresentationStyle = .fullScreen
                vc.loadUrl(url)
                appDelegate.window??.rootViewController?.present(vc, animated: true, completion: nil)
            }else{
                //其他情况进入人工审核
                self?.gotoRealName()
            }
        }) {[weak self] (error) in
            self?.gotoRealName()
        }.disposed(by: disposeBag)
        
    }
    
    func gotoRealName(){
        //进入人工审核
        let vc = EXRealNameOneVC()
        vc.mainView.regionEntity = self.regionEntity
        self.yy_viewController?.navigationController?.pushViewController(vc, animated: true)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension EXRealNameCertificationChooseView : UITableViewDelegate , UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 74
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewNameDatas.count
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
                    mySelf.regionEntity = rentity
                    mySelf.observerTextField()
                }
                textFieldSelect.normalStyle()
                vc.modalPresentationStyle = .fullScreen
                self?.yy_viewController?.navigationController?.present(vc, animated: true, completion: nil)
            }
        }
        return cell
    }
}
