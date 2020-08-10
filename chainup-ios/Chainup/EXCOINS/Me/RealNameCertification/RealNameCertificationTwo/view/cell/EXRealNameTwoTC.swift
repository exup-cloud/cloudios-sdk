//
//  EXRealNameTwoTC.swift
//  Chainup
//
//  Created by zewu wang on 2019/3/28.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import UIKit
import YYWebImage

class EXRealNameTwoTC: UITableViewCell,MarkCheckable {
    
    var entity = EXRealBtnEntity()
    
    typealias ClickBtnBlock = (Int) -> ()
    var clickBtnBlock : ClickBtnBlock?
    
    lazy var titleLabel : UILabel = {
        let label = UILabel()
        label.extUseAutoLayout()
        label.font = UIFont.ThemeFont.SecondaryRegular
        label.textColor = UIColor.ThemeLabel.colorMedium
        return label
    }()
    
    lazy var imgBtn : UIButton = {
        let btn = UIButton()
        btn.extUseAutoLayout()
        btn.extSetAddTarget(self, #selector(clickImgBtn))
        return btn
    }()
    
    internal lazy var checkMarkView : CheckMarkView = {
        let check =  CheckMarkView.init(style:.xMarkBig, isChecked:true, presenter:self)
        return check
    }()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.extSetCell()
        contentView.addSubViews([titleLabel,imgBtn])
        imgBtn.addSubViews([checkMarkView])
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(imgBtn)
            make.right.equalToSuperview().offset(-10)
            make.height.equalTo(14)
            make.top.equalToSuperview().offset(30)
        }
        imgBtn.snp.makeConstraints { (make) in
            make.height.equalTo(140)
            make.width.equalTo(240)
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(15)
        }
        checkMarkView.snp.makeConstraints { (make) in
            make.right.top.equalToSuperview()
            make.height.width.equalTo(70)
        }
    }
    
    func setCell(_ entity : EXRealBtnEntity){
        titleLabel.text = entity.title
//        imgBtn.yy_setImage(with: URL.init(string: entity.imgUrl), for: UIControlState.normal, placeholder: UIImage.themeImageNamed(imageName: entity.placeholderImg))
        if entity.image != nil{
            imgBtn.setImage(entity.image, for: UIControlState.normal)
        }else{
            imgBtn.setImage(UIImage.themeImageNamed(imageName: entity.placeholderImg), for: UIControlState.normal)
        }
        self.entity = entity
        checkMarkView.isHidden = entity.imgUrl == ""
    }
    
    //点击按钮
    @objc func clickImgBtn(){
        if imgBtn.yy_imageURL(for: .normal) != nil{//有图放大
            EXAlert.showPhotoBrowser(urls: [self.entity.imgUrl])
        }else{//没有图添加
            clickBtnBlock?(self.tag - 1000)
        }
    }
    
    func didTapped(isCheck: Bool) {
        checkMarkView.checked = true
        self.entity.imgUrl = ""
        self.entity.image = nil
//        checkMarkView.isHidden = true
        (self.yy_viewController as? EXRealNameTwoVC)?.mainView.tableView.reloadData()
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
