//
//  SLSwapCarculateAlertView.swift
//  Chainup
//
//  Created by KarlLichterVonRandoll on 2020/1/6.
//  Copyright © 2020 zewu wang. All rights reserved.
//

import Foundation

class SLSwapCarculateAlertView : UIView {
    typealias AlertCallback = (Int) -> ()
    var alertCallback : AlertCallback?
    var type = 0
    
    init(frame: CGRect ,type: Int) {
        super.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
        self.type = type
        self.backgroundColor = UIColor.ThemeView.mask
        mainView.layer.cornerRadius = 3
        mainView.layer.masksToBounds = true
        if type == 0 {
            mainView.frame = CGRect.init(x: 0, y: 0, width: 335, height: 217)
            mainView.addSubViews([titleLabel,
                                  depositLabel,
                                  positionLabel,
                                  resultLabel,
                                  resultLabel2,
                                  depositNumber,
                                  positionNumber,
                                  resultNum1,
                                  resultNum2,
                                  cancelBtn,
                                  confirm,
                                  unit1])
            titleLabel.snp.makeConstraints { (make) in
                make.height.equalTo(22)
                make.left.equalToSuperview().offset(20)
                make.right.equalToSuperview().offset(-20)
                make.top.equalToSuperview().offset(18)
            }
            depositLabel.snp.makeConstraints { (make) in
                make.height.equalTo(14)
                make.left.equalToSuperview().offset(20)
                make.top.equalTo(titleLabel.snp.bottom).offset(20)
                make.width.equalTo((mainView.width - 40) * 0.5)
            }
            positionLabel.snp.makeConstraints { (make) in
                make.height.equalTo(14)
                make.left.equalToSuperview().offset(20)
                make.top.equalTo(depositLabel.snp.bottom).offset(12)
                make.width.equalTo((mainView.width - 40) * 0.5)
            }
            resultLabel.snp.makeConstraints { (make) in
                make.height.equalTo(14)
                make.left.equalToSuperview().offset(20)
                make.top.equalTo(positionLabel.snp.bottom).offset(12)
                make.width.equalTo((mainView.width - 40) * 0.5)
            }
            resultLabel2.snp.makeConstraints { (make) in
                make.height.equalTo(14)
                make.left.equalToSuperview().offset(20)
                make.top.equalTo(resultLabel.snp.bottom).offset(12)
                make.width.equalTo((mainView.width - 40) * 0.5)
            }
            unit1.snp.makeConstraints { (make) in
                make.height.equalTo(14)
                make.right.equalToSuperview().offset(-20)
                make.centerY.equalTo(depositLabel.snp.centerY)
            }
            depositNumber.snp.makeConstraints { (make) in
                make.height.equalTo(14)
                make.right.equalTo(unit1.snp.left).offset(-2)
                make.centerY.equalTo(depositLabel.snp.centerY)
            }
            positionNumber.snp.makeConstraints { (make) in
                make.height.equalTo(14)
                make.left.equalTo(positionLabel.snp.right)
                make.right.equalToSuperview().offset(-20)
                make.centerY.equalTo(positionLabel.snp.centerY)
            }
            resultNum1.snp.makeConstraints { (make) in
                make.height.equalTo(14)
                make.left.equalTo(resultLabel.snp.right)
                make.right.equalToSuperview().offset(-20)
                make.centerY.equalTo(resultLabel.snp.centerY)
            }
            resultNum2.snp.makeConstraints { (make) in
                make.height.equalTo(14)
                make.left.equalTo(resultLabel2.snp.right)
                make.right.equalToSuperview().offset(-20)
                make.centerY.equalTo(resultLabel2.snp.centerY)
            }
            confirm.snp.makeConstraints { (make) in
                make.height.equalTo(20)
                make.right.equalToSuperview().offset(-20)
                make.top.equalTo(resultLabel2.snp.bottom).offset(26)
            }
            cancelBtn.snp.makeConstraints { (make) in
                make.height.equalTo(20)
                make.top.equalTo(confirm.snp.top)
                make.right.equalTo(confirm.snp.left).offset(-30)
            }
            resultLabel.text = "contract_alert_lossgain".localized()
            resultLabel2.text = "contract_deposit_rate".localized()
        } else if type == 1 {
            mainView.frame = CGRect.init(x: 0, y: 0, width: 335, height: 217)
            mainView.addSubViews([titleLabel,
                                  depositLabel,
                                  positionLabel,
                                  resultLabel,
                                  resultLabel2,
                                  depositNumber,
                                  positionNumber,
                                  resultNum1,
                                  resultNum2,cancelBtn,
                                  confirm,unit1])
            titleLabel.snp.makeConstraints { (make) in
                make.height.equalTo(22)
                make.left.equalToSuperview().offset(20)
                make.right.equalToSuperview().offset(-20)
                make.top.equalToSuperview().offset(18)
            }
            depositLabel.snp.makeConstraints { (make) in
                make.height.equalTo(14)
                make.left.equalToSuperview().offset(20)
                make.top.equalTo(titleLabel.snp.bottom).offset(20)
                make.width.equalTo((mainView.width - 40) * 0.5)
            }
            positionLabel.snp.makeConstraints { (make) in
                make.height.equalTo(14)
                make.left.equalToSuperview().offset(20)
                make.top.equalTo(depositLabel.snp.bottom).offset(12)
                make.width.equalTo((mainView.width - 40) * 0.5)
            }
            resultLabel.snp.makeConstraints { (make) in
                make.height.equalTo(14)
                make.left.equalToSuperview().offset(20)
                make.top.equalTo(positionLabel.snp.bottom).offset(12)
                make.width.equalTo((mainView.width - 40) * 0.5)
            }
            resultLabel2.snp.makeConstraints { (make) in
                make.height.equalTo(14)
                make.left.equalToSuperview().offset(20)
                make.top.equalTo(resultLabel.snp.bottom).offset(12)
                make.width.equalTo((mainView.width - 40) * 0.5)
            }
            unit1.snp.makeConstraints { (make) in
                make.height.equalTo(14)
                make.right.equalToSuperview().offset(-20)
                make.centerY.equalTo(depositLabel.snp.centerY)
            }
            depositNumber.snp.makeConstraints { (make) in
                make.height.equalTo(14)
                make.right.equalTo(unit1.snp.left).offset(-2)
                make.centerY.equalTo(depositLabel.snp.centerY)
            }
            positionNumber.snp.makeConstraints { (make) in
                make.height.equalTo(14)
                make.left.equalTo(positionLabel.snp.right)
                make.right.equalToSuperview().offset(-20)
                make.centerY.equalTo(positionLabel.snp.centerY)
            }
            resultNum1.snp.makeConstraints { (make) in
                make.height.equalTo(14)
                make.left.equalTo(resultLabel.snp.right)
                make.right.equalToSuperview().offset(-20)
                make.centerY.equalTo(resultLabel.snp.centerY)
            }
            resultNum2.snp.makeConstraints { (make) in
                make.height.equalTo(14)
                make.left.equalTo(resultLabel2.snp.right)
                make.right.equalToSuperview().offset(-20)
                make.centerY.equalTo(resultLabel2.snp.centerY)
            }
            confirm.snp.makeConstraints { (make) in
                make.height.equalTo(20)
                make.right.equalToSuperview().offset(-20)
                make.top.equalTo(resultLabel2.snp.bottom).offset(26)
            }
            cancelBtn.snp.makeConstraints { (make) in
                make.height.equalTo(20)
                make.top.equalTo(confirm.snp.top)
                make.right.equalTo(confirm.snp.left).offset(-30)
            }
            depositLabel.text = "contract_text_liqPrice".localized()
            resultLabel.text = "contract_actual_starting_mr".localized()
            resultLabel2.text = "contract_actual_starting_mmr".localized()
        } else {
            mainView.frame = CGRect.init(x: 0, y: 0, width: 335, height: 166)
            mainView.addSubViews([titleLabel,
                                  depositLabel,
                                  positionLabel,
                                  depositNumber,
                                  positionNumber,cancelBtn,
                                  confirm,unit1])
            titleLabel.snp.makeConstraints { (make) in
                make.height.equalTo(22)
                make.left.equalToSuperview().offset(20)
                make.right.equalToSuperview().offset(-20)
                make.top.equalToSuperview().offset(18)
            }
            depositLabel.snp.makeConstraints { (make) in
                make.height.equalTo(14)
                make.left.equalToSuperview().offset(20)
                make.top.equalTo(titleLabel.snp.bottom).offset(20)
                make.width.equalTo((mainView.width - 40) * 0.5)
            }
            positionLabel.snp.makeConstraints { (make) in
                make.height.equalTo(14)
                make.left.equalToSuperview().offset(20)
                make.top.equalTo(depositLabel.snp.bottom).offset(12)
                make.width.equalTo((mainView.width - 40) * 0.5)
            }
            unit1.snp.makeConstraints { (make) in
                make.height.equalTo(14)
                make.right.equalToSuperview().offset(-20)
                make.centerY.equalTo(depositLabel.snp.centerY)
            }
            depositNumber.snp.makeConstraints { (make) in
                make.height.equalTo(14)
                make.right.equalTo(unit1.snp.left).offset(-2)
                make.centerY.equalTo(depositLabel.snp.centerY)
            }
            positionNumber.snp.makeConstraints { (make) in
                make.height.equalTo(14)
                make.left.equalTo(positionLabel.snp.right)
                make.right.equalToSuperview().offset(-20)
                make.centerY.equalTo(positionLabel.snp.centerY)
            }
            confirm.snp.makeConstraints { (make) in
                make.height.equalTo(20)
                make.right.equalToSuperview().offset(-20)
                make.top.equalTo(positionNumber.snp.bottom).offset(26)
            }
            cancelBtn.snp.makeConstraints { (make) in
                make.height.equalTo(20)
                make.top.equalTo(confirm.snp.top)
                make.right.equalTo(confirm.snp.left).offset(-30)
            }
            positionLabel.text = "contract_target_close_price".localized()
        }
        mainView.center = self.center
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
    
    lazy var mainView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.ThemeView.bg
        self.addSubview(view)
        return view
    }()
    
    lazy var titleLabel : UILabel = {
        let label = UILabel(text: "contract_alert_carculate_result".localized(),
                            font: UIFont.ThemeFont.HeadBold,
                            textColor: UIColor.ThemeLabel.colorLite,
                            alignment: NSTextAlignment.left)
        label.extUseAutoLayout()
        return label
    }()
    
    lazy var depositLabel : UILabel = {
        let label = UILabel(text: "contract_alert_occupation_argin".localized(), font: UIFont.ThemeFont.SecondaryRegular, textColor: UIColor.ThemeLabel.colorMedium, alignment: NSTextAlignment.left)
        label.extUseAutoLayout()
        return label
    }()
    
    lazy var positionLabel : UILabel = {
        let label = UILabel(text: "contract_positon_value".localized(), font: UIFont.ThemeFont.SecondaryRegular, textColor: UIColor.ThemeLabel.colorMedium, alignment: NSTextAlignment.left)
        label.extUseAutoLayout()
        return label
    }()
    
    lazy var resultLabel : UILabel = {
        let label = UILabel(text: "contract_alert_lossgain".localized(), font: UIFont.ThemeFont.SecondaryRegular, textColor: UIColor.ThemeLabel.colorMedium, alignment: NSTextAlignment.left)
        label.extUseAutoLayout()
        return label
    }()
    
    lazy var resultLabel2 : UILabel = {
        let label = UILabel(text: "contract_deposit_rate".localized(), font: UIFont.ThemeFont.SecondaryRegular, textColor: UIColor.ThemeLabel.colorMedium, alignment: NSTextAlignment.left)
        label.extUseAutoLayout()
        return label
    }()
    
    lazy var depositNumber : UILabel = {
        let label = UILabel(text: "--", font: UIFont.ThemeFont.BodyRegular, textColor: UIColor.ThemeState.warning, alignment: NSTextAlignment.right)
        label.extUseAutoLayout()
        return label
    }()
    
    lazy var positionNumber : UILabel = {
        let label = UILabel(text: "--", font: UIFont.ThemeFont.BodyRegular, textColor: UIColor.ThemeLabel.colorLite, alignment: NSTextAlignment.right)
        label.extUseAutoLayout()
        return label
    }()
    
    lazy var unit1 : UILabel = {
        let label = UILabel(text: "--", font: UIFont.ThemeFont.BodyRegular, textColor: UIColor.ThemeLabel.colorLite, alignment: NSTextAlignment.right)
        label.extUseAutoLayout()
        return label
    }()
    
    lazy var resultNum1 : UILabel = {
        let label = UILabel(text: "--", font: UIFont.ThemeFont.BodyRegular, textColor: UIColor.ThemeLabel.colorLite, alignment: NSTextAlignment.right)
        label.extUseAutoLayout()
        return label
    }()
    
    lazy var resultNum2 : UILabel = {
        let label = UILabel(text: "--", font: UIFont.ThemeFont.BodyRegular, textColor: UIColor.ThemeLabel.colorLite, alignment: NSTextAlignment.right)
        label.extUseAutoLayout()
        return label
    }()
    
    //取消按钮
    lazy var cancelBtn : UIButton = {
        let btn = UIButton()
        btn.extUseAutoLayout()
        btn.extSetAddTarget(self, #selector(clickCancelBtn))
        btn.layoutIfNeeded()
        btn.setTitle("common_text_btnCancel".localized(), for: UIControlState.normal)
        btn.setTitleColor(UIColor.ThemeLabel.colorMedium, for: UIControlState.normal)
        btn.titleLabel?.font = UIFont.ThemeFont.BodyBold
        return btn
    }()
    
    lazy var confirm : UIButton = {
        let btn = UIButton()
        btn.extUseAutoLayout()
        btn.titleLabel?.textAlignment = .right
        btn.extSetAddTarget(self, #selector(clickConfirm))
        btn.setTitle("common_text_btnConfirm".localized(), for: UIControlState.normal)
        btn.setTitleColor(UIColor.ThemeLabel.colorHighlight, for: .normal)
        btn.titleLabel!.font = UIFont.ThemeFont.BodyBold
        btn.titleLabel?.textAlignment = .right
        return btn
    }()
    
    @objc func clickCancelBtn(_ btn : UIButton){
        SLSwapCarculateAlertView.dismiss(v: self)
    }
    
    @objc func clickConfirm(_ btn : UIButton){
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.4) {
            self.alertCallback?(0)
        }
        SLSwapCarculateAlertView.dismiss(v: self)
    }
    
    // MARK:- interface
    func updataInfo(_ result1 : String, _ result2 : String, _ result3 : String, _ result4 : String, _ unit : String) {
        if self.type == 0 {
            depositNumber.text = result1
            positionNumber.text = result2
            resultNum1.text = result3
            resultNum2.text = result4
        } else if self.type == 1 {
            depositNumber.text = result1
            positionNumber.text = result2
            resultNum1.text = result3
            resultNum2.text = result4
        } else if self.type == 2 {
            depositNumber.text = result1
            positionNumber.text = result2
        }
        unit1.text = unit
    }
    
    func show() {
        UIApplication.shared.keyWindow?.addSubview(self)
    }
    static func dismiss(v: UIView) {
        for view in UIApplication.shared.keyWindow!.subviews {
            if view is SLSwapCarculateAlertView {
                v.removeFromSuperview()
                break
            }
        }
    }
}
