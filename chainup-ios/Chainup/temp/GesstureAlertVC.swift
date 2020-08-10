//
//  GesstureAlertVC.swift
//  Chainup
//
//  Created by xue on 2018/11/28.
//  Copyright © 2018 zewu wang. All rights reserved.
//

import UIKit

class GesstureAlertVC: UIViewController {

    @IBOutlet weak var titleL: UILabel!
    
    @IBOutlet weak var detailL: UILabel!
    
    @IBOutlet weak var IMG: UIImageView!
    var type = "0"

    @IBOutlet weak var imgVConstraintWidth: NSLayoutConstraint!
    
    lazy var statusLabel : UILabel = {
        let label = UILabel()
        label.extUseAutoLayout()
        label.font = UIFont.ThemeFont.HeadRegular
        label.textColor = UIColor.ThemeLabel.colorLite
        label.textAlignment = .center
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(statusLabel)
        statusLabel.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.height.equalTo(16)
            make.top.equalTo(IMG.snp.bottom).offset(30)
        }
        
        FingerPrintVerify.fingerIsSupportCallBack { (type) in

                if type == "1" {
                    self.setData("1")
                    self.type = "1"

                }else if type == "2"{
                    self.setData("2")

                    self.type = "2"
                }

                else
                {

                    self.setData("3")
                    self.type = "3"
                }
            
        
        }

        // Do any additional setup after loading the view.
    }
    
    @IBAction func Setting(_ sender: UIButton) {
        
        if type == "1" || type == "2"{
            
            FingerPrintVerify.fingerPrintLocalAuthenticationFallBackTitle(LanguageTools.getString(key: "login_action_oneClick"), localizedReason: LanguageTools.getString(key: "login_action_oneClick")) { (success, error, alert) in
                if success == true{
                    
                    XUserDefault.setFaceIdOrTouchId("100")
                    EXAlert.showSuccess(msg: alert ?? "")
                    self.navigationController?.popViewController(animated: true)
                }else{
                    EXAlert.showFail(msg: alert ?? "")
                }
            }
            
        }else if type == "3"{
     
            let onevc = GestureValidationVC()
            
            onevc.type = GestureValidationType.loginSet
           
            onevc.confirmGesturesBlock = {[weak self](password) in
                guard let mySelf = self else{return}
                let twovc = GestureValidationVC()
                twovc.confirmGesturesCompleteBlock = {() in
                    self?.navigationController?.popViewController(animated: true)
                }
                twovc.type = GestureValidationType.loginSetAgain
                twovc.code = password
                
                onevc.popBack(false)
                
                mySelf.navigationController?.pushViewController(twovc, animated: true)
            }
            self.navigationController?.pushViewController(onevc, animated: true)
        }   
    }
    
    func setData(_ type:NSString){
        
        if type == "1"{
            self.statusLabel.text = "Touch-ID"
            self.titleL.text = LanguageTools.getString(key: "login_text_fingerprint")
            self.detailL.text = LanguageTools.getString(key: "login_tip_fingerprint")
            self.imgVConstraintWidth.constant = 136
            
            self.IMG.image = UIImage.themeImageNamed(imageName: "login_fingerprintlogin")
        }else if type == "2"{
            self.statusLabel.text = "Face-ID"
            self.titleL.text = LanguageTools.getString(key: "safety_text_faceId")
            self.detailL.text = LanguageTools.getString(key: "safety_tip_faceIdAdvantage")
            self.imgVConstraintWidth.constant = 136
            
            self.IMG.image =  UIImage.themeImageNamed(imageName: "login_facelogin")
        }else if type == "3"{
            self.statusLabel.text = ""
            self.titleL.text = LanguageTools.getString(key: "safety_text_gesturePassword")
            self.detailL.text = LanguageTools.getString(key: "safety_action_setGesturePassword")
            
        }
    }
    
    @IBAction func remove(_ sender: UIButton) {
        XUserDefault.setNextRemind()

        self.navigationController?.popViewController(animated: true)
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
