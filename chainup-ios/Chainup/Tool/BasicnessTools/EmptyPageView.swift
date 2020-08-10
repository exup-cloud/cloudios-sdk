//
//  EmptyPageView.swift
//  AppProject
//
//  Created by zewu wang on 2018/8/6.
//  Copyright © 2018年 zewu wang. All rights reserved.
//

import UIKit

class EmptyPageView: UIView {
    typealias ClickBtnBlock = () -> ()
    var clickBtnBlock : ClickBtnBlock?
    
    typealias ClickLabelBlock = () -> ()
    var clickLabelBlock : ClickLabelBlock?
    //添加按钮
    lazy var addBtn : UIButton = {
        let btn = UIButton()
        btn.extUseAutoLayout()
        btn.extSetImages([UIImage.init(named: "add_coin")!], controlStates: [UIControlState.normal])
        btn.extSetAddTarget(self, #selector(clickAddBtn))
        btn.titleLabel?.font = UIFont.ThemeFont.HeadRegular
        return btn
    }()
    
    //文字
    lazy var label : UILabel = {
        let label = UILabel()
        label.extUseAutoLayout()
        label.textAlignment = .center
        label.extSetText(LanguageTools.getString(key: "subtitle_no_favorite"), textColor: UIColor.ThemeLabel.colorMedium, fontSize: 14)
        label.isUserInteractionEnabled = true
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
        addSubViews([addBtn,label])
        addConstraints()
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(clickLabel))
        label.addGestureRecognizer(tap)
    }
    
    func addConstraints() {
        
        addBtn.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.centerY.equalToSuperview().offset(-75)
            make.height.width.equalTo(62)
        }
        
        label.snp.makeConstraints { (make) in
            make.right.left.equalTo(self)
            make.top.equalTo(addBtn.snp.bottom).offset(20)
            make.height.equalTo(15)
        }
        
    }
    
    //点击
    @objc func clickLabel(){
        self.clickLabelBlock?()
    }
    
    func setView(_ labelText : String , imgStr : String){
        label.text = labelText
        addBtn.setImage(UIImage.init(named: imgStr), for: UIControlState.normal)
    }
    
    @objc func clickAddBtn(){
        clickBtnBlock?()
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
