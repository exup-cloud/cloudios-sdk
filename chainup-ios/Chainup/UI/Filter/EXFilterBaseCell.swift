//
//  EXFilterBaseCell.swift
//  Chainup
//
//  Created by liuxuan on 2019/4/10.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import UIKit

class EXFilterBaseCell: UITableViewCell {
    
    typealias ExpandCallback = (Bool) -> ()
    var cellDidExpandBlock : ExpandCallback?
    
    typealias ItemSelectedCallback = (String) -> ()
    var itemDidChangeBlock : ItemSelectedCallback?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
