//
//  SLSwapTransferRecordVc.swift
//  Chainup
//
//  Created by KarlLichterVonRandoll on 2020/1/8.
//  Copyright © 2020 zewu wang. All rights reserved.
//

import Foundation

class SLSwapTransferRecordVc: NavCustomVC,NavigationPlugin,EXEmptyDataSetable {
    private let swapTransferCellID = "EXLeverageTransferRecordCell"
    var page = 1
    var symbol = ""//传过来的币对
    
    var transactionType = "0" // 1.转入合约，2. 转出合约
    var modelsArr = [SLSwapTransferListModel]()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .plain)
        tableView.extSetTableView(self, self)
        return tableView
    }()
    let filter = EXFilterView()
    var filterParam = [String:String]()
    internal lazy var navigation : EXNavigation = {
        let nav =  EXNavigation.init(affectScroll: self.tableView, presenter: self)
        nav.isLastNavigationStyle = true
        return nav
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 11.0, *) {
            self.tableView.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        initLayout()
        handNavigationBar()
        bindCell()
        self.exEmptyDataSet(self.tableView, attributeBlock: { () -> ([EXEmptyDataSetAttributeKeyType : Any]) in
            return [
                .verticalOffset:(CGFloat(-110)),
            ]
        })
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.filter.dismissFilter()
    }
    override func setNavCustomV() {
        self.xscrollView = self.tableView
    }
    func handNavigationBar() {
        self.navigation.setTitle(title:symbol + "transfer_text_record".localized())
        self.navigation.setdefaultType(type: .list)
        navigation.configRightItems(["screening"])
        navigation.rightItemCallback = {[weak self] tag in
            self?.filterAction()
        }
    }
    private func initLayout() {
        view.addSubview(tableView)
        tableView.snp_makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(self.navCustomView.snp_bottom)
        }
    }
    func filterAction() {
        if filter.isShow {
            return
        }
        filter.delegate = self
        filter.filterParams = self.filterParam
        filter.show(inView: self.view)
    }
    func bindCell()  {
        self.tableView.backgroundColor = UIColor.ThemeView.bg
        tableView.register(UINib.init(nibName: "EXLeverageTransferRecordCell", bundle: nil), forCellReuseIdentifier: "EXLeverageTransferRecordCell")
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        tableView.rowHeight = UITableViewAutomaticDimension;
        tableView.estimatedRowHeight = 200;
        let view = UIView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: 0.001))
        tableView.tableHeaderView = view
        self.tableView.mj_header = EXRefreshHeaderView (refreshingBlock: {[weak self] in
            guard let mySelf = self else{return}
            mySelf.page = 1
            mySelf.loadData()
        })
        self.tableView.mj_footer = EXRefreshFooterView (refreshingBlock: {[weak self] in
            guard let mySelf = self else{return}
            mySelf.loadData()
        })
        loadData()
    }
}

extension SLSwapTransferRecordVc {
    
    func loadData() {
        let start = self.filterParam["startTime"]
        let end = self.filterParam["endTime"]
        
        appApi.rx.request(.transferList(coinSymbol: self.symbol, transactionScene: "contract_transfer", startTime: start, endTime: end, page: String(page)))
            .MJObjectMap(SLSwapTransferModel.self)
            .subscribe{[weak self] event in
                switch event {
                case .success(let model):
                     guard let mySelf = self else{return}
                       if mySelf.page == 1{
                           mySelf.modelsArr.removeAll()
                       }
                     var arrM : [SLSwapTransferListModel] = []
                     for item in model.financeList {
                        if mySelf.transactionType == "0" {
                            arrM.append(item)
                        } else {
                            if item.status == mySelf.transactionType {
                                arrM.append(item)
                            }
                        }
                     }
                       mySelf.modelsArr += arrM
                       mySelf.tableView.reloadData()
                       mySelf.page = mySelf.page + 1
                       mySelf.endRefresh()
                    break
                case .error(_):
                    break
                }
        }.disposed(by: self.disposeBag)
    }
    //结束刷新
    func endRefresh(){
        self.tableView.mj_footer?.endRefreshing()
        self.tableView.mj_header?.endRefreshing()
    }
}

extension SLSwapTransferRecordVc:UITableViewDataSource,UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return modelsArr.count
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let element = modelsArr[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "EXLeverageTransferRecordCell", for: indexPath) as! EXLeverageTransferRecordCell
        cell.setSwapModel(model: element)
        return cell
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = EXLeverageTransferRecordSectionHeader.loadFromNib()
        header.leftILab.text = "charge_text_date".localized()
        header.middleLab.text = "charge_text_volume".localized()
        header.rightLab.text = "contract_text_type".localized()
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 12
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

extension SLSwapTransferRecordVc :EXFilterViewDelegate  {
    func getTradTypeModel()-> EXFilterDataModel {
        let folditems = EXFilterItem.getItem(titles: ["common_action_sendall".localized(),"contract_bb_transfer_to_contract".localized(),"contract_contract_transfer_to_bb".localized()], valueKeys: ["0","1","2"])
        return EXFilterDataModel.getFoldModel(key: "tradeType", title: "filter_fold_transactionType".localized(), contents: folditems)
    }
    func filterDataSource() -> [EXFilterDataModel] {
         let dateModel = EXFilterDataModel.getDateModel(beginDateKey: "startTime", endDateKey: "endTime", title: "charge_text_date".localized())
        return [self.getTradTypeModel(),dateModel]
    }
    
    func filterConfirm(params: [String : String]) {
        self.page = 1
        self.filterParam = params
        transactionType = params["tradeType"] ?? ""
        self.tableView.mj_header.beginRefreshing()
    }
}

