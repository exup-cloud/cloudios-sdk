//
//  EXCoinBorrowRecordHeaderView.swift
//  Chainup
//
//  Created by ljw on 2019/11/5.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import UIKit

class EXCoinBorrowRecordHeaderView: UIView,NibLoadable {

    @IBOutlet weak var riskRatioLab: UILabel!
    @IBOutlet weak var riskRatioAmoutLab: UILabel!
    @IBOutlet weak var askBtn: UIButton!
    @IBOutlet weak var typeLab: UILabel!
    @IBOutlet weak var middleSymbolLab: UILabel!
    @IBOutlet weak var rightSymbolLab: UILabel!
    @IBOutlet weak var availableLab: UILabel!
    @IBOutlet weak var middleAvailableLab: UILabel!
    @IBOutlet weak var rightAvailableLab: UILabel!
    @IBOutlet weak var freezeLab: UILabel!
    @IBOutlet weak var middleFreezeLab: UILabel!
    @IBOutlet weak var rightFreezeLab: UILabel!
    @IBOutlet weak var borrowLab: UILabel!
    @IBOutlet weak var middleBorrowLab: UILabel!
    @IBOutlet weak var rightBorrowLab: UILabel!
    @IBOutlet weak var convertBorrowLab: UILabel!
    @IBOutlet weak var progressWidthCon: NSLayoutConstraint!
    @IBOutlet weak var progressView: UIView!
    @IBOutlet weak var progressBackView: UIView!
    var model = EXLeverCoinBorrowRecord() {
        didSet {
            updateUI()
        }
    }
    
    @IBOutlet weak var bottomMarginView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.ThemeView.bg
        self.snp.makeConstraints { (make) in
            make.width.equalTo(SCREEN_WIDTH)
        }//一定要设置宽，否则会有问题
        self.backgroundColor = UIColor.ThemeView.bg
        riskRatioLab.extSetText("leverage_risk".localized(), textColor: UIColor.ThemeLabel.colorMedium, fontSize: 12)
        riskRatioLab.font = UIFont.init(name: "PingFangSC-Regular", size: 12)
        riskRatioAmoutLab.extSetText("--", textColor: UIColor.ThemeLabel.colorLite, fontSize: 12)
        riskRatioAmoutLab.font = UIFont.init(name: "PingFangSC-Semibold", size: 12)
        askBtn.extSetImages([UIImage.themeImageNamed(imageName: "assets_doubt")], controlStates: [UIControlState.normal])
        progressBackView.backgroundColor = UIColor.ThemeView.bgGap
        progressView.backgroundColor = UIColor.ThemeState.fail
        typeLab.extSetText("contract_text_type".localized(), textColor: UIColor.ThemeLabel.colorDark, fontSize: 12)
        typeLab.font = UIFont.init(name: "PingFangSC-Regular", size: 12)
        middleSymbolLab.extSetText("", textColor: typeLab.textColor, fontSize: typeLab.font.pointSize)
        middleSymbolLab.font = UIFont.init(name: "PingFangSC-Regular", size: 12)
        rightSymbolLab.extSetText("", textColor: typeLab.textColor, fontSize: typeLab.font.pointSize)
        rightSymbolLab.font = UIFont.init(name: "PingFangSC-Regular", size: 12)
        availableLab.extSetText("assets_text_available".localized(), textColor: UIColor.ThemeLabel.colorMedium, fontSize: 14)
        availableLab.font = UIFont.init(name: "PingFangSC-Regular", size: 14)
        freezeLab.extSetText("assets_text_freeze".localized(), textColor: UIColor.ThemeLabel.colorMedium, fontSize: 14)
        freezeLab.font = UIFont.init(name: "PingFangSC-Regular", size: 14)
        borrowLab.extSetText("leverage_have_borrowed".localized(), textColor: UIColor.ThemeLabel.colorMedium, fontSize: 14)
        borrowLab.font = UIFont.init(name: "PingFangSC-Regular", size: 14)
        
        middleAvailableLab.extSetText("", textColor: UIColor.ThemeLabel.colorLite, fontSize: 14)
        middleAvailableLab.font = UIFont.init(name: "PingFangSC-Regular", size: 14)
        
        rightAvailableLab.extSetText("", textColor: UIColor.ThemeLabel.colorLite, fontSize: 14)
        rightAvailableLab.font = UIFont.init(name: "PingFangSC-Regular", size: 14)
        
        middleFreezeLab.extSetText("", textColor: UIColor.ThemeLabel.colorLite, fontSize: 14)
        middleFreezeLab.font = UIFont.init(name: "PingFangSC-Regular", size: 14)
        
        rightFreezeLab.extSetText("", textColor: UIColor.ThemeLabel.colorLite, fontSize: 14)
        rightFreezeLab.font = UIFont.init(name: "PingFangSC-Regular", size: 14)
        
        middleBorrowLab.extSetText("", textColor: UIColor.ThemeLabel.colorLite, fontSize: 14)
        middleBorrowLab.font = UIFont.init(name: "PingFangSC-Regular", size: 14)
        
        rightBorrowLab.extSetText("", textColor: UIColor.ThemeLabel.colorLite, fontSize: 14)
        rightBorrowLab.font = UIFont.init(name: "PingFangSC-Regular", size: 14)
        
        convertBorrowLab.extSetText("assets_text_equivalence".localized(), textColor: UIColor.ThemeLabel.colorMedium, fontSize: 14)
        convertBorrowLab.font = UIFont.init(name: "PingFangSC-Regular", size: 14)
        
        bottomMarginView.backgroundColor = UIColor.ThemeView.bgGap
        }
    
    func updateUI() {
        
        middleSymbolLab.text = self.model.baseCoin.aliasName()
        rightSymbolLab.text = self.model.quoteCoin.aliasName()
        //可用
        middleAvailableLab.text = model.baseNormalBalance.formatAmount(model.baseCoin,isLeverage: true)
        rightAvailableLab.text = model.quoteNormalBalance.formatAmount(model.quoteCoin,isLeverage: true)
        //冻结
        middleFreezeLab.text = model.baseLockBalance.formatAmount(model.baseCoin,isLeverage: true)
        rightFreezeLab.text = model.quoteLockBalance.formatAmount(model.quoteCoin,isLeverage: true)
        //已借
        middleBorrowLab.text = model.baseBorrowBalance.formatAmount(model.baseCoin,isLeverage: true)
        rightBorrowLab.text = model.quoteBorrowBalance.formatAmount(model.quoteCoin,isLeverage: true)
        let ratio = model.riskRate.StringToFloat()
        if ratio > 110 {
            riskRatioAmoutLab.text = String(format: "%@%%", model.riskRate)
            if ratio > 130{//绿色
                riskRatioLab.textColor = UIColor.ThemeState.success
                riskRatioAmoutLab.textColor = UIColor.ThemeState.success
                progressView.backgroundColor = UIColor.ThemeState.success
                if ratio >= 150 {
                    progressWidthCon.constant = (SCREEN_WIDTH - 30.0)
                }else {
                    progressWidthCon.constant = (SCREEN_WIDTH - 30.0) * (ratio - 110) / 40.0
                }
                
            }
            
            if 110 < ratio && ratio <= 130 {
                 riskRatioLab.textColor = UIColor.ThemeState.fail
                 riskRatioAmoutLab.textColor = UIColor.ThemeState.fail
                 progressView.backgroundColor = UIColor.ThemeState.fail
                progressWidthCon.constant = (SCREEN_WIDTH - 30.0) * (ratio - 110) / 40.0
            }
        }
    }
    
}


