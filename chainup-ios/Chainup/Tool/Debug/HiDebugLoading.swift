//
//  HiDebugLoading.swift
//  Chainup
//
//  Created by liuxuan on 2019/3/7.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import UIKit

class HiDebugLoading: UIView,LoadingAnimation,MarkCheckable {
    func setCheck(isCheck: Bool) {
        
    }
    
    
    internal lazy var checkMarkView : CheckMarkView = {
        let check =  CheckMarkView.init(style:.xMark, isChecked:true, presenter:self)
        return check
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        config()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        config()
    }
    
    
    func config(){
        self.addSubview(self.checkMarkView)
        self.checkMarkView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.right.equalToSuperview()
            make.width.height.equalTo(40)
        }
    }
    
    
    func isAnimating() {
        
    }
    
    func animationStopped() {
        
    }
    
    
    var activityIndicator: LoadingView  { get {return self.loading}}
    var loading = LoadingView.init(frame: CGRect(x: 0, y: 0, width: 50, height: 50))

    override func layoutSubviews() {
        super.layoutSubviews()
        self.showLoading(radius: 50)

    }

}
