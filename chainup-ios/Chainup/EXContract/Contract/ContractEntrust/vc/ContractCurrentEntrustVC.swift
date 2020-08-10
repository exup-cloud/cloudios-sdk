//
//  ContractCurrentEntrustVC.swift
//  Chainup
//
//  Created by zewu wang on 2019/5/10.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import UIKit

class ContractCurrentEntrustVC: NavCustomVC ,EXEmptyDataSetable {
    
    lazy var mainView : ContractCurrentEntrustView = {
        let view = ContractCurrentEntrustView()
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
        self.mainView.getContractCurrent()

    }
    
    override func setNavCustomV() {
        self.setTitle("contract_text_currentEntrust".localized())
        self.xscrollView = mainView.tableView
        let historyBtn = UIButton()
        historyBtn.extUseAutoLayout()
        historyBtn.layoutIfNeeded()
        historyBtn.setTitle("contract_text_historyCommision".localized(), for: UIControlState.normal)
        historyBtn.setTitleColor(UIColor.ThemeLabel.colorMedium, for: UIControlState.normal)
        historyBtn.titleLabel?.font = UIFont.ThemeFont.BodyRegular
        self.navCustomView.addSubview(historyBtn)
        historyBtn.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-15)
            make.height.equalTo(20)
            make.centerY.equalTo(self.navCustomView.popBtn)
        }
        historyBtn.extSetAddTarget(self, #selector(clickHistoryBtn))
    }
    
    //点击历史委托
    @objc func clickHistoryBtn(){
        let vc = ContractHistoryVC()
        vc.mainView.entity = self.mainView.entity
        self.navigationController?.pushViewController(vc, animated: true)
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
