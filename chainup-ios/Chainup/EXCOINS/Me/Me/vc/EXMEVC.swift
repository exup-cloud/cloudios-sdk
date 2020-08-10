//
//  EXMEVC.swift
//  Chainup
//
//  Created by zewu wang on 2019/3/23.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import UIKit

class EXMEVC: NavCustomVC {
    
    lazy var mainView : EXMEView = {
        let view = EXMEView()
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if XUserDefault.getToken() != nil{
            //请求个人信息 并更新
            UserInfoEntity.sharedInstance().getUserInfo {
                self.mainView.infoView.reloadView()
            }
        }else{
            self.mainView.infoView.reloadView()
        }
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
