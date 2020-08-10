//
//  EXHorizonlIndexContainer.swift
//  Chainup
//
//  Created by liuxuan on 2019/3/13.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import UIKit

class EXHorizonlIndexContainer: NibBaseView {
    
    @IBOutlet var indexsContainer: UIStackView!
    typealias ScaleChangeBlock = (String) -> ()
    var scaleDidChage : ScaleChangeBlock?

    override func onCreate() {
        self.loadItems()
    }
    
    func loadItems(){
        let klineScalse = PublicInfoEntity.sharedInstance.klineScale
        for (idx, scale) in klineScalse.enumerated() {
            let scaleView = EXKLineScaleView()
            scaleView.backgroundColor = UIColor.ThemeView.bg
            scaleView.bgBtn.tag = idx
            if idx == 0 {
                scaleView.setTitle(title: "Line".localized())
            }else {
                scaleView.setTitle(title: scale.localized())
            }
            scaleView.bgBtn.addTarget(self, action: #selector(scaleBtnDidTap(sender:)), for: .touchUpInside)
            indexsContainer.addArrangedSubview(scaleView)
        }
    }
    
    @objc func scaleBtnDidTap(sender:UIButton) {
        let klineScalse = PublicInfoEntity.sharedInstance.klineScale
        var key = ""
        if sender.tag == 0 {
            key = "Line"
        }else {
            key = klineScalse[sender.tag]
        }
        self.defaultScale(key: key)
        self.scaleDidChage?(key)
    }
    
    func defaultScale(key:String?) {
        let scaleKey = key ?? KlineScaleDefaultKey
        
        var klineScalse = PublicInfoEntity.sharedInstance.klineScale
        if klineScalse.firstIndex(of: "1min") == 0  {
            klineScalse.remove(at: 0)
            klineScalse.insert("Line", at: 0)
        }
        var  selectedIdx = 0
        for (idx, scale) in klineScalse.enumerated() {
            if scale == scaleKey {
                selectedIdx = idx
                break
            }
        }
        
        for (idx,scaleView) in indexsContainer.subviews.enumerated() {
            if scaleView .isKind(of: EXKLineScaleView.self ) {
                let item = scaleView as! EXKLineScaleView
                item.setSelected(isSelect: (idx==selectedIdx))
            }
        }
    }
}
