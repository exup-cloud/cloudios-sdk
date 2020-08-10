//
//  EXReLoginVC.swift
//  Chainup
//
//  Created by zewu wang on 2019/3/11.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import UIKit

class EXReLoginVC: NavCustomVC {
    
    //取消按钮
    lazy var cancelBtn : UIButton = {
        let btn = UIButton()
        btn.extUseAutoLayout()
        btn.titleLabel?.font = UIFont.ThemeFont.BodyRegular
        btn.setTitleColor(UIColor.ThemeLabel.colorMedium, for: UIControlState.normal)
        btn.setTitle(LanguageTools.getString(key: "common_text_btnCancel"), for: UIControlState.normal)
        btn.contentHorizontalAlignment = .left
        btn.extSetAddTarget(self, #selector(clickCancelBtn))
        return btn
    }()
    
    lazy var mainView : EXReLoginView = {
        let view = EXReLoginView()
        view.extUseAutoLayout()
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        contentView.addSubview(mainView)
        mainView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    override func setNavCustomV() {
        self.navCustomView.backView.backgroundColor = UIColor.ThemeView.bg
        self.navCustomView.popBtn.isHidden = true
        self.navCustomView.addSubview(cancelBtn)
        cancelBtn.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.centerY.equalTo(self.navCustomView.popBtn)
            make.width.lessThanOrEqualTo(200)
            make.height.equalTo(16)
        }
    }
    
    @objc func clickCancelBtn(){
        guard let _ = BusinessTools.getRootNavBar()else{
            return
        }
        if let _ = BusinessTools.getRootTabbar(){
            if XUserDefault.getToken() == nil{
                popBack()
            }else{
                popBack()
            }
        }else{
            popBack()
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
