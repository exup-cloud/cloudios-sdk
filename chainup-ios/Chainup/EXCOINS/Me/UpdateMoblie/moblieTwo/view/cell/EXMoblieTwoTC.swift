//
//  EXMoblieTwoTC.swift
//  Chainup
//
//  Created by zewu wang on 2019/4/13.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import UIKit

class EXMoblieTwoTC: UITableViewCell {
    
    var entity = EXBindingMoblieEntity()
    
    typealias TextfieldValueChangeBlock = (String) -> ()
    var textfieldValueChangeBlock : TextfieldValueChangeBlock?
    //选择
    lazy var selectionText : EXSelectionField = {
        let text = EXSelectionField()
        text.extUseAutoLayout()
        text.textfieldDidTapBlock = {[weak self] in
            self?.chooseRegion()
        }
        return text
    }()
    
    //输入框
    lazy var textField : EXTextField = {
        let text = EXTextField()
        text.extUseAutoLayout()
        text.enableTitleModel = true
        text.input.keyboardType = .numberPad
        text.setTitle(title: LanguageTools.getString(key: "personal_text_phoneNumber"))
        text.textfieldValueChangeBlock = {[weak self]str in
            self?.textfieldValueChangeBlock?(str)
        }
        return text
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.extSetCell()
        contentView.addSubViews([selectionText,textField])
        selectionText.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.height.equalTo(27)
            make.bottom.equalToSuperview()
            make.right.equalToSuperview().offset(-15)
        }
        textField.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.height.equalTo(57)
            make.bottom.equalToSuperview()
            make.right.equalToSuperview().offset(-15)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setCell(_ entity : EXBindingMoblieEntity){
        self.entity = entity
        selectionText.isHidden = entity.type != "0"
        textField.isHidden = entity.type != "1"
        
        selectionText.input.text = entity.text
        textField.input.text = entity.text
        
        if entity.type == "1"{
            textField.setPlaceHolder(placeHolder: entity.placeHolder)
        }
    }
    
    //点击选择区域
    func chooseRegion(){
        let vc = RegionVC()
        vc.clickRegionCellBlock = {[weak self]rentity in
            if BasicParameter.isHan() {
                self?.selectionText.input.text = rentity.cnName + rentity.dialingCode
            }else{
                self?.selectionText.input.text = rentity.enName + rentity.dialingCode
            }
            self?.entity.info = rentity.numberCode + rentity.dialingCode
        }
        self.selectionText.normalStyle()
        vc.modalPresentationStyle = .fullScreen
        self.yy_viewController?.navigationController?.present(vc, animated: true, completion: nil)
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
