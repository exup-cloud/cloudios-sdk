//
//  EXDrawerVC.swift
//  Chainup
//
//  Created by zewu wang on 2019/4/1.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import UIKit

let dr_Width = 250 / 375 * SCREEN_WIDTH

class EXDrawerVC: UIViewController {
    
    typealias PullBlock = () -> ()
    var pullBlock : PullBlock?
    
    //背景
    lazy var backView : UIView = {
        let view = UIView()
        view.extUseAutoLayout()
        view.backgroundColor = UIColor.extColorWithHex("000000", alpha: 0.2)
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(pullAnimation))
        view.addGestureRecognizer(tap)
        return view
    }()
    
    //抽屉背景
    lazy var drawerV : UIView = {
        let view = UIView.init(frame: CGRect.init(x: -dr_Width, y: 0, width: dr_Width, height: SCREEN_HEIGHT))
        return view
    }()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.view.addSubViews([backView,drawerV])
        backView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        //导航控制器根控制器禁止左滑 否则 左滑 易出现卡顿现象
        let screenPan = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(rightSliderScreen))
        screenPan.edges = UIRectEdge.left
        self.view.addGestureRecognizer(screenPan)
        
    }
    
    @objc open func rightSliderScreen(_ pan : UIScreenEdgePanGestureRecognizer){
        //do nothing
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //设置抽屉的位置
    private func makeDrawerV(_ push : Bool){
        if push == true{
            drawerV.frame = CGRect.init(x: 0, y: 0, width: dr_Width, height: SCREEN_HEIGHT)
        }else{
            drawerV.frame = CGRect.init(x: -dr_Width, y: 0, width: dr_Width, height: SCREEN_HEIGHT)
        }
    }
    
    //推出动画
    func pushAnimation(){
        self.view.isUserInteractionEnabled = false
        UIView.animate(withDuration: 0.3, animations: {
            self.makeDrawerV(true)
        }) { (b) in
            if b == true{
                self.view.isUserInteractionEnabled = true
            }
        }
    }
    
    //收回动画
    @objc func pullAnimation(){
        self.view.isUserInteractionEnabled = false
        UIView.animate(withDuration: 0.3, animations: {
             self.makeDrawerV(false)
        }) { (b) in
            if b == true{
                self.view.removeFromSuperview()
                self.removeFromParentViewController()
                self.pullBlock?()
            }
        }
    }
    
    //添加到window
    private func addWindow(){
        guard let appDelegate = UIApplication.shared.delegate else {
            return
        }
        for vc in appDelegate.window??.rootViewController?.childViewControllers ?? []{
            if vc.classForCoder == EXDrawerVC.classForCoder(){
                return
            }
        }
        appDelegate.window??.rootViewController?.addChildViewController(self)
        appDelegate.window??.rootViewController?.view.addSubview(self.view)
    }
    
}

extension EXDrawerVC{
    
    //如果是view 用这个方法
    func addView(_ view : UIView){
        view.extUseAutoLayout()
        drawerV.addSubview(view)
        view.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        addWindow()
        pushAnimation()
    }
    
    //如果是vc 用这个方法
    func addVC(_ vc : UIViewController){
        addChildViewController(vc)
        addView(vc.view)
    }
    
}
