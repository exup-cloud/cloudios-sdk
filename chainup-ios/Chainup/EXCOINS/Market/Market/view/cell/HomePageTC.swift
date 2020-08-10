//
//  HomePageTC.swift
//  AppProject
//
//  Created by zewu wang on 2018/8/6.
//  Copyright © 2018年 zewu wang. All rights reserved.
//

import UIKit


class HomePageTC: UITableViewCell {
    
    typealias LongCellBlock = (CoinDetailsEntity) -> ()
    var longCellBlock : LongCellBlock?
    
    var entity = CoinDetailsEntity()
    
    lazy var tagView :EXTagView = {
        let view = EXTagView.commonTagView()
        view.isHidden = true
        return view
    }()
    
    //名字
    lazy var nameLabel : UILabel = {
        let label = UILabel()
        label.extUseAutoLayout()
        label.textColor = UIColor.ThemeLabel.colorLite
        label.text = "--"
        return label
    }()
    
    //成交量
    lazy var dealLabel : UILabel = {
        let label = UILabel()
        label.extUseAutoLayout()
        label.font = UIFont().themeHNFont(size: 12)
        label.textColor = UIColor.ThemeLabel.colorMedium
        label.text = "--"
        return label
    }()
    
    //价格
    lazy var priceLabel : UILabel = {
        let label = UILabel()
        label.extUseAutoLayout()
        label.font = UIFont().themeHNBoldFont(size: 16)
        label.textColor = UIColor.ThemeLabel.colorLite
        label.text = "--"
        return label
    }()
    
    //真实价格
    lazy var rmbLabel : UILabel = {
        let label = UILabel()
        label.extUseAutoLayout()
        label.font = UIFont().themeHNFont(size: 12)
        label.text = "--"
        label.textColor = UIColor.ThemeLabel.colorMedium
        return label
    }()
    
    //涨幅
    lazy var amplitudeLabel : UILabel = {
        let label = UILabel()
        label.extUseAutoLayout()
        label.extSetCornerRadius(1.5)
        label.textAlignment = .center
        label.textColor = UIColor.white
        label.text = "--"
        label.font = UIFont().themeHNBoldFont(size: 14)
        return label
    }()
    
    //底部的线
    lazy var bottomLineV : UIView = {
        let view = UIView()
        view.extUseAutoLayout()
        view.backgroundColor = UIColor.ThemeView.seperator
        return view
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubViews([nameLabel,tagView,dealLabel,priceLabel,rmbLabel,amplitudeLabel,bottomLineV])
        contentView.backgroundColor = UIColor.ThemeView.bg
        selectionStyle = .none
        addConstraint()
    }
    
    func addConstraint() {
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.right.equalTo(priceLabel.snp.left).offset(-10)
            make.top.equalToSuperview().offset(10)
            make.height.equalTo(19)
        }
        
        dealLabel.snp.makeConstraints { (make) in
            make.left.right.equalTo(nameLabel)
            make.top.equalTo(nameLabel.snp.bottom).offset(2)
            make.height.equalTo(17)
        }
        
        priceLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(SCREEN_WIDTH / 2.5)
            make.right.equalTo(amplitudeLabel.snp.left).offset(-10)
            make.height.equalTo(19)
            make.top.equalTo(nameLabel)
        }
        
        rmbLabel.snp.makeConstraints { (make) in
            make.left.right.equalTo(priceLabel)
            make.height.equalTo(14)
            make.top.equalTo(priceLabel.snp.bottom).offset(4)
        }
        
        amplitudeLabel.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-15)
            make.height.equalTo(32)
            make.width.equalTo(72)
            make.centerY.equalToSuperview()
        }
        
        bottomLineV.snp.makeConstraints { (make) in
            make.height.equalTo(0.5)
            make.left.equalToSuperview().offset(15)
            make.bottom.right.equalToSuperview()
        }
        
        tagView.snp.remakeConstraints { (make) in
            make.left.equalTo(nameLabel.snp_right)
            make.right.lessThanOrEqualTo(amplitudeLabel.snp_left)
            make.top.equalTo(5)
            make.width.equalTo(5)
        }
        
        let single = UITapGestureRecognizer.init(target: self, action: #selector(singletap))
        single.numberOfTapsRequired = 1
        self.addGestureRecognizer(single)
        
    }
    
    func setCellWithEntity(_ entity : CoinDetailsEntity){
        self.entity = entity
        nameLabel.attributedText = entity.nameAttrStr
        if entity.marketTag.isEmpty {
            tagView.isHidden = true
        }else {
            tagView.isHidden = false
            tagView.setTitle(entity.marketTag, for: .normal)
            let nameWidth = entity.nameWidth + 15 + tagView.paddingX
            tagView.snp.remakeConstraints { (make) in
                make.left.equalTo(nameWidth + 5)
                make.right.lessThanOrEqualTo(nameLabel.snp_right)
                make.top.equalTo(5)
                make.width.equalTo(entity.marketTagWidth)
            }
        }
    }
    
    //ws传进来的值
    func ws_setCellWithEntity(_ entity : CoinDetailsEntity){
//        entity.subject.subscribe {[weak self] (event) in
//            guard let mySelf = self else{return}
//            if let name = event.element , name != mySelf.entity.name{
//                return
//            }
            self.dealLabel.text = LanguageTools.getString(key: "24H") + " \(entity.vol)"
            self.rmbLabel.text = entity.rmb
//            mySelf.priceLabel.textColor = entity.color
            self.priceLabel.text = entity.close
            self.amplitudeLabel.text = entity.rose
            self.amplitudeLabel.backgroundColor = entity.backColor
//        }.disposed(by: disposeBag)
    }
    
    //点击cell
    @objc func singletap(){
        var entity = CoinMapEntity()
        entity = PublicInfoManager.sharedInstance.getCoinMapInfo(self.entity.name)
        
//        let vc = EXMarketDetailVc.instanceFromStoryboard(name: StoryBoardNameMarket)
//        vc.entity = entity
//        self.yy_viewController?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func addTap(){
        if self.gestureRecognizers?.count == 1{
            let long = UILongPressGestureRecognizer.init(target: self, action: #selector(longCell))
            self.addGestureRecognizer(long)
        }
    }
    
    //长按cell
    @objc func longCell(_ tap : UITapGestureRecognizer){
        if (tap.state == UIGestureRecognizerState.began) {
            let view = EXNormalAlert()
            view.configAlert(title: "",message:"market_tip_confirmDeleteCollection".localized() + "?")
            view.alertCallback = {[weak self](tag) in
                guard let mySelf = self else{return}
                if tag == 0{
                    mySelf.longCellBlock?(mySelf.entity)
                }
            }
            EXAlert.showAlert(alertView: view)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
