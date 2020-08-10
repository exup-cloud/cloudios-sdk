//
//  TabbarItem.swift
//  AppProject
//
//  Created by zewu wang on 2018/7/31.
//  Copyright © 2018年 zewu wang. All rights reserved.
//

import UIKit
import RxSwift
import YYWebImage

class TabbarItem: UIView {
    
    //点击tabbarItem的热信号
    public var subject : BehaviorSubject<Bool> = BehaviorSubject(value: false)
    
    //图案
    lazy var imageBtn : UIButton = {
        let btn = UIButton()
        btn.extUseAutoLayout()
        btn.isUserInteractionEnabled = false
        _ = subject.asObservable().subscribe({ (event) in
            if let b = event.element{
//                btn.backgroundColor = b == true ? UIColor.yellow : UIColor.red
                btn.isSelected = b
            }
        })
        return btn
    }()
    
    //文字
    lazy var labelBtn : UIButton = {
        let btn = UIButton()
        btn.extUseAutoLayout()
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 9)
        btn.isUserInteractionEnabled = false
        btn.setTitleColor(UIColor.ThemeLabel.colorMedium, for: UIControlState.normal)
        btn.setTitleColor(UIColor.ThemeView.highlight, for: UIControlState.selected)
        _ = subject.asObservable().subscribe({ (event) in
            if let b = event.element{
//                btn.backgroundColor = b == true ? UIColor.yellow : UIColor.red
                btn.isSelected = b
            }
        })
        return btn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubViews([imageBtn , labelBtn])
        addConstraint()
        self.isUserInteractionEnabled = true
    }
    
    func addConstraint() {
        imageBtn.snp.makeConstraints { (make) in
            make.top.equalTo(7)
            make.centerX.equalTo(self)
            make.height.equalTo(22)
            make.width.equalTo(22)
        }
        labelBtn.snp.makeConstraints { (make) in
            make.top.equalTo(imageBtn.snp.bottom).offset(5)
            make.height.equalTo(10)
            make.left.right.equalTo(self)
        }
    }
    
    //设置配置
    func setImageAndLabel(_ model : TabbarModel){
        
        if let url = URL.init(string: model.onlineDefaultIcon){
            imageBtn.yy_setImage(with: url, for: UIControlState.normal, placeholder: UIImage.themeImageNamed(imageName: model.localDefaultIcon), options: YYWebImageOptions.allowBackgroundTask, completion: nil)
        }else{
            imageBtn.setImage(UIImage.themeImageNamed(imageName: model.localDefaultIcon), for: UIControlState.normal)
        }
        if let url = URL.init(string: model.onlineSelectIcon){
            imageBtn.yy_setImage(with: url, for: UIControlState.selected, placeholder: UIImage.themeImageNamed(imageName: model.localSelectIcon), options: YYWebImageOptions.allowBackgroundTask, completion: nil)
        }else{
             imageBtn.setImage(UIImage.themeImageNamed(imageName: model.localSelectIcon), for: UIControlState.selected)
        }
        
        if model.onlineTitle == ""{
            labelBtn.setTitle(model.localTitle, for: UIControlState.normal)
        }else{
            labelBtn.setTitle(model.onlineTitle, for: UIControlState.normal)
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
