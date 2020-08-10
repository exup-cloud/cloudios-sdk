//
//  EXLeverageCoinSearchVc.swift
//  Chainup
//
//  Created by ljw on 2019/11/7.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import UIKit
enum EXLeverageCoinSearchType {
    case none
    case transfer//划转
    case borrow //借贷
    case journal//资金流水
}
class EXLeverageCoinSearchVc: UIViewController,EXEmptyDataSetable {
    lazy var dataArr : [CoinMapEntity] = {
       return PublicInfoManager.sharedInstance.getAllLeverArray()
    }()
    var searchArr = [CoinMapEntity]()
    var type = EXLeverageCoinSearchType.none
    typealias CallBackBlock = (_ str : String) -> ()
    var backCoinNameBlock : CallBackBlock?
    @IBOutlet weak var topCon: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var cancleLab: UILabel!
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        self.exEmptyDataSet(self.tableView, attributeBlock: { () -> ([EXEmptyDataSetAttributeKeyType : Any]) in
            return [
                .verticalOffset:(CGFloat(-110)),
            ]
        })
        if type == .journal {
            let allCoin = CoinMapEntity()
            allCoin.name = "leverage_all_coinMap".localized()
            dataArr.insert(allCoin, at: 0)
        }
        searchArr = dataArr
        tableView.reloadData()
    }

    @IBAction func cancleAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    func configUI()  {
        self.tableView.backgroundColor = UIColor.ThemeView.bg
        tableView.register(UINib.init(nibName: "EXLeverageCoinSearchCell", bundle: nil), forCellReuseIdentifier: "EXLeverageCoinSearchCell")
        tableView.rowHeight = UITableViewAutomaticDimension;
        tableView.estimatedRowHeight = 200;
        cancleLab.text = "common_text_btnCancel".localized()
        topCon.constant = NAV_STATUS_HEIGHT + 15
        searchField.placeholder = "assets_action_search".localized()
        //searchField.becomeFirstResponder()
        searchField.rx.text.orEmpty.asObservable()
        .distinctUntilChanged()
        .subscribe(onNext:{[weak self] text in
            self?.searchFor(key: text)
        }).disposed(by: self.disposeBag)
    }
    
    func searchFor(key : String) {
        self.searchArr.removeAll()
        tableView.reloadData()
        for item in dataArr {
            if item.name.lowercased().contains(key.lowercased()) {
                searchArr.append(item)
            }
        }
        tableView.reloadData()
    }
    

}
extension EXLeverageCoinSearchVc:UITableViewDataSource,UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchArr.count
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EXLeverageCoinSearchCell", for: indexPath) as! EXLeverageCoinSearchCell
        let model = searchArr[indexPath.row]
        cell.coinName.text = model.name.aliasCoinMapName()
        return cell
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = searchArr[indexPath.row]
        if backCoinNameBlock != nil {
            backCoinNameBlock?(model.name)
            self.navigationController?.popViewController(animated: true)
        }else {
            if type == .borrow {//借贷
               let vc = EXLeverageReturnVc.init(nibName: "EXLeverageReturnVc", bundle: nil)
               vc.type = .leverageBorrow
               vc.currentCoinName = model.name.uppercased()
               self.navigationController?.pushViewController(vc, animated: true)
            }else if type == .transfer {//划转
        let transfer = EXAccountTransferVc.instanceFromStoryboard(name: StoryBoardNameAsset)
                   transfer.isPopRoot = true
                   transfer.coinMapName = model.name.uppercased()
                   transfer.transferFlow = .leverageToExchagne
                   transfer.onTrasferSuccessCallback = { [weak self] (ftype,ttype) in

                   }
                self.navigationController?.pushViewController(transfer, animated: true)
            }
           
        }
    }
}

