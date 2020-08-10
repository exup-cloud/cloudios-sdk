//
//  ContractPositionTC.swift
//  Chainup
//
//  Created by zewu wang on 2019/5/14.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import UIKit

class ContractPositionTC: UITableViewCell {
    
    //点击杠杆跳转
    typealias ClickLeverageBlock = (ContractUserPositionEntity) -> ()
    var clickLeverageBlock : ClickLeverageBlock?
    
    //点击市价平仓
    typealias ClickMarketPositionsBlock = (ContractUserPositionEntity) -> ()
    var clickMarketPositionsBlock : ClickMarketPositionsBlock?
    
    var entity = ContractUserPositionEntity()
    
    //买卖类型
    lazy var dealTypeLabel : UILabel = {
        let label = UILabel()
        label.extUseAutoLayout()
        label.font = UIFont.ThemeFont.HeadRegular
        return label
    }()
    
    //合约名字
    lazy var nameLabel : UILabel = {
        let label = UILabel()
        label.extUseAutoLayout()
        label.layoutIfNeeded()
        label.textColor = UIColor.ThemeLabel.colorLite
        label.font = UIFont.ThemeFont.HeadBold
        return label
    }()
    
    lazy var shareBtn : UIButton = {
        let btn = UIButton()
        btn.extUseAutoLayout()
        btn.setImage(UIImage.themeImageNamed(imageName: "contract_share"), for: UIControlState.normal)
        btn.addTarget(self, action: #selector(clickShareBtn), for: UIControlEvents.touchUpInside)
        return btn
    }()
    
    //合约类型
    lazy var contractTypeLabel : UILabel = {
        let label = UILabel()
        label.extUseAutoLayout()
        label.layoutIfNeeded()
        label.textColor = UIColor.ThemeLabel.colorMedium
        label.font = UIFont.ThemeFont.SecondaryRegular
        return label
    }()
    
    //仓位id
    lazy var positionIdView : ContractPositionDetailView = {
        let view = ContractPositionDetailView()
        view.extUseAutoLayout()
        view.leftLabel.text = "contract_position_id".localized()
        return view
    }()
    
    //强平价格
    lazy var flatPriceView : ContractPositionDetailView = {
        let view = ContractPositionDetailView()
        view.extUseAutoLayout()
        return view
    }()
    
    //已实现盈亏
    lazy var PLEDView : ContractPositionDetailView = {
        let view = ContractPositionDetailView()
        view.extUseAutoLayout()
        view.leftLabel.text = "contract_text_realisedPNL".localized()
        return view
    }()
    
    //保证金
    lazy var marginView : ContractPositionDetailView = {
        let view = ContractPositionDetailView()
        view.extUseAutoLayout()
        view.isEnable = true
        view.leftLabel.text = "contract_text_margin".localized()
        return view
    }()
    
    //开仓均价
    lazy var openAverageView : ContractPositionDetailView = {
        let view = ContractPositionDetailView()
        view.extUseAutoLayout()
        return view
    }()
    
    //仓位数量
    lazy var volumView : ContractPositionDetailView = {
        let view = ContractPositionDetailView()
        view.extUseAutoLayout()
        view.leftLabel.text = "contract_text_positionNumber".localized() + " (\("contract_text_volumeUnit".localized()))"
        return view
    }()
    
    //未实现盈亏
    lazy var PLNView : ContractPositionDetailView = {
        let view = ContractPositionDetailView()
        view.extUseAutoLayout()
        view.leftLabel.text = "contract_text_unrealisedPNL".localized() + "(" + "contract_text_returnRateUnit".localized() + ")"
        return view
    }()
    
    //价值
    lazy var valueView : ContractPositionDetailView = {
        let view = ContractPositionDetailView()
        view.extUseAutoLayout()
        return view
    }()
    
    //标记价格
    lazy var tagPriceView : ContractPositionDetailView = {
        let view = ContractPositionDetailView()
        view.extUseAutoLayout()
        return view
    }()
    
    //横线
    lazy var hlineV : UIView = {
        let view = UIView()
        view.extUseAutoLayout()
        view.backgroundColor = UIColor.ThemeView.seperator
        return view
    }()
    
    //竖线
    lazy var vlineV : UIView = {
        let view = UIView()
        view.extUseAutoLayout()
        view.backgroundColor = UIColor.ThemeView.seperator
        return view
    }()
    
    //调整杠杆
    lazy var adjustBtn : UIButton = {
        let btn = UIButton()
        btn.extUseAutoLayout()
        btn.setTitleColor(UIColor.ThemeBtn.highlight, for: UIControlState.normal)
        btn.titleLabel?.font = UIFont.ThemeFont.HeadBold
        btn.extSetAddTarget(self, #selector(clickAdjustBtn))
        return btn
    }()
    
    //点击调整杠杆
    @objc func clickAdjustBtn(){
        self.clickLeverageBlock?(self.entity)
    }
    
    //市价平仓
    lazy var marketPositionsBtn : UIButton = {
        let btn = UIButton()
        btn.extUseAutoLayout()
        btn.extSetAddTarget(self, #selector(clickMarketBtn))
        btn.setTitleColor(UIColor.ThemeBtn.highlight, for: UIControlState.normal)
        btn.titleLabel?.font = UIFont.ThemeFont.HeadBold
        btn.setTitle("contract_text_marketPriceFlat".localized(), for: UIControlState.normal)
        return btn
    }()
    
    //底部的线
    lazy var bottomView : UIView = {
        let view = UIView()
        view.extUseAutoLayout()
        view.backgroundColor = UIColor.ThemeNav.bg
        return view
    }()
    
    //点击市价平仓
    @objc func clickMarketBtn(){
        self.clickMarketPositionsBlock?(self.entity)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.extSetCell()
        self.contentView.addSubViews([dealTypeLabel,nameLabel,shareBtn,contractTypeLabel,flatPriceView,PLEDView,marginView,openAverageView,volumView,PLNView,valueView,tagPriceView,hlineV,vlineV,adjustBtn,marketPositionsBtn,bottomView])
        
        //分仓模式
        if ContractPublicInfoManager.manager.getContractPositionType() == "1"{
            self.contentView.addSubview(positionIdView)
            positionIdView.snp.makeConstraints { (make) in
                make.height.equalTo(16)
                make.left.right.equalToSuperview()
                make.top.equalTo(dealTypeLabel.snp.bottom).offset(15)
            }
            flatPriceView.snp.makeConstraints { (make) in
                make.height.equalTo(16)
                make.left.right.equalToSuperview()
                make.top.equalTo(positionIdView.snp.bottom).offset(9)
            }
        }else{
            flatPriceView.snp.makeConstraints { (make) in
                make.height.equalTo(16)
                make.left.right.equalToSuperview()
                make.top.equalTo(dealTypeLabel.snp.bottom).offset(15)
            }
        }
        
        dealTypeLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.top.equalToSuperview().offset(15)
            make.height.equalTo(22)
        }
    
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(dealTypeLabel.snp.right).offset(5)
            make.height.equalTo(19)
            make.top.equalTo(dealTypeLabel)
        }
        
        shareBtn.snp.makeConstraints{(make) in
            make.right.equalToSuperview().offset(-15)
            make.height.width.equalTo(20)
            make.centerY.equalTo(nameLabel)
        }
        
        contractTypeLabel.snp.makeConstraints { (make) in
            make.height.equalTo(17)
            make.centerY.equalTo(nameLabel)
            make.left.equalTo(nameLabel.snp.right).offset(6)
        }
        PLEDView.snp.makeConstraints { (make) in
            make.height.equalTo(16)
            make.left.right.equalToSuperview()
            make.top.equalTo(flatPriceView.snp.bottom).offset(9)
        }
        marginView.snp.makeConstraints { (make) in
            make.height.equalTo(16)
            make.left.right.equalToSuperview()
            make.top.equalTo(PLEDView.snp.bottom).offset(9)
        }
        openAverageView.snp.makeConstraints { (make) in
            make.height.equalTo(16)
            make.left.right.equalToSuperview()
            make.top.equalTo(marginView.snp.bottom).offset(9)
        }
        volumView.snp.makeConstraints { (make) in
            make.height.equalTo(16)
            make.left.right.equalToSuperview()
            make.top.equalTo(openAverageView.snp.bottom).offset(9)
        }
        PLNView.snp.makeConstraints { (make) in
            make.height.equalTo(16)
            make.left.right.equalToSuperview()
            make.top.equalTo(volumView.snp.bottom).offset(9)
        }
        valueView.snp.makeConstraints { (make) in
            make.height.equalTo(16)
            make.left.right.equalToSuperview()
            make.top.equalTo(PLNView.snp.bottom).offset(9)
        }
        tagPriceView.snp.makeConstraints { (make) in
            make.height.equalTo(16)
            make.left.right.equalToSuperview()
            make.top.equalTo(valueView.snp.bottom).offset(9)
        }
        hlineV.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.height.equalTo(0.5)
            make.top.equalTo(tagPriceView.snp.bottom).offset(15)
        }
        vlineV.snp.makeConstraints { (make) in
            make.width.equalTo(0.5)
            make.centerX.equalToSuperview()
            make.top.equalTo(hlineV.snp.bottom).offset(10)
            make.bottom.equalTo(bottomView.snp.top).offset(-10)
        }
        adjustBtn.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.height.equalTo(20)
            make.right.equalTo(contentView.snp.centerX)
            make.centerY.equalTo(vlineV)
        }
        marketPositionsBtn.snp.makeConstraints { (make) in
            make.right.equalToSuperview()
            make.left.equalTo(contentView.snp.centerX)
            make.height.equalTo(20)
            make.centerY.equalTo(vlineV)
        }
        bottomView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(10)
        }
    }
    
    //设置视图
    func setCell(_ entity : ContractUserPositionEntity){
        
        self.entity = entity
        
        positionIdView.setRitht(entity.id)
        
        dealTypeLabel.textColor = entity.side_color
        dealTypeLabel.text = entity.side == "BUY" ? "contract_text_long".localized() : "contract_text_short".localized()
        
        nameLabel.text = entity.symbol
        
        if ContractPublicInfoManager.manager.getContractPositionType() == "1"{
            contractTypeLabel.text = entity.contractContentModel.getContractTitle() + " (\(entity.leverageLevel)X)"
        }else{
            contractTypeLabel.text = entity.contractContentModel.getContractTitle()
        }
        
        flatPriceView.setLeft("contract_text_liqPrice".localized() + " (\(entity.quoteSymbol))")
        flatPriceView.setRitht(entity.fmtLiqPrice())
        
        PLEDView.setRitht(entity.fmtRealisedAmountIndex())
        
        marginView.setRitht(entity.fmtMargin() + "BTC")
        marginView.entity = entity
        
        openAverageView.setLeft("contract_text_openAveragePrice".localized() + " (\(entity.quoteSymbol))")
        openAverageView.setRitht(entity.fmtAvgPrice())
        
        volumView.rightLabel.textColor = entity.side_color
        let volume = entity.volume
//        if entity.side == "BUY"{
//            volume = "+" + entity.volume
//        }else{
//            volume = "-" + entity.volume
//        }
        volumView.setRitht(volume)
        
        PLNView.setRitht(entity.fmtUnrealisedAmountIndex() + "(\(entity.fmtUnrealisedRateIndex()))")
        
        valueView.setLeft("contract_text_value".localized() + "(BTC)")
        valueView.setRitht(entity.fmtPriceValue())
        
        tagPriceView.setLeft("contract_text_markPrice".localized() + "(\(entity.quoteSymbol))")
        tagPriceView.setRitht(entity.fmtIndexPrice())
        
        if ContractPublicInfoManager.manager.getContractPositionType() == "1"{
            adjustBtn.setTitle("contract_text_limitPositions".localized(), for: UIControlState.normal)
        }else{
            adjustBtn.setTitle("contract_action_editLever".localized() + "(\(entity.leverageLevel)x)", for: UIControlState.normal)
        }
    }
    
    @objc func clickShareBtn(){
        let view = EXContractShareVIew()
        view.setView(self.entity)
        if let vc = self.yy_viewController{
            view.show(vc)
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

class ContractPositionDetailView : UIView{
    
    var entity = ContractUserPositionEntity()
    
    //点击保证金
    typealias ClickRightLabelBlock = (ContractUserPositionEntity) -> ()
    var clickRightLabelBlock : ClickRightLabelBlock?
    
    var isEnable = false
    {
        didSet{
            setEnable()
        }
    }
    
    lazy var leftLabel : UILabel = {
        let label = UILabel()
        label.extUseAutoLayout()
        label.textColor = UIColor.ThemeLabel.colorMedium
        label.font = UIFont.ThemeFont.SecondaryRegular
        return label
    }()
    
    lazy var rightLabel : UILabel = {
        let label = UILabel()
        label.extUseAutoLayout()
        label.textColor = UIColor.ThemeLabel.colorLite
        label.font = UIFont.ThemeFont.BodyRegular
        label.textAlignment = .right
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubViews([leftLabel,rightLabel])
        leftLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.right.equalTo(self.snp.centerX)
            make.height.equalTo(14)
            make.centerY.equalToSuperview()
        }
        rightLabel.snp.makeConstraints { (make) in
            make.height.equalTo(16)
            make.left.equalTo(self.snp.centerX)
            make.right.equalToSuperview().offset(-15)
            make.centerY.equalToSuperview()
        }
    }
    
    func setEnable(){
        rightLabel.textColor = UIColor.ThemeLabel.colorHighlight
        rightLabel.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(clickRightLabel))
        rightLabel.addGestureRecognizer(tap)
    }
    
    func setLeft(_ left : String){
        leftLabel.text = left
    }
    
    func setRitht(_ right : String){
        rightLabel.text = right
    }
    
    //点击右边的按钮
    @objc func clickRightLabel(){
        self.clickRightLabelBlock?(self.entity)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
