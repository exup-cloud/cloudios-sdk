//
//  EXSelectorFillterCell.swift
//  Chainup
//
//  Created by liuxuan on 2019/11/8.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import UIKit

class EXSelectorFillterCell: UITableViewCell {
    typealias TxtFieldSelectionBlock = () -> ()
    var textfieldDidTapBlock : TxtFieldSelectionBlock?
    
    @IBOutlet var selctor: EXSelectionField!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.backgroundColor = UIColor.ThemeView.bg
        selctor.arrowModel(enabled: true)
        selctor.textfieldDidTapBlock = {[weak self] in
            guard let strongSelf = self else { return }
            strongSelf.textfieldDidTapBlock?()
        }
    }
    
    func bindSelector(title:String,value:String) {
        selctor.titleMode(enabled: true)
        selctor.setTitle(title: title)
        selctor.setText(text: value)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    class func getHeight() -> CGFloat{
         //54的输入框 + 15gap + 15gap
        return 84
    }
     
    
}
