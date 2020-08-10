//
//  EXMarketDetailRecordCell.swift
//  Chainup
//
//  Created by liuxuan on 2019/5/30.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import UIKit

class EXMarketDetailRecordCell: UITableViewCell {
    @IBOutlet var leftLabel: UILabel!
    @IBOutlet var middleLabel: UILabel!
    @IBOutlet var rightLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        leftLabel.text = "kline_text_dealTime".localized()
        middleLabel.text = "contract_text_price".localized()
        rightLabel.text = "charge_text_volume".localized()

        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
