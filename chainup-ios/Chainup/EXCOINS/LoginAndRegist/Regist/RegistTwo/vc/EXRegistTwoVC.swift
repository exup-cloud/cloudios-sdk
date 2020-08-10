//
//  EXRegistTwoVC.swift
//  Chainup
//
//  Created by zewu wang on 2019/3/7.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import UIKit

class EXRegistTwoVC: NavCustomVC {

    lazy var mainView : EXRegistTwoView = {
        let view = EXRegistTwoView()
        view.extUseAutoLayout()
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contentView.addSubViews([mainView])
        mainView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    override func setNavCustomV() {
        self.lastVC = true
    }
    
}
