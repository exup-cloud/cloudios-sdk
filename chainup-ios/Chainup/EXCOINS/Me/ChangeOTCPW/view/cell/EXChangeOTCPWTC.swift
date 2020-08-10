//
//  EXChangeOTCPWTC.swift
//  Chainup
//
//  Created by zewu wang on 2019/4/13.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import UIKit

class EXChangeOTCPWTC: UITableViewCell {
    
    var entity = EXChangeOTCEntity()
    
    typealias TextfieldValueChangeBlock = () -> ()
    var textfieldValueChangeBlock : TextfieldValueChangeBlock?
    
    lazy var textField : EXTextField = {
        let text = EXTextField()
        text.extUseAutoLayout()
        text.enableTitleModel = true
        text.enablePrivacyModel = true
        text.textfieldValueChangeBlock = {[weak self] str in
            self?.entity.info = str
            self?.textfieldValueChangeBlock?()
        }
        return text
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.extSetCell()
        contentView.addSubViews([textField])
        textField.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.height.equalTo(57)
            make.bottom.equalToSuperview()
        }
    }
    
    func setCell(_ entity : EXChangeOTCEntity){
        textField.setTitle(title: entity.name)
        textField.setPlaceHolder(placeHolder: entity.placeHolder)
        self.entity = entity
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
