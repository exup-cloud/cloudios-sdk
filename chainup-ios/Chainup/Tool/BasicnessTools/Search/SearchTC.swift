//
//  SearchTC.swift
//  AppProject
//
//  Created by zewu wang on 2018/8/6.
//  Copyright © 2018年 zewu wang. All rights reserved.
//

import UIKit
import YYWebImage

class SearchTC: UITableViewCell {
    
    var entity = SearchEntity()
    
    //名字
    lazy var nameLabel : UILabel = {
        let label = UILabel()
        label.extUseAutoLayout()
        return label
    }()
    
    //图片
    lazy var imgV : UIImageView = {
        let imgV = UIImageView()
        imgV.extUseAutoLayout()
        return imgV
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubViews([imgV,nameLabel])
        self.extSetCell(UIColor.ThemeView.bg)
        selectionStyle = .none
        imgV.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(10)
            make.centerY.equalToSuperview()
            make.height.width.equalTo(20)
        }
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(imgV.snp.right).offset(7)
            make.centerY.equalTo(contentView)
            make.height.equalTo(15)
            make.right.equalToSuperview().offset(-10)
        }
    }
    
    func setCellWithEntity(_ entity : SearchEntity){
        nameLabel.setCoinMap(entity.name.aliasCoinMapName())
        if let url = URL.init(string: entity.img){
            imgV.yy_setImage(with: url, options: YYWebImageOptions.allowBackgroundTask)
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

//带添加按钮的cell
class SearchAddTC : SearchTC{
    
    var userSymbolsVm:UserSymbolsVM!
    //添加按钮
    lazy var addBtn : UIButton = {
        let btn = UIButton()
        btn.extUseAutoLayout()
//        btn.extSetCornerRadius(2)
        btn.extSetAddTarget(self, #selector(clickAddBtn))
        btn.setImage(UIImage.themeImageNamed(imageName: "quotes_optional_default"), for: UIControlState.normal)
        btn.setImage(UIImage.themeImageNamed(imageName: "quotes_optional_selected"), for: UIControlState.selected)
//        btn.extSetTitle(LanguageTools.getString(key: "add"), 13, UIColor.ThemeView.bg, UIControlState.normal)
//        btn.extSetTitle(LanguageTools.getString(key: "cancel"), 13, UIColor.ThemeLabel.colorLite, UIControlState.selected)
        return btn
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.userSymbolsVm = UserSymbolsVM()
        contentView.addSubViews([addBtn])
        imgV.isHidden = true
        
        nameLabel.snp.remakeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.centerY.equalTo(contentView)
            make.height.equalTo(15)
            make.right.equalToSuperview().offset(-10)
        }
        
        addBtn.snp.makeConstraints { (make) in
            make.right.equalTo(contentView).offset(-15)
            make.centerY.equalTo(contentView)
            make.width.equalTo(15)
            make.height.equalTo(15)
        }
    }
    
    func setBtn(_ entity : SearchEntity){
        addBtn.isSelected = entity.state == "1"
        self.entity = entity
//        if entity.state == "0"{
//            addBtn.backgroundColor = UIColor.ThemeBtn.highlight
//        }else{
//            addBtn.backgroundColor = UIColor.clear
//        }
    }
    
    override func setCellWithEntity(_ entity: SearchEntity) {
        super.setCellWithEntity(entity)
        setBtn(entity)
    }
    
    //MARK:点击添加按钮
    @objc func clickAddBtn(_ btn : UIButton){
        btn.isSelected = !btn.isSelected
        
        //删除
        let operationType = btn.isSelected ? "1 ": "2"
        
       let info = PublicInfoManager.sharedInstance.getCoinMapInfo(self.entity.name).symbol
    
        userSymbolsVm.handSysmbols(operationType: operationType, symbols: info)
        
        if btn.isSelected{
//            addBtn.backgroundColor = UIColor.clear
            XUserDefault.collectionCoinMap(self.entity.name)
        }else{
//            addBtn.backgroundColor = UIColor.ThemeBtn.highlight
            XUserDefault.cancelCollectionCoinMap(self.entity.name)
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//右边带有选择的tc
class SearchChooseImgVTC : SearchTC {
    
    //选择按钮
    lazy var chooseImgV : UIImageView = {
        let imgV = UIImageView()
        imgV.extUseAutoLayout()
        imgV.isHidden = true
        imgV.image = UIImage.init(named: "choose")
        return imgV
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubViews([chooseImgV])
        
        chooseImgV.snp.makeConstraints { (make) in
            make.right.equalTo(contentView).offset(-10)
            make.centerY.equalTo(contentView)
            make.width.equalTo(12)
            make.height.equalTo(7)
        }
    }
    
    func setImgV(_ entity : SearchEntity){
        chooseImgV.isHidden = entity.state == "0"
    }
    
    override func setCellWithEntity(_ entity: SearchEntity) {
        super.setCellWithEntity(entity)
        setImgV(entity)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


