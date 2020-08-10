//
//  SLSwapSettingVc.swift
//  Chainup
//
//  Created by KarlLichterVonRandoll on 2019/12/25.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import Foundation

class SLSwapSettingVc: NavCustomVC {
    
    typealias SelectUnitBlock = () -> ()
    var selectUnitBlock : SelectUnitBlock?
    
    typealias TriggerChangeBlock = () -> ()
    var triggerChangeBlock : TriggerChangeBlock?
    
    let cellReUseID = "SLSwapSettingCell_ID"
    lazy var contentTableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .plain)
        tableView.rowHeight = 48
        tableView.extSetTableView(self, self)
        tableView.extRegistCell([SLSwapSettingTC.classForCoder()], [cellReUseID])
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 11.0, *) {
            self.contentTableView.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        
        self.contentView.addSubview(self.contentTableView)
        self.initLayout()
    }
    
    override func setNavCustomV() {
        self.setTitle("contract_fund_setting".localized())
        self.navtype = .list
    }
    
    private func initLayout() {
        self.contentTableView.snp_makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(self.navCustomView.snp_bottom)
        }
    }
}

// MARK: - UITableViewDelegate & UITableViewDataSource

extension SLSwapSettingVc: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 3
        }
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReUseID, for: indexPath) as! SLSwapSettingTC
        cell.showSwitchV(false)
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                cell.nameLabel.text = "contract_swap_show_unit".localized()
                cell.typeLabel.text = "contract_text_volumeUnit".localized()
                let idx = BTStoreData.storeObject(forKey: BT_UNIT_VOL) as? Int ?? 0
                if idx == 0 {
                    cell.typeLabel.text = "contract_text_volumeUnit".localized()
                } else {
                    cell.typeLabel.text = "contract_swap_coin".localized()
                }
            } else if indexPath.row == 1  {
                cell.nameLabel.text = "contract_carculate_unrealisedPNL".localized()
                let idx = BTStoreData.storeObject(forKey: ST_UNREA_CARCUL) as? Int ?? 0
                if idx == 0 {
                    cell.typeLabel.text = "contract_last_price".localized()
                } else {
                    cell.typeLabel.text = "contract_text_fairPrice".localized()
                }
            } else {
                cell.nameLabel.text = "contract_submitorder_confirm".localized()
                cell.showSwitchV(true)
                cell.switchV.setOn(isOn: XUserDefault.getOnComfirmSwapAlert())
                cell.lineView.isHidden = true
                cell.onValueChangeCallback = {[weak self]b in
                    guard let mySelf = self else{return}
                    mySelf.switchV(b)
                }
            }
        } else {
            if indexPath.row == 0 {
                cell.nameLabel.text = "contract_effective_time".localized()
                let idx = BTStoreData.storeObject(forKey: ST_DATE_CYCLE) as? Int ?? 0
                if idx == 0 {
                    cell.typeLabel.text = "contract_cycle_oneday".localized()
                } else {
                    cell.typeLabel.text = "contract_cycle_oneweek".localized()
                }
            } else {
                cell.nameLabel.text = "contract_trigger_type".localized()
                let idx = BTStoreData.storeObject(forKey: ST_TIGGER_PRICE) as? Int ?? 0
                if idx == 0 {
                    cell.typeLabel.text = "contract_last_price".localized()
                } else if idx == 1 {
                    cell.typeLabel.text = "contract_text_fairPrice".localized()
                } else {
                    cell.typeLabel.text = "contract_text_indexPrice".localized()
                }
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 1 {
            let view = UIView()
            view.backgroundColor = UIColor.ThemeNav.bg
            let label = UILabel(text: "contract_plan_order_setting".localized(), font: UIFont.ThemeFont.SecondaryRegular, textColor: UIColor.ThemeLabel.colorMedium, alignment: .left)
            view.addSubview(label)
            label.snp.makeConstraints { (make) in
                make.left.equalToSuperview().offset(15)
                make.top.equalToSuperview().offset(10)
                make.height.equalTo(17)
                make.right.equalToSuperview().offset(-15)
            }
            return view
        }
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1 {
            return 32
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 48
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sheet = EXActionSheetView()
        var arr : [String]?
        var idx = 0
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                arr = ["contract_text_volumeUnit".localized(),"contract_swap_coin".localized()]
                idx = BTStoreData.storeObject(forKey: BT_UNIT_VOL) as? Int ?? 0
            } else if indexPath.row == 1 {
                arr = ["contract_last_price".localized(),"contract_text_fairPrice".localized()]
                idx = BTStoreData.storeObject(forKey: ST_UNREA_CARCUL) as? Int ?? 0
            } else {
                return
            }
        } else {
            if indexPath.row == 0 {
                arr = ["contract_cycle_oneday".localized(),"contract_cycle_oneweek".localized()]
                idx = BTStoreData.storeObject(forKey: ST_DATE_CYCLE) as? Int ?? 0
            } else {
                arr = ["contract_last_price".localized(),"contract_text_fairPrice".localized(),"contract_text_indexPrice".localized()]
                idx = BTStoreData.storeObject(forKey: ST_TIGGER_PRICE) as? Int ?? 0
            }
        }
        sheet.configButtonTitles(buttons: arr!,selectedIdx: idx)
        sheet.actionIdxCallback = {[weak self](idx) in
            guard let mySelf = self else{return}
            mySelf.handleSelectedRow(indexPath: indexPath, idx: idx)
        }
        sheet.actionCancelCallback =  {() in
        }
        EXAlert.showSheet(sheetView: sheet)
    }
    
    func handleSelectedRow(indexPath: IndexPath, idx: Int) {
        let cell = self.contentTableView.cellForRow(at: indexPath) as! SLSwapSettingTC
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                if idx == 0 { /// 张
                    cell.typeLabel.text = "contract_text_volumeUnit".localized()
                } else { /// 币
                    cell.typeLabel.text = "contract_swap_coin".localized()
                }
                BTStoreData.setStoreObjectAndKey(idx, key: BT_UNIT_VOL)
                self.selectUnitBlock?()
            } else if indexPath.row == 1 {
                if idx == 0 { /// 最新价格
                    cell.typeLabel.text = "contract_last_price".localized()
                } else { /// 合理价格
                    cell.typeLabel.text = "contract_text_fairPrice".localized()
                }
                BTStoreData.setStoreObjectAndKey(idx, key: ST_UNREA_CARCUL)
            }
        } else {
            if indexPath.row == 0 {
                if idx == 0 { /// 24h
                    cell.typeLabel.text = "contract_cycle_oneday".localized()
                } else { /// 7天
                    cell.typeLabel.text = "contract_cycle_oneweek".localized()
                }
                BTStoreData.setStoreObjectAndKey(idx, key: ST_DATE_CYCLE)
            } else {
                if idx == 0 { /// 最新价格
                    cell.typeLabel.text = "contract_last_price".localized()
                } else if idx == 1 { /// 合理价格
                    cell.typeLabel.text = "contract_text_fairPrice".localized()
                } else { /// 指数价格
                    cell.typeLabel.text = "contract_text_indexPrice".localized()
                }
                BTStoreData.setStoreObjectAndKey(idx, key: ST_TIGGER_PRICE)
                self.triggerChangeBlock?()
            }
        }
    }
    
    func switchV(_ b : Bool){
        if b == true{//开启手势
            XUserDefault.setComfirmSwapAlert(true)
        }else{
            XUserDefault.setComfirmSwapAlert(false)
        }
        self.contentTableView.reloadData()
    }
}

class SLSwapSettingTC: UITableViewCell {
    typealias OnValueChangeCallback = (Bool) -> ()
    var onValueChangeCallback : OnValueChangeCallback?
    
    /// 选项名称
    lazy var nameLabel: UILabel = {
        let label = UILabel(text: nil, font: UIFont.ThemeFont.BodyRegular, textColor: UIColor.ThemeLabel.colorLite, alignment: NSTextAlignment.left)
        label.extUseAutoLayout()
        return label
    }()
    
    /// 类型种类
    lazy var typeLabel: UILabel = {
        let label = UILabel(text: nil, font: UIFont.ThemeFont.SecondaryRegular, textColor: UIColor.ThemeLabel.colorMedium, alignment: NSTextAlignment.right)
        label.extUseAutoLayout()
        return label
    }()
    
    lazy var arrowView: UIImageView = {
        let arrow = UIImageView(image: UIImage.themeImageNamed(imageName: "contract_enter"))
        arrow.extUseAutoLayout()
        arrow.contentMode = .scaleAspectFit
        return arrow
    }()
    
    lazy var switchV : EXSwitch = {
        let view = EXSwitch()
        view.extUseAutoLayout()
        view.layoutIfNeeded()
        view.onValueChangeCallback = {[weak self] b in
            guard let mySelf = self else{return}
            mySelf.onValueChangeCallback?(b)
        }
        view.isHidden = true
        return view
    }()
    
    lazy var lineView: UIView = {
        let line = UIView()
        line.backgroundColor = UIColor.ThemeView.seperator
        line.extUseAutoLayout()
        return line
    }()
    
    func showSwitchV(_ status : Bool) {
        if status {
            switchV.isHidden = false
            arrowView.isHidden = true
        } else {
            switchV.isHidden = true
            arrowView.isHidden = false
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.extSetCell()
        self.contentView.addSubViews([nameLabel,typeLabel,arrowView,switchV,lineView])
        self.initLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initLayout() {
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.top.equalToSuperview().offset(15)
            make.height.equalTo(20)
        }
        arrowView.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-15)
            make.centerY.equalTo(nameLabel.snp.centerY)
            make.width.equalTo(8.5)
            make.height.equalTo(10)
        }
        typeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(nameLabel.snp.right).offset(15)
            make.right.equalTo(arrowView.snp.left).offset(-5)
            make.centerY.equalTo(nameLabel.snp.centerY)
            make.height.equalTo(20)
        }
        switchV.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-15)
        }
        lineView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(0.5)
        }
    }
}
