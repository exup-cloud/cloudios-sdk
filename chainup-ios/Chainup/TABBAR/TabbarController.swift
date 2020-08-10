//
//  TabbarController.swift
//  AppProject
//
//  Created by zewu wang on 2018/7/31.
//  Copyright © 2018年 zewu wang. All rights reserved.
//

import UIKit

class TabbarController: UITabBarController {

    override  public func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(  animated)
        
        
    }
    
    override public func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
    }
    
    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public override var shouldAutorotate: Bool{
        return false
    }
    
    
    public override var supportedInterfaceOrientations: UIInterfaceOrientationMask{
        return UIInterfaceOrientationMask.portrait
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension UITabBarController{
    
    //获取所有tabbar的vc
    @objc func getAllTabVC() -> [UIViewController]{
        if self.viewControllers != nil{
            return self.viewControllers!
        }
        return []
    }
    
    //获取当前vc的位置
    func getVCIndex(_ vc : UIViewController) -> Int{
        let array = getAllTabVC()
        for i in 0..<array.count{
            if array[i].classForCoder == vc.classForCoder{
                return i
            }
        }
        //如果没有就找首页
        return 0
    }
    
    func selectIndexWith(_ vc : UIViewController){
        let index = getVCIndex(vc)
        selectIndex(index)
    }
    
    //选中某个tab
    func selectIndex(_ index : Int , showLogin : Bool = true){
        self.selectedIndex = index
        for view in (self.view.subviews){
            if view is TabbarView{
                (view as! TabbarView).changeItem(1000 + index)
            }
        }
    }
    
    //获取某个vc
    func getTabbarVC(_ index : Int) -> UIViewController{
        if let count = viewControllers?.count , let vc = viewControllers{
            if count > index{
                return vc[index]
            }else if count > 0{
                return vc[0]
            }
        }
        return UIViewController()
    }
    
    //获取当前的vc
    func getCurrentTabbarVC() -> UIViewController{
        let index = self.selectedIndex
        let vc = getTabbarVC(index)
        return vc
    }
}


