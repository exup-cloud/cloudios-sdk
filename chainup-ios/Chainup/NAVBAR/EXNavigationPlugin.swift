//
//  EXNavigationPlugin.swift
//  Chainup
//
//  Created by liuxuan on 2019/3/25.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import UIKit
import RxSwift

// 自定义navbar协议
@objc protocol NavigationPlugin {
    var navigation: EXNavigation { get }
    @objc optional func largeTitleValueChanged(height:CGFloat)
}

class EXNavigation: NavCustomView {
    var style:Int = 0
    var scroll:UIScrollView?
    weak var presenter: (UIViewController & NavigationPlugin)!
    var largeTitleStyle :Bool = true
    var customBack :Bool = false
    var fullHeight:CGFloat = NAV_SCREEN_HEIGHT + 62
    var rightItems:[UIButton] = []
    var rightItemCallback:((Int)->())?
    var customBackCallback:(()->())?
    var filter:EXFilterView?
    
    var isLastNavigationStyle:Bool = false {
        didSet {
            self.backView.backgroundColor = isLastNavigationStyle ? UIColor.ThemeView.bg : UIColor.ThemeNav.bg
        }
    }

    
    var navtype = NavType.normal
    {
        didSet{
            switch navtype {
            case .list:
                self.snp.remakeConstraints { (make) in
                    make.top.left.right.equalToSuperview()
                    make.height.equalTo(fullHeight)
                }
                self.middleTitle.snp.remakeConstraints { (make) in
                    make.top.equalTo(self.popBtn.snp.bottom).offset(24)
                    make.height.equalTo(33)
                    make.left.equalToSuperview().offset(15)
                    make.width.lessThanOrEqualTo(SCREEN_WIDTH - 100)
                }
                self.presenter.largeTitleValueChanged?(height:NAV_SCREEN_HEIGHT + 62 )
                self.middleTitle.font = UIFont.ThemeFont.H1Bold
            case .listtitle:
                self.middleTitle.snp.remakeConstraints { (make) in
                    make.centerY.equalTo(self.popBtn)
                    make.height.equalTo(33)
                    make.centerX.equalToSuperview()
                    make.width.lessThanOrEqualTo(SCREEN_WIDTH - 100)
                }
                self.snp.remakeConstraints { (make) in
                    make.top.left.right.equalToSuperview()
                    make.height.equalTo(NAV_SCREEN_HEIGHT)
                }
                self.presenter.largeTitleValueChanged?(height:NAV_SCREEN_HEIGHT )
                self.middleTitle.font = UIFont.ThemeFont.H3Bold
            case .notitle:
                self.self.middleTitle.isHidden = true
            case .nopopback:
                self.middleTitle.snp.remakeConstraints { (make) in
                    make.centerY.equalTo(self.popBtn)
                    make.height.equalTo(33)
                    make.left.equalToSuperview().offset(15)
                    make.width.lessThanOrEqualTo(SCREEN_WIDTH - 100)
                }
                self.self.popBtn.isHidden = true
            default:
                break
            }
        }
    }
    
    required init(style:Int = 0,
                  title:String = "",
                  font:CGFloat = 18.0,
                  color:UIColor = UIColor.ThemeLabel.colorLite,
                  affectScroll:UIScrollView?,
                  presenter: (UIViewController & NavigationPlugin)!,
                  useLargeTitleNavigation:Bool = true,
                  customHandleBack:Bool = false) {
        
        super.init(frame: CGRect.zero)
        self.style = style
        self.scroll = affectScroll
        self.largeTitleStyle = useLargeTitleNavigation
        customBack = customHandleBack
        self.middleTitle.extSetText(title, textColor: color, fontSize: font)
        self.presenter = presenter
        config()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        config()
    }
    
    func config() {
        self.clickPopBtnBlock = {[weak self] () in
            guard let mySelf = self else{return}
            mySelf.back()
        }
        
        if let effectsScroll = scroll  {
            effectsScroll.rx.contentOffset
                .subscribe(onNext: { [weak self] point  in
                    guard let mySelf = self else{return}
                    let y = point.y
//                    print(y)
                    if mySelf.navtype == .list{
                        if y > 0{
                            mySelf.navtype = .listtitle
                        }
                    }else if mySelf.navtype == .listtitle{
                        if y < 0{
                            mySelf.navtype = .list
                        }
                    }
                }).disposed(by: self.disposeBag)
        }
        presenter.view.addSubview(self)
        self.navtype = .listtitle
    }
    
    func setdefaultType(type:NavType){
        self.navtype = type
    }
    
    func setTitle(title:String) {
        self.middleTitle.text = title
    }
    
    func setCustomView(_ customView:UIView) {
        self.setdefaultType(type: .nopopback)
        self.setTitle(title: "")
        self.backView.addSubview(customView)
        customView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    func configRightItems(_ itemtitles:[String],
                          isImageName:Bool = true,
                          btnColor:UIColor = UIColor.ThemeLabel.colorMedium) {
        for item in rightItems {
            item.removeFromSuperview()
        }
        var lastRightBtn:UIButton?
        for (idx,itemtitle) in itemtitles.enumerated().reversed() {
            let btn = UIButton.init(type: .custom)
            if isImageName {
                btn.setImage(UIImage.themeImageNamed(imageName: itemtitle), for: .normal)
            }else {
                btn.titleLabel?.textAlignment = .right
                btn.titleLabel?.font = UIFont.ThemeFont.BodyRegular
                btn.setTitleColor(btnColor, for: .normal)
                btn.setTitle(itemtitle, for: .normal)
            }
            btn.tag = idx
            btn.addTarget(self, action: #selector(onRightItemClicked(sender:)), for: .touchUpInside)
            self.addSubview(btn)
            rightItems.append(btn)
            
            var width:CGFloat = 0
            
            if isImageName {
                width = 38
                btn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 5)
            }else {
                width = itemtitle.textSizeWithFont(UIFont.ThemeFont.BodyRegular, width: CGFloat.greatestFiniteMagnitude).width + 5
            }
            
            if let lastOne = lastRightBtn {
                btn.snp.makeConstraints { (make) in
                    make.centerY.equalTo(lastOne.snp.centerY)
                    make.width.equalTo(width)
                    make.height.equalTo(38)
                    make.right.equalTo(lastOne.snp.left)
                }
            }else {
                btn.snp.makeConstraints { (make) in
                    make.centerY.equalTo(popBtn.snp.centerY)
                    make.width.equalTo(width)
                    make.height.equalTo(38)
                    make.right.equalToSuperview().offset(isImageName ? 0 : -12)
                }
            }
            lastRightBtn = btn
        }
    }
    
    @objc func onRightItemClicked(sender:UIButton) {
        self.rightItemCallback?(sender.tag)
    }
    
    func bindFilter(filter:EXFilterView) {
        self.filter = filter
    }
    
    func setScanClearNavi() {
        self.backgroundColor = UIColor.clear
        self.backView.backgroundColor = UIColor.clear
        self.popBtn.setImage(nil, for: .normal)
        self.popBtn.setTitle("common_text_btnCancel".localized(), for: .normal)
        self.popBtn.setTitleColor(UIColor.ThemeLabel.white, for: .normal)
        popBtn.titleLabel?.font = UIFont.ThemeFont.BodyRegular
        popBtn.snp.remakeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.top.equalToSuperview().offset(34 + NAV_TOP)
            make.height.equalTo(16)
        }
        for btn in rightItems {
            btn.setTitleColor(UIColor.ThemeLabel.white, for: .normal)
        }
    }
    
    func hideRightItems() {
        for btn in rightItems {
            btn.isHidden = true
        }
    }
    
    func back(){
        self.filter?.dismissFilter()
        if customBack {
            //self.presenter = nil
            customBackCallback?()
            return
        }
        self.removeFromSuperview()
        presenter.navigationController?.popViewController(animated: true)
        //self.presenter = nil
    }
}
