//
//  StatementVC.swift
//  AppProject
//
//  Created by zewu wang on 2018/8/4.
//  Copyright © 2018年 zewu wang. All rights reserved.
//

import UIKit

class StatementVC: WebVC {
    
    var titleStr : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setTitle(titleStr)
        getDatas()
    }
    
    func getDatas(){
        let url = NetManager.sharedInstance.url(EXNetworkDoctor.sharedManager.getAppAPIHost(), model: NetDefine.common, action: NetDefine.terms)
//        let url = NetManager.sharedInstance.url(NetDefine.http_host_url, model: NetDefine.common, action: NetDefine.terms)
        NetManager.sharedInstance.sendRequest(url , parameters: [:],mothed : .get, success: { (result, response, nil) in
            if let result = result as? [String : Any]{
                guard let data = result["data"] as? [[String : Any]] else{return}
                if data.count > 0{
                    guard let url = data[0]["url"] as? String else{return}
                    self.loadUrl(url)
                }
            }
        }) { (state , error , nil) in
            
        }
    }
    
    override func setNavCustomV() {
        super.setNavCustomV()
        self.lastVC = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
