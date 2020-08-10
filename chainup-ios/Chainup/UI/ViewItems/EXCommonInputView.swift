//
//  EXCommonInputView.swift
//  Chainup
//
//  Created by liuxuan on 2019/5/16.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import UIKit

class EXCommonInputView: NibBaseView {

    @IBOutlet var input: EXTextField!
    
    func disableTouch() {
        input.isUserInteractionEnabled = false
    }

    override func onCreate() {
        input.enableTitleModel = true
    }
    
    func setTitle(_ text:String) {
        input.setTitle(title: text)
    }
    
    func setContent(_ content:String) {
        input.setText(text:content)
    }
    
    func setPlaceHolder(_ placeHoloder:String ) {
        input.setPlaceHolder(placeHolder: placeHoloder)
    }
    
}
