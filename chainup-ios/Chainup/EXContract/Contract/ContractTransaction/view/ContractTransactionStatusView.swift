//
//  ContractTransactionStatusView.swift
//  Chainup
//
//  Created by zewu wang on 2019/5/9.
//  Copyright © 2019 zewu wang. All rights reserved.
//  合约交易状态栏

import UIKit
import RxSwift

class ContractTransactionStatusView: UIView {
    
    var entity = ContractContentModel()

    lazy var leftView : ContractTransactionStatusDetailView = {
        let view = ContractTransactionStatusDetailView()
        view.extUseAutoLayout()
        view.nameLabel.text = "contract_text_positionNumber".localized()
        return view
    }()
    
    lazy var middleView : ContractTransactionStatusDetailView = {
        let view = ContractTransactionStatusDetailView()
        view.extUseAutoLayout()
        view.nameLabel.text = "contract_text_returnRate".localized()
        return view
    }()
    
    lazy var rightView : ContractTransactionStatusDetailView = {
        let view = ContractTransactionStatusDetailView()
        view.extUseAutoLayout()
        view.nameLabel.textAlignment = .right
        view.nameLabel.text = "contract_text_liqPrice".localized()
        view.volumeLabel.textAlignment = .right
        return view
    }()
    
    lazy var lineV : UIView = {
        let view = UIView()
        view.extUseAutoLayout()
        view.backgroundColor = UIColor.ThemeNav.bg
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.ThemeView.bg
        addSubViews([leftView,middleView,rightView,lineV])
        let width = (SCREEN_WIDTH - 30) / 3
        leftView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.width.equalTo(width)
            make.height.equalTo(35)
            make.top.equalToSuperview().offset(15)
        }
        middleView.snp.makeConstraints { (make) in
            make.left.equalTo(leftView.snp.right)
            make.width.equalTo(width)
            make.height.equalTo(35)
            make.top.equalToSuperview().offset(15)
        }
        rightView.snp.makeConstraints { (make) in
            make.left.equalTo(middleView.snp.right)
            make.width.equalTo(width)
            make.height.equalTo(35)
            make.top.equalToSuperview().offset(15)
        }
        lineV.snp.makeConstraints { (make) in
            make.bottom.left.right.equalToSuperview()
            make.height.equalTo(10)
        }
        reloadView()
    }
    
    func setView(_ left : String , middle : String , right : String){
        leftView.setVolume(left)
        middleView.setVolume(middle)
        rightView.setVolume(right)
    }
    
    func reloadView(){
        leftView.setVolume("--")
        middleView.setVolume("--")
        rightView.setVolume("--")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension ContractTransactionStatusView{
    
    //获取用户持仓信息
    func getUserPosition(){
        if XUserDefault.getToken() != nil{
            contractApi.hideAutoLoading()
            contractApi.rx.request(ContractAPIEndPoint.userPosition(contractId: entity.id)).MJObjectMap(ContractUserPositionModels.self).subscribe(onSuccess: {[weak self] (models) in
                if models.positions.count > 0{
                    let entity = models.positions[0]
                    self?.setView(entity.volume, middle: entity.fmtUnrealisedRateIndex(), right: entity.fmtLiqPrice())
                }else{
                    self?.setView("--", middle: "--", right: "--")
                }
            }) { (error) in
                
            }.disposed(by: disposeBag)
        }
    }

}

class ContractTransactionStatusDetailView : UIView {
    
    lazy var nameLabel : UILabel = {
        let label = UILabel()
        label.extUseAutoLayout()
        label.font = UIFont.ThemeFont.SecondaryRegular
        label.textColor = UIColor.ThemeLabel.colorDark
        return label
    }()
    
    lazy var volumeLabel : UILabel = {
        let label = UILabel()
        label.extUseAutoLayout()
        label.font = UIFont.ThemeFont.BodyRegular
        label.textColor = UIColor.ThemeLabel.colorLite
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.ThemeView.bg
        addSubViews([nameLabel,volumeLabel])
        nameLabel.snp.makeConstraints { (make) in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(12)
        }
        volumeLabel.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.height.equalTo(14)
            make.top.equalTo(nameLabel.snp.bottom).offset(8)
        }
    }
    
    func setVolume(_ text : String){
        volumeLabel.text = text
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
