//
//  EXAccountTransferSelectorView.swift
//  Chainup
//
//  Created by liuxuan on 2019/5/15.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import UIKit

class EXAccountTransferSelectorView: NibBaseView {
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var iconView: UIImageView!
    @IBOutlet var tapBtn: UIButton!
    var accountType:EXAccountType?
    
    typealias SelectorDidTapCallback = () -> ()
    var onSelectorTapped:SelectorDidTapCallback?
    
    var enableTap:Bool = false {
        didSet {
            iconView.isHidden = !enableTap
        }
    }
    
    override func onCreate() {
        self.enableTap = false
        iconView.image = UIImage.themeImageNamed(imageName: "dropdown")
    }
    
    @IBAction func didTapped(_ sender: Any) {
        if enableTap {
            onSelectorTapped?()
        }
    }
    
}
