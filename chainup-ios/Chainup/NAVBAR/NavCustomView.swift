//
//  NavCustomView.swift
//  AppProject
//
//  Created by zewu wang on 2018/7/31.
//  Copyright © 2018年 zewu wang. All rights reserved.
//

import UIKit
import SnapKit

typealias ClickPopBtnBlock = () -> ()

class NavCustomView: UIView {
    
    var clickPopBtnBlock : ClickPopBtnBlock?//点击返回按钮的回调
    
    lazy var tagView :EXTagView = {
        let view = EXTagView.commonTagView()
        view.isHidden = true
        return view
    }()

    //背景
    lazy var backView : UIView = {
        let view = UIView()
        view.extUseAutoLayout()
        view.backgroundColor = UIColor.ThemeNav.bg
        return view
    }()
    
    //title
    lazy var middleTitle : UILabel = {
        let label = UILabel()
        label.extUseAutoLayout()
        label.textColor = UIColor.ThemeLabel.colorLite
        label.font = UIFont.ThemeFont.H3Bold
        return label
    }()
    
    var popBtn : UIButton = {
        let btn = UIButton()
        btn.extUseAutoLayout()
        btn.setImage(UIImage.themeImageNamed(imageName:"return"), for: UIControlState.normal)
        btn.setEnlargeEdgeWithTop(10, left: 20, bottom: 10, right: 20)
        return btn
    }()

    
    lazy var cancelBtn : UIButton = {
        let btn = UIButton()
        btn.extUseAutoLayout()
        btn.addTarget(self, action: #selector(clickPopBtn), for: UIControlEvents.touchUpInside)
        btn.extSetTitle(LanguageTools.getString(key: "common_text_btnCancel"), 14, UIColor.ThemeLabel.colorMedium, UIControlState.normal)
        btn.layoutIfNeeded()
        btn.isHidden = true
        return btn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubViews([backView ,tagView, middleTitle , popBtn,cancelBtn])
        self.addConstraint()
        popBtn.extSetAddTarget(self, #selector(clickPopBtn))
    }

    
    func setCancelBtn(){
        cancelBtn.isHidden = false
        popBtn.isHidden = true
    }
    
    //MARK:添加约束
    func addConstraint() {
        backView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        middleTitle.snp.makeConstraints { (make) in
            make.centerY.equalTo(popBtn)
            make.height.lessThanOrEqualTo(64)
            make.left.equalTo(popBtn.snp.right).offset(10)
            make.width.lessThanOrEqualTo(SCREEN_WIDTH - 100)
        }
        popBtn.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.top.equalToSuperview().offset(34 + NAV_TOP)
            make.width.height.equalTo(16)
        }
        cancelBtn.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(15)
            make.height.equalTo(14)
            make.centerY.equalTo(middleTitle)
        }
    }
    
    func showMarketTag(market:String,offset:CGFloat = 5){
        let symbol = PublicInfoManager.sharedInstance.getCoinMapLeft(market)
        let marketTag = PublicInfoManager.sharedInstance.getCoinMarketTag(symbol)
        if marketTag.isEmpty {
            tagView.isHidden = true
        }else {
            tagView.isHidden = false
            tagView.setTitle(marketTag, for: .normal)
            let tagWidth = tagView.commonTagWidth(titleStr: marketTag)
            tagView.snp.remakeConstraints { (make) in
                make.left.equalTo(middleTitle.snp_right).offset(offset)
                make.top.equalTo(middleTitle.snp_top)
                make.width.equalTo(tagWidth)
            }
        }
    }
    
    //MARK:设置右边的模块,title需要跟着右边的控价改变自己的显示区域
    func setRightModule(_ views : [UIView] , rightSize : (Int , Int) = (19,19)){
        self.addSubViews(views)
        for i in 0..<views.count{
            let view = views[i]
            let rightDistance : CGFloat = CGFloat((i + 1) * 10 + i * rightSize.0)
            view.snp.makeConstraints { (make) in
                make.centerY.equalTo(middleTitle)
                make.height.equalTo(rightSize.1)
                make.width.equalTo(rightSize.0)
                make.right.equalTo(-rightDistance)
            }
        }
        if views.count > 2{
            middleTitle.snp.updateConstraints { (make) in
                make.right.equalTo(-views.count * 25)
            }
        }
    }
    
    //MARK:设置左边的模块,title需要跟着右边的控价改变自己的显示区域
    func setLeftModule(_ views : [UIView]  , _ showPopBtn : Bool = true , leftSize : (Int , Int) = (19,19)){
        self.addSubViews(views)
        for i in 0..<views.count{
            let view = views[i]
            let left : CGFloat = showPopBtn ? 20 : 0
            popBtn.isHidden = !showPopBtn
            let leftDistance : CGFloat = CGFloat((i + 1) * 10 + i * leftSize.0) + left
            view.snp.makeConstraints { (make) in
                make.centerY.equalTo(middleTitle)
                make.height.equalTo(leftSize.1)
                make.width.equalTo(leftSize.0)
                make.left.equalTo(leftDistance)
            }
        }
        if views.count > 1{
            middleTitle.snp.updateConstraints { (make) in
                make.left.equalTo(views.count * 25)
            }
        }
    }
    
    //MARK:点击返回按钮的回调
    @objc func clickPopBtn(){
        clickPopBtnBlock?()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
