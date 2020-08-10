//
//  EXRealNameOneVC.swift
//  Chainup
//
//  Created by zewu wang on 2019/3/27.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import UIKit

class EXRealNameOneVC: NavCustomVC {

    lazy var mainView : EXRealNameOneView = {
        let view = EXRealNameOneView()
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
    
    override func setNavCustomV() {
        self.setTitle("otcSafeAlert_action_identify".localized())
        self.xscrollView = mainView.tableView
        self.lastVC = true
    }
    
    @objc func realNameTwoNotification(){
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
