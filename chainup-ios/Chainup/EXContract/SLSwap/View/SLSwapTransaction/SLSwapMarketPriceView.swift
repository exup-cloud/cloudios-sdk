//
//  SLSwapMarketPriceView.swift
//  Chainup
//
//  Created by KarlLichterVonRandoll on 2019/12/20.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import Foundation

class SLSwapMarketPriceView: UIView {
    
    // 点击深度价格
    typealias ClickRightBlock = (SLOrderBookModel) -> ()
    var clickRightBlock : ClickRightBlock?
    var decimal : NSInteger = 0
    var depthCount = 5
    var itemModel : BTItemModel? {
        didSet {
            if itemModel != nil {
                footView.indicatorsPrice.text = itemModel!.index_px.toSmallPrice(withContractID: itemModel!.instrument_id)
                footView.fairPrice.text = itemModel!.fair_px.toSmallPrice(withContractID: itemModel!.instrument_id)
                footView.fundRatePrice.text = (itemModel!.funding_rate ?? "0").toPercentString(3)
                footView.contractID = itemModel!.instrument_id
                decimal = NSString.getPrice_unit(withContractID: itemModel!.instrument_id) / 10
                isCoin = BTStoreData.storeBool(forKey: BT_UNIT_VOL)
            }
        }
    }
    var isCoin : Bool? {
        didSet {
            var unit = "contract_text_volumeUnit".localized()
            if isCoin == true {
                unit = itemModel?.contractInfo.base_coin ?? "--"
            }
            headView.volumLabel.text = "charge_text_volume".localized() + "(" + unit + ")"
        }
    }
    
    var buyTableViewRowDatas : [SLOrderBookModel] = []
    var sellTableViewRowDatas : [SLOrderBookModel] = []
    
    var tableViewRowDatas : [SLOrderBookModel] = []
    var middleTCRow = 5
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        reloadView()
    }
    
    func reloadView(){
        tableViewRowDatas.removeAll()
        buyTableViewRowDatas.removeAll()
        sellTableViewRowDatas.removeAll()
        for i in 0..<11{
            if i < 5{
                let order = SLOrderBookModel()
                order.way = "2"
                tableViewRowDatas.append(order)
            } else {
                let order = SLOrderBookModel()
                order.way = "1"
                tableViewRowDatas.append(order)
            }
            buyTableViewRowDatas.append(SLOrderBookModel())
            
            let sell = SLOrderBookModel()
            sell.way = "2"
            sellTableViewRowDatas.append(sell)
        }
        tableView.reloadData()
    }
    
    // 刷新深度数据
    func updateDepthData(instrument_id : Int64) {
        if instrument_id == itemModel?.instrument_id {
            let maxVolume = self.findMaxVolFromDepthData()
            let buys = SLPublicSwapInfo.sharedInstance()?.getBidOrderBooks(10) ?? []
            let sells = SLPublicSwapInfo.sharedInstance()?.getAskOrderBooks(10) ?? []
            self.setBuy(buys, max: maxVolume)
            self.setSell(sells, max: maxVolume)
        }
    }
    
    // 清除深度数据
    func clearDepathData() {
        SLPublicSwapInfo.sharedInstance().clearOrderBooks()
        let maxVolume = self.findMaxVolFromDepthData()
        self.setBuy(SLPublicSwapInfo.sharedInstance()?.getBidOrderBooks(10) ?? [], max: maxVolume)
        self.setSell(SLPublicSwapInfo.sharedInstance()?.getAskOrderBooks(10) ?? [], max: maxVolume)
    }
    
    //设置买
    func setBuy(_ buys : [SLOrderBookModel] , max : String){
        buyTableViewRowDatas.removeAll()
        for _ in 0..<11{
            let buy = SLOrderBookModel()
            buy.way = "1"
            buyTableViewRowDatas.append(buy)
        }
        var buyArr : [SLOrderBookModel] = []
        if buys.count > 11 {
            for i in 0..<11 {
                buyArr.append(buys[i])
            }
        } else {
            buyArr = buys
        }
        for i in 0..<buyArr.count {
            buyTableViewRowDatas[i].px = buyArr[i].px
            if isCoin == true {
                let qty = SLFormula.ticket(toCoin: buyArr[i].qty, price: buyArr[i].px, contract: itemModel!.contractInfo).toSmallValue(withContract: itemModel!.instrument_id)
                let maxQty = SLFormula.ticket(toCoin: max, price: buyArr[i].px, contract: itemModel!.contractInfo)
                buyTableViewRowDatas[i].qty = qty
                buyTableViewRowDatas[i].max_volume = maxQty
            } else {
                buyTableViewRowDatas[i].qty = buyArr[i].qty
                buyTableViewRowDatas[i].max_volume = max
            }
        }
        setTableViewRowDatas()
    }
    
    //设置卖
    func setSell(_ sells : [SLOrderBookModel] , max : String){
        sellTableViewRowDatas.removeAll()
        for _ in 0..<11{
            let sell = SLOrderBookModel()
            sell.way = "2"
            sellTableViewRowDatas.append(sell)
        }
        var sellArr : [SLOrderBookModel] = []
        if sells.count > 11 {
            for i in (0..<11) {
                sellArr.append(sells[i])
            }
        } else {
            sellArr = sells
        }
        for i in 0..<sellArr.count {
            sellTableViewRowDatas[10 - i].px = sellArr[i].px
            if isCoin == true {
                let qty = SLFormula.ticket(toCoin: sellArr[i].qty, price: sellArr[i].px, contract: itemModel!.contractInfo).toSmallValue(withContract: itemModel!.instrument_id)
                let maxQty = SLFormula.ticket(toCoin: max, price: sellArr[i].px, contract: itemModel!.contractInfo)
                sellTableViewRowDatas[10 - i].qty = qty
                sellTableViewRowDatas[10 - i].max_volume = maxQty
            } else {
                sellTableViewRowDatas[10 - i].qty = sellArr[i].qty
                sellTableViewRowDatas[10 - i].max_volume = max
            }
        }
        setTableViewRowDatas()
    }
    
    func setTableViewRowDatas(){
        tableViewRowDatas = []
        for _ in 0..<11{
            tableViewRowDatas.append(SLOrderBookModel())
        }
        if middleTCRow == 0{
            tableViewRowDatas[1..<11] = buyTableViewRowDatas[0..<10]
        }else if middleTCRow == 5{
            tableViewRowDatas[6..<11] = buyTableViewRowDatas[0..<5]
            tableViewRowDatas[0..<5] = sellTableViewRowDatas[6..<11]
        }else{
            tableViewRowDatas[0..<10] = sellTableViewRowDatas[1..<11]
        }
        tableView.reloadData()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Lazy
    lazy var headView : SLSwapMarketPriceHeaderView = {
        let view = SLSwapMarketPriceHeaderView()
        return view
    }()
    
    lazy var footView : SLSwapMarketPriceFooterView = {
        let view = SLSwapMarketPriceFooterView()
        view.clickPankouBlock = {[weak self](type) in
            switch type{
            case .defaultPan:// 默认盘口
                self?.depthCount = 5
                self?.middleTCRow = 5
                if EXKLineManager.isGreen() == true{
                    self?.footView.dishBtn.setImage(UIImage.themeImageNamed(imageName: "defaultpankou"), for: UIControlState.normal)
                } else {
                    self?.footView.dishBtn.setImage(UIImage.themeImageNamed(imageName: "default_reversepankou"), for: UIControlState.normal)
                }
            case .buy: // 买
                self?.depthCount = 10
                self?.middleTCRow = 0
                if EXKLineManager.isGreen() == true{
                    self?.footView.dishBtn.setImage(UIImage.themeImageNamed(imageName: "buy"), for: UIControlState.normal)
                }else{
                    self?.footView.dishBtn.setImage(UIImage.themeImageNamed(imageName: "sell"), for: UIControlState.normal)
                }
            case .sell: // 卖
                self?.depthCount = 10
                self?.middleTCRow = 10
                if EXKLineManager.isGreen() == true{
                    self?.footView.dishBtn.setImage(UIImage.themeImageNamed(imageName: "sell"), for: UIControlState.normal)
                }else{
                    self?.footView.dishBtn.setImage(UIImage.themeImageNamed(imageName: "buy"), for: UIControlState.normal)
                }
            }
            self?.setTableViewRowDatas()
        }
        view.clickFundRateBlock = {[weak self] in
            let vc = SLSwapFundRateVC()
            vc.itemModel = self?.itemModel
            self?.yy_viewController?.navigationController?.pushViewController(vc, animated: true)
        }
        return view
    }()
    
    lazy var tableView : UITableView = {
        let tableView = UITableView()
        tableView.extUseAutoLayout()
        tableView.bounces = false
        tableView.extSetTableView(self, self)
        tableView.extRegistCell([SLSwapMarketPriceTC.classForCoder(),SLSwapMarketPriceMiddleTC.classForCoder()], ["SLSwapMarketPriceTC","SLSwapMarketPriceMiddleTC"])
        return tableView
    }()
    
    /// 取出前 11 条数据中的最大值
    func findMaxVolFromDepthData() -> (String) {
        var maxBuyVol: Double = 0
        var maxSellVol: Double = 0
        let buys = SLPublicSwapInfo.sharedInstance()?.getBidOrderBooks(10) ?? []
        let sells = SLPublicSwapInfo.sharedInstance()?.getAskOrderBooks(10) ?? []
        for i in 0..<11 {
            if let buyModel = buys[safe: i] {
                if BasicParameter.handleDouble(buyModel.qty) > maxBuyVol {
                    maxBuyVol = BasicParameter.handleDouble(buyModel.qty)
                }
            }
            if let sellModel = sells[safe: i] {
                if BasicParameter.handleDouble(sellModel.qty) > maxSellVol {
                    maxSellVol = BasicParameter.handleDouble(sellModel.qty)
                }
            }
        }
        return String(max(maxBuyVol, maxSellVol))
    }
}

// MARK: - functuin view

class SLSwapMarketPriceHeaderView : UIView{
    
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
            make.right.equalTo(volumLabel.snp.left)
            make.top.equalToSuperview().offset(18)
            make.height.equalTo(14)
        }
        volumLabel.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-15)
            make.top.equalToSuperview().offset(18)
            make.height.equalTo(14)
            make.width.equalTo(priceLabel.snp.width)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

enum SLSwapMarketPriceShowType {
    case defaultPan
    case buy
    case sell
}

class SLSwapMarketPriceFooterView : UIView{
    
    var type = TransactionPankouType.defaultPan
    
    typealias ClickPankouBlock = (TransactionPankouType) -> ()
    var clickPankouBlock : ClickPankouBlock?
    
    typealias ClickFundRateBlock = () -> ()
    var clickFundRateBlock : ClickFundRateBlock?
    var showAlert = false
    var contractID : Int64 = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.ThemeView.bg
        addSubViews([dishBtn,indicatorsLabel,indicatorsPrice,fairLabel,fairPrice,fairBtn,fundRateLabel,fundRateBtn,fundRatePrice])
        dishBtn.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(10)
            make.width.equalTo(16)
            make.right.equalToSuperview().offset(-15)
        }
        indicatorsLabel.snp.makeConstraints { (make) in
            make.top.equalTo(dishBtn.snp.bottom).offset(15)
            make.height.equalTo(12)
            make.left.equalToSuperview()
            make.right.equalTo(indicatorsPrice.snp.left).offset(-10)
        }
        indicatorsPrice.snp.makeConstraints { (make) in
            make.height.centerY.equalTo(indicatorsLabel)
            make.right.equalToSuperview().offset(-15)
            make.width.lessThanOrEqualTo(200)
        }
        fairLabel.snp.makeConstraints { (make) in
            make.top.equalTo(indicatorsLabel.snp.bottom).offset(10)
            make.height.equalTo(14)
            make.left.equalToSuperview()
            make.right.equalTo(fairPrice.snp.left).offset(-10)
        }
        fairBtn.snp.makeConstraints { (make) in
            make.left.equalTo(fairLabel.snp.right).offset(2)
            make.centerY.equalTo(fairLabel)
        }
        fairPrice.snp.makeConstraints { (make) in
            make.height.centerY.equalTo(fairLabel)
            make.right.equalToSuperview().offset(-15)
            make.width.lessThanOrEqualTo(200)
        }
        fundRateLabel.snp.makeConstraints { (make) in
            make.top.equalTo(fairPrice.snp.bottom).offset(10)
            make.height.equalTo(14)
            make.left.equalToSuperview()
            make.right.equalTo(fairPrice.snp.left).offset(-10)
        }
        fundRateBtn.snp.makeConstraints { (make) in
            make.left.equalTo(fundRateLabel.snp.right).offset(2)
            make.centerY.equalTo(fundRateLabel)
        }
        fundRatePrice.snp.makeConstraints { (make) in
            make.height.centerY.equalTo(fundRateLabel)
            make.right.equalToSuperview().offset(-15)
            make.width.lessThanOrEqualTo(200)
        }
        reloadView()
    }
    
    // MARK: - 懒加载控件
    /// 指数价格
    lazy var indicatorsLabel : UILabel = {
        let label = UILabel()
        label.extUseAutoLayout()
        label.textColor = UIColor.ThemeLabel.colorMedium
        label.font = UIFont.ThemeFont.SecondaryRegular
        label.text = "contract_text_indexPrice".localized()
        return label
    }()
    
    /// 指数价格
    lazy var indicatorsPrice : UILabel = {
        let label = UILabel()
        label.extUseAutoLayout()
        label.textAlignment = .right
        label.textColor = UIColor.ThemeLabel.colorMedium
        label.font = UIFont.ThemeFont.SecondaryRegular
        return label
    }()
    
    /// 合理价格
    lazy var fairLabel : UILabel = {
        let label = UILabel()
        label.extUseAutoLayout()
        label.textColor = UIColor.ThemeLabel.colorMedium
        label.font = UIFont.ThemeFont.SecondaryRegular
        label.text = "contract_text_fairPrice".localized()
        label.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(clickFairBtn))
        label.addGestureRecognizer(tap)
        return label
    }()
    
    /// 合理价格
    lazy var fairPrice : UILabel = {
        let label = UILabel()
        label.extUseAutoLayout()
        label.textAlignment = .right
        label.textColor = UIColor.ThemeLabel.colorMedium
        label.font = UIFont.ThemeFont.SecondaryRegular
        return label
    }()
    
    /// 资金费率
    lazy var fundRateLabel : UILabel = {
        let label = UILabel()
        label.extUseAutoLayout()
        label.textColor = UIColor.ThemeLabel.colorMedium
        label.font = UIFont.ThemeFont.SecondaryRegular
        label.text = "contract_text_fundRate".localized()
        label.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(clickFundRateBtn))
        label.addGestureRecognizer(tap)
        return label
    }()
    
    /// 资金费率
    lazy var fundRatePrice : UILabel = {
        let label = UILabel()
        label.extUseAutoLayout()
        label.textAlignment = .right
        label.textColor = UIColor.ThemeLabel.colorMedium
        label.font = UIFont.ThemeFont.SecondaryRegular
        return label
    }()

    /// 合理价格提示
    lazy var fairBtn : UIButton = {
        let btn = UIButton()
        btn.extUseAutoLayout()
        btn.setEnlargeEdgeWithTop(10, left: 10, bottom: 10, right: 10)
        btn.setImage(UIImage.themeImageNamed(imageName: "contract_prompt"), for: UIControlState.normal)
        btn.extSetAddTarget(self, #selector(clickFairBtn))
        return btn
    }()
    
    /// 资金费率提示
    lazy var fundRateBtn : UIButton = {
        let btn = UIButton()
        btn.extUseAutoLayout()
        btn.setEnlargeEdgeWithTop(10, left: 10, bottom: 10, right: 10)
        btn.setImage(UIImage.themeImageNamed(imageName: "contract_prompt"), for: UIControlState.normal)
        btn.extSetAddTarget(self, #selector(clickFundRateBtn))
        return btn
    }()
    
    /// 盘口
    lazy var dishBtn : UIButton = {
        let btn = UIButton()
        btn.extUseAutoLayout()
        if EXKLineManager.isGreen() == true{
            btn.setImage(UIImage.themeImageNamed(imageName: "defaultpankou"), for: UIControlState.normal)
        }else{
            btn.setImage(UIImage.themeImageNamed(imageName: "default_reversepankou"), for: UIControlState.normal)
        }
        btn.setEnlargeEdgeWithTop(10, left: 10, bottom: 10, right: 10)
        btn.extSetAddTarget(self, #selector(clickDishBtn))
        return btn
    }()
    
    /// 点击盘口按钮
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
    
    // 点击合理价格
    @objc func clickFairBtn() {
        if showAlert == true {
            return
        }
        let alert = EXNormalAlert()
        alert.configSigleAlert(title: "contract_text_fairPrice".localized(), message: "contract_text_fairPrice_tips".localized(), sigleBtnTitle: "alert_common_iknow".localized())
        //展示
        EXAlert.showAlert(alertView: alert)
    }
    
    // 点击资金费率
    @objc func clickFundRateBtn() {
        if showAlert == true {
            return
        }
        showAlert = true
        BTContractTool.getFundingrateWithContractID(self.contractID, success: { (item) in
            guard let dataArr = item as? [BTIndexDetailModel] else {return}
            //         资金费率
            let alert = SLSwapFundRateView(frame: CGRect.init(x: 0, y: 0, width:335, height: 337))
            alert.fundRateData = dataArr
            alert.alertCallback = { [weak self] idx in
                guard let weakSelf = self else { return }
                if idx == 1 {
                    weakSelf.clickFundRateBlock?()
                }
                weakSelf.showAlert = false
            }
            alert.show()
        }) { (error) in
            self.showAlert = false
        }
    }
    
    func reloadView(){
        indicatorsPrice.text = " --"
        fairPrice.text = " --"
        fundRatePrice.text = "--"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class SLSwapMarketPriceTC: UITableViewCell {
    
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
    
    func setCell(_ entity : SLOrderBookModel){
        priceLabel.textColor = entity.way == "1" ? UIColor.ThemekLine.up : UIColor.ThemekLine.down
        if entity.px != nil {
            priceLabel.text = entity.px
        } else {
            priceLabel.text = "--"
        }
        if entity.qty != nil {
            volumLabel.text = entity.qty
        } else {
            volumLabel.text = "--"
        }
        
        progressView.backgroundColor = priceLabel.textColor.withAlphaComponent(0.05)

        var lenght : CGFloat = 0
        if entity.max_volume != "0" , volumLabel.text != "--"{
            if let l = NSString.init(string: volumLabel.text!).dividing(by: entity.max_volume, decimals: 8) {
                lenght = CGFloat(Float(l) ?? 0) * SCREEN_WIDTH * (1 - proportion1)
            }
        }
        progressView.snp.updateConstraints { (make) in
            make.width.equalTo(lenght)
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

class SLSwapMarketPriceMiddleTC : UITableViewCell{
    
    lazy var oneView : UIView = {
        let view = UIView()
        view.extUseAutoLayout()
        view.backgroundColor = UIColor.ThemeNav.bg
        return view
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.extSetCell()
        contentView.addSubViews([oneView])
        oneView.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.right.equalToSuperview().offset(-15)
            make.height.equalTo(1)
            make.centerY.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SLSwapMarketPriceView : UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return headView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return footView
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == middleTCRow{
            return 22
        }else{
            return 24
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 11
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == middleTCRow {
            let cell : SLSwapMarketPriceMiddleTC = tableView.dequeueReusableCell(withIdentifier: "SLSwapMarketPriceMiddleTC") as! SLSwapMarketPriceMiddleTC
            return cell
        }else{
            let cell : SLSwapMarketPriceTC = tableView.dequeueReusableCell(withIdentifier: "SLSwapMarketPriceTC") as! SLSwapMarketPriceTC
            let entity = tableViewRowDatas[indexPath.row]
            cell.setCell(entity)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row != middleTCRow{
            let entity = tableViewRowDatas[indexPath.row]
            if entity.px != "--"{
                self.clickRightBlock?(entity)
            }
        }
    }
}
