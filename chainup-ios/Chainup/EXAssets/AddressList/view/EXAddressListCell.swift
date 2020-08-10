//
//  EXAddressListCell.swift
//  Chainup
//
//  Created by liuxuan on 2019/5/5.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import UIKit

class EXAddressListCell: UITableViewCell {
    @IBOutlet var verticalView: EXAddressVerticalView!
    var selectedAddress = ""

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func updateCellItem(_ addressItem:AddressItem) {
        let coinAddress = addressItem.address
        let remark = addressItem.label
        if let _ = coinAddress.range(of: "_") {
            let addressAry = coinAddress.components(separatedBy: "_")
            if addressAry.count == 2 {
                verticalView.addressLabel.text = addressAry[0]
                verticalView.tagLabel.text = addressAry[1]
            }
        }else {
            verticalView.hideTagLabel()
            verticalView.addressLabel.text = coinAddress
        }
        verticalView.remarkLabel.text = remark
    }
    
    func showAddressCheckMark(_ isShow:Bool) {
        verticalView.checkIcon.isHidden = !isShow
    }
    
}
