//
//  EXBouncedView.swift
//  Chainup
//
//  Created by zewu wang on 2019/11/6.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import UIKit

class EXBouncedModel : NSObject{
    
    var img = ""
    var name = ""
    var tag = -1
    
}

class EXBouncedView: UIView {
    
    typealias ClickViewBlock = (String) -> ()
    var clickViewBlock : ClickViewBlock?

    lazy var struckView : UIStackView = {
        let view = UIStackView()
        view.extUseAutoLayout()
        view.axis = .vertical
        view.layoutIfNeeded()
        view.backgroundColor = UIColor.ThemeView.bg
        view.extSetCornerRadius(1.5)
        view.clipsToBounds = true
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        addSubview(struckView)
        struckView.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-15)
            make.top.equalToSuperview().offset(40 + NAV_TOP)
        }
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(clickView))
        self.addGestureRecognizer(tap)
    }
    
    @objc func clickView(){
        self.removeFromSuperview()
    }
    
    func setData(_ models : [EXBouncedModel]){
        struckView.removeAllArrangedSubviews()
        for index in 0..<models.count{
            let model = models[index]
            model.tag = 1000 + index
            let view = EXBouncedDetailView()
            view.setView(model)
            view.clickViewBlock = {[weak self]str in
                self?.clickViewBlock?(str)
                self?.clickView()
            }
            struckView.addArrangedSubview(view)
            self.setViewLayout(view ,index : index, models : models)
        }
    }
    
    func setViewLayout(_ view : EXBouncedDetailView ,index : Int , models : [EXBouncedModel]){
        if models.count == 1{
            view.snp.makeConstraints { (make) in
                make.left.right.equalToSuperview()
                make.height.equalTo(60)
                make.top.equalToSuperview()
            }
        }else if models.count == 2{
            if index == 0{
                view.isFirst()
                view.snp.makeConstraints { (make) in
                    make.left.right.equalToSuperview()
                    make.height.equalTo(40)
                    make.top.equalToSuperview()
                }
            }else if index == models.count - 1{
                view.isLast()
                view.snp.makeConstraints { (make) in
                    make.left.right.equalToSuperview()
                    make.height.equalTo(40)
                    make.top.equalToSuperview().offset(60)
                }
            }
        }else if models.count > 2{
            if index == 0{
                view.isFirst()
                view.snp.makeConstraints { (make) in
                    make.left.right.equalToSuperview()
                    make.height.equalTo(50)
                    make.top.equalToSuperview()
                }
            }else if index == models.count - 1{
                view.isLast()
                view.snp.makeConstraints { (make) in
                    make.left.right.equalToSuperview()
                    make.height.equalTo(50)
                    make.bottom.equalToSuperview()
                }
            }else{
                view.snp.makeConstraints { (make) in
                    make.left.right.equalToSuperview()
                    make.height.equalTo(40)
                    make.top.equalToSuperview().offset(index * 40 + 10)
                }
            }
        }
    }
    
    func show(){
        guard let appDelegate  = UIApplication.shared.delegate else {
            return
        }
        if appDelegate.window != nil   {
            appDelegate.window??.rootViewController?.view.addSubview(self)
            appDelegate.window??.rootViewController?.view.bringSubview(toFront: self)
            self.snp.makeConstraints { (make) in
                make.edges.equalToSuperview()
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class EXBouncedDetailView: UIView {
    
    typealias ClickViewBlock = (String) -> ()
    var clickViewBlock : ClickViewBlock?
    
    lazy var imgV : UIImageView = {
        let imgV = UIImageView()
        imgV.extUseAutoLayout()
        imgV.layoutIfNeeded()
        imgV.contentMode = .center
        return imgV
    }()
    
    lazy var label : UILabel = {
        let label = UILabel()
        label.extUseAutoLayout()
        label.textColor = UIColor.ThemeLabel.colorLite
        label.font = UIFont.ThemeFont.BodyRegular
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubViews([imgV,label])
        self.backgroundColor = UIColor.ThemeView.bg
        imgV.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.centerY.equalTo(label)
            make.width.equalTo(20)
        }
        label.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(45)
            make.width.lessThanOrEqualTo(100)
            make.right.equalToSuperview().offset(-10)
            make.centerY.equalToSuperview()
            make.height.equalTo(20)
        }
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(clickView))
        self.addGestureRecognizer(tap)
    }
    
    @objc func clickView(){
        self.clickViewBlock?(self.label.text ?? "")
    }
    
    func setView(_ model : EXBouncedModel){
        imgV.image = UIImage.themeImageNamed(imageName: model.img)
        label.text = model.name
        tag = model.tag
    }
    
    func isFirst(){
        label.snp.remakeConstraints { (make) in
            make.left.equalToSuperview().offset(45)
            make.width.lessThanOrEqualTo(100)
            make.right.equalToSuperview().offset(-10)
            make.top.equalToSuperview().offset(20)
            make.height.equalTo(20)
        }
    }
    
    func isLast(){
        label.snp.remakeConstraints { (make) in
            make.left.equalToSuperview().offset(45)
            make.width.lessThanOrEqualTo(100)
            make.right.equalToSuperview().offset(-10)
            make.bottom.equalToSuperview().offset(-20)
            make.height.equalTo(20)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
