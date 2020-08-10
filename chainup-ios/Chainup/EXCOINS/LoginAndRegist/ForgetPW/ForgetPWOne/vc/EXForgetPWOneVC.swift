//
//  EXForgetPWOneVC.swift
//  Chainup
//
//  Created by zewu wang on 2019/3/8.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import UIKit

class EXForgetPWOneVC: NavCustomVC {
    
    lazy var mainView : EXForgetPWOneView = {
        let view = EXForgetPWOneView()
        view.extUseAutoLayout()
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        contentView.addSubViews([mainView])
        mainView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        self.lastVC = true
    }
    
}
