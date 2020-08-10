//
//  ContractTransactionHeadView.swift
//  Chainup
//
//  Created by zewu wang on 2019/5/14.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import UIKit

class ContractTransactionHeadView: UIView {
    
    //状态栏
    lazy var contractTransactionStatusView :  ContractTransactionStatusView = {
        let view = ContractTransactionStatusView()
        view.extUseAutoLayout()
        return view
    }()
    
    lazy var leftView : ContractTransactionLeftView = {
        let view = ContractTransactionLeftView()
        view.extUseAutoLayout()
        return view
    }()
    
    lazy var rightView : ContractTransactionRightView = {
        let view = ContractTransactionRightView()
        view.extUseAutoLayout()
        view.getEntityBlock = {[weak self]entity in
            self?.leftView.tagPriceEntity = entity
        }
        view.clickRightBlock = {[weak self]entity in
            self?.leftView.priceTextField.input.text = entity.price
        }
        return view
    }()
    
    lazy var bottomView : UIView = {
        let view = UIView()
        view.extUseAutoLayout()
        view.backgroundColor = UIColor.ThemeNav.bg
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubViews([contractTransactionStatusView,leftView,rightView,bottomView])
        contractTransactionStatusView.snp.makeConstraints { (make) in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(74)
        }
        leftView.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.top.equalTo(contractTransactionStatusView.snp.bottom)
            make.width.equalTo(proportion_width)
            make.height.equalTo(392)
        }
        rightView.snp.makeConstraints { (make) in
            make.right.equalToSuperview()
            make.left.equalTo(leftView.snp.right)
            make.top.bottom.equalTo(leftView)
        }
        bottomView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(leftView.snp.bottom)
            make.height.equalTo(10)
        }
        reloadView()
    }
    
    func reloadView(){
        //如果未登录 或者 分仓模式下 ，不展示状态栏
        if XUserDefault.getToken() == nil || ContractPublicInfoManager.manager.getContractPositionType() == "1"{
            contractTransactionStatusView.snp.updateConstraints { (make) in
                make.height.equalTo(0)
            }
        }else{
            contractTransactionStatusView.snp.updateConstraints { (make) in
                make.height.equalTo(74)
            }
        }
        contractTransactionStatusView.reloadView()
        leftView.reloadView()
        rightView.reloadView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
