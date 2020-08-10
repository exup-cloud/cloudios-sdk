//
//  EXAssetBaseVc.swift
//  Chainup
//
//  Created by liuxuan on 2019/4/28.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import UIKit

class EXAssetBaseVc: UIViewController {
    typealias AssetUpdateCallback = (EXCommonAssetModel) -> ()
    var onAssetupdate:AssetUpdateCallback?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func updatePrivacy() {
        
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
