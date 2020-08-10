//
//  NibBaseView.swift
//  Chainup
//
//  Created by liuxuan on 2019/1/10.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import UIKit

class NibBaseView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.privateOnCreate()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.privateOnCreate()
    }
    
    private func privateOnCreate(){
        
        let name = String(describing:type(of:self))
        let nibView = UINib.init(nibName: name, bundle: nil).instantiate(withOwner: self, options: nil).first as! UIView
        
//        nibView.translatesAutoresizingMaskIntoConstraints = false
        self .addSubview(nibView)
        nibView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        self.onCreate()
    }
    
    override func layoutSubviews() {
        self.setNeedsDisplay()
    }
    public func onCreate(){
    
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
