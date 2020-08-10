//
//  EXChangePWVC.swift
//  Chainup
//
//  Created by zewu wang on 2019/4/12.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import UIKit

class EXChangePWVC: NavCustomVC {

    lazy var mainView : EXChangePWV = {
        let view = EXChangePWV()
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
        self.setTitle(LanguageTools.getString(key: "safety_action_changeLoginPassword"))
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
