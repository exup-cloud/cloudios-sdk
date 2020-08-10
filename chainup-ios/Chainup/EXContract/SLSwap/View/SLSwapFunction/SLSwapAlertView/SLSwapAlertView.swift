//
//  SLSwapAlertView.swift
//  Chainup
//
//  Created by KarlLichterVonRandoll on 2019/12/24.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import Foundation

class SLSwapOpenSwapView: UIView {
    typealias AlertCallback = (Int64) -> ()
    var alertCallback : AlertCallback?
    
    lazy var mainView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.ThemeView.bg
        self.addSubview(view)
        return view
    }()
    
    lazy var titleLabel : UILabel = {
        let label = UILabel()
        label.extUseAutoLayout()
        label.textAlignment = .left
        label.textColor = UIColor.ThemeLabel.colorLite
        label.font = UIFont.ThemeFont.HeadBold
        label.text = "contract_text_openswap".localized()
        return label
    }()
    
    lazy var tipsView : UITextView = {
        let textView = UITextView(frame: CGRect.init(x: 20, y: 57, width: self.width - 40, height: 423))
        textView.extUseAutoLayout()
        textView.backgroundColor = UIColor.ThemeView.bg;
        textView.font = UIFont.ThemeFont.BodyRegular
        textView.textColor = UIColor.ThemeLabel.colorLite
        textView.isScrollEnabled = true
        textView.text = "contract_text_openswap_risk".localized()
        textView.textAlignment = .left
        textView.isEditable = false
        textView.isScrollEnabled = true
        return textView
    }()
    
    lazy var openContractBtn : EXButton = {
        let btn = EXButton()
        btn.extUseAutoLayout()
        btn.extSetAddTarget(self, #selector(clickOpenContractBtn))
        btn.setTitle("contract_text_knowrisk".localized(), for: UIControlState.normal)
        btn.color = UIColor.ThemeBtn.highlight
        return btn
    }()
    
    func setupUI() {
        titleLabel.snp.makeConstraints { (make) in
            make.height.equalTo(22)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.top.equalToSuperview().offset(18)
        }

        tipsView.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-74)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.top.equalToSuperview().offset(57)
        }
        openContractBtn.snp.makeConstraints { (make) in
            make.height.equalTo(44)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.bottom.equalToSuperview().offset(-15)
        }
    }
    
    @objc func clickOpenContractBtn(_ btn : UIButton){
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.4) {
            self.alertCallback?(0)
        }
        SLSwapOpenSwapView.dismiss(v: self)
    }
    
    override init(frame: CGRect) {
        super.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
        self.backgroundColor = UIColor.ThemeView.mask
        var height = 554
        if (554 + GH_NavStatusBarHeight) > SCREEN_HEIGHT {
            height = Int(SCREEN_HEIGHT - GH_NavStatusBarHeight)
        }
        mainView.frame = CGRect.init(x: 0, y: 0, width: Int(SCREEN_WIDTH - 40), height: height)
        mainView.center = self.center
        mainView.layer.cornerRadius = 3
        mainView.layer.masksToBounds = true
        mainView.addSubViews([titleLabel,tipsView,openContractBtn])
        setupUI()
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
// MARK:- interface
    func show() {
        UIApplication.shared.keyWindow?.addSubview(self)
    }
    static func dismiss(v: UIView) {
        for view in UIApplication.shared.keyWindow!.subviews {
            if view is SLSwapOpenSwapView {
                v.removeFromSuperview()
                break
            }
        }
    }
}

class SLSwapFundRateView: UIView {
    typealias AlertCallback = (Int) -> ()
    var alertCallback : AlertCallback?
    var fundRateData : [BTIndexDetailModel]? {
        didSet {
            if fundRateData != nil && (fundRateData?.count) ?? 0 > 4 {
                contentTableView.reloadData()
            }
        }
    }
    override init(frame: CGRect) {
        super.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
        self.backgroundColor = UIColor.ThemeView.mask
        mainView.frame = CGRect.init(x: 0, y: 0, width: 335, height: 337)
        mainView.center = self.center
        mainView.layer.cornerRadius = 3
        mainView.layer.masksToBounds = true
        mainView.addSubViews([titleLabel,contentLabel,contentTableView,checkMoreBtn,knowBtn])
        titleLabel.snp.makeConstraints { (make) in
            make.height.equalTo(22)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.top.equalToSuperview().offset(18)
        }
        contentLabel.snp.makeConstraints { (make) in
//            make.height.equalTo(36)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
        }
        contentTableView.snp.makeConstraints { (make) in
            make.height.equalTo(140)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.top.equalTo(contentLabel.snp.bottom).offset(10)
        }
        checkMoreBtn.snp.makeConstraints { (make) in
            make.height.equalTo(20)
            make.left.equalToSuperview().offset(20)
            make.top.equalTo(contentTableView.snp.bottom).offset(8)
        }
        knowBtn.snp.makeConstraints { (make) in
            make.height.equalTo(20)
            make.right.equalToSuperview().offset(-20)
            make.bottom.equalToSuperview().offset(-15)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var mainView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.ThemeView.bg
        self.addSubview(view)
        return view
    }()
        
    lazy var titleLabel : UILabel = {
        let label = UILabel()
        label.extUseAutoLayout()
        label.textAlignment = .left
        label.textColor = UIColor.ThemeLabel.colorLite
        label.font = UIFont.ThemeFont.HeadBold
        label.text = "contract_fund_rate".localized()
        return label
    }()
    
    lazy var contentLabel : UILabel = {
        let label = UILabel()
        label.extUseAutoLayout()
        label.textAlignment = .left
        label.textColor = UIColor.ThemeLabel.colorMedium
        label.font = UIFont.ThemeFont.BodyRegular
        label.text = "contract_text_fundRate_intro".localized()
        label.numberOfLines = 0
        return label
    }()
    
    lazy var contentTableView : UITableView = {
        let tableView = UITableView()
        tableView.extUseAutoLayout()
        tableView.isScrollEnabled = false
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.rowHeight = 35
        tableView.backgroundColor = UIColor.ThemeView.bg
        tableView.separatorColor = UIColor.ThemeView.bg
        tableView.allowsSelection = false
        tableView.extSetTableView(self, self)
        tableView.extRegistCell([SLSwapFundRateTC.classForCoder()], ["SLSwapFundRateTC"])
        return tableView
    }()
    
    lazy var checkMoreBtn : UIButton = {
        let btn = UIButton()
        btn.extUseAutoLayout()
        btn.extSetAddTarget(self, #selector(clickCheckMore))
        btn.setTitle("contract_text_checkmore".localized(), for: UIControlState.normal)
        btn.setTitleColor(UIColor.ThemeLabel.colorHighlight, for: .normal)
        btn.titleLabel!.font = UIFont.ThemeFont.BodyBold
        return btn
    }()
    
    lazy var knowBtn : UIButton = {
        let btn = UIButton()
        btn.extUseAutoLayout()
        btn.titleLabel?.textAlignment = .right
        btn.extSetAddTarget(self, #selector(clickIKnow))
        btn.setTitle("alert_common_iknow".localized(), for: UIControlState.normal)
        btn.setTitleColor(UIColor.ThemeLabel.colorHighlight, for: .normal)
        btn.titleLabel!.font = UIFont.ThemeFont.BodyBold
        return btn
    }()
    
    @objc func clickIKnow(_ btn : UIButton){
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.4) {
            self.alertCallback?(0)
        }
        SLSwapFundRateView.dismiss(v: self)
    }
    @objc func clickCheckMore(_ btn : UIButton){
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.4) {
            self.alertCallback?(1)
        }
        SLSwapFundRateView.dismiss(v: self)
    }
    // MARK:- interface
    func show() {
        UIApplication.shared.keyWindow?.addSubview(self)
        self.contentTableView.reloadData()
    }
    static func dismiss(v: UIView) {
        for view in UIApplication.shared.keyWindow!.subviews {
            if view is SLSwapFundRateView {
                v.removeFromSuperview()
                break
            }
        }
    }
    
    static func isShow() -> Bool {
        for view in UIApplication.shared.keyWindow!.subviews {
            if view is SLSwapFundRateView {
                return true
            }
        }
        return false
    }
}

extension SLSwapFundRateView : UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 35
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if fundRateData != nil && (fundRateData?.count) ?? 0 > 4 {
            return 4
        }
        return (fundRateData?.count) ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : SLSwapFundRateTC = tableView.dequeueReusableCell(withIdentifier: "SLSwapFundRateTC") as! SLSwapFundRateTC
        if fundRateData != nil {
            guard let model = fundRateData?[indexPath.row] else {return cell}
            cell.timeLabel.text = BTFormat.timeOnlyDate(fromDateStr: model.timestamp.stringValue)
            cell.rateLabel.text = model.rate.toPercentString(4)
        }
        return cell
    }
}

class SLSwapFundRateTC: UITableViewCell {
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubViews([timeLabel,rateLabel,line])
        extSetCell()
        timeLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.centerY.equalToSuperview()
            make.height.equalTo(14)
            make.width.equalTo(self.contentView.width * 0.5)
        }
        rateLabel.snp.makeConstraints { (make) in
            make.left.equalTo(timeLabel.snp.right)
            make.right.equalToSuperview()
            make.centerY.equalToSuperview()
            make.height.equalTo(14)
        }
        
        line.snp.makeConstraints { (make) in
            make.left.equalTo(timeLabel.snp.left)
            make.height.equalTo(0.5)
            make.width.equalTo(self.contentView.width)
            make.top.equalToSuperview().offset(34)
        }
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var timeLabel : UILabel = {
        let label = UILabel()
        label.extUseAutoLayout()
        label.textAlignment = .left
        label.textColor = UIColor.ThemeLabel.colorMedium
        label.font = UIFont.ThemeFont.SecondaryRegular
        label.text = "--"
        return label
    }()
    
    lazy var rateLabel : UILabel = {
        let label = UILabel()
        label.extUseAutoLayout()
        label.textAlignment = .right
        label.textColor = UIColor.ThemeLabel.colorMedium
        label.font = UIFont.ThemeFont.SecondaryRegular
        label.text = "--"
        return label
    }()
    
    lazy var line : UIView = {
        let v = UIView()
        v.extUseAutoLayout()
        v.backgroundColor = UIColor.ThemeView.seperator
        return v
    }()
}
