//
//  SLSwapSegmentView.swift
//  Chainup
//
//  Created by KarlLichterVonRandoll on 2019/12/20.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import Foundation

class SLSwapSegmentView: UIView {
    typealias ClickBtnBlock = (Int) -> ()
    var clickBtnBlock : ClickBtnBlock?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.ThemeNav.bg
        addSubViews([openBtn,closeBtn,positionBtn,priceLabel,rateLabel,lineV])
        openBtn.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.bottom.equalToSuperview().offset(-10)
            make.height.equalTo(22)
        }
        closeBtn.snp.makeConstraints { (make) in
            make.left.equalTo(openBtn.snp.right).offset(40)
            make.bottom.equalToSuperview().offset(-10)
            make.height.equalTo(22)
        }
        positionBtn.snp.makeConstraints { (make) in
            make.left.equalTo(closeBtn.snp.right).offset(40)
            make.bottom.equalToSuperview().offset(-10)
            make.height.equalTo(22)
        }
        priceLabel.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-15)
            make.centerY.equalTo(openBtn).offset(-8)
            make.height.equalTo(16)
        }
        rateLabel.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-15)
            make.centerY.equalTo(openBtn).offset(10)
            make.height.equalTo(12)
        }
        lineV.snp.makeConstraints { (make) in
            make.centerX.equalTo(openBtn)
            make.bottom.equalToSuperview()
            make.height.equalTo(3)
            make.width.equalTo(20)
        }
    }
    
    @objc func clickBtn(_ btn : UIButton){
        reloadBtnStatus(btn)
        self.clickBtnBlock?(btn.tag)//1000 开仓 1001 平仓 1001 持仓
    }
    
    func reloadBtnStatus(_ btn : UIButton){
        btn.isSelected = true
        if btn.tag == 1000 {
            closeBtn.isSelected = false
            positionBtn.isSelected = false
        } else if btn.tag == 1001 {
            openBtn.isSelected = false
            positionBtn.isSelected = false
        } else if btn.tag == 1002 {
            openBtn.isSelected = false
            closeBtn.isSelected = false
        }
        reloadLineV(btn)
    }
    
    func reloadLineV(_ btn : UIButton){
        lineV.snp.remakeConstraints { (make) in
            make.centerX.equalTo(btn)
            make.bottom.equalToSuperview()
            make.height.equalTo(3)
            make.width.equalTo(20)
        }
    }
    
    func setView(_ tick : PriceTick){
        priceLabel.text = tick.close
        priceLabel.textColor = tick.rose_Color
    }
    
    func reloadView(){
        priceLabel.text = "--"
        priceLabel.textColor = UIColor.ThemeLabel.colorLite
    }
    
    func updataHoldPositionNumber(_ volume : String) {
        if volume == "0" {
            let attrString = NSMutableAttributedString().add(string: LanguageTools.getString(key: "contract_action_holdMargin"), attrDic: [NSAttributedStringKey.foregroundColor : UIColor.ThemeLabel.colorMedium, NSAttributedStringKey.font : UIFont.ThemeFont.HeadBold])
            let selectedAttrString = NSMutableAttributedString().add(string: LanguageTools.getString(key: "contract_action_holdMargin"), attrDic: [NSAttributedStringKey.foregroundColor : UIColor.ThemeLabel.colorLite, NSAttributedStringKey.font : UIFont.ThemeFont.HeadBold])
            positionBtn.setAttributedTitle(attrString, for: .normal)
            positionBtn.setAttributedTitle(selectedAttrString, for: .selected)
        } else {
            let attrString = NSMutableAttributedString().add(string: LanguageTools.getString(key: "contract_action_holdMargin"), attrDic: [NSAttributedStringKey.foregroundColor : UIColor.ThemeLabel.colorMedium, NSAttributedStringKey.font : UIFont.ThemeFont.HeadBold]).add(string: String(format: "【%@】", volume), attrDic: [NSAttributedStringKey.foregroundColor : UIColor.ThemeLabel.colorMedium, NSAttributedStringKey.font : UIFont.ThemeFont.SecondaryBold])
            let selectedAttrString = NSMutableAttributedString().add(string: LanguageTools.getString(key: "contract_action_holdMargin"), attrDic: [NSAttributedStringKey.foregroundColor : UIColor.ThemeLabel.colorLite, NSAttributedStringKey.font : UIFont.ThemeFont.HeadBold]).add(string: String(format: "【%@】", volume), attrDic: [NSAttributedStringKey.foregroundColor : UIColor.ThemeLabel.colorLite, NSAttributedStringKey.font : UIFont.ThemeFont.SecondaryBold])
            positionBtn.setAttributedTitle(attrString, for: .normal)
            positionBtn.setAttributedTitle(selectedAttrString, for: .selected)
        }
    }
    
// MARK: - lazy
    lazy var openBtn : UIButton = { // 开仓
        let btn = UIButton()
        btn.extUseAutoLayout()
        btn.layoutIfNeeded()
        btn.tag = 1000
        btn.setTitle(LanguageTools.getString(key: "contract_text_openAverage"), for: UIControlState.normal)
        btn.setTitleColor(UIColor.ThemeLabel.colorMedium, for: UIControlState.normal)
        btn.setTitleColor(UIColor.ThemeLabel.colorLite, for: UIControlState.selected)
        btn.titleLabel?.font = UIFont.ThemeFont.HeadBold
        btn.extSetAddTarget(self, #selector(clickBtn(_:)))
        return btn
    }()
    
    lazy var closeBtn : UIButton = { // 平仓
        let btn = UIButton()
        btn.extUseAutoLayout()
        btn.layoutIfNeeded()
        btn.tag = 1001
        btn.setTitle(LanguageTools.getString(key: "contract_action_closeContract"), for: UIControlState.normal)
        btn.setTitleColor(UIColor.ThemeLabel.colorMedium, for: UIControlState.normal)
        btn.setTitleColor(UIColor.ThemeLabel.colorLite, for: UIControlState.selected)
        btn.titleLabel?.font = UIFont.ThemeFont.HeadBold
        btn.extSetAddTarget(self, #selector(clickBtn(_:)))
        return btn
    }()
    
    lazy var positionBtn : UIButton = { // 持仓
        let btn = UIButton()
        btn.extUseAutoLayout()
        btn.layoutIfNeeded()
        btn.tag = 1002
        let attrString = NSMutableAttributedString().add(string: LanguageTools.getString(key: "contract_action_holdMargin"), attrDic: [NSAttributedStringKey.foregroundColor : UIColor.ThemeLabel.colorMedium, NSAttributedStringKey.font : UIFont.ThemeFont.HeadBold])
        let selectedAttrString = NSMutableAttributedString().add(string: LanguageTools.getString(key: "contract_action_holdMargin"), attrDic: [NSAttributedStringKey.foregroundColor : UIColor.ThemeLabel.colorLite, NSAttributedStringKey.font : UIFont.ThemeFont.HeadBold])
        btn.setAttributedTitle(attrString, for: .normal)
        btn.setAttributedTitle(selectedAttrString, for: .selected)
        btn.extSetAddTarget(self, #selector(clickBtn(_:)))
        return btn
    }()
    
    lazy var priceLabel : UILabel = {
        let label = UILabel()
        label.extUseAutoLayout()
        label.font = UIFont.ThemeFont.HeadBold
        label.text = "--"
        label.textColor = UIColor.ThemekLine.up
        return label
    }()
    
    lazy var rateLabel : UILabel = {
        let label = UILabel()
        label.extUseAutoLayout()
        label.font = UIFont.ThemeFont.MinimumRegular
        label.text = "--"
        label.textColor = UIColor.ThemekLine.up
        label.backgroundColor = UIColor.ThemekLine.up15
        label.layer.cornerRadius = 1
        label.layer.masksToBounds = true
        return label
    }()
    
    lazy var lineV : UIView = {
        let view = UIView()
        view.extUseAutoLayout()
        view.backgroundColor = UIColor.ThemeView.highlight
        return view
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
