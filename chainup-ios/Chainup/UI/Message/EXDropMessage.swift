//
//  EXDropMessage.swift
//  Chainup
//
//  Created by liuxuan on 2019/3/9.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import UIKit

class EXDropMessage: NibBaseView {
    
    @IBOutlet private var messageLabel: UILabel!
    @IBOutlet var bgView: UIView!
    
    
    var messageType:DropMessageType = .success {
        didSet {
            switch messageType {
            case .success:
                bgView.backgroundColor = UIColor.ThemeState.normal80
                break
            case .fail:
                bgView.backgroundColor = UIColor.ThemeState.fail80
                break
            case .warning:
                bgView.backgroundColor = UIColor.ThemeState.warning80
                break
            }
        }
    }
    
    var message:String = ""{
        didSet {
            messageLabel.text = message
        }
    }
    
    override func onCreate() {
        
    }
    
}
