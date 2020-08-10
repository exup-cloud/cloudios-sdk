//
//  CoinCVC.swift
//  AppProject
//
//  Created by zewu wang on 2018/8/6.
//  Copyright © 2018年 zewu wang. All rights reserved.
//

import UIKit
import RxSwift

class CoinCVC: UICollectionViewCell {
    
    //点击热信号
//    public var subject : BehaviorSubject<Int> = BehaviorSubject(value: 0)
    
    //展示的按钮
    lazy var btn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.extUseAutoLayout()
        btn.isUserInteractionEnabled = false
        btn.setTitleColor(UIColor.ThemeLabel.colorLite, for: UIControlState.selected)
        btn.setTitleColor(UIColor.ThemeLabel.colorMedium, for: UIControlState.normal)
        btn.titleLabel?.font = UIFont.ThemeFont.HeadRegular
        btn.layoutIfNeeded()
        return btn
    }()
    
    //按钮下部的线
    lazy var hline : UIView = {
        let view = UIView()
        view.extUseAutoLayout()
        view.backgroundColor = UIColor.ThemeView.highlight
        return view
    }()
    
//    override func bindUI() {
//        super.bindUI()
////        _ = subject.asObserver().subscribe({ (event) in
////            if let tag = event.element{
////
////            }
////        }).disposed(by: disposeBagForBinding)
//    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubViews([btn,hline])
//        contentView.backgroundColor = UIColor.ThemeNav.bg
        addConstraints()
    }
    
    func addConstraints() {
        btn.snp.makeConstraints { (make) in
            make.bottom.equalTo(hline.snp.top).offset(-10)
//            make.centerX.equalTo(contentView)
//            make.width.lessThanOrEqualToSuperview()
            make.left.right.equalToSuperview()
            make.height.equalTo(17)
        }
        
        hline.snp.makeConstraints { (make) in
            make.centerX.equalTo(btn)
            make.width.equalTo(20)
            make.bottom.equalTo(contentView)
            make.height.equalTo(3)
        }
        
    }
    
    func setCellWithEntity(_ entity : CoinEntity){
        if entity.showLine == true{
            btn.titleLabel?.font = UIFont.ThemeFont.HeadBold
        }else{
            btn.titleLabel?.font = UIFont.ThemeFont.HeadRegular
        }
        self.btn.isSelected = entity.showLine
        self.hline.isHidden = !entity.showLine
        btn.setTitle(entity.name.aliasName(), for: UIControlState.normal)
//        btn.setTitle("0000000000000", for: UIControlState.normal)

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        
        let att = super.preferredLayoutAttributesFitting(layoutAttributes);
        if let string = btn.titleLabel?.text as? String {
            //        let string:NSString = texts.text! as NSString
            
            var newFram = string.boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: btn.bounds.size.height), options: .usesLineFragmentOrigin, attributes: [
                NSAttributedStringKey.font : btn.titleLabel?.font
                ], context: nil)
            newFram.size.height += 10;
            newFram.size.width += 30;
            att.frame = newFram;
        }
        // 如果你cell上的子控件不是用约束来创建的,那么这边必须也要去修改cell上控件的frame才行
        // self.textLabel.frame = CGRectMake(0, 0, attributes.frame.size.width, 30);
        
        return att;
    }
    
}
