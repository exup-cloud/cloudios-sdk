//
//  EXAnnouncementVC.swift
//  Chainup
//
//  Created by zewu wang on 2019/4/18.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import UIKit

class EXAnnouncementVC: NavCustomVC {
    
    lazy var mainView : EXAnnouncementView = {
        let view = EXAnnouncementView()
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
        self.setTitle(LanguageTools.getString(key: "personal_text_notice"))
        self.xscrollView = mainView.tableView
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
