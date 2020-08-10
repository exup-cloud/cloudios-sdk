//
//  RecommendCVC.swift
//  Chainup
//
//  Created by zewu wang on 2018/11/7.
//  Copyright © 2018 zewu wang. All rights reserved.
//  推荐

import UIKit

class RecommendCVC: UICollectionViewCell {
    
    lazy var tagView :EXTagView = {
        let view = EXTagView.commonTagView()
        view.setContentHuggingPriority(.defaultLow, for: .horizontal)
        view.isHidden = true
        return view
    }()
    
    lazy var backView : UIView = {
        let view = UIView()
        view.extUseAutoLayout()
        view.backgroundColor = UIColor.ThemeView.bg
        return view
    }()
    
    lazy var nameLabel : UILabel = {//名字
        let label = UILabel()
        label.extUseAutoLayout()
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        label.textColor = UIColor.ThemeLabel.colorMedium
        label.font = UIFont.ThemeFont.SecondaryRegular
        return label
    }()
    
    lazy var priceLabel : UILabel = {//价格
        let label = UILabel()
        label.extUseAutoLayout()
        label.text = "--"
        label.font = UIFont().themeHNBoldFont(size: 16)
        label.textColor = UIColor.ThemeLabel.colorLite
        return label
    }()
    
    lazy var rmbLabel : UILabel = {//折合钱
        let label = UILabel()
        label.extUseAutoLayout()
        label.text = "--"
        label.font = UIFont.ThemeFont.SecondaryRegular
        label.textColor = UIColor.ThemeLabel.colorMedium
        return label
    }()
    
    //涨幅
    lazy var amplitudeLabel : UILabel = {
        let label = UILabel()
        label.extUseAutoLayout()
        label.layoutIfNeeded()
        label.text = "--"
        label.textAlignment = .right
        label.font = UIFont.ThemeFont.SecondaryRegular
        label.textColor = UIColor.ThemeLabel.colorMedium
        return label
    }()
    
    lazy var hlineV : UIView = {
        let view = UIView()
        view.extUseAutoLayout()
        view.backgroundColor = UIColor.ThemeView.seperator
        return view
    }()
    
    lazy var kLine : EXHomeKlineView = {
        let view = EXHomeKlineView()
        view.extUseAutoLayout()
        view.backgroundColor = UIColor.ThemeView.bg
        view.isHidden = true
        return view
    }()
    
    var wsVm = EXKlineWsVm()
    
    var xdataarr : [CGFloat] = []
    var ydataarr : [CGFloat] = []
    var entity : HomeRecommendedEntity = HomeRecommendedEntity()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(backView)
        contentView.backgroundColor = UIColor.ThemeView.bg
        backView.addSubViews([nameLabel,priceLabel,rmbLabel,amplitudeLabel,hlineV,kLine])
        backView.backgroundColor = UIColor.ThemeView.bg
        
        if EXHomeViewModel.status() == .one {
            
            hlineV.snp.makeConstraints { (make) in
                make.centerY.right.equalToSuperview()
                make.height.equalTo(79)
                make.width.equalTo(0.5)
            }
            
            backView.snp.makeConstraints { (make) in
                make.left.right.equalToSuperview()
                make.height.equalTo(79)
                make.centerY.equalToSuperview()
            }
            
            nameLabel.snp.makeConstraints { (make) in
                make.left.equalToSuperview().offset(15)
//                make.right.equalToSuperview().offset(-15)
                make.top.equalToSuperview().offset(10)
                make.height.equalTo(14)
            }
            
            amplitudeLabel.snp.makeConstraints { (make) in
                make.height.equalTo(14)
                make.right.equalToSuperview().offset(-14)
                make.centerY.equalTo(nameLabel)
            }
            
        }else if EXHomeViewModel.status() == .two{
            
            hlineV.snp.makeConstraints { (make) in
                make.top.bottom.right.equalToSuperview()
                make.width.equalTo(0.5)
            }
            
            backView.snp.makeConstraints { (make) in
                make.left.right.equalToSuperview()
                make.height.equalTo(130)
                make.centerY.equalToSuperview()
            }
            
            nameLabel.snp.makeConstraints { (make) in
                make.left.equalToSuperview().offset(15)
                make.right.equalToSuperview().offset(-15)
                make.top.equalToSuperview().offset(10)
                make.height.equalTo(14)
            }
            amplitudeLabel.textAlignment = .left
            amplitudeLabel.snp.makeConstraints { (make) in
                make.height.equalTo(14)
                make.right.equalToSuperview().offset(-15)
                make.left.equalToSuperview().offset(15)
                make.top.equalTo(rmbLabel.snp.bottom).offset(3)
            }
            kLine.isHidden = false
            kLine.snp.makeConstraints { (make) in
                make.left.equalToSuperview().offset(15)
                make.right.equalToSuperview().offset(-15)
                make.height.equalTo(36)
                make.top.equalTo(amplitudeLabel.snp.bottom).offset(5)
            }
        }
       
        priceLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.top.equalTo(nameLabel.snp.bottom).offset(9)
            make.height.equalTo(19)
        }
        
        rmbLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.height.equalTo(14)
            make.top.equalTo(priceLabel.snp.bottom).offset(6)
        }
    }
    
    func setCell(_ entity : HomeRecommendedEntity){
        self.entity = entity
        if entity.name.aliasCoinMapName() == ""{
            nameLabel.text = "--"
            priceLabel.text = "--"
            rmbLabel.text = "--"
            amplitudeLabel.text = "--"
//            tagView.isHidden = true
            return
        }
        nameLabel.text = entity.name.aliasCoinMapName()
        rmbLabel.text = entity.rmb
        
        amplitudeLabel.textColor = entity.backColor
        amplitudeLabel.text = entity.rose
                
        priceLabel.text = entity.close
        
        if EXHomeViewModel.status() == .two{
            handleWsVM(entity)
        }
        
//        if EXHomeViewModel.status() == .one{
//            let symbol = PublicInfoManager.sharedInstance.getCoinMapLeft(entity.name)
//            let marketTag = PublicInfoManager.sharedInstance.getCoinMarketTag(symbol)
//            if marketTag.isEmpty {
//                tagView.isHidden = true
//            }else {
//                tagView.isHidden = false
//                tagView.setTitle(marketTag, for: .normal)
//
//            }
//        }
    }
    
    func handleWsVM(_ entity : HomeRecommendedEntity){
        wsVm.kcandleType = "1min"
        wsVm.entity.symbol = entity.symbol
        wsVm.disconnectAll()
        wsVm.connecKlineWs()
        wsVm.kLineHistroyDatas
            .subscribe(onNext:{[weak self] (historys,hasPre) in
                guard let `self` = self else {return}
                self.xdataarr.removeAll()
                self.ydataarr.removeAll()
                var history : [KLineChartItem] = []
                if historys.count >= 20{
                    let fromIndex = historys.count - 21
                    let toIndex = historys.count - 1
                    history = Array(historys[fromIndex...toIndex])
                }else{
                    history = historys
                }
                for item in history{
                    self.xdataarr.append(CGFloat(item.vol))
                    self.ydataarr.append(CGFloat(item.close))
                }
                if self.ydataarr.count > 0 && self.xdataarr.count > 0{
                    self.kLine.isHidden = false
                    self.kLine.setView(XDatasArr: self.xdataarr, YDatasArr: self.ydataarr)
                }else{
                    self.kLine.isHidden = true
                }
            }).disposed(by: self.disposeBag)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
//        let fullWidth:CGFloat = 160
//        let namewidth = CGFloat(ceilf( Float(entity.name.aliasCoinMapName().textSizeWithFont(UIFont.ThemeFont.SecondaryRegular, width: CGFloat.greatestFiniteMagnitude).width + 15)))
//        let roseWidth = entity.rose.textSizeWithFont(UIFont.ThemeFont.SecondaryRegular, width: CGFloat.greatestFiniteMagnitude).width + 15
//
//        var tagWidth = tagView.commonTagWidth(titleStr: tagView.titleLabel?.text ?? "")
//        let savedWidth = fullWidth - roseWidth - namewidth
//        if savedWidth < tagWidth {
//            tagWidth = savedWidth
//        }
//        tagView.frame = CGRect(x: namewidth, y: 5, width: tagWidth, height: 14)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class EXHomeKlineView : UIView{
    
    lazy var view : XSHLineChartView = {
        let view = XSHLineChartView.init(frame: CGRect.init(x: 0, y: 0, width: 99, height: 36))
        view.backgroundColor = UIColor.ThemeView.bg
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.ThemeView.bg
        addSubview(view)
    }
    
    func setColor(_ color : UIColor){
        view.setColor(color)
    }
    
    func setView(XDatasArr:[CGFloat],YDatasArr:[CGFloat]){
        view.creatLineChart(XDatasArr: XDatasArr, YDatasArr: YDatasArr)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
