//
//  UIAlertBackView.swift
//  Chainup
//
//  Created by zewu wang on 2018/8/9.
//  Copyright © 2018年 zewu wang. All rights reserved.
//

import UIKit

class UIAlertBackView: UIView {
    
    lazy var backView : UIView = {
        let view = UIView()
        view.extUseAutoLayout()
        view.backgroundColor = UIColor.ThemeView.bg
        view.extSetCornerRadius(2)
        return view
    }()
    
    lazy var titleLabel : UILabel = {
        let label = UILabel()
        label.extUseAutoLayout()
        label.textAlignment = .center
        label.extSetTextColor(UIColor.ThemeLabel.colorLite, fontSize: 18)
        return label
    }()
    
    //取消按钮
    lazy var cancelBtn : UIButton = {
        let btn = UIButton()
        btn.extUseAutoLayout()
        btn.extSetTitle(LanguageTools.getString(key: "cancel"), titleColor: UIColor.ThemeLabel.colorLite)
        btn.extSetAddTarget(self , #selector(clickCancelBtn))
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        return btn
    }()
    
    //确认按钮
    lazy var confirmBtn : UIButton = {
        let btn = UIButton()
        btn.extUseAutoLayout()
        btn.extSetTitle(LanguageTools.getString(key: "confirm"), titleColor: UIColor.ThemeView.highlight)
        btn.extSetAddTarget(self , #selector(clickConfirmBtn))
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        return btn
    }()
    
    //横线
    lazy var hline : UIView = {
        let view = UIView()
        view.extUseAutoLayout()
        view.backgroundColor = UIColor.ThemeView.seperator
        return view
    }()
    
    //竖线
    lazy var vline : UIView = {
        let view = UIView()
        view.extUseAutoLayout()
        view.backgroundColor = UIColor.ThemeView.seperator
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubViews([backView])
        backView.addSubViews([titleLabel,cancelBtn,confirmBtn,vline,hline])
        addConstraints()
        self.backgroundColor = UIColor.ThemeView.mask
    }
    
    //MARK:点击确认按钮
    @objc func clickConfirmBtn(){
    }
    
    //MARK:点击取消按钮
    @objc func clickCancelBtn(){
        self.removeFromSuperview()
    }
    
    //MARK:设置alerView
    func alertWith(_ title : String = "" , backViewHeight : CGFloat = 0){
        titleLabel.text = title
        backView.snp.updateConstraints { (make) in
            make.height.equalTo(backViewHeight)
        }
    }
    
    //MARK:展示
    func show(_ view : UIView){
        weak var v = view
        if v != nil{
            v?.addSubview(self)
            self.snp.makeConstraints { (make) in
                make.edges.equalTo(v!)
            }
        }
    }
    
    func addConstraints() {
        
        backView.snp.makeConstraints { (make) in
            make.center.equalTo(self)
            make.height.equalTo(125)
            make.left.equalTo(self).offset(40)
            make.right.equalTo(self).offset(-40)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(backView).offset(26)
            make.height.equalTo(18)
            make.left.equalTo(backView).offset(10)
            make.right.equalTo(backView).offset(-10)
        }
        
        cancelBtn.snp.makeConstraints { (make) in
            make.left.equalTo(backView)
            make.right.equalTo(backView.snp.centerX)
            make.bottom.equalTo(backView)
            make.height.equalTo(40)
        }
        
        confirmBtn.snp.makeConstraints { (make) in
            make.left.equalTo(backView.snp.centerX)
            make.right.equalTo(backView)
            make.bottom.equalTo(backView)
            make.height.equalTo(40)
        }
        
        hline.snp.makeConstraints { (make) in
            make.left.right.equalTo(backView)
            make.bottom.equalTo(cancelBtn.snp.top)
            make.height.equalTo(1)
        }
        
        vline.snp.makeConstraints { (make) in
            make.centerX.equalTo(backView)
            make.bottom.equalTo(backView)
            make.height.equalTo(40)
            make.width.equalTo(1)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

class UIAlertMiddleTitleView : UIAlertBackView{
    typealias ClickConfirmBtnBlock = () -> ()
    var clickConfirmBtnBlock : ClickConfirmBtnBlock?
    
    lazy var middleTitleLabel : UILabel = {
        let label = UILabel()
        label.extUseAutoLayout()
        label.extSetTextColor(UIColor.ThemeLabel.colorMedium, fontSize: 15)
        label.numberOfLines = 2
        label.textAlignment = .center
        label.layoutIfNeeded()
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backView.addSubview(middleTitleLabel)
        middleTitleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
        }
        backView.snp.updateConstraints { (make) in
            make.height.equalTo(180)
        }
    }
    
    override func clickConfirmBtn() {
        clickConfirmBtnBlock?()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

