//
//  EXRealNameCertificationChooseVC.swift
//  Chainup
//
//  Created by zewu wang on 2019/7/30.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import UIKit

class EXRealNameCertificationChooseVC: NavCustomVC {

    lazy var mainView : EXRealNameCertificationChooseView = {
        let view = EXRealNameCertificationChooseView()
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
        NotificationCenter.default.addObserver(self, selector: #selector(realNameTwoNotification), name:  NSNotification.Name.init("RealNameTwoNotification"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //如果后台开关打开了 才会显示
        if PublicInfoEntity.sharedInstance.interfaceSwitch == "1"{
            mainView.getLanguage()
        }
    }
    
    @objc func realNameTwoNotification(){
        self.navigationController?.popViewController(animated: false)
        self.navigationController?.popViewController(animated: false)
        DispatchQueue.main.async {
            guard let appDelegate  = UIApplication.shared.delegate else {
            return
            }
            if appDelegate.window != nil {
                let vc = EXRealNameThreeVC()
                vc.modalPresentationStyle = .fullScreen
                appDelegate.window??.rootViewController?.present(vc, animated: true, completion: nil)
            }
        }
    }
    
    override func setNavCustomV() {
        self.setTitle("otcSafeAlert_action_identify".localized())
        self.xscrollView = mainView.tableView
        self.lastVC = true
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
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
