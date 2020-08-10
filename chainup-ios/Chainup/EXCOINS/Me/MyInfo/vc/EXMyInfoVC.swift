//
//  EXMyInfoVC.swift
//  Chainup
//
//  Created by zewu wang on 2019/3/23.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import UIKit
import RxSwift

class EXMyInfoVC: NavCustomVC {
    
    lazy var  mainView : EXMyInfoView = {
        let view = EXMyInfoView()
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
        self.setTitle(LanguageTools.getString(key: "userinfo_text_data"))
        self.xscrollView = self.mainView.tableView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //请求接口之后才会更新数据
        appApi.hideAutoLoading()
        UserInfoEntity.sharedInstance().getUserInfo {[weak self] in
            self?.mainView.setData()
        }
    }
}
