//
//  SLSwapTableHeader.swift
//  Chainup
//
//  Created by KarlLichterVonRandoll on 2020/1/8.
//  Copyright © 2020 zewu wang. All rights reserved.
//

import Foundation

class SLSwapTableHeader: UIView {
    
    let toolBar: SLAssetToolBar = {
        let tool = SLAssetToolBar()
        return tool
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(toolBar)
        toolBar.frame = CGRect.init(x: 0, y: 0, width: self.width, height: self.height)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
