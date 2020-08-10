//
//  EXRealNameTwoView.swift
//  Chainup
//
//  Created by zewu wang on 2019/3/28.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import UIKit
import RxSwift

class EXRealNameTwoView: UIView , EXImagePickerDelegate {
    
    lazy var pickerController:EXImagePicker = {
        let pickC = EXImagePicker.init()
        pickC.delegate = self
        return pickC
    }()
    let uploader:EXImageUploader = EXImageUploader.init()
    
    var realNameTwoEntity = EXRealNameTwoEntity()
    
    var entity = UploadFileTokenEntity()
    
    var realBtnEntity = EXRealBtnEntity()
    
    var tableViewNameDatas : [String] = [LanguageTools.getString(key: "common_action_uploadFrontView"),LanguageTools.getString(key: "common_action_uploadBackView"),LanguageTools.getString(key: "common_action_uplodadIdInHand")]
    
    var tableViewRowDatas : [EXRealBtnEntity] = []
    
    lazy var tableView : UITableView = {
        let tableView = UITableView.init(frame: CGRect.zero, style: UITableViewStyle.grouped)
        tableView.extUseAutoLayout()
        tableView.extSetTableView(self, self)
        tableView.extRegistCell([EXRealNameTwoTC.classForCoder()], ["EXRealNameTwoTC"])
        tableView.estimatedSectionFooterHeight = 100
        return tableView
    }()
    
    lazy var tableFooterView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.ThemeView.bg
        return view
    }()
    
    lazy var nextBtn : EXButton = {
        let btn = EXButton()
        btn.extUseAutoLayout()
//        btn.isEnabled = false
        btn.extSetCornerRadius(1.5)
        btn.backgroundColor = UIColor.ThemeBtn.highlight
        btn.setTitle(LanguageTools.getString(key: "common_action_next"), for: UIControlState.normal)
        btn.rx.tap.asObservable()
            .throttle(1, scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                guard let `self` = self else { return }
                self.clickNextBtn()
            }).disposed(by: self.disposeBag)
        return btn
    }()
    
    lazy var warningLabel : UILabel = {
        let label = UILabel()
        label.extUseAutoLayout()
        label.font = UIFont.ThemeFont.SecondaryRegular
        label.textColor = UIColor.ThemeLabel.colorDark
        label.text = LanguageTools.getString(key: "common_tip_uploadImgRequire")
        return label
    }()
    
    lazy var warningInfoLabel : UILabel = {
        let label = UILabel()
        label.extUseAutoLayout()
        label.numberOfLines = 0
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubViews([tableView])
        tableFooterView.addSubViews([nextBtn,warningLabel,warningInfoLabel])
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        nextBtn.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.top.equalToSuperview().offset(30)
            make.height.equalTo(44)
        }
        warningLabel.snp.makeConstraints { (make) in
            make.top.equalTo(nextBtn.snp.bottom).offset(30)
            make.height.equalTo(16)
            make.left.right.equalTo(nextBtn)
        }
        warningInfoLabel.snp.makeConstraints { (make) in
            make.top.equalTo(warningLabel.snp.bottom).offset(5)
            make.left.right.equalTo(nextBtn)
            make.bottom.equalToSuperview().offset(-30 - TABBAR_BOTTOM)
        }
        setDatas()
        uploader.rx_imgUrl.skip(1)
            .subscribe(onNext: { [weak self] imgUrl in
                guard let mySelf = self else { return }
                mySelf.realBtnEntity.imgUrl = imgUrl
            }).disposed(by: self.disposeBag)
        uploader.rx_img.skip(1)
            .subscribe(onNext: { [weak self] img in
                guard let mySelf = self else { return }
                mySelf.realBtnEntity.image = img
                mySelf.tableView.reloadData()
            }).disposed(by: self.disposeBag)
        
    }
    
    func setDatas(){
        for str in tableViewNameDatas{
            let entity = EXRealBtnEntity()
            entity.title = str
            switch str{
            case LanguageTools.getString(key: "common_action_uploadFrontView"):
                entity.placeholderImg = "personal_positiveupload"
            case LanguageTools.getString(key: "common_action_uploadBackView"):
                entity.placeholderImg = "personal_uploadreverse"
            case LanguageTools.getString(key: "common_action_uplodadIdInHand"):
                entity.placeholderImg = "personal_handhelddocuments"
            default:
                break
            }
            tableViewRowDatas.append(entity)
        }
        setWarningInfoLabel()
        tableView.reloadData()
    }
    
    func setWarningInfoLabel(){
        var att = "kyc_explain_photoTip".localized()
        if EXRealNameModelManager.sharedInstance.model.language == ""{
            att = att + "\n" + "kyc_explain_lastTip".localized()
        }else{
            att = att + "\n4." + EXRealNameModelManager.sharedInstance.model.language
        }
        let paraph = NSMutableParagraphStyle()
        //将行间距设置为6
        paraph.lineSpacing = 6
        //样式属性集合
        let attributeText = NSMutableAttributedString().add(string: att, attrDic: [NSAttributedStringKey.font : UIFont.ThemeFont.SecondaryRegular,NSAttributedStringKey.foregroundColor :  UIColor.ThemeLabel.colorMedium ,NSAttributedStringKey.paragraphStyle : paraph])
        warningInfoLabel.attributedText = attributeText
    }
    
    //点击实名下一步
    @objc func clickNextBtn(){
        for entity in tableViewRowDatas{
            if entity.imgUrl == ""{
                EXAlert.showFail(msg: LanguageTools.getString(key: "common_tip_pleaseUpload"))
                return
            }
        }
        appApi.rx.request(AppAPIEndPoint.authRealname(countryCode: realNameTwoEntity.countryCode, certificateType: realNameTwoEntity.certificateType, userName: realNameTwoEntity.userName, certificateNumber: realNameTwoEntity.certificateNumber, firstPhoto: tableViewRowDatas[0].imgUrl, secondPhoto: tableViewRowDatas[1].imgUrl, thirdPhoto: tableViewRowDatas[2].imgUrl, familyName: realNameTwoEntity.familyName, name: realNameTwoEntity.name,numberCode: realNameTwoEntity.numberCode)).MJObjectMap(EXBaseModel.self).subscribe(onSuccess: {[weak self] (model) in
            UserInfoEntity.sharedInstance().authLevel = "0"
            UserInfoEntity.setTmpDict()
            self?.yy_viewController?.navigationController?.popViewController(animated: false)
            NotificationCenter.default.post(name: NSNotification.Name.init("RealNameTwoNotification"), object: nil)
        }) { (error) in
            
        }.disposed(by: disposeBag)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension EXRealNameTwoView : UITableViewDelegate , UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return tableFooterView
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewRowDatas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let entity = tableViewRowDatas[indexPath.row]
        let cell : EXRealNameTwoTC = tableView.dequeueReusableCell(withIdentifier: "EXRealNameTwoTC") as! EXRealNameTwoTC
        cell.setCell(entity)
        cell.tag = 1000 + indexPath.row
        cell.clickBtnBlock = {[weak self](tag) in
            guard let mySelf = self else{return}
            mySelf.realBtnEntity = mySelf.tableViewRowDatas[tag]
            mySelf.chooseImg()
        }
        return cell
    }
    
}

extension EXRealNameTwoView : UIImagePickerControllerDelegate & UINavigationControllerDelegate{
    
    func chooseImg(){
        
        let arr : [String] = [LanguageTools.getString(key: "noun_camera_takephoto"),LanguageTools.getString(key: "noun_camera_takeAlbum")]
        let sheet = EXActionSheetView()
        sheet.actionIdxCallback = {[weak self](idx) in
            guard let mySelf = self else{return}
            mySelf.handlePhoto(idx)
        }
        sheet.configButtonTitles(buttons: arr)
        EXAlert.showSheet(sheetView: sheet)
        
    }
    
    func handlePhoto(_ sheetIdx : Int){
        if sheetIdx == 0 {
            pickerController.selectImageFromCameraSuccess({[weak self] (picker) in
                guard let `self` = self else {return}
                picker.modalPresentationStyle = .fullScreen
                self.yy_viewController?.present(picker, animated: true, completion: nil)
                },Fail: {
                    
            })
        }else if sheetIdx == 1 {
            pickerController.selectImageFromAlbumSuccess({[weak self] (picker) in
                guard let `self` = self else {return}
                picker.modalPresentationStyle = .fullScreen
                self.yy_viewController?.present(picker, animated: true, completion: nil)
                },Fail: {
                    
            })
        }
    }
}

extension EXRealNameTwoView {
    
    func selectImageFinished(_ image: UIImage) {
        uploader.uploadImage(img: image , type : "1" , imgUrlType : "half")
    }
    
}


