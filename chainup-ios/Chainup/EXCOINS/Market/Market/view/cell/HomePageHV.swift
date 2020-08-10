//
//  HomePageHV.swift
//  AppProject
//
//  Created by zewu wang on 2018/8/6.
//  Copyright © 2018年 zewu wang. All rights reserved.
//

import UIKit

class HomePageHV: UIView {

    typealias ClickBtnBlock = (EXDirectionButton) -> ()
    var clickBtnBlock : ClickBtnBlock?
    
    var btnArr : [EXDirectionButton] = []
    
    //名字
    lazy var nameBtn : EXDirectionButton = {
        let btn = EXDirectionButton()
        btn.extUseAutoLayout()
        btn.doubleTriangleStyle = true
        btn.titleLabel.textColor = UIColor.ThemeLabel.colorDark
        btn.addTarget(self, action: #selector(clickBtn), for: UIControlEvents.touchUpInside)
        btn.text(content: LanguageTools.getString(key: "home_action_coinNameTitle"))
        return btn
    }()
    
    //最新价
    lazy var newpriceBtn : EXDirectionButton = {
        let btn = EXDirectionButton()
        btn.extUseAutoLayout()
        btn.doubleTriangleStyle = true
        btn.titleLabel.textColor = UIColor.ThemeLabel.colorDark
        btn.addTarget(self, action: #selector(clickBtn), for: UIControlEvents.touchUpInside)
        btn.text(content: LanguageTools.getString(key: "home_text_dealLatestPrice"))
        return btn
    }()
    
    //幅度
    lazy var amplitudeBtn : EXDirectionButton = {
        let btn = EXDirectionButton()
        btn.extUseAutoLayout()
        btn.doubleTriangleStyle = true
        btn.titleLabel.textColor = UIColor.ThemeLabel.colorDark
        btn.addTarget(self, action: #selector(clickBtn), for: UIControlEvents.touchUpInside)
        btn.text(content: LanguageTools.getString(key: "common_text_priceLimit"))
        return btn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        btnArr = [nameBtn,newpriceBtn,amplitudeBtn]
        addSubViews([nameBtn,newpriceBtn,amplitudeBtn])
//        let width = (SCREEN_WIDTH - 20)/3
        nameBtn.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.right.equalTo(newpriceBtn.snp.left).offset(-10)
            make.centerY.equalToSuperview().offset(4)
            make.height.equalTo(17)
        }
        newpriceBtn.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(SCREEN_WIDTH / 2.5)
            make.right.equalTo(amplitudeBtn.snp.left).offset(-10)
            make.height.equalTo(17)
            make.centerY.equalTo(nameBtn)
        }
        amplitudeBtn.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-15)
            make.height.equalTo(17)
            make.width.equalTo(72)
            make.centerY.equalTo(nameBtn)
        }
        self.backgroundColor = UIColor.ThemeView.bg
    }
    
    @objc func clickBtn(_ sender : EXDirectionButton){
        for btn in btnArr{
            if btn != sender{
                btn.reset()
            }
        }
        clickBtnBlock?(sender)
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
