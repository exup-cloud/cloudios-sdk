//
//  EXAppMailTC.swift
//  Chainup
//
//  Created by zewu wang on 2019/3/26.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import UIKit

class EXAppMailTC: UITableViewCell {
    
    var mailEntity:EXAppMailEntity?
    let pasteboard = UIPasteboard.general
    lazy var titleLabel : UILabel = {
        let label = UILabel()
        label.extUseAutoLayout()
        label.font = UIFont.ThemeFont.BodyBold
        label.textColor = UIColor.ThemeLabel.colorLite
        return label
    }()
    
    lazy var timeLabel : UILabel = {
        let label = UILabel()
        label.extUseAutoLayout()
        label.textAlignment = .right
        label.font = UIFont.ThemeFont.SecondaryRegular
        label.textColor = UIColor.ThemeLabel.colorMedium
        return label
    }()
    
    lazy var contentLabel : UILabel = {
        let label = UILabel()
        label.extUseAutoLayout()
        label.font = UIFont.ThemeFont.BodyRegular
        label.textColor = UIColor.ThemeLabel.colorLite
        label.numberOfLines = 0
        return label
    }()
    
    lazy var lineV : UIView = {
        let view = UIView()
        view.extUseAutoLayout()
        view.backgroundColor = UIColor.ThemeView.seperator
        return view
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.extSetCell()
        let longTap = UILongPressGestureRecognizer(target: self, action: #selector(longPress))
        self.contentView .addGestureRecognizer(longTap)
        contentView.addSubViews([titleLabel,timeLabel,contentLabel,lineV])
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.top.equalToSuperview().offset(13)
            make.width.lessThanOrEqualTo(150)
            make.height.equalTo(20)
        }
        timeLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(titleLabel)
            make.right.equalToSuperview().offset(-15)
            make.height.equalTo(17)
            make.left.equalTo(titleLabel.snp.right).offset(10)
        }
        contentLabel.snp.makeConstraints { (make) in
            make.left.equalTo(titleLabel)
            make.right.equalToSuperview().offset(-15)
            make.top.equalTo(timeLabel.snp.bottom).offset(10)
            make.bottom.equalToSuperview().offset(-10)
        }
        lineV.snp.makeConstraints { (make) in
            make.right.bottom.equalToSuperview()
            make.left.equalTo(titleLabel)
            make.height.equalTo(0.5)
        }
    }
    
    @objc func longPress(sender:UILongPressGestureRecognizer) {
        
        if sender.state == .began {
            
            if let content = self.mailEntity?.messageContent {
                //            common_tip_copySuccess
                self.pasteboard.string = content
                ProgressHUDManager.showSuccessWithStatus("common_tip_copySuccess".localized())
            }
            
        }
    }
    func setCell(_ entity : EXAppMailEntity){
        self.mailEntity = entity
        titleLabel.text = entity.messageTitle
        timeLabel.text = entity.ctime
        contentLabel.text = entity.messageContent
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
