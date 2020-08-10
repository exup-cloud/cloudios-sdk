//
//  EXLeverageCoinSearchCell.swift
//  Chainup
//
//  Created by ljw on 2019/11/7.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import UIKit

class EXLeverageCoinSearchCell: UITableViewCell {

    @IBOutlet weak var coinName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.backgroundColor = UIColor.ThemeView.bg
        coinName.font = UIFont.init(name: "coinName", size: 14)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
