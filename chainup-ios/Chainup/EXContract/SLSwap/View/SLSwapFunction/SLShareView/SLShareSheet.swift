//
//  SLShareSheet.swift
//  Chainup
//
//  Created by KarlLichterVonRandoll on 2020/1/7.
//  Copyright © 2020 zewu wang. All rights reserved.
//

import Foundation

class SLShareSheet: UIView {
    
    typealias AlertCallback = (Int,UIImage?) -> ()
    var alertCallback : AlertCallback?
    
    var position : BTPositionModel? {
        didSet {
            if position != nil {
                 updateShareSheetInfo(position!)
            }
        }
    }
    
    lazy var shareBgView : UIView = {
        let view = UIView(frame: CGRect.init(x: 0, y: 0, width: 375, height: 667))
        return view
    }()
    
    lazy var copyLabel : UILabel = {
        let label = UILabel(text: "contract_final_right_interpretcopy".localized(), font: UIFont.ThemeFont.BodyRegular, textColor:  UIColor.extColorWithHex("5D5E7C"), alignment: .center)
        return label
    }()
    
    let logoView: UIImageView = {
        let bgV = UIImageView(image: UIImage.themeImageNamed(imageName: "LOGO_share"))
        return bgV
    }()
    
    var shareV : SLShareView = {
        let share = SLShareView(frame: CGRect.init(x: 0, y: 0, width: 280, height: 500))
        share.clipsToBounds = false
        return share
    }()
    
    let saveBtn : UIButton = {
        let button = EXButton()
        button.setTitle("common_share_confirm".localized(), for: .normal)
        button.extSetAddTarget(self, #selector(clickWechat))
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initLayout()
        self.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(dismiss))
        self.addGestureRecognizer(tap)
    }
    
    @objc func dismiss(){
        self.removeFromSuperview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initLayout() {
        self.backgroundColor = UIColor.ThemeView.mask
        self.addSubViews([shareV,saveBtn])
        shareV.snp.makeConstraints { (make) in
            make.width.equalTo(280)
            make.height.equalTo(500)
            make.centerX.equalTo(SCREEN_WIDTH * 0.5)
            make.top.equalTo((SCREEN_HEIGHT - 476 - 84) * 0.5)
        }
        saveBtn.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.width * 0.5)
            make.height.equalTo(44)
            make.width.equalTo(140)
            make.top.equalTo(shareV.snp.bottom).offset(40)
        }
    }
    
    @objc func clickCancel(_ btn : UIButton){
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.4) {
            self.alertCallback?(0,nil)
        }
        SLShareSheet.dismiss(v: self)
    }
    @objc func clickSave(_ btn : UIButton){
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.4) {
            let image = self.getShareImage()
            self.alertCallback?(1,image)
        }
        SLShareSheet.dismiss(v: self)
    }
    @objc func clickWechat(_ btn : UIButton){
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.4) {
            let image = self.getShareImage()
            self.alertCallback?(2,image)
        }
        SLShareSheet.dismiss(v: self)
    }
    
    func getShareImage() -> UIImage {
        shareV.removeFromSuperview()
        self.shareBgView.addSubViews([shareV])
        shareV.snp.makeConstraints { (make) in
            make.left.right.bottom.top.equalToSuperview()
        }
        shareV.updateLayout()
        shareV.setNeedsLayout()
        shareV.layoutIfNeeded()
        return shareV.asImage()
    }
    
    func updateShareSheetInfo(_ position: BTPositionModel) {
//        let profit = position.unrealised_profit.bigDiv(position.im) ?? "0"
        let r = position.repayRate.toPercentString(2) ?? ""
        let detailStr = EXContractShareModel.getDetailStr(r.extStringSub(NSRange.init(location: 0, length: r.count - 1)).bigMul("100"))
        shareV.defineLabel.text = String(format:"\"%@\"",detailStr)
        var rate = position.repayRate.toPercentString(2) ?? "0.00%"
        if position.unrealised_profit.greaterThanOrEqual(BT_ZERO) {
            rate = "+" + rate
        } else {
            shareV.rateLabel.textColor = UIColor.ThemekLine.down
        }
        if position.side == .openEmpty {
            shareV.directBtn.backgroundColor = UIColor.ThemekLine.down
            shareV.directBtn.setTitle("contract_action_short".localized(), for: .normal)
        }
        shareV.rateLabel.text = rate
        shareV.swapName.text = position.contractInfo.symbol
        
        let idx = BTStoreData.storeObject(forKey: ST_UNREA_CARCUL) as? Int ?? 0
        if idx == 0 {
            shareV.fairLabel.text = "contract_last_price".localized()
            shareV.fairPrice.text = position.lastPrice.toSmallPrice(withContractID:position.instrument_id)
        } else {
            shareV.fairLabel.text = "contract_text_fairPrice".localized()
            shareV.fairPrice.text = position.markPrice.toSmallPrice(withContractID:position.instrument_id)
        }
        shareV.openPrice.text = position.avg_cost_px.toSmallPrice(withContractID:position.instrument_id)
    }
    
    // MARK:- interface

    func show() {
        UIApplication.shared.keyWindow?.addSubview(self)
    }
    static func dismiss(v: UIView) {
        for view in UIApplication.shared.keyWindow!.subviews {
            if view is SLShareSheet {
                v.removeFromSuperview()
                break
            }
        }
    }
    
    static func createShareViewWithPosition(_ position : BTPositionModel) -> SLShareSheet {
        let alert = SLShareSheet(frame: CGRect.init(x: 0, y: 0, width:SCREEN_WIDTH, height: SCREEN_HEIGHT))
        alert.position = position
        return alert
    }
}

class SLShareView: UIView {
    
    let bgV: UIImageView = {
        let view = UIImageView()
        return view
    }()
    
    /// icon
    let iconView: UIImageView = {
        let icon = UIImageView(image: UIImage.themeImageNamed(imageName: "AppIcon"))
        icon.layer.cornerRadius = 2
        icon.layer.masksToBounds = true
        return icon
    }()
    
    /// 自定义话术
    let defineLabel: UILabel = {
        let label = UILabel(text: "", font: UIFont.ThemeFont.H3Bold, textColor:  UIColor.ThemeLabel.colorLite, alignment: .center)
        return label
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel(text: BasicParameter.getAppName(), font: UIFont.systemFont(ofSize: 14, weight:.medium), textColor:  UIColor.ThemeLabel.colorLite, alignment: .left)
        return label
    }()
    
    /// 背景图
    let bgView: UIImageView = {
        let bgV = UIImageView(image: UIImage.themeImageNamed(imageName: "contract_share_small"))
        return bgV
    }()
    
    /// 背景图
    let bottomView: UIImageView = {
        let bgV = UIImageView(image: UIImage.themeImageNamed(imageName: "bg_moon"))
        return bgV
    }()
    
    /// 收益率
    let profitRate: UILabel = {
        let label = UILabel(text: "contract_deposit_rate".localized(), font: UIFont.ThemeFont.BodyRegular, textColor: UIColor.ThemeLabel.colorLite, alignment: .right)
        return label
    }()
    
    /// 仓位方向
    let directBtn: UIButton = {
        let btn = UIButton(buttonType: .custom, title: "contract_action_long".localized(), titleFont: UIFont.ThemeFont.MinimumRegular, titleColor: UIColor.ThemeLabel.white)
        btn.layer.cornerRadius = 1.5
        btn.layer.masksToBounds = true
        btn.isUserInteractionEnabled = false
        btn.backgroundColor = UIColor.ThemekLine.up
        return btn
    }()
    
    /// 收益率
    let rateLabel: UILabel = {
        let label = UILabel(text: "--%", font: UIFont.ThemeFont.H1Bold, textColor:  UIColor.ThemekLine.up, alignment: .center)
        return label
    }()
    
    /// 合约名称
    let nameLabel: UILabel = {
        let label = UILabel(text: "contract_perpetual_contract".localized(), font: UIFont.ThemeFont.SecondaryRegular, textColor:  UIColor.ThemeLabel.colorMedium, alignment: .center)
        return label
    }()
    
    let swapName: UILabel = {
        let label = UILabel(text: "BTCUSDT", font: UIFont.ThemeFont.SecondaryBold, textColor:  UIColor.ThemeLabel.colorLite, alignment: .center)
        return label
    }()
    
    let midLine1 : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.ThemeView.seperator
        return view
    }()
    
    let midLine2 : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.ThemeView.seperator
        return view
    }()
    
    /// 合理价格
    let fairLabel: UILabel = {
        let label = UILabel(text: "contract_last_price".localized(), font: UIFont.ThemeFont.SecondaryRegular, textColor:  UIColor.ThemeLabel.colorMedium, alignment: .center)
        return label
    }()
    
    let fairPrice: UILabel = {
        let label = UILabel(text: "5249.00", font: UIFont.ThemeFont.SecondaryBold, textColor:  UIColor.ThemeLabel.colorLite, alignment: .center)
        return label
    }()
    
    /// 开仓价格
    let openLabel: UILabel = {
        let label = UILabel(text: "contract_cost_position_price".localized(), font: UIFont.ThemeFont.SecondaryRegular, textColor:  UIColor.ThemeLabel.colorMedium, alignment: .center)
        return label
    }()
    
    let openPrice: UILabel = {
        let label = UILabel(text: "5230.00", font: UIFont.ThemeFont.SecondaryBold, textColor:  UIColor.ThemeLabel.colorLite, alignment: .center)
        return label
    }()
    
    let line: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.ThemeView.seperator
        return v
    }()
    
    /// 二维码
    let qrView: UIImageView = {
        let qrIcon = LBXScanWrapper.createCode(codeType: "CIQRCodeGenerator", codeString: UserInfoEntity.sharedInstance().inviteUrl, size: CGSize(width: 50, height: 50), qrColor: UIColor.ThemeLabel.colorLite, bkColor: UIColor.ThemeView.bg)
        let bgV = UIImageView(image: qrIcon)
        bgV.backgroundColor = UIColor.ThemeView.bg
        return bgV
    }()
    
    /// 扫码提示
    let qrTipsLabel: UILabel = {
        let label = UILabel(text: "common_share_detail".localized(), font: UIFont.ThemeFont.MinimumRegular, textColor:  UIColor.ThemeLabel.colorMedium, alignment: .left)
        return label
    }()
    
    let qrTipsView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.ThemeView.mask
        let imageView = UIImageView(image: UIImage.themeImageNamed(imageName: "contract_share_arrow"))
        let label = UILabel(text: "contract_share_downloadtips".localized(), font: UIFont.ThemeFont.MinimumRegular, textColor:  UIColor.ThemeLabel.white, alignment: .center)
        view.addSubViews([imageView,label])
        imageView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(4)
            make.right.bottom.equalToSuperview().offset(-4)
            make.width.equalTo(12)
        }
        label.snp.makeConstraints { (make) in
            make.left.top.bottom.equalToSuperview()
            make.right.equalTo(imageView.snp.left)
        }
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = false
        self.initLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initLayout() {
        
        self.addSubViews([
                          iconView,
                          bgView,
                          defineLabel,
                          titleLabel,
                          profitRate,
                          directBtn,
                          rateLabel,
                          nameLabel,
                          swapName,
                          midLine1,
                          fairLabel,
                          fairPrice,
                          midLine2,
                          openLabel,
                          openPrice,
                          line,
                          qrView,
                          qrTipsLabel,
                          qrTipsView])
        bgView.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalTo(240)
        }
       
        defineLabel.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(bgView.snp.bottom).offset(24)
            make.height.equalTo(20)
        }
        
        profitRate.snp.makeConstraints { (make) in
            make.height.equalTo(14)
            make.top.equalTo(defineLabel.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-self.width * 0.5)
        }
        directBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(profitRate.snp.centerY)
            make.left.equalTo(profitRate.snp.right).offset(6)
            make.width.equalTo(30)
            make.height.equalTo(14)
        }
        rateLabel.snp.makeConstraints { (make) in
            make.top.equalTo(profitRate.snp.bottom).offset(2)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(30)
        }
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(5)
            make.top.equalTo(rateLabel.snp.bottom).offset(21)
            make.height.equalTo(14)
        }
        midLine1.snp.makeConstraints { (make) in
            make.height.equalTo(25)
            make.width.equalTo(0.5)
            make.centerY.equalTo(nameLabel.snp.bottom)
            make.centerX.equalTo(nameLabel.snp.right)
        }
        fairLabel.snp.makeConstraints { (make) in
            make.left.equalTo(nameLabel.snp.right).offset(5)
            make.top.equalTo(rateLabel.snp.bottom).offset(21)
            make.height.equalTo(14)
            make.width.equalTo(nameLabel.snp.width)
        }
        midLine2.snp.makeConstraints { (make) in
            make.height.equalTo(25)
            make.width.equalTo(0.5)
            make.centerY.equalTo(nameLabel.snp.bottom)
            make.centerX.equalTo(fairLabel.snp.right)
        }
        openLabel.snp.makeConstraints { (make) in
            make.left.equalTo(fairLabel.snp.right).offset(5)
            make.right.equalToSuperview().offset(-5)
            make.top.equalTo(rateLabel.snp.bottom).offset(21)
            make.height.equalTo(14)
            make.width.equalTo(nameLabel.snp.width)
        }
        swapName.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(5)
            make.top.equalTo(nameLabel.snp.bottom).offset(5)
            make.height.equalTo(14)
        }
        fairPrice.snp.makeConstraints { (make) in
            make.left.equalTo(swapName.snp.right).offset(5)
            make.top.equalTo(nameLabel.snp.bottom).offset(5)
            make.height.equalTo(14)
            make.width.equalTo(swapName.snp.width)
        }
        openPrice.snp.makeConstraints { (make) in
            make.left.equalTo(fairPrice.snp.right).offset(5)
            make.right.equalToSuperview().offset(-5)
            make.top.equalTo(nameLabel.snp.bottom).offset(5)
            make.height.equalTo(14)
            make.width.equalTo(swapName.snp.width)
        }
        line.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-80)
            make.height.equalTo(0.5)
        }
        qrView.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-15)
            make.bottom.equalToSuperview().offset(-10)
            make.width.equalTo(60)
            make.height.equalTo(60)
        }
        iconView.snp.makeConstraints { (make) in
            make.width.equalTo(30)
            make.height.equalTo(30)
            make.left.equalToSuperview().offset(20)
            make.top.equalTo(line.snp.bottom).offset(10)
        }
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(iconView.snp.right).offset(10)
            make.right.equalToSuperview().offset(-75)
            make.top.equalTo(iconView.snp.top)
            make.height.equalTo(15)
        }
        qrTipsLabel.snp.makeConstraints { (make) in
            make.left.equalTo(iconView.snp.right).offset(10)
            make.right.equalToSuperview().offset(-75)
            make.top.equalTo(titleLabel.snp.bottom)
            make.height.equalTo(15)
        }
        qrTipsView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20)
            make.width.equalTo(100)
            make.height.equalTo(20)
            make.top.equalTo(iconView.snp.bottom).offset(10)
        }
        qrTipsView.layer.cornerRadius = 10
        qrTipsView.layer.masksToBounds = true
        self.backgroundColor = UIColor.ThemeView.bg
    }
    
    func updateLayout() {
        bgView.image = UIImage.themeImageNamed(imageName: "contract_share_big")
        bgView.snp.remakeConstraints { (make) in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalTo(345)
        }
        profitRate.snp.remakeConstraints { (make) in
            make.height.equalTo(15)
             make.top.equalTo(defineLabel.snp.bottom).offset(26)
             make.left.equalToSuperview().offset(20)
             make.right.equalToSuperview().offset(-SCREEN_WIDTH * 0.5)
         }
         directBtn.snp.remakeConstraints { (make) in
             make.centerY.equalTo(profitRate.snp.centerY)
             make.left.equalTo(profitRate.snp.right).offset(6)
             make.width.equalTo(30)
             make.height.equalTo(15)
         }
         rateLabel.snp.remakeConstraints { (make) in
             make.top.equalTo(profitRate.snp.bottom).offset(4)
             make.left.equalToSuperview().offset(20)
             make.right.equalToSuperview().offset(-20)
             make.height.equalTo(30)
         }
         nameLabel.snp.remakeConstraints { (make) in
             make.left.equalToSuperview().offset(5)
             make.top.equalTo(rateLabel.snp.bottom).offset(35)
             make.height.equalTo(14)
         }
         fairLabel.snp.remakeConstraints { (make) in
             make.left.equalTo(nameLabel.snp.right).offset(5)
             make.top.equalTo(rateLabel.snp.bottom).offset(35)
             make.height.equalTo(14)
             make.width.equalTo(nameLabel.snp.width)
         }
         openLabel.snp.remakeConstraints { (make) in
             make.left.equalTo(fairLabel.snp.right).offset(5)
             make.right.equalToSuperview().offset(-5)
             make.top.equalTo(rateLabel.snp.bottom).offset(35)
             make.height.equalTo(14)
             make.width.equalTo(nameLabel.snp.width)
         }
         swapName.snp.remakeConstraints { (make) in
             make.left.equalToSuperview().offset(5)
             make.top.equalTo(nameLabel.snp.bottom).offset(5)
             make.height.equalTo(14)
         }
         fairPrice.snp.remakeConstraints { (make) in
             make.left.equalTo(swapName.snp.right).offset(5)
             make.top.equalTo(nameLabel.snp.bottom).offset(5)
             make.height.equalTo(14)
             make.width.equalTo(swapName.snp.width)
         }
         openPrice.snp.remakeConstraints { (make) in
             make.left.equalTo(fairPrice.snp.right).offset(5)
             make.right.equalToSuperview().offset(-5)
             make.top.equalTo(nameLabel.snp.bottom).offset(5)
             make.height.equalTo(14)
             make.width.equalTo(swapName.snp.width)
         }
         line.snp.remakeConstraints { (make) in
             make.left.equalToSuperview()
             make.right.equalToSuperview()
             make.bottom.equalToSuperview().offset(-120)
             make.height.equalTo(0.5)
         }
         qrView.snp.remakeConstraints { (make) in
             make.right.equalToSuperview().offset(-15)
             make.bottom.equalToSuperview().offset(-15)
             make.width.equalTo(90)
             make.height.equalTo(90)
         }
         iconView.snp.remakeConstraints { (make) in
             make.width.equalTo(40)
             make.height.equalTo(40)
             make.left.equalToSuperview().offset(20)
            make.top.equalTo(line.snp.bottom).offset(23)
         }
         titleLabel.snp.remakeConstraints { (make) in
             make.left.equalTo(iconView.snp.right).offset(10)
             make.right.equalToSuperview().offset(-65)
             make.top.equalTo(iconView.snp.top)
             make.height.equalTo(20)
         }
         qrTipsLabel.snp.remakeConstraints { (make) in
             make.left.equalTo(iconView.snp.right).offset(10)
             make.right.equalToSuperview().offset(-65)
             make.top.equalTo(titleLabel.snp.bottom)
             make.height.equalTo(20)
         }
        qrTipsView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20)
            make.width.equalTo(100)
            make.height.equalTo(23)
            make.top.equalTo(iconView.snp.bottom).offset(10)
        }
    }
}

extension UIView {
    //将当前视图转为UIImage
    func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
    
    func findController() -> UIViewController! {
        return self.findControllerWithClass(UIViewController.self)
    }
    
    func findNavigator() -> UINavigationController! {
        return self.findControllerWithClass(UINavigationController.self)
    }
    
    func findControllerWithClass<T>(_ clzz: AnyClass) -> T? {
        var responder = self.next
        while(responder != nil) {
            if (responder!.isKind(of: clzz)) {
                return responder as? T
            }
            responder = responder?.next
        }
        return nil
    }
}
