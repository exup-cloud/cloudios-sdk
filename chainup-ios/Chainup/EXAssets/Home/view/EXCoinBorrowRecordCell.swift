//
//  EXCoinBorrowRecordCell.swift
//  Chainup
//
//  Created by ljw on 2019/11/5.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import UIKit
enum EXCoinBorrowType {
    case record
    case history
}
class EXCoinBorrowRecordCell: UITableViewCell {
    typealias returnCallBackBlock = () -> ()
    var returnSuccessBlock : returnCallBackBlock?
    @IBOutlet weak var topSymbolLab: UILabel!
    @IBOutlet weak var timeLab: UILabel!
    @IBOutlet weak var returnBackView: UIView!
    @IBOutlet weak var returnLab: UILabel!
    @IBOutlet weak var amountTitleLab: UILabel!
    @IBOutlet weak var amountLab: UILabel!
    @IBOutlet weak var rateTitleLab: UILabel!
    @IBOutlet weak var rateLab: UILabel!
    @IBOutlet weak var noReturnTitleLab: UILabel!
    @IBOutlet weak var noReturnLab: UILabel!
    @IBOutlet weak var interestTitleLab: UILabel!
    @IBOutlet weak var interestLab: UILabel!
    var currentModel = EXCurrentBorrowListModel()
    @IBOutlet weak var hasReturnLab: UILabel!
    
    var type = EXCoinBorrowType.record {
        didSet {
            setType()
        }
    }
    
    func setType()  {
        if type == .record {
            returnLab.text = "leverage_return".localized()
            amountTitleLab.text = "charge_text_volume".localized()
            rateTitleLab.text = "leverage_rate".localized()
            noReturnTitleLab.text = "leverage_noreturn_amount".localized()
            interestTitleLab.text = "leverage_noreturn_interest".localized()
            returnBackView.isHidden = false
            hasReturnLab.isHidden = true
        }else if type == .history {
            amountTitleLab.text = "common_text_coinsymbol".localized()//币种
            rateTitleLab.text = "charge_text_volume".localized()//数量
            noReturnTitleLab.text = "leverage_rate".localized()
            interestTitleLab.text = "leverage_interest".localized()
            returnBackView.isHidden = true
            hasReturnLab.isHidden = false
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.backgroundColor = UIColor.ThemeView.bg
        self.returnBackView.layer.cornerRadius = 1.5
        self.returnBackView.layer.masksToBounds = true
        self.selectionStyle = UITableViewCellSelectionStyle.none
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(returnMoney))
        returnBackView.addGestureRecognizer(tap)
    }
    @objc func returnMoney() {
        let vc = EXLeverageReturnVc.init(nibName: "EXLeverageReturnVc", bundle: nil)
        vc.type = .leverageReturn
        vc.model = currentModel
        vc.successBlock = {[weak self] in
            guard let mySelf = self else {return}
            mySelf.returnSuccessBlock?()
        }
        self.yy_viewController?.navigationController?.pushViewController(vc, animated: true)
    }
    func setModel(model : EXCurrentBorrowListModel) {
        currentModel = model
        timeLab.text = DateTools.strToTimeString(model.ctime, dateFormat:"yyyy/MM/dd HH:mm:ss")
        if type == .record {//未归还
            topSymbolLab.text = model.coin.aliasName()
            amountLab.text = model.borrowMoney.formatAmount(model.coin,isLeverage: true)
            rateLab.text = model.interestRate
            noReturnLab.text = model.oweAmount.formatAmount(model.coin,isLeverage: true)
            interestLab.text = model.oweInterest.formatAmount(model.coin,isLeverage: true)
        }else {//归还
            topSymbolLab.text = model.base.uppercased() + "/" + model.quote.uppercased()
            amountLab.text = model.coin.aliasName()
            rateLab.text = model.borrowMoney.formatAmount(model.coin,isLeverage: true)
            noReturnLab.text = model.interestRate
            interestLab.text = model.interest.formatAmount(model.coin,isLeverage: true)
            if model.status == "3" {
                hasReturnLab.text = "leverage_all_return".localized()
            }else if model.status == "4" {
                hasReturnLab.text = "leverage_have_blowUp".localized() 
            }else if model.status == "5" {
                hasReturnLab.text = "leverage_have_wearStore".localized()
            }else if model.status == "6" {
                hasReturnLab.text = "leverage_blowUp_end".localized()
            }else if model.status == "7" {
                hasReturnLab.text = "leverage_wearStore_end".localized() 
            }// 状态：1借贷 2部分归还 3全部归还 4爆仓 5穿仓 6爆仓完结 7 穿仓完结
        }
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
