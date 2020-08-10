//
//  EXCoinWithDrawEmptyTagView.swift
//  Chainup
//
//  Created by liuxuan on 2019/5/9.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import UIKit

class EXCoinWithDrawEmptyTagView: NibBaseView {
    @IBOutlet var tagView: EXTextField!
    
    override func onCreate() {
        tagView.setPlaceHolder(placeHolder: "withdraw_tip_tagEmpty".localized())
    }

    func setEmpty() {
        tagView.setText(text: "")
    }
}
