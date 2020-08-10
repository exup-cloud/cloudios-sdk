//
//  ContractToolView.swift
//  Chainup
//
//  Created by zewu wang on 2019/5/9.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import UIKit

class ContractToolView: UIView {
    
    typealias ClickBtnBlock = (Int) -> ()
    var clickBtnBlock : ClickBtnBlock?
    
    lazy var dealBtn : UIButton = {
        let btn = UIButton()
        btn.extUseAutoLayout()
        btn.layoutIfNeeded()
        btn.tag = 1000
        btn.setTitle(LanguageTools.getString(key: "assets_action_transaction"), for: UIControlState.normal)
        btn.setTitleColor(UIColor.ThemeLabel.colorMedium, for: UIControlState.normal)
        btn.setTitleColor(UIColor.ThemeLabel.colorLite, for: UIControlState.selected)
        btn.titleLabel?.font = UIFont.ThemeFont.HeadBold
        btn.extSetAddTarget(self, #selector(clickBtn(_:)))
        return btn
    }()
    
    lazy var positionBtn : UIButton = {
        let btn = UIButton()
        btn.extUseAutoLayout()
        btn.layoutIfNeeded()
        btn.tag = 1001
        btn.setTitle(LanguageTools.getString(key: "contract_action_holdMargin"), for: UIControlState.normal)
        btn.setTitleColor(UIColor.ThemeLabel.colorMedium, for: UIControlState.normal)
        btn.setTitleColor(UIColor.ThemeLabel.colorLite, for: UIControlState.selected)
        btn.titleLabel?.font = UIFont.ThemeFont.HeadBold
        btn.extSetAddTarget(self, #selector(clickBtn(_:)))
        return btn
    }()
    
    lazy var moneyLabel : UILabel = {
        let label = UILabel()
        label.extUseAutoLayout()
        label.font = UIFont.ThemeFont.HeadBold
        label.text = "--"
        label.textColor = UIColor.ThemeLabel.colorLite
        return label
    }()
    
    lazy var lineV : UIView = {
        let view = UIView()
        view.extUseAutoLayout()
        view.backgroundColor = UIColor.ThemeView.highlight
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.ThemeNav.bg
        addSubViews([dealBtn,positionBtn,moneyLabel,lineV])
        dealBtn.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.bottom.equalToSuperview().offset(-10)
            make.height.equalTo(22)
        }
        positionBtn.snp.makeConstraints { (make) in
            make.left.equalTo(dealBtn.snp.right).offset(40)
            make.bottom.equalToSuperview().offset(-10)
            make.height.equalTo(22)
        }
        moneyLabel.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-15)
            make.centerY.equalTo(dealBtn)
            make.height.equalTo(16)
        }
        lineV.snp.makeConstraints { (make) in
            make.centerX.equalTo(dealBtn)
            make.bottom.equalToSuperview()
            make.height.equalTo(3)
            make.width.equalTo(20)
        }
    }
    
    @objc func clickBtn(_ btn : UIButton){
        reloadBtnStatus(btn)
        self.clickBtnBlock?(btn.tag)//1000 交易 1001 持仓
    }
    
    func reloadBtnStatus(_ btn : UIButton){
        dealBtn.isSelected = btn == dealBtn
        positionBtn.isSelected = !dealBtn.isSelected
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
        moneyLabel.text = tick.close
        moneyLabel.textColor = tick.rose_Color
    }
    
    func reloadView(){
        moneyLabel.text = "--"
        moneyLabel.textColor = UIColor.ThemeLabel.colorLite
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
