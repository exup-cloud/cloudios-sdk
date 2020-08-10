//
//  EXHelpVC.swift
//  Chainup
//
//  Created by zewu wang on 2019/4/22.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import UIKit

class EXHelpVC: NavCustomVC,EXEmptyDataSetable {
    
    lazy var mainView : EXHelpView = {
        let view = EXHelpView()
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
        self.exEmptyDataSet(mainView.tableView)
    }
    
    override func setNavCustomV() {
        self.setTitle(LanguageTools.getString(key: "personal_text_helpcenter"))
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
