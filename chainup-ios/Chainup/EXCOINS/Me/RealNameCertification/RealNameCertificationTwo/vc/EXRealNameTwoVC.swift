//
//  EXRealNameTwoVC.swift
//  Chainup
//
//  Created by zewu wang on 2019/3/28.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import UIKit

class EXRealNameTwoVC: NavCustomVC {
    
    lazy var mainView : EXRealNameTwoView = {
        let view = EXRealNameTwoView()
        view.extUseAutoLayout()
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        contentView.addSubViews([mainView])
        mainView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    override func setNavCustomV() {
        self.setTitle(LanguageTools.getString(key: "otcSafeAlert_action_identify"))
        self.xscrollView = mainView.tableView
        self.lastVC = true
    }
    
    
}
