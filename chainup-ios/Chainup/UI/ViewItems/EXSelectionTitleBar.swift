//
//  EXSelectionTitleBar.swift
//  Chainup
//
//  Created by liuxuan on 2019/4/4.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import UIKit

class EXSelectionBarStyle :NSObject {
    var titleFont :UIFont = UIFont.ThemeFont.HeadBold
    var titleColor:UIColor = UIColor.ThemeLabel.colorMedium
    var titleHighLightColor:UIColor = UIColor.ThemeLabel.colorLite
    
    var indicatorWidth :CGFloat = 15.0
    var indicatorHeight :CGFloat = 3.0
    var horizonGap :CGFloat = 40
    var startX :CGFloat = 15

}

class EXSelectionTitleBar: NibBaseView {

    @IBOutlet var baseScroll: UIScrollView!
    var titleBtns:[EXTitleBarItem] = []
    @IBOutlet var seperator: UIView!
    
    var titleBarCallback:((Int)->())?
    
    var style:EXSelectionBarStyle = EXSelectionBarStyle()
    override func onCreate() {
        themeNoti()
    }
    
    func hideSeperator() {
        seperator.isHidden = true 
    }
    
    func themeNoti() {
        _ = NotificationCenter.default.rx
            .notification(Notification.Name(rawValue: THEME_CHANGE_NOTI))
            .takeUntil(self.rx.deallocated) //页面销毁自动移除通知监听
            .subscribe(onNext: {[weak self] notification in
                guard let `self` = self else {return}
                self.reloadUI()
            })
    }
    
    func reloadUI() {
        self.backgroundColor = UIColor.ThemeView.bg
        for bar in self.titleBtns {
            bar.backgroundColor = UIColor.ThemeView.bg
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func setSelected(atIdx:Int) {
        for (idx,btn) in self.titleBtns.enumerated() {
            btn.isSelected = (idx == atIdx)
        }
    }
    
    func bindTitleBar(with titles:[String],indicatorColors:[UIColor]=[UIColor.ThemeLabel.colorHighlight,UIColor.ThemeLabel.colorHighlight]) {
        if self.titleBtns.count > 0 {
            for btn in titleBtns {
                btn.removeFromSuperview()
            }
            self.titleBtns.removeAll()
        }
        
        var lastItem:EXTitleBarItem?
        for (idx,title)  in titles.enumerated() {
            let titleBtn = EXTitleBarItem()
            titleBtn.indicatorWidth.constant = style.indicatorWidth
            titleBtn.btnItem.tag = idx
            titleBtn.setFont(style.titleFont)
            titleBtn.setTitle(title)
            titleBtn.setTitleColor(self.style.titleColor, state:.normal)
            titleBtn.setTitleColor(self.style.titleHighLightColor, state: .selected)
            if indicatorColors.count > idx {
                let color = indicatorColors[idx]
                titleBtn.selectedColor = color
            }
            titleBtn.btnItem.addTarget(self, action: #selector(onTitleBtnAction(sender:)), for: .touchUpInside)
            self.baseScroll.addSubview(titleBtn)
            self.titleBtns.append(titleBtn)
        
            if  titles.count == 1 {
                titleBtn.snp.makeConstraints { (make) in
                    make.left.equalTo(style.startX)
                    make.right.lessThanOrEqualTo(baseScroll.snp.right)
                    make.centerY.equalToSuperview()
                    make.top.bottom.equalToSuperview()
                }
            }else {
                if let btn = lastItem {
                    if idx == titles.count - 1 {
                        titleBtn.snp.makeConstraints { (make) in
                            make.left.equalTo(btn.snp.right).offset(self.style.horizonGap)
                            make.right.lessThanOrEqualTo(baseScroll.snp.right)
                            make.centerY.equalToSuperview()
                            make.top.bottom.equalToSuperview()
                        }
                    }else {
                        titleBtn.snp.makeConstraints { (make) in
                            make.left.equalTo(btn.snp.right).offset(self.style.horizonGap)
                            make.centerY.equalToSuperview()
                            make.top.bottom.equalToSuperview()
                        }
                    }
                }else {
                    titleBtn.snp.makeConstraints { (make) in
                        make.left.equalTo(style.startX)
                        make.centerY.equalToSuperview()
                        make.top.bottom.equalToSuperview()
                    }
                }
            }
            lastItem = titleBtn
        }
        self.setSelected(atIdx: 0)
    }
    
    @objc func onTitleBtnAction(sender:UIButton) {
        for btn in titleBtns {
            btn.isSelected = (btn.btnItem == sender)
        }
        self.titleBarCallback?(sender.tag)
    }
}
