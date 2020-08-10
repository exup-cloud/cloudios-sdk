//
//  EXInviteView.swift
//  Chainup
//
//  Created by zewu wang on 2019/6/17.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import UIKit
import YYWebImage

class EXInviteView: UIView {
    
    let proportion : CGFloat = SCREEN_WIDTH / 375
    
    lazy var imgV : UIImageView = {
        let imgV = UIImageView()
        imgV.extUseAutoLayout()
//        if BasicParameter.isHan(){
//            imgV.image = UIImage.init(named: "online_chinese")
//        }else{
//            imgV.image = UIImage.init(named: "online_english")
//        }
        return imgV
    }()
    
    lazy var inviteCodeImgV : UIImageView = {
        let imgV = UIImageView()
        imgV.extUseAutoLayout()
        if UserInfoEntity.sharedInstance().inviteUrl != ""{
            imgV.image = QRCodeCreate().creteScancode(UserInfoEntity.sharedInstance().inviteUrl)
        }
        return imgV
    }()
    
    lazy var inviteCodeLabel : UILabel = {
        let label = UILabel()
        label.extUseAutoLayout()
        let att = NSMutableAttributedString().add(string: "register_text_inviteCode".localized(), attrDic: [NSAttributedStringKey.font : UIFont.ThemeFont.BodyRegular , NSAttributedStringKey.foregroundColor : UIColor.ThemeLabel.colorMedium]).add(string: " " + UserInfoEntity.sharedInstance().inviteCode, attrDic: [NSAttributedStringKey.font : UIFont.ThemeFont.BodyRegular , NSAttributedStringKey.foregroundColor : UIColor.ThemeLabel.colorLite])
        label.attributedText = att
        return label
    }()
    
    lazy var copyBtn : EXInviteCopyBtn = {
        let btn = EXInviteCopyBtn()
        btn.extUseAutoLayout()
        btn.layoutIfNeeded()
        btn.extSetCornerRadius(1.5)
        btn.backgroundColor = UIColor.ThemeTab.bg
        btn.extSetAddTarget(self, #selector(copyInviteCode))
        return btn
    }()
    
    lazy var saveBtn : UIButton = {
        let btn = UIButton()
        btn.extUseAutoLayout()
        btn.backgroundColor = UIColor.ThemeTab.bg
        btn.setTitleColor(UIColor.ThemeLabel.colorLite, for: UIControlState.normal)
        btn.setTitle("common_action_savePoster".localized(), for: UIControlState.normal)
        btn.titleLabel?.font = UIFont.ThemeFont.HeadBold
        btn.extSetAddTarget(self, #selector(screenshotsV))
        return btn
    }()
    
    lazy var copylinkBtn : UIButton = {
        let btn = UIButton()
        btn.extUseAutoLayout()
        btn.backgroundColor = UIColor.ThemeBtn.highlight
        btn.setTitleColor(UIColor.white, for: UIControlState.normal)
        btn.setTitle("common_action_copyLink".localized(), for: UIControlState.normal)
        btn.titleLabel?.font = UIFont.ThemeFont.HeadBold
        btn.extSetAddTarget(self, #selector(copyLinkUrl))
        return btn
    }()
    
    lazy var logoImgV : UIImageView = {
        let imgV = UIImageView()
        imgV.extUseAutoLayout()
        if let url = URL.init(string:  PublicInfoEntity.sharedInstance.app_logo_list_new.logo_black){
            imgV.yy_setImage(with: url, options: YYWebImageOptions.allowBackgroundTask)
        }
        return imgV
    }()
    
    lazy var screenV : EXInviteScreenshotsV = {
        let view = EXInviteScreenshotsV.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: 603 * proportion))
        view.isHidden = true
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.ThemeView.bg
        addSubViews([imgV,inviteCodeLabel,copyBtn,saveBtn,copylinkBtn,screenV])
        imgV.addSubViews([inviteCodeImgV,logoImgV])
        
        imgV.snp.makeConstraints { (make) in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(proportion * 509)
        }
        inviteCodeImgV.snp.makeConstraints { (make) in
            make.height.width.equalTo(proportion * 60)
            make.left.equalToSuperview().offset(proportion * 43)
            make.bottom.equalToSuperview().offset(-(proportion * 46))
        }
        logoImgV.snp.makeConstraints { (make) in
            make.top.left.equalToSuperview().offset(20)
            make.height.equalTo(22)
            make.width.equalTo(110)
        }
        inviteCodeLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.right.equalTo(copyBtn.snp.left).offset(-10)
            make.height.equalTo(20)
            make.top.equalTo(imgV.snp.bottom).offset(15 * proportion)
        }
        copyBtn.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-15)
            make.centerY.equalTo(inviteCodeLabel)
            make.height.equalTo(25)
        }
        saveBtn.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.right.equalTo(self.snp.centerX)
            make.height.equalTo(48)
            make.bottom.equalToSuperview().offset(-TABBAR_BOTTOM)
        }
        copylinkBtn.snp.makeConstraints { (make) in
            make.right.equalToSuperview()
            make.left.equalTo(self.snp.centerX)
            make.height.equalTo(48)
            make.bottom.equalToSuperview().offset(-TABBAR_BOTTOM)
        }
        
        ///获取数据
        getData()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
extension EXInviteView {
    //MARK:获取数据
    func getData() {
        appApi.rx.request(.getInvitationImgs)
            .MJObjectMap(EXInviteFriendModel.self,false)
            .subscribe{[weak self] event in
                guard let mySelf = self else{return}
                switch event {
                case .success(let model):
                    //MARK:当前页赋值
                    mySelf.setImage(model: model)
                    //MARK: 截屏赋值
                    mySelf.screenV.setImage(model: model)
                    break
                case .error(_):
                    break
                }
            }.disposed(by: self.disposeBag)
    }
    
    
    //MARK: 获取数据后赋值
    func setImage(model : EXInviteFriendModel) {
        var image : UIImage?
        var urlStr : String = ""
        if BasicParameter.isHan(){
            image = UIImage.init(named: "online_chinese")
            urlStr = model.online_img_cn
        }else{
            image = UIImage.init(named: "online_english")
            urlStr = model.online_img_en
        }
        imgV.yy_setImage(with: URL.init(string: urlStr), placeholder: image, options: YYWebImageOptions.allowBackgroundTask) { [weak self] (image, url, fromtype, stage, error) in
            guard let mySelf = self else{return}
            if image != nil && error == nil {
                mySelf.logoImgV.isHidden = true
            }
        }
        
       
    }
    
    
}
extension EXInviteView{
    
    //截图到相册
    @objc func screenshotsV(){
        screenV.snapShotArea(rect: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: 603 * proportion)) {[weak self] (image) in
            guard let mySelf = self else{return}
            UIImageWriteToSavedPhotosAlbum(image, self, #selector(mySelf.saveImg), nil)
        }
    }
    
    @objc func saveImg(image:UIImage,didFinishSavingWithError error:NSError?,contextInfo:AnyObject) {
        if error != nil{
            ProgressHUDManager.showFailWithStatus(LanguageTools.getString(key: "common_tip_saveImgFail"))
            return
        }
        ProgressHUDManager.showSuccessWithStatus(LanguageTools.getString(key: "common_tip_saveImgSuccess"))
    }
    
    @objc func copyLinkUrl(){
        if UserInfoEntity.sharedInstance().inviteUrl == ""{
            return
        }
        UIPasteboard.general.string = UserInfoEntity.sharedInstance().inviteUrl
        EXAlert.showSuccess(msg: "common_tip_copySuccess".localized())
    }
    
    @objc func copyInviteCode(){
        if UserInfoEntity.sharedInstance().inviteUrl == ""{
            return
        }
        UIPasteboard.general.string = UserInfoEntity.sharedInstance().inviteCode
        EXAlert.showSuccess(msg: "common_tip_copySuccess".localized())
    }
    
    
}

//复制按钮
class EXInviteCopyBtn : UIButton {
    
    lazy var imgV : UIImageView = {
        let imgV = UIImageView()
        imgV.extUseAutoLayout()
        imgV.image = UIImage.themeImageNamed(imageName: "fiat_copy")
        return imgV
    }()
    
    lazy var label : UILabel = {
        let label = UILabel()
        label.extUseAutoLayout()
        label.font = UIFont.ThemeFont.SecondaryRegular
        label.textColor = UIColor.ThemeLabel.colorMedium
        label.text = "common_action_copy".localized()
        label.layoutIfNeeded()
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubViews([imgV,label])
        imgV.snp.makeConstraints { (make) in
            make.width.equalTo(11)
            make.height.equalTo(13)
            make.centerY.equalToSuperview()
            make.right.equalTo(label.snp.left).offset(-5)
            make.left.equalToSuperview().offset(8)
        }
        label.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-8)
            make.centerY.equalToSuperview()
            make.height.equalTo(17)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class EXInviteScreenshotsV : UIView{
    
    let proportion : CGFloat = SCREEN_WIDTH / 375
    
    lazy var imgV : UIImageView = {
        let imgV = UIImageView()
        imgV.extUseAutoLayout()
//        if BasicParameter.isHan(){
//            imgV.image = UIImage.init(named: "local_chinese")
//        }else{
//            imgV.image = UIImage.init(named: "local_english")
//        }
        return imgV
    }()
    
    lazy var logoImgV : UIImageView = {
        let imgV = UIImageView()
        imgV.extUseAutoLayout()
        if let url = URL.init(string:  PublicInfoEntity.sharedInstance.app_logo_list_new.logo_black){
            imgV.yy_setImage(with: url, options: YYWebImageOptions.allowBackgroundTask)
        }
        return imgV
    }()
    
    lazy var inviteCodeImgV : UIImageView = {
        let imgV = UIImageView()
        imgV.extUseAutoLayout()
        if UserInfoEntity.sharedInstance().inviteUrl != ""{
            imgV.image = QRCodeCreate().creteScancode(UserInfoEntity.sharedInstance().inviteUrl)
        }
        return imgV
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubViews([imgV])
        self.backgroundColor = UIColor.black
        imgV.addSubViews([logoImgV,inviteCodeImgV])
        imgV.snp.makeConstraints { (make) in
            make.left.right.top.equalToSuperview()
            make.bottom.equalToSuperview().offset(1)
        }
        logoImgV.snp.makeConstraints { (make) in
            make.top.left.equalToSuperview().offset(20)
            make.height.equalTo(22)
            make.width.equalTo(110)
        }
        inviteCodeImgV.snp.makeConstraints { (make) in
            make.height.width.equalTo(60 * proportion)
            make.left.equalToSuperview().offset(43 * proportion)
            make.bottom.equalToSuperview().offset(-(60 * proportion))
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
extension EXInviteScreenshotsV {
    func setImage(model : EXInviteFriendModel) {
        var image : UIImage?
        var urlStr : String = ""
        
        if BasicParameter.isHan(){
            image = UIImage.init(named: "local_chinese")
            urlStr = model.local_img_cn
        }else{
            image = UIImage.init(named: "local_english")
            urlStr = model.local_img_en
        }
        imgV.yy_setImage(with: URL.init(string: urlStr), placeholder: image, options: YYWebImageOptions.allowBackgroundTask) { [weak self] (image, url, fromtype, stage, error) in
            guard let mySelf = self else{return}
            if image != nil && error == nil {
                mySelf.logoImgV.isHidden = true
            }
        }
    }
}
