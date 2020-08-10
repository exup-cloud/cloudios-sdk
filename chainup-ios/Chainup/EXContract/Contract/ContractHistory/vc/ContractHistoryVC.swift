//
//  ContractHistoryVC.swift
//  Chainup
//
//  Created by zewu wang on 2019/5/13.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import UIKit

class ContractHistoryVC: NavCustomVC ,EXEmptyDataSetable , EXFilterViewDelegate{
    
    let dropView = EXFilterView()
    
    var filterData : [String : String] = ["contractType":"0"]
    
    lazy var mainView : ContractHistoryView = {
        let view = ContractHistoryView()
        view.extUseAutoLayout()
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        contentView.addSubview(mainView)
        mainView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        self.exEmptyDataSet(mainView.tableView)
        self.mainView.getContractHistory()

    }
    
    override func setNavCustomV() {
        self.xscrollView = mainView.tableView
        self.setTitle("contract_text_historyCommision".localized())
        self.lastVC = true
        
        let screeningBtn = UIButton()
        screeningBtn.extUseAutoLayout()
        screeningBtn.setImage(UIImage.themeImageNamed(imageName: "screening"), for: UIControlState.normal)
        self.navCustomView.addSubview(screeningBtn)
        screeningBtn.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-15)
            make.height.width.equalTo(18)
            make.centerY.equalTo(self.navCustomView.popBtn)
        }
        screeningBtn.extSetAddTarget(self, #selector(clickScreeningBtn))
    }
    
    //点击筛选
    @objc func clickScreeningBtn(){
        if dropView.isShow == true{
            return
        }
        dropView.delegate = self
        dropView.show(inView: self.view, position: CGPoint(x: 0, y: NAV_SCREEN_HEIGHT))
        dropView.filterParams = self.filterData
        dropView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        dropView.dismissFilter()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ContractHistoryVC{
    func filterDataSource() -> [EXFilterDataModel] {
        var models : [EXFilterDataModel] = []
        //隐藏撤单
        let switchModel = EXFilterDataModel.getSwitchModel(key: "isShowCanceled", title: "contract_text_hideCancelOrder".localized())
        models.append(switchModel)
        
        //合约类型
        let markets = ["0","1","2","3","4"]
        let titles = ["contract_text_perpetual".localized(),"contract_text_currentWeek".localized(),"contract_text_nextWeek".localized(),"noun_date_month".localized(),"noun_date_quarter".localized()]
        let coinitems = EXFilterItem.getItem(titles: titles, valueKeys: markets)
        //一半输入,一半折叠
        let mixModel = EXFilterDataModel.getMixModel(title: "filter_fold_contractType".localized() + "/" + "filter_fold_contractLimit".localized(), leftKey: "symbol", rightKey: "contractType", leftplaceHolder: "filter_fold_contractType".localized(), rightItems: coinitems)
        models.append(mixModel)
        
        //委托方向
        let dealitems = EXFilterItem.getItem(titles: ["common_action_sendall".localized(),"contract_text_long".localized(),"contract_text_short".localized()], valueKeys: ["","BUY","SELL"])
        let dealTypeModel = EXFilterDataModel.getFoldModel(key: "side", title: "filter_fold_contractOrderType".localized(), contents: dealitems)
        models.append(dealTypeModel)
    
        //委托方向
        if ContractPublicInfoManager.manager.getContractPositionType() == "1"{
            let actionitems = EXFilterItem.getItem(titles: ["common_action_sendall".localized(),"contract_text_openAverage".localized(),"contract_action_closeContract".localized()], valueKeys: ["","OPEN","CLOSE"])
            let actionTypeModel = EXFilterDataModel.getFoldModel(key: "action", title: "contract_text_positionsDirection".localized(), contents: actionitems)
            models.append(actionTypeModel)
        }
     
        //价格类型
        let items = EXFilterItem.getItem(titles: [LanguageTools.getString(key: "common_action_sendall"),LanguageTools.getString(key: "contract_action_limitPrice"),LanguageTools.getString(key: "contract_action_marketPrice")], valueKeys: ["","1","2"])
        let priceTypeModel = EXFilterDataModel.getFoldModel(key: "orderType", title: "filter_fold_contractOrderPriceType".localized(), contents: items)
        models.append(priceTypeModel)
        
        //日期
        let dateModel = EXFilterDataModel.getDateModel(beginDateKey: "startTime", endDateKey: "endTime", title: "charge_text_date".localized())
//        models.append(dateModel)
        
        return models
    }
    
    func filterConfirm(params: [String : String]) {
        mainView.setParams(params)
        mainView.page = 1
        mainView.getContractHistory()
    }
    
    func cellModelForceSelect(_ idx: Int) -> Bool {
        return (idx == 1) ? true :false
    }
    
    func forceParamNotFill(_ emptyData: [String : String]) {
        print(emptyData)
        if let coin = emptyData["symbol"] , coin == ""{
            EXAlert.showFail(msg: "contract_tip_seiresInput".localized())
        }
    }
}
