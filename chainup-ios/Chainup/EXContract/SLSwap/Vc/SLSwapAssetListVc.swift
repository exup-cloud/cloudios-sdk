//
//  SLSwapAssetListVc.swift
//  Chainup
//
//  Created by KarlLichterVonRandoll on 2020/1/7.
//  Copyright © 2020 zewu wang. All rights reserved.
//

import Foundation

class SLSwapAssetListVc: EXAssetBaseVc,StoryBoardLoadable {
    private let reuseID = "SLSwapAssetListCell_ID"
    @IBOutlet var swapAssetTable: UITableView!
    var assetVm:EXAssetsVm = EXAssetsVm()
    var assetArr : [BTItemCoinModel] = []
    let toolbarHeader:SLSwapTableHeader = SLSwapTableHeader(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 84))
    var contractAssetModel:EXContractAccountModel = EXContractAccountModel()
    var needUpdatedPrivacy:Bool = false
    
    override func updatePrivacy() {
        if self.swapAssetTable != nil  {
            assetArr = SLPersonaSwapInfo.sharedInstance().getAllSwapAssetItem() ?? []
            self.swapAssetTable.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(toolbarHeader)
        swapAssetTable.extSetTableView(self, self)
        handleToolbar()
        bindVm()
        swapAssetTable.extRegistCell([SLAssetInfoCell.classForCoder()],[reuseID])
        /// 私有信息刷新
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(contractAssetUpdataAsset),
                                               name: NSNotification.Name(rawValue: BTSocketDataUpdate_Contract_Unicast_Notification),
                                               object: nil)
        
        // 添加退出登录通知
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(refreshLogout),
                                               name: NSNotification.Name(rawValue: "Logout_notification_name"),
                                               object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func handleJumpToSwapVc() {
        if let tabbar = BusinessTools.getRootTabbar() {
            let index = tabbar.getVCIndex(SLSwapVc())
            tabbar.selectIndex(index)
        }
    }
    
    func bindVm() {
        self.assetVm.onAssetCallback = {[weak self] accountModel in
            self?.updateBalance()
        }
        requestBalalance()
    }
    
    func updateBalance() {
        let assetModel = EXCommonAssetModel()
        assetModel.positionMargin = "BTC"
        assetModel.totalBalanceSymbol = "BTC"
        assetModel.assetType = .contract
        // 把所有币种都转换为 BTC
        if let coinArray = SLPersonaSwapInfo.sharedInstance().getAllSwapAssetItem() {
            let allBTC = PublicInfoManager.sharedInstance.convertAssetsToBTC(coinArray: coinArray)
            assetModel.totalBalance = allBTC
        } else {
            assetModel.totalBalance = "0"
        }
        self.onAssetupdate?(assetModel)
    }
    
    func requestBalalance() {
        if XUserDefault.isOffLine() {
            self.assetVm.otcAssetsList.accept([])
        } else {
            self.assetVm.getSwapAccountBalance()
        }
    }
    
    func handleToolbar() {
        view.addSubview(toolbarHeader)
        toolbarHeader.toolBar.bindToolBarItems(self.assetVm.getSwapToolbars())
        toolbarHeader.toolBar.onToolBarSelected = {[weak self] action in
            self?.handleToolbarAction(action)
        }
        self.swapAssetTable.tableHeaderView = toolbarHeader
    }
    
    func handleToolbarAction(_ action:EXAssetToolBarAction) {
        assetVm.handleSwapToolbarAction(action, contractAssetModel, self)
    }
    
    // 合约资产刷新通知
    @objc func contractAssetUpdataAsset(notification: NSNotification) {
        assetArr = SLPersonaSwapInfo.sharedInstance().getAllSwapAssetItem()
        swapAssetTable.reloadData()
        self.updateBalance()
    }
    
    /// 退出登录
    @objc private func refreshLogout() {
        // 更新顶部资产总和
        self.updateBalance()
        // 更新底部资产列表
        self.assetArr = []
        self.swapAssetTable.reloadData()
    }
}

extension SLSwapAssetListVc : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView()
        header.backgroundColor = UIColor.ThemeNav.bg
        header.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 10)
        return header
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return assetArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseID, for: indexPath) as! SLAssetInfoCell
        let itemModel = assetArr[indexPath.row]
        let property = SLMinePerprotyModel()
        property.conversionContractAssetsWithitemModel(itemModel)
        cell.assetModel = property
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let itemCoinModel = assetArr[indexPath.row]
        let vc = SLAssetsDetailVC()
        self.navigationController?.pushViewController(vc, animated: true)
        vc.itemCoinModel = itemCoinModel
    }
}
