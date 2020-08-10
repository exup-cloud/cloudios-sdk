//
//  ContractTransactionRightTC.swift
//  Chainup
//
//  Created by zewu wang on 2019/5/14.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import UIKit

class ContractTransactionRightHeaderView : UIView{
    
    //价格
    lazy var priceLabel : UILabel = {
        let label = UILabel()
        label.extUseAutoLayout()
        label.font = UIFont.ThemeFont.MinimumRegular
        label.textColor = UIColor.ThemeLabel.colorDark
        label.text = "contract_text_price".localized()
        return label
    }()
    
    //数量
    lazy var volumLabel : UILabel = {
        let label = UILabel()
        label.extUseAutoLayout()
        label.font = UIFont.ThemeFont.MinimumRegular
        label.textColor = UIColor.ThemeLabel.colorDark
        label.textAlignment = .right
        label.text = "charge_text_volume".localized() + "(" + "contract_text_volumeUnit".localized() + ")"
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.ThemeView.bg
        addSubViews([priceLabel,volumLabel])
        priceLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.right.equalTo(self.snp.centerX).offset(10)
            make.top.equalToSuperview().offset(18)
            make.height.equalTo(14)
        }
        volumLabel.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-15)
            make.left.equalTo(priceLabel.snp.right).offset(10)
            make.top.equalToSuperview().offset(18)
            make.height.equalTo(14)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

enum TransactionPankouType {
    case defaultPan
    case buy
    case sell
}

class ContractTransactionRightFooterView : UIView{
    
    var type = TransactionPankouType.defaultPan
    
    typealias ClickPankouBlock = (TransactionPankouType) -> ()
    var clickPankouBlock : ClickPankouBlock?
    
    //指数价格
    lazy var indicatorsLabel : UILabel = {
        let label = UILabel()
        label.extUseAutoLayout()
        label.textColor = UIColor.ThemeLabel.colorMedium
        label.font = UIFont.ThemeFont.SecondaryRegular
        label.text = "contract_text_indexPrice".localized()
        return label
    }()
    
    //指数价格
    lazy var indicatorsPrice : UILabel = {
        let label = UILabel()
        label.extUseAutoLayout()
        label.textAlignment = .right
        label.textColor = UIColor.ThemeLabel.colorMedium
        label.font = UIFont.ThemeFont.SecondaryRegular
        return label
    }()
    
    //标记价格
    lazy var tagLabel : UILabel = {
        let label = UILabel()
        label.extUseAutoLayout()
        label.textColor = UIColor.ThemeLabel.colorMedium
        label.font = UIFont.ThemeFont.SecondaryRegular
        label.text = "contract_text_markPrice".localized()
        return label
    }()
    
    //标记价格
    lazy var tagPrice : UILabel = {
        let label = UILabel()
        label.extUseAutoLayout()
        label.textAlignment = .right
        label.textColor = UIColor.ThemeLabel.colorMedium
        label.font = UIFont.ThemeFont.SecondaryRegular
        return label
    }()
    
//    //深度
//    lazy var depthBtn : EXDirectionButton = {
//        let btn = EXDirectionButton()
//        btn.extUseAutoLayout()
//        btn.addTarget(self, action: #selector(clickDishBtn), for: UIControlEvents.touchUpInside)
//        return btn
//    }()

    //盘口
    lazy var dishBtn : UIButton = {
        let btn = UIButton()
        btn.extUseAutoLayout()
        if EXKLineManager.isGreen() == true{
            btn.setImage(UIImage.themeImageNamed(imageName: "defaultpankou"), for: UIControlState.normal)
        }else{
            btn.setImage(UIImage.themeImageNamed(imageName: "default_reversepankou"), for: UIControlState.normal)
        }
        btn.setEnlargeEdgeWithTop(10, left: 10, bottom: 10, right: 10)
//        btn.setImage(UIImage.themeImageNamed(imageName: "defaultpankou"), for: UIControlState.normal)
        btn.extSetAddTarget(self, #selector(clickDishBtn))
        return btn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.ThemeView.bg
        addSubViews([indicatorsLabel,indicatorsPrice,tagLabel,tagPrice,dishBtn])
        indicatorsLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(15)
            make.height.equalTo(12)
            make.left.equalToSuperview()
            make.right.equalTo(indicatorsPrice.snp.left).offset(-10)
        }
        indicatorsPrice.snp.makeConstraints { (make) in
            make.height.centerY.equalTo(indicatorsLabel)
            make.right.equalToSuperview().offset(-15)
            make.width.lessThanOrEqualTo(200)
        }
        tagLabel.snp.makeConstraints { (make) in
            make.top.equalTo(indicatorsLabel.snp.bottom).offset(5)
            make.height.equalTo(12)
            make.left.equalToSuperview()
            make.right.equalTo(tagPrice.snp.left).offset(-10)
        }
        tagPrice.snp.makeConstraints { (make) in
            make.height.centerY.equalTo(tagLabel)
            make.right.equalToSuperview().offset(-15)
            make.width.lessThanOrEqualTo(200)
        }
//        depthBtn.snp.makeConstraints { (make) in
//            make.centerY.equalTo(dishBtn)
//            make.left.equalToSuperview()
//            make.right.equalTo(dishBtn.snp.left).offset(-5)
//        }
        dishBtn.snp.makeConstraints { (make) in
            make.height.equalTo(14)
            make.width.equalTo(16)
            make.right.equalToSuperview().offset(-15)
            make.top.equalTo(tagLabel.snp.bottom).offset(15)
        }
        reloadView()
    }
    
    //点击深度(先不实现)
    @objc func clickDepthBtn(){
        
    }
    
    //点击盘口按钮
    @objc func clickDishBtn(){
        let arr = ["contract_text_defaultMarket".localized(),"contract_text_buyMarket".localized(),"contract_text_sellMarket".localized()]
        let sheet = EXActionSheetView()
        sheet.actionIdxCallback = {[weak self](idx) in
            guard let mySelf = self else{return}
            switch idx {
            case 0:
                self?.type = .defaultPan
            case 1:
                self?.type = .buy
            case 2:
                self?.type = .sell
            default:
                break
            }
            mySelf.clickPankouBlock?(mySelf.type)
        }
        //设置默认值
        var idx = 0
        switch type {
        case .defaultPan:
            idx = 0
        case .buy:
            idx = 1
        case .sell:
            idx = 2
        }
        sheet.configButtonTitles(buttons:  arr,selectedIdx: idx)
        EXAlert.showSheet(sheetView: sheet)
    }
    
    
    
    func reloadView(){
        indicatorsPrice.text = " --"
        tagPrice.text = " --"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class ContractTransactionRightTC: UITableViewCell {
    
    //价格
    lazy var priceLabel : UILabel = {
        let label = UILabel()
        label.extUseAutoLayout()
        label.font = UIFont.ThemeFont.SecondaryRegular
        return label
    }()
    
    //数量
    lazy var volumLabel : UILabel = {
        let label = UILabel()
        label.extUseAutoLayout()
        label.font = UIFont.ThemeFont.SecondaryRegular
        label.textColor = UIColor.ThemeLabel.colorMedium
        label.textAlignment = .right
        label.layoutIfNeeded()
        return label
    }()
    
    //进度视图
    lazy var progressView : UIView = {
        let view = UIView()
        view.extUseAutoLayout()
        return view
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.extSetCell()
        contentView.addSubViews([priceLabel,volumLabel,progressView])
        priceLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.right.equalTo(volumLabel.snp.left).offset(-10)
            make.centerY.equalToSuperview()
            make.height.equalTo(14)
        }
        volumLabel.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-15)
            make.centerY.equalToSuperview()
            make.height.equalTo(14)
        }
        progressView.snp.makeConstraints { (make) in
            make.right.top.bottom.equalToSuperview()
            make.width.equalTo(0)
        }
    }
    
    func setCell(_ entity : ContractTransactionWSEntity , model : ContractContentModel){
        priceLabel.textColor = entity.side == "1" ? UIColor.ThemekLine.up : UIColor.ThemekLine.down
        if entity.price != "--"{
            priceLabel.text = (entity.price as NSString).decimalString1(Int(model.pricePrecision) ?? 8)
        }else{
            priceLabel.text = "--"
        }
        volumLabel.text = entity.volum
        
        progressView.backgroundColor = priceLabel.textColor.withAlphaComponent(0.05)

        progressView.snp.updateConstraints { (make) in
            make.width.equalTo(entity.lenght())
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

class ContractTransationMiddleTC : UITableViewCell{
    
    lazy var oneView : UIView = {
        let view = UIView()
        view.extUseAutoLayout()
        return view
    }()
    
    lazy var twoView : UIView = {
        let view = UIView()
        view.extUseAutoLayout()
        return view
    }()
    
    lazy var threeView : UIView = {
        let view = UIView()
        view.extUseAutoLayout()
        return view
    }()
    
    lazy var fourView : UIView = {
        let view = UIView()
        view.extUseAutoLayout()
        return view
    }()
    
    lazy var fiveView : UIView = {
        let view = UIView()
        view.extUseAutoLayout()
        return view
    }()
    
    var viewArr : [UIView] = []
    
    //提示按钮
    lazy var promptBtn : UIButton = {
        let btn = UIButton()
        btn.extUseAutoLayout()
        btn.setImage(UIImage.themeImageNamed(imageName: "assets_prompt"), for: UIControlState.normal)
        return btn
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.extSetCell()
        contentView.addSubViews([oneView,twoView,threeView,fourView,fiveView,promptBtn])
        oneView.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.height.equalTo(10)
            make.width.equalTo(4)
            make.centerY.equalToSuperview()
        }
        twoView.snp.makeConstraints { (make) in
            make.left.equalTo(oneView.snp.right).offset(2)
            make.height.equalTo(10)
            make.width.equalTo(4)
            make.centerY.equalToSuperview()
        }
        threeView.snp.makeConstraints { (make) in
            make.left.equalTo(twoView.snp.right).offset(2)
            make.height.equalTo(10)
            make.width.equalTo(4)
            make.centerY.equalToSuperview()
        }
        fourView.snp.makeConstraints { (make) in
            make.left.equalTo(threeView.snp.right).offset(2)
            make.height.equalTo(10)
            make.width.equalTo(4)
            make.centerY.equalToSuperview()
        }
        fiveView.snp.makeConstraints { (make) in
            make.left.equalTo(fourView.snp.right).offset(2)
            make.height.equalTo(10)
            make.width.equalTo(4)
            make.centerY.equalToSuperview()
        }
        promptBtn.snp.makeConstraints { (make) in
            make.left.equalTo(fiveView.snp.right).offset(10)
            make.height.width.equalTo(12)
            make.centerY.equalToSuperview()
        }
        
        viewArr = [oneView,twoView,threeView,fourView,fiveView]
        self.setCell(0)
        
        contentView.isUserInteractionEnabled = false
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(clickProptmBtn))
        self.addGestureRecognizer(tap)
    }
    
    @objc func clickProptmBtn(){
        //提示框
        let alert = EXNormalAlert()
        alert.configSigleAlert(title: "contract_tip_autoReduce".localized(), message: "contract_text_autoReduceDesc".localized(), sigleBtnTitle: "alert_common_iknow".localized())
        //展示
        EXAlert.showAlert(alertView: alert)
    }
    
    func setCell(_ num : Int){
        for i in 0..<viewArr.count{
            if i < num{
                viewArr[i].backgroundColor = UIColor.ThemeView.highlight
            }else{
                viewArr[i].backgroundColor = UIColor.ThemeNav.bg
            }
        }
    }
    
//    func setView(_ ){
//
//
//
//    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
