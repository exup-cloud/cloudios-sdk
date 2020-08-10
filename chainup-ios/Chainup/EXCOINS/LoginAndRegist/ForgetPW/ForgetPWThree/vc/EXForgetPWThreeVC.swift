//
//  EXForgetPWThreeVC.swift
//  Chainup
//
//  Created by zewu wang on 2019/4/23.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import UIKit

class EXForgetPWThreeVC: NavCustomVC {
    
    lazy var mainView : EXForgetPWThreeView = {
        let view = EXForgetPWThreeView()
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
