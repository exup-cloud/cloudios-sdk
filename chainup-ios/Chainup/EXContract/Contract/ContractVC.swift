//
//  ContractVC.swift
//  Chainup
//
//  Created by zewu wang on 2019/5/9.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import UIKit

class ContractVC: NavCustomVC ,EXEmptyDataSetable {
        
    let height = SCREEN_HEIGHT - TABBAR_HEIGHT - NAV_SCREEN_HEIGHT - 44
    
    var entity = ContractContentModel()
    {
        didSet{
            contractPosstionView.entity = entity
            contractTransactionView.entity = entity
            self.titleLabel.text = entity.getContractName()
        }
    }
    
    lazy var scrollView : UIScrollView = {
        let scrollView = UIScrollView.init(frame: CGRect.init(x: 0, y: 44, width: SCREEN_WIDTH, height: height))
        scrollView.contentSize = CGSize.init(width: SCREEN_WIDTH * 2, height: height)
        scrollView.isScrollEnabled = false
        return scrollView
    }()
    
    lazy var toolView : ContractToolView = {
        let view = ContractToolView()
        view.extUseAutoLayout()
        view.clickBtnBlock = {[weak self](tag) in
            if tag == 1001{//点击持仓页面 需要登录
                if XUserDefault.getToken() == nil{
                    BusinessTools.modalLoginVC()
                    view.reloadBtnStatus(view.dealBtn)
                    return
                }
            }
            self?.scrollView.setContentOffset(CGPoint.init(x: CGFloat(tag - 1000) * SCREEN_WIDTH, y: 0), animated: true)
            self?.contractPosstionView.getDatas()
        }
        return view
    }()
    
    //合约交易页面
    lazy var contractTransactionView : ContractTransactionView = {
        let view = ContractTransactionView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: height))
        view.newPriceBlock = {[weak self]tick in
            self?.toolView.setView(tick)
        }
        return view
    }()
    
    //持仓页面
    lazy var contractPosstionView : ContractPosstionView = {
        let view = ContractPosstionView.init(frame: CGRect.init(x: SCREEN_WIDTH, y: 0, width: SCREEN_WIDTH, height: height))
        view.changeLevelBlock = {[weak self] in
            self?.contractTransactionView.contractTransactionHeadView.leftView.reloadLevel()
        }
        return view
    }()
    
    //选择按钮
    lazy var chooseBtn : UIButton = {
        let btn = UIButton()
        btn.extUseAutoLayout()
        btn.setEnlargeEdgeWithTop(10, left: 10, bottom: 10, right: 10)
        btn.setImage(UIImage.themeImageNamed(imageName: "contract_sidepull"), for: UIControlState.normal)
        btn.extSetAddTarget(self, #selector(clickChooseBtn))
        return btn
    }()
    
    //标题
    lazy var titleLabel : UILabel = {
        let label = UILabel()
        label.extUseAutoLayout()
        label.isUserInteractionEnabled = true
        label.font = UIFont.ThemeFont.H3Bold
        label.textColor = UIColor.ThemeLabel.colorLite
        return label
    }()
    
    //进入详情按钮
    lazy var detailBtn : UIButton = {
        let btn = UIButton()
        btn.extUseAutoLayout()
        btn.setImage(UIImage.themeImageNamed(imageName: "contract_klinediagram"), for: UIControlState.normal)
        btn.extSetAddTarget(self, #selector(clickDetailBtn))
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        contentView.addSubViews([toolView,scrollView])
//        contentView.
        scrollView.addSubViews([contractTransactionView,contractPosstionView])
        toolView.snp.makeConstraints { (make) in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(44)
        }
        //解决tableview 顶部留白
        if #available(iOS 11.0, *) {
            contractTransactionView.tableView.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        setEntity()
        self.exEmptyDataSet(contractPosstionView.tableView)
        forbidMoveFromScreenLeft()
    }
    
    func setEntity(){
        self.entity = ContractPublicInfoManager.manager.getDefaultContract()
    }
    
    override func setNavCustomV() {
        self.navtype = .nopopback
        self.navCustomView.backView.addSubViews([chooseBtn,titleLabel,detailBtn])
        chooseBtn.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.width.equalTo(16)
            make.height.equalTo(14)
            make.centerY.equalTo(self.navCustomView.popBtn)
        }
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(chooseBtn.snp.right).offset(10)
            make.height.equalTo(25)
            make.right.equalTo(detailBtn.snp.left).offset(-10)
            make.centerY.equalTo(chooseBtn)
        }
        detailBtn.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-15)
            make.height.equalTo(17)
            make.width.equalTo(14)
            make.centerY.equalTo(chooseBtn)
        }
        
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(clickChooseBtn))
        titleLabel.addGestureRecognizer(tap)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadView()
        contractTransactionView.appear()
        contractPosstionView.getDatas()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        contractTransactionView.disAppear()
    }
    
    //点击选择按钮 弹出抽屉
    @objc func clickChooseBtn(){
        self.view.isUserInteractionEnabled = false
        let vc = EXDrawerVC()
        let view = ContractDrawerView.getSharedInstance()
        view.clickCellBlock = {[weak self](entity) in
            guard let mySelf = self else{return}
            mySelf.entity = entity
            mySelf.reloadView()
            vc.pullAnimation()
        }
        vc.pullBlock = {[weak self] in
            self?.view.isUserInteractionEnabled = true
        }
        vc.addView(view)
        view.tableView.reloadEmptyDataSet()
    }
    
    //点击合约详情按钮
    @objc func clickDetailBtn(){

    }
    
    func reloadView(){
        contractTransactionView.reloadView()
        toolView.reloadView()
        if XUserDefault.getToken() == nil{
            toolView.reloadBtnStatus(toolView.dealBtn)
            scrollView.setContentOffset(CGPoint.init(x: 0, y: 0), animated: true)
        }
    }

}

extension ContractVC : EXTradeCmdProtocal {
    //symbol 是contractid
    func excuteCmd(symbol: String, action: String) {
        let model = ContractPublicInfoManager.manager.getContractWithContractId(symbol)
        if model.id != ""{
            self.entity = model
        }else{
            setEntity()
        }
        toolView.reloadLineV(toolView.dealBtn)
        self.reloadView()
        self.scrollView.setContentOffset(CGPoint.init(x: 0, y: 0), animated: false)
    }
}
