//
//  EXToDoListView.swift
//  Chainup
//
//  Created by liuxuan on 2019/4/10.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import UIKit

class EXToDoListView: NibBaseView {
    @IBOutlet var icon: UIImageView!
    @IBOutlet var title: UILabel!
    var isDone:Bool = false {
        didSet {
            self.udpateState()
        }
    }
    
    override func onCreate() {

    }
    
    func udpateState() {
        if isDone {
            icon.image = UIImage.themeImageNamed(imageName: "fiat_complete")
        }else {
            icon.image = UIImage.themeImageNamed(imageName: "fiat_unfinished")
        }
    }


}
