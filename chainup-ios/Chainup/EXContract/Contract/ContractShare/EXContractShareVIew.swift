//
//  EXContractShareVIew.swift
//  Chainup
//
//  Created by zewu wang on 2020/2/20.
//  Copyright © 2020 zewu wang. All rights reserved.
//

import UIKit

class EXContractShareModel : NSObject{
    
    class func getDetailStr(_ str : String) -> String{
        var text = ""
        if str.contains("-"){
            if (str as NSString).isSmall("-50"){
                text = "common_share_losePrompt100".localized()
            }else if (str as NSString).isSmall("-20"){
                text = "common_share_losePrompt50".localized()
            }else if (str as NSString).isSmall("-10"){
                text = "common_share_losePrompt20".localized()
            }else if (str as NSString).isSmall("-5"){
                text = "common_share_losePrompt10".localized()
            }else{
                text = "common_share_losePrompt5".localized()
            }
        }else{
            if (str as NSString).isBig("50"){
                text = "common_share_winPrompt100".localized()
            }else if (str as NSString).isBig("20"){
                text = "common_share_winPrompt50".localized()
            }else if (str as NSString).isBig("10"){
                text = "common_share_winPrompt20".localized()
            }else if (str as NSString).isBig("5"){
                text = "common_share_winPrompt10".localized()
            }else{
                text = "common_share_winPrompt5".localized()
            }
        }
        return text
    }
    
}

class EXContractShareVIew: UIView {

    lazy var screenshotsView : UIView = {
        let view = UIView()
        view.extUseAutoLayout()
        view.backgroundColor = UIColor.clear
        view.layer.backgroundColor = UIColor.clear.cgColor
        return view
    }()
    
    lazy var backView : UIImageView = {
        let view = UIImageView()
        view.extUseAutoLayout()
        view.image = UIImage.themeImageNamed(imageName: "contract_share_background")
        return view
    }()
    
    lazy var headImgV : UIImageView = {
        let imgV = UIImageView()
        imgV.extUseAutoLayout()
        return imgV
    }()
    
    lazy var titleLabel : UILabel = {
        let label = UILabel()
        label.extUseAutoLayout()
        label.textAlignment = .center
        label.font = UIFont.ThemeFont.HeadRegular
        label.textColor = UIColor.ThemeLabel.share
        return label
    }()
    
    lazy var yieldLabel : UILabel = {
        let label = UILabel()
        label.extUseAutoLayout()
        label.layoutIfNeeded()
        label.textAlignment = .center
        label.font = UIFont.ThemeFont.HeadRegular
        label.textColor = UIColor.ThemeLabel.colorMedium
        label.text = "contract_deposit_rate".localized()
        return label
    }()
    
    lazy var longshortLabel : UILabel = {
        let label = UILabel()
        label.extUseAutoLayout()
        label.textAlignment = .center
        label.textColor = UIColor.ThemeLabel.white
        label.font = UIFont.ThemeFont.MinimumRegular
        label.textAlignment = .center
        return label
    }()
    
    lazy var yieldDetailLabel : UILabel = {
        let label = UILabel()
        label.extUseAutoLayout()
        label.font = UIFont.boldSystemFont(ofSize: 32)
        label.textColor = UIColor.ThemeLabel.share
        label.textAlignment = .center
        return label
    }()
    
    lazy var typeView : EXContractShareDetailView = {
        let view = EXContractShareDetailView()
        view.extUseAutoLayout()
        return view
    }()
    
    lazy var newPriceView : EXContractShareDetailView = {
        let view = EXContractShareDetailView()
        view.extUseAutoLayout()
        view.settop("home_text_dealLatestPrice".localized())
        return view
    }()
    
    lazy var averageOpenView : EXContractShareDetailView = {
        let view = EXContractShareDetailView()
        view.extUseAutoLayout()
        view.settop("contract_text_openAveragePrice".localized())
        return view
    }()
    
    lazy var qrCodeImgV : UIImageView = {
        let imgV = UIImageView()
        imgV.extUseAutoLayout()
        return imgV
    }()
    
    lazy var promptLabel : UILabel = {
        let label = UILabel()
        label.extUseAutoLayout()
        label.font = UIFont.ThemeFont.SecondaryRegular
        label.textColor = UIColor.ThemeLabel.colorMedium
        label.textAlignment = .center
        return label
    }()
    
    lazy var shareBtn : UIButton = {
        let btn = UIButton()
        btn.extUseAutoLayout()
        btn.addTarget(self, action: #selector(clickShareBtn), for: UIControlEvents.touchUpInside)
        btn.backgroundColor = UIColor.ThemeBtn.highlight
        btn.setTitle("common_share_confirm".localized(), for: UIControlState.normal)
        btn.setTitleColor(UIColor.white, for: UIControlState.normal)
        btn.titleLabel?.font = UIFont.ThemeFont.HeadBold
        return btn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        self.isUserInteractionEnabled = true
        addSubViews([screenshotsView,shareBtn])
        screenshotsView.addSubview(backView)
        backView.addSubViews([headImgV,titleLabel,yieldLabel,typeView,newPriceView,averageOpenView,longshortLabel,yieldDetailLabel,qrCodeImgV,promptLabel])
        
        let height = 502 * (SCREEN_WIDTH - 60) / 345
        screenshotsView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(30)
            make.right.equalToSuperview().offset(-30)
            make.center.equalToSuperview()
            make.height.equalTo(height+42)
        }
        
        backView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(42)
            make.height.equalTo(height)
        }
        headImgV.snp.makeConstraints { (make) in
            make.centerY.equalTo(backView.snp.top)
            make.height.width.equalTo(84)
            make.centerX.equalToSuperview()
        }
        titleLabel.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.height.equalTo(21)
            make.top.equalTo(headImgV.snp.bottom).offset(23)
        }
        yieldLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(65)
            make.height.equalTo(20)
        }
        longshortLabel.snp.makeConstraints { (make) in
            make.height.equalTo(18)
            make.width.equalTo(32)
            make.centerY.equalTo(yieldLabel)
            make.left.equalTo(yieldLabel.snp.right).offset(5)
        }
        yieldDetailLabel.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(yieldLabel.snp.bottom).offset(9)
            make.height.equalTo(36)
        }
        let viewwidth = (SCREEN_WIDTH - 20 - 60 - 60) / 3
        typeView.snp.makeConstraints { (make) in
            make.height.equalTo(40)
            make.width.equalTo(viewwidth)
            make.left.equalToSuperview().offset(30)
            make.top.equalTo(yieldDetailLabel.snp.bottom).offset(60)
        }
        newPriceView.snp.makeConstraints { (make) in
            make.height.equalTo(40)
            make.width.equalTo(viewwidth)
            make.left.equalTo(typeView.snp.right).offset(10)
            make.centerY.equalTo(typeView)
        }
        averageOpenView.snp.makeConstraints { (make) in
            make.height.equalTo(40)
            make.width.equalTo(viewwidth)
            make.left.equalTo(newPriceView.snp.right).offset(10)
            make.centerY.equalTo(typeView)
        }
        qrCodeImgV.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.height.width.equalTo(58)
            make.bottom.equalTo(promptLabel.snp.top).offset(-10)
        }
        promptLabel.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-40)
            make.height.equalTo(17)
        }
        shareBtn.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.width.equalTo(140)
            make.height.equalTo(44)
            make.top.equalTo(backView.snp.bottom).offset(20)
        }
        
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(clickSelf))
        self.addGestureRecognizer(tap)
    }
    
    func setImg(_ img : UIImage){
        backView.image = img
    }
    
    var vc = UIViewController()
    
    func show(_ vc : UIViewController){
        guard let appDelegate  = UIApplication.shared.delegate else {
            return
        }
        self.vc = vc
        if appDelegate.window != nil   {
            appDelegate.window??.rootViewController?.view.addSubview(self)
            appDelegate.window??.rootViewController?.view.bringSubview(toFront: self)
            self.snp.makeConstraints { (make) in
                make.edges.equalToSuperview()
            }
        }
    }
    
    func setView(_ entity : ContractUserPositionEntity){
        let lesszero = entity.fmtUnrealisedRateIndex().contains("-") ? true : false
        
        headImgV.image = lesszero ? UIImage.themeImageNamed(imageName: "contract_share_cry") : UIImage.themeImageNamed(imageName: "contract_share_smile")
        
        titleLabel.text = EXContractShareModel.getDetailStr(entity.fmtUnrealisedRateIndex().replacingOccurrences(of: "%", with: ""))
        
        longshortLabel.backgroundColor = entity.side_color
        longshortLabel.text = entity.side == "BUY" ? "contract_action_long".localized() : "contract_action_short".localized()
        
        yieldDetailLabel.text = entity.fmtUnrealisedRateIndex()
        
        typeView.settop(entity.contractContentModel.getContractTitle())
        typeView.setbottom(entity.symbol)
        
        newPriceView.setbottom(entity.fmtIndexPrice())
        
        averageOpenView.setbottom(entity.fmtAvgPrice())
        
        qrCodeImgV.image = QRCodeCreate().creteScancode(PublicInfoEntity.sharedInstance.sharingPage)
        
        promptLabel.text = "common_share_scanCode".localized() + BasicParameter.getAppName() + " APP"
        
    }
    
    @objc func clickShareBtn(){
        self.layoutIfNeeded()
        if let image = screenshotsView.screenShot(){
            BasicParameter.share(vc, image: image, completionHandler: {
                self.clickSelf()
            })
        }
    }
    
    @objc func clickSelf(){
        self.removeFromSuperview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

class EXContractShareDetailView : UIView{

    lazy var topLabel : UILabel = {
        let label = UILabel()
        label.extUseAutoLayout()
        label.font = UIFont.ThemeFont.SecondaryRegular
        label.textColor = UIColor.ThemeLabel.colorMedium
        return label
    }()
    
    lazy var bottomLabel : UILabel = {
        let label = UILabel()
        label.extUseAutoLayout()
        label.font = UIFont.ThemeFont.BodyRegular
        label.textColor = UIColor.ThemeLabel.white
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubViews([topLabel,bottomLabel])
        topLabel.snp.makeConstraints { (make) in
            make.height.equalTo(17)
            make.top.left.right.equalToSuperview()
        }
        bottomLabel.snp.makeConstraints { (make) in
            make.height.equalTo(18)
            make.bottom.left.right.equalToSuperview()
        }
    }
    
    func settop(_ str : String){
        topLabel.text = str
    }
    
    func setbottom(_ str : String){
        bottomLabel.text = str
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
