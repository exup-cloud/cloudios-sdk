//
//  EXChangeOTCPWVC.swift
//  Chainup
//
//  Created by zewu wang on 2019/4/13.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import UIKit

class EXChangeOTCPWVC: NavCustomVC {

    lazy var mainView : EXChangeOTCPWView = {
        let view = EXChangeOTCPWView()
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
    }
    
    override func setNavCustomV() {
        //已设置资金密码
        if UserInfoEntity.sharedInstance().isCapitalPwordSet == "1"{
            self.setTitle(LanguageTools.getString(key: "safety_text_editOtcPassword"))
        }else{//未设置资金密码
            self.setTitle(LanguageTools.getString(key: "safety_action_otcPassword"))
        }
        self.xscrollView = mainView.tableView
        self.lastVC = true
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
