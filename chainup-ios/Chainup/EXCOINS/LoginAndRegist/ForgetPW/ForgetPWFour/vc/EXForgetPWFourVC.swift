//
//  EXForgetPWThreeVC.swift
//  Chainup
//
//  Created by zewu wang on 2019/3/8.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import UIKit

class EXForgetPWFourVC: NavCustomVC {

    lazy var mainView : EXForgetPWFourView = {
        let view = EXForgetPWFourView()
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
