//
//  SLSwapCalculatorVc.swift
//  Chainup
//
//  Created by KarlLichterVonRandoll on 2020/1/6.
//  Copyright © 2020 zewu wang. All rights reserved.
//

import Foundation

class SLSwapCalculatorVc: NavCustomVC {
    private let reuseID = "SLSwapCalculatorCell_ID"
    private let settingReUseID = "SLSwapSettingCell_ID"
    
    var swapType : String = "--"
    var direction : String = "contract_buy_long".localized()
    var leverage : String = "10X"
    
    var itemModel : BTItemModel? {
        didSet {
            if itemModel != nil {
                self.contractModel = itemModel!.contractInfo
                swapType = itemModel?.name ?? "-"
//                leverage = self.contractModel?.max_leverage ?? "100" + "X"
                self.contentTableView.reloadData()
            }
        }
    }
    
    var futures : [BTItemModel] {
        var arrM = [BTItemModel]()
        for obj in SLPublicSwapInfo.sharedInstance()!.getTickersWithArea(.CONTRACT_BLOCK_UNKOWN) ?? [] where obj.contractInfo != nil {
            if obj.name != nil {
                arrM.append(obj)
            }
        }
        arrM.sort { (obj1, obj2) -> Bool in
            obj1.instrument_id < obj2.instrument_id
        }
        return arrM
    }
    
    var textField = UITextField()
    var textField1 = UITextField()
    var textField2 = UITextField()
    
    var contractModel : BTContractsModel?
    
    private lazy var contentTableView: UITableView = {
        let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: self.contentView.height - 155), style: .plain)
        tableView.extSetTableView(self, self)
        tableView.extRegistCell([SLSwapSettingTC.classForCoder(),SLSwapCalculatorTC.classForCoder()],  [self.settingReUseID,self.reuseID])
        return tableView
    }()
    
    private var selectedIndex: Int = 0
    private lazy var sectionView: EXSelectionTitleBar = {
        let view = EXSelectionTitleBar()
        view.setSelected(atIdx: 0)
        view.bindTitleBar(with: ["contract_carculate_lose_gain".localized(), "contract_text_liqPrice".localized(), "contract_target_profit_rate".localized()])
        view.titleBarCallback = {
            [weak self] index in
            self?.selectedIndex = index
            self?.contentTableView.reloadData()
        }
        return view
    }()
    
    private lazy var carculateView: SLSwapCalculatorFootView = {
        let view = SLSwapCalculatorFootView()
        view.backgroundColor = UIColor.ThemeView.bg
        view.tipsLabel.text = "common_text_tip".localized()
        view.tipsContent.text = "contract_carculate_tips".localized()
        view.carculateCallback = {[weak self] tag in
            guard let mySelf = self else{return}
            mySelf.startCarculate()
        }
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.contentView.addSubViews([self.contentTableView])
        view.addSubview(carculateView)
        if #available(iOS 11.0, *) {
            self.contentTableView.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        self.initLayout()
    }
    
    override func setNavCustomV() {
        self.setTitle("contract_fund_calculator".localized())
        self.navtype = .list
        self.xscrollView = self.contentTableView
    }
    
    private func initLayout() {
        self.contentTableView.snp_makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(155)
        }
        self.carculateView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-navBarHeight())
            make.height.equalTo(155)
        }
    }
    
// MARK: - Even Click
    func startCarculate() {
        if self.itemModel == nil {
            return
        }
        let alert = SLSwapCarculateAlertView.init(frame: CGRect.init(), type: self.selectedIndex)
        let order = BTContractOrderModel()
        order.position_type = BTPositionOpenType.pursueType
        order.qty = self.textField.text
        order.px = self.textField1.text
        let markPrice = self.textField2.text
        order.instrument_id = self.itemModel!.instrument_id;
        order.leverage = self.leverage.extStringSub(NSRange.init(location: 0, length: self.leverage.ch_length - 1))
        if self.direction == "contract_buy_long".localized() {
            order.side = BTContractOrderWay.buy_OpenLong
        } else {
            order.side = BTContractOrderWay.sell_OpenShort
        }
        let openModel = BTContractsOpenModel.init(orderModel: order, contractInfo: self.contractModel ?? nil, assets: nil)
        if self.selectedIndex == 0 {
            var profit = "0"
            if self.direction == "contract_buy_long".localized() {
                profit = SLFormula.calculateCloseLongProfitAmount(order.qty, holdAvgPrice: order.px, markPrice: markPrice!, contractSize: self.contractModel!.face_value, isReverse: self.contractModel!.is_reverse).toSmallValue(withContract: self.itemModel!.instrument_id)
            } else {
                profit = SLFormula.calculateCloseShortProfitAmount(order.qty, holdAvgPrice: order.px, markPrice: markPrice!, contractSize: self.contractModel!.face_value, isReverse: self.contractModel!.is_reverse).toSmallValue(withContract: self.itemModel!.instrument_id)
            }
            var deposit = openModel?.im ?? "0"
            if "1".bigDiv(order.leverage).greaterThan(order.imr) {
                deposit = openModel!.orderAvai.bigMul("1".bigDiv(order.leverage))
            }
            deposit = deposit.toSmallValue(withContract: self.itemModel!.instrument_id)
            let value = (openModel?.orderAvai ?? "0").toSmallValue(withContract: self.itemModel!.instrument_id) ?? "0"
            let rate = profit.bigDiv(deposit).toPercentString(2) ?? "0.00 %"
            alert.updataInfo(deposit, value, profit, rate, order.contractInfo.margin_coin)
        } else if self.selectedIndex == 1 {
            let closePx = openModel?.liquidatePrice ?? "0"
            let value = (openModel?.orderAvai ?? "0").toSmallValue(withContract: self.itemModel!.instrument_id) ?? "0"
            let start = order.imr.bigDiv("100").toPercentString(2) ?? "0.00 %"
            let end = order.mmr.toPercentString(2) ?? "0.00 %"
            alert.updataInfo(closePx, value, start, end, order.contractInfo.margin_coin)
        } else if self.selectedIndex == 2 {
            var deposit = openModel?.im ?? "0"
            var value = (openModel?.orderAvai ?? "0").toSmallValue(withContract: self.itemModel!.instrument_id) ?? "0"
            if DecimalOne.bigDiv(order.leverage).greaterThan(order.leverage) {
                deposit = value.bigMul(DecimalOne.bigDiv(order.leverage))
            }
            deposit = deposit.toSmallValue(withContract: self.itemModel!.instrument_id)
            if !self.contractModel!.is_reverse {
                if self.direction == "contract_buy_long".localized() {
                    value = value.bigAdd(markPrice)
                } else {
                    value = value.bigSub(markPrice)
                }
            } else {
                if self.direction == "contract_buy_long".localized() {
                    value = value.bigSub(markPrice)
                } else {
                    value = value.bigAdd(markPrice)
                }
            }
            let targetPrice = SLFormula.calculateQuotePrice(withValue: value, vol: order.qty, contract: self.contractModel!).toSmallPrice(withContractID:self.itemModel!.instrument_id) ?? "0"
            alert.updataInfo(deposit, targetPrice, "", "", order.contractInfo.margin_coin)
        }
        alert.show()
    }
}

// MARK: - UITableViewDelegate & UITableViewDataSource
extension SLSwapCalculatorVc: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        if self.selectedIndex == 1 {
            return 4
        } else {
            return 5
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        if indexPath.section == 1 && indexPath.row > 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: reuseID, for: indexPath) as! SLSwapCalculatorTC
            if indexPath.row == 2 {
                cell.textField.titleLabel.text = "contract_text_position".localized()
                cell.textField.extraLabel.text = "contract_text_volumeUnit".localized()
                self.textField = cell.textField.input
                cell.textField.setPlaceHolder(placeHolder: "contract_text_position".localized())
            } else if indexPath.row == 3 {
                cell.textField.titleLabel.text = "contract_open_position_price".localized()
                self.textField1 = cell.textField.input
                cell.textField.extraLabel.text = self.contractModel?.quote_coin ?? "--"
                cell.textField.setPlaceHolder(placeHolder: "contract_text_price".localized())
            } else if indexPath.row == 4 {
                self.textField2 = cell.textField.input
                if self.selectedIndex == 0 {
                    cell.textField.titleLabel.text = "contract_close_position_price".localized()
                    cell.textField.extraLabel.text = self.contractModel?.quote_coin ?? "--"
                    cell.textField.setPlaceHolder(placeHolder:"" + "contract_text_price".localized())
                } else if self.selectedIndex == 2 {
                    cell.textField.titleLabel.text = "contract_target_profit_value".localized()
                    cell.textField.extraLabel.text = self.contractModel?.margin_coin ?? "--"
                    cell.textField.setPlaceHolder(placeHolder: "contract_deposit_value".localized())
                }
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: settingReUseID, for: indexPath) as! SLSwapSettingTC
            if indexPath.section == 0 {
                cell.nameLabel.text = "contract_swap_type".localized()
                cell.typeLabel.text = self.swapType
                cell.lineView.isHidden = true
            } else if indexPath.section == 1 {
                if indexPath.row == 0 {
                    cell.nameLabel.text = "leverage_direction".localized()
                    cell.typeLabel.text = self.direction
                } else {
                    cell.nameLabel.text = "contract_text_lever".localized()
                    cell.typeLabel.text = self.leverage
                }
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 1 {
            return self.sectionView
        } else {
            return UIView()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        } else {
            return 43
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == 0 {
            let v = UIView()
            v.backgroundColor = UIColor.ThemeNav.bg
            return v
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0 {
            return 10
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 && indexPath.row > 1 {
            return 73
        } else {
            return 50
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 && indexPath.row > 1 {
            return
        }
        let cell = self.contentTableView.cellForRow(at: indexPath) as! SLSwapSettingTC
        let sheet = EXActionSheetView()
        var arr : [String] = []
        if indexPath.section == 0 {
            for item in futures {
                arr.append(item.name ?? "-")
            }
        } else {
            if indexPath.row == 0 {
                arr = ["contract_buy_long".localized(), "contract_sell_short".localized()]
            } else if indexPath.row == 1 {
                let leverageVc = SLLeverageVc()
                
                let makeOrderViewModel = SLSwapMarkOrderViewModel()
                makeOrderViewModel.itemModel = self.itemModel
                leverageVc.makeOrderViewModel = makeOrderViewModel
                leverageVc.currentPx = self.itemModel?.fair_px ?? "0"
                leverageVc.insterment_id = self.itemModel?.instrument_id ?? 0
                leverageVc.clickComfirmLeverage = {[weak self] (positionType, leverage) in
                    guard let mySelf = self else{return}
                    cell.typeLabel.text = leverage + "X"
                    mySelf.leverage = leverage + "X"
                }
                self.navigationController?.pushViewController(leverageVc, animated: true)
                return
            }
        }
        var idx = 0
        for i in 0..<arr.count{
            if arr[i] == cell.typeLabel.text {
                idx = i
                break
            }
        }
        sheet.configButtonTitles(buttons: arr,selectedIdx: idx)
        sheet.actionIdxCallback = {[weak self](idx) in
            guard let mySelf = self else{return}
            cell.typeLabel.text = arr[idx]
            if indexPath.section == 0 {
                mySelf.swapType = cell.typeLabel.text!
                mySelf.itemModel = mySelf.futures[idx]
            } else {
                if indexPath.row == 0 {
                    mySelf.direction = cell.typeLabel.text!
                } else if indexPath.row == 1 {
                    mySelf.leverage = cell.typeLabel.text!
                }
            }
        }
        sheet.actionCancelCallback =  {[weak self]() in
            guard self != nil else{return}
        }
        EXAlert.showSheet(sheetView: sheet)
    }
}

class SLSwapCalculatorTC: UITableViewCell {
    
    lazy var textField : EXTextField = {
        let textField = EXTextField()
        textField.extUseAutoLayout()
        textField.enableTitleModel = true
        textField.input.keyboardType = UIKeyboardType.decimalPad
        textField.maxLenth = 20
        return textField
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.extSetCell()
        self.contentView.addSubViews([textField])
        self.initLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initLayout() {
        textField.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.top.equalToSuperview().offset(20)
            make.bottom.equalToSuperview()
        }
    }
}

class SLSwapCalculatorFootView: UIView {
    typealias FooterCallback = (Int) -> ()
    var carculateCallback : FooterCallback?
    /// 温馨提示
    lazy var tipsLabel: UILabel = {
        let label = UILabel(text: nil, font: UIFont.ThemeFont.SecondaryRegular, textColor: UIColor.ThemeLabel.colorDark, alignment: NSTextAlignment.left)
        label.extUseAutoLayout()
        return label
    }()
    
    ///  提示内容
    lazy var tipsContent: UILabel = {
        let label = UILabel(text: nil, font: UIFont.ThemeFont.SecondaryRegular, textColor: UIColor.ThemeLabel.colorMedium, alignment: NSTextAlignment.left)
        label.numberOfLines = 0
        label.extUseAutoLayout()
        return label
    }()
    
    lazy var startCarculateBtn : EXButton = {
        let btn = EXButton()
        btn.extUseAutoLayout()
        btn.extSetAddTarget(self, #selector(clickStartCarculateBtn))
        btn.setTitle("contract_carculate_start".localized(), for: UIControlState.normal)
        btn.color = UIColor.ThemeBtn.highlight
        return btn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubViews([tipsLabel,tipsContent,startCarculateBtn])
        initLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initLayout() {
        tipsLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.top.equalToSuperview().offset(20)
            make.height.equalTo(16)
            make.width.equalTo(98)
        }
        tipsContent.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.top.equalTo(tipsLabel.snp.bottom).offset(5)
            make.height.equalTo(40)
        }
        startCarculateBtn.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.top.equalTo(tipsContent.snp.bottom).offset(20)
            make.height.equalTo(44)
        }
    }
    
    @objc func clickStartCarculateBtn(_ btn : UIButton){
        self.carculateCallback?(0)
    }
}
