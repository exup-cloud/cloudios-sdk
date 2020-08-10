
//
//  EXMarketShareView.swift
//  Chainup
//
//  Created by zewu wang on 2020/2/20.
//  Copyright © 2020 zewu wang. All rights reserved.
//

import UIKit

class EXMarketShareView: UIView {

    lazy var backView : UIImageView = {
        let view = UIImageView()
        view.extUseAutoLayout()
//        view.contentMode = .scaleAspectFill
//        view.clipsToBounds = true
        return view
    }()
    
    lazy var bottomView : UIView = {
        let view = UIView()
        view.extUseAutoLayout()
        view.backgroundColor = UIColor.ThemeLabel.colorHighlight
        return view
    }()
    
    lazy var iconView : UIImageView = {
        let view = UIImageView()
        view.extUseAutoLayout()
        view.image = UIImage.themeImageNamed(imageName: "AppIcon")
        return view
    }()
    
    lazy var nameLabel : UILabel = {
        let label = UILabel()
        label.extUseAutoLayout()
        label.font = UIFont.ThemeFont.BodyRegular
        label.textColor = UIColor.ThemeLabel.white
        label.text = BasicParameter.getAppName()
        return label
    }()
    
    lazy var textLabel : UILabel = {
        let label = UILabel()
        label.extUseAutoLayout()
        label.font = UIFont.ThemeFont.MinimumRegular
        label.textColor = UIColor.ThemeLabel.white
        label.text = "common_share_detail".localized()
        return label
    }()
    
    lazy var qrCodeImgV : UIImageView = {
        let imgV = UIImageView()
        imgV.extUseAutoLayout()
        return imgV
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
        addSubViews([backView,shareBtn])
        backView.addSubViews([bottomView])
        bottomView.addSubViews([iconView,nameLabel,textLabel,qrCodeImgV])
        let height = 543 * (SCREEN_WIDTH - 60) / 315
        backView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(30)
            make.right.equalToSuperview().offset(-30)
            make.center.equalToSuperview()
            make.height.equalTo(height)
        }
        bottomView.snp.makeConstraints { (make) in
            make.bottom.left.right.equalToSuperview()
            make.height.equalTo(60)
        }
        iconView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(20)
            make.height.width.equalTo(40)
        }
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(iconView.snp.right).offset(10)
            make.right.equalTo(qrCodeImgV.snp.left).offset(-5)
            make.top.equalTo(iconView)
            make.height.equalTo(16)
        }
        textLabel.snp.makeConstraints { (make) in
            make.left.right.equalTo(nameLabel)
            make.bottom.equalTo(iconView)
            make.height.equalTo(14)
        }
        qrCodeImgV.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-20)
            make.height.width.equalTo(40)
        }
        shareBtn.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.width.equalTo(140)
            make.height.equalTo(44)
            make.top.equalTo(backView.snp.bottom).offset(20)
        }
        
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(clickSelf))
        self.addGestureRecognizer(tap)
        
        setQRCode()
    }
    
    func setImg(_ img : UIImage){
        backView.image = img
    }
    
    func setQRCode(){
        qrCodeImgV.image = QRCodeCreate().creteScancode(PublicInfoEntity.sharedInstance.sharingPage)
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
    
    @objc func clickShareBtn(){
        self.layoutIfNeeded()
        if let image = backView.screenShot(){
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
