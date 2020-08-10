//
//  TabbarView.swift
//  AppProject
//
//  Created by zewu wang on 2018/7/31.
//  Copyright © 2018年 zewu wang. All rights reserved.
//

import UIKit

class TabbarView: UIView {
    
    var tabbarModel = TabbarModels()
    
    var tabbarItemModel : [TabbarModel] = []

    var tabbarcontroller : UITabBarController?//真实的tabbar
    
    //顶部的线
    lazy var topLine : UIView = {
        let view = UIView()
        view.extUseAutoLayout()
        view.backgroundColor = UIColor.ThemeView.seperator
        return view
    }()
    
    public init(_ tabbarcontroller : UITabBarController){
        super.init(frame: CGRect.zero)
        setTabbarItemModel()
        self.tabbarcontroller = tabbarcontroller
        setTabbarItem()
        _ = LanguageBase.getSubjectAsobsever().subscribe({[weak self] (event) in
            guard let mySelf = self else {return}
            mySelf.reloadTabbarItem()
        })
        addSubview(topLine)
        topLine.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(0.5)
        }
        PublicInfo.sharedInstance.subject.asObserver().subscribe {[weak self] (i) in
            guard let mySelf = self else{return}
            mySelf.reloadTabbarItem()
            }.disposed(by: disposeBag)
    }
    
    func setTabbarItemModel(){

        tabbarItemModel = [tabbarModel.homeModel,tabbarModel.contractModel,tabbarModel.assetModel]
    }
    
    //MARK:设置tabbar的视图
    public func setTabbarItem(){
        guard let count = self.tabbarcontroller?.viewControllers?.count else{return}
        if count <= 5{
            let width = SCREEN_WIDTH / CGFloat(count)
            for i in 0..<count{
                initTabbarItem(i, width: width)
            }
        }else{
            let width = SCREEN_WIDTH / 5
            for i in 0..<5{
               initTabbarItem(i, width: width)
            }
        }
    }
    
    //MARK:添加tabbar的item
    func initTabbarItem(_ tag : Int , width : CGFloat){
        let tabbarItem = TabbarItem()
        tabbarItem.tag = tag + 1000
        tabbarItem.setImageAndLabel(tabbarItemModel[tag])
        addSubview(tabbarItem)
        tabbarItem.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(self)
            make.left.equalTo(width * CGFloat((tag)))
            make.width.equalTo(width)
        }
        
        if tag == self.tabbarcontroller?.selectedIndex{
            tabbarItem.subject.onNext(true)
        }
        
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(clickTabbarItem))
        tap.numberOfTapsRequired = 1
        tabbarItem.addGestureRecognizer(tap)
    }

    @objc func reloadTabbarItem(){
        for view in subviews{
            if view is TabbarItem{
                view.removeFromSuperview()
            }
        }
        tabbarModel = TabbarModels()
        setTabbarItemModel()
        setTabbarItem()
    }
    
    //MARK:点击tabbarItem
    @objc func clickTabbarItem(_ tap : UITapGestureRecognizer){
        if let view = tap.view as? TabbarItem{
            let vc = self.tabbarcontroller?.getTabbarVC(view.tag - 1000)
            if vc is EXAssetsContainerVc{
                if XUserDefault.getToken() == nil{
                    BusinessTools.modalLoginVC()
                    return
                }
            }
            self.tabbarcontroller?.selectIndex(view.tag - 1000)
        }
    }
    
    //MARK:改变item
    func changeItem(_ tag : Int){
        for subview in self.subviews{
            if let v = subview as? TabbarItem{
                v.subject.onNext(v.tag == tag)
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
