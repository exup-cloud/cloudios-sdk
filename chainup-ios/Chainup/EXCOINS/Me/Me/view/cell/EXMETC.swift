//
//  EXMETC.swift
//  Chainup
//
//  Created by zewu wang on 2019/3/23.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import UIKit

class EXMETC: UITableViewCell {
    
    lazy var imgV : UIImageView = {
        let imgV = UIImageView()
        imgV.extUseAutoLayout()
        imgV.contentMode = UIViewContentMode.scaleAspectFit
        return imgV
    }()
    
    lazy var nameLabel : UILabel = {
        let label = UILabel()
        label.extUseAutoLayout()
        label.font = UIFont.ThemeFont.HeadRegular
        label.textColor = UIColor.ThemeLabel.colorLite
        return label
    }()
    
    lazy var rightImgV : UIImageView = {
        let imgV = UIImageView()
        imgV.extUseAutoLayout()
        imgV.image = UIImage.themeImageNamed(imageName: "enter")
        imgV.layoutIfNeeded()
        return imgV
    }()
    
    lazy var lineV : UIView = {
        let view = UIView()
        view.extUseAutoLayout()
        view.backgroundColor = UIColor.ThemeView.seperator
        return view
    }()
    
    lazy var redView : UIView = {
        let view = UIView()
        view.extUseAutoLayout()
        view.extSetCornerRadius(3)
        view.backgroundColor = UIColor.ThemeView.highlight
        return view
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.extSetCell()
        contentView.addSubViews([imgV,nameLabel,rightImgV,lineV,redView])
        imgV.snp.makeConstraints { (make) in
            make.height.width.equalTo(16)
            make.left.equalToSuperview().offset(17)
            make.centerY.equalToSuperview()
        }
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(imgV.snp.right).offset(14)
            make.centerY.equalToSuperview()
            make.height.equalTo(20)
            make.right.equalTo(redView.snp.left).offset(-10)
        }
        rightImgV.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-15)
//            make.height.width.equalTo(8.5)
            make.centerY.equalToSuperview()
        }
        lineV.snp.makeConstraints { (make) in
            make.right.bottom.equalToSuperview()
            make.height.equalTo(0.5)
            make.left.equalTo(imgV)
        }
        redView.snp.makeConstraints { (make) in
            make.height.width.equalTo(6)
            make.centerY.equalToSuperview()
            make.right.equalTo(rightImgV.snp.left).offset(-7)
        }
    }
    
    func setCell(_ entity : EXMEEntity,lineVHidden : Bool){
        nameLabel.text = entity.name
        lineV.isHidden = lineVHidden
        imgV.image = UIImage.themeImageNamed(imageName: entity.imgName)
        redView.isHidden = entity.unRead
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
