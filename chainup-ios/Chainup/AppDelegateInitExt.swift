//
//  AppDelegateInitExt.swift
//  AppProject
//
//  Created by zewu wang on 2018/7/31.
//  Copyright © 2018年 zewu wang. All rights reserved.
//

import UIKit

extension AppDelegate{

    func initTabbarV() -> UITabBarController{
        
        let asset = EXAssetsContainerVc.instanceFromStoryboard(name: StoryBoardNameAsset)
       
        let viewContrllers = [EXHomeVC(),SLSwapVc(),asset]
        
//        viewContrllers = [contractVc]
        //系统的
        let tabbarController = TabbarController()
        tabbarController.tabBar.isHidden = true
        tabbarController.selectedIndex = 0
        tabbarController.viewControllers = viewContrllers
        
        let tabbarView = TabbarView(tabbarController)
        tabbarView.backgroundColor = UIColor.ThemeTab.bg
        tabbarController.view.addSubview(tabbarView)
        tabbarView.frame = CGRect.init(x: 0, y: SCREEN_HEIGHT - TABBAR_HEIGHT, width: SCREEN_WIDTH, height: TABBAR_HEIGHT)
        return tabbarController
    }
    
    func initNavBarV() -> UINavigationController{
        let navBar = NavController()
        let tabbar = initTabbarV()
        navBar.isNavigationBarHidden = true
        navBar.viewControllers = [tabbar]
        navController = navBar
        return navBar
    }
    
    func initWindow() -> UIWindow{
        let nav = initNavBarV()
        let window = UIWindow(frame: UIScreen.main.bounds)
        //TODO: 这个颜色不确定是干啥的
        window.backgroundColor = UIColor.white
        window.rootViewController = nav
       // window.rootViewController = EXJsWebViewController()
        window.makeKeyAndVisible()
        return window
    }
    
}
