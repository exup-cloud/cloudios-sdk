//
//  EXEmailOpenVC.swift
//  Chainup
//
//  Created by zewu wang on 2019/4/16.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import UIKit

class EXEmailOpenVC: NavCustomVC {

    lazy var mainView : EXEmailOpenView = {
        let view = EXEmailOpenView()
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
        self.setTitle(LanguageTools.getString(key: "safety_text_mailAuth"))
        self.xscrollView = mainView.tableView
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mainView.tableView.reloadData()
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
