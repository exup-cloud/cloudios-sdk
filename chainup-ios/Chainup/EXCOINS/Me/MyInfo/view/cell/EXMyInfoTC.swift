//
//  EXMyInfoTC.swift
//  Chainup
//
//  Created by zewu wang on 2019/3/25.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import UIKit

class EXMyInfoTC: UITableViewCell {
    
    lazy var nameLabel : UILabel = {
        let label = UILabel()
        label.extUseAutoLayout()
        label.textColor = UIColor.ThemeLabel.colorLite
        label.font = UIFont.ThemeFont.HeadRegular
        return label
    }()
    
    lazy var rightImgV : UIImageView = {
        let imgV = UIImageView()
        imgV.extUseAutoLayout()
        return imgV
    }()
    
    lazy var rightLabel : UILabel = {
        let label = UILabel()
        label.extUseAutoLayout()
        label.textColor = UIColor.ThemeLabel.colorMedium
        label.font = UIFont.ThemeFont.SecondaryRegular
        label.textAlignment = .right
        label.layoutIfNeeded()
        return label
    }()
    
    lazy var rightBtn : UIButton = {
        let btn = UIButton()
        btn.extUseAutoLayout()
        btn.setImage(UIImage.themeImageNamed(imageName: "enter"), for: UIControlState.normal) 
        return btn
    }()
    
    lazy var lineV : UIView = {
        let view = UIView()
        view.extUseAutoLayout()
        view.backgroundColor = UIColor.ThemeView.seperator
        return view
    }()
    
//    lazy var redView : UIView = {
//        let view = UIView()
//        view.extUseAutoLayout()
//        view.backgroundColor = UIColor.ThemeLabel.colorHighlight
//        view.extSetCornerRadius(3)
//        return view
//    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.extSetCell()
        contentView.addSubViews([nameLabel,rightImgV,rightLabel,rightBtn,lineV])
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.centerY.equalToSuperview()
            make.height.equalTo(20)
            make.right.equalTo(rightLabel.snp.left).offset(-10)
        }
        rightImgV.snp.makeConstraints { (make) in
            make.height.width.equalTo(26)
            make.right.equalTo(rightBtn.snp.left).offset(-5)
            make.centerY.equalToSuperview()
        }
        rightLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalTo(rightBtn.snp.left).offset(-5)
            make.height.equalTo(17)
        }
//        redView.snp.makeConstraints { (make) in
//            make.right.equalTo(rightBtn.snp.left).offset(-5)
//            make.height.width.equalTo(6)
//            make.centerY.equalToSuperview()
//        }
        rightBtn.snp.makeConstraints { (make) in
            make.height.equalTo(10)
            make.width.equalTo(7)
            make.right.equalToSuperview().offset(-15)
            make.centerY.equalToSuperview()
        }
        lineV.snp.makeConstraints { (make) in
            make.right.bottom.equalToSuperview()
            make.height.equalTo(0.5)
            make.left.equalTo(nameLabel)
        }
    }
    
    func setCell(_ entity : EXMyInfoEntity){
        nameLabel.text = entity.name
        rightImgV.isHidden = entity.rightImgName == ""
        rightLabel.isHidden = !rightImgV.isHidden
        rightBtn.isHidden = entity.rightBtnBool
        if entity.rightBtnBool == false{
            rightLabel.snp.remakeConstraints { (make) in
                make.centerY.equalToSuperview()
                make.right.equalTo(rightBtn.snp.left).offset(-5)
                make.height.equalTo(17)
            }
        }else{
            rightLabel.snp.remakeConstraints { (make) in
                make.centerY.equalToSuperview()
                make.right.equalToSuperview().offset(-15)
                make.height.equalTo(17)
            }
        }
        if entity.rightImgName != ""{
            rightImgV.image = UIImage.themeImageNamed(imageName: "personal_headportrait")
        }else{
            self.rightLabel.text = entity.rightInfo
        }
//        redView.isHidden = entity.unRead
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
