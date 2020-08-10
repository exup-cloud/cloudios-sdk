//
//  ContractHistoryTC.swift
//  Chainup
//
//  Created by zewu wang on 2019/5/14.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import UIKit

class ContractHistoryTC: ContractTransactionTC {
    
    lazy var typeView : ContractTransactionTCDetailView = {
        let view = ContractTransactionTCDetailView()
        view.extUseAutoLayout()
        view.setLeft("contract_text_type".localized())
        return view
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        valueView.isHidden = true
        remainingView.isHidden = true
        cancelBtn.isHidden = true
        rightLabel.isHidden = false
        contentView.addSubViews([typeView])
        dealView.snp.remakeConstraints { (make) in
            make.height.equalTo(16)
            make.left.right.equalToSuperview()
            make.top.equalTo(volumView.snp.bottom).offset(10)
        }
        typeView.snp.makeConstraints { (make) in
            make.height.equalTo(16)
            make.left.right.equalToSuperview()
            make.top.equalTo(dealAverageView.snp.bottom).offset(10)
        }
    }
    
    override func setCell(_ entity: ContractCurrentEntity) {
        super.setCell(entity)
        
//        cancelBtn.isHidden = true
//        valueView.isHidden = true
//        remainingView.isHidden = true
        
        rightLabel.text = entity.statusText
        if entity.type == "1"{//限价
            typeView.setRight("contract_text_limitPriceOrder".localized())
        }else{//市价
            typeView.setRight("contract_text_typeMarket".localized())
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
