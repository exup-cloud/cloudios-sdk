//
//  UIViewExtension.swift
//  SDJG
//
//  Created by 王俊 on 16/4/18.
//  Modify  by 王俊 on 17/6/5. swift3.0
//  Copyright © 2016年 sunlands. All rights reserved.
//

import UIKit

public enum BTShakeDirection: Int {
      case horizontal
      case vertical
}

extension UIView
{
    
    /**
     开启自动布局
     */
    public final func extUseAutoLayout(){
//        self.extSetBorderWidth(1, color: UIColor.green)
        self.translatesAutoresizingMaskIntoConstraints = false
        
    }
    
    /**
     设置圆角
     
     - parameter radius: 圆角半径 必须
     */
    public final func extSetCornerRadius(_ radius : CGFloat ){
        
        
        self.layer.masksToBounds = true
        self.layer.cornerRadius = radius
        
    }
    
    /**
    设置视图边框以及颜色
    
    - parameter w:     边框大小 必须
    - parameter color: 颜色 必须
    */
    public final func extSetBorderWidth(_ width : CGFloat , color : UIColor){
        
        self.layer.borderWidth = width
        self.layer.borderColor = color.cgColor
        
    }
    
    /**
     设置阴影 - 颜色 偏移 透明度
     
     - parameter color:        颜色
     - parameter shadowOffset: 偏移量
     - parameter opacity:      透明度
     */
    public final func extSetShadowColor(_ color : UIColor , shadowOffset : CGSize , opacity : Float){
        
        self.layer.shadowOffset = shadowOffset;
        self.layer.shadowColor = color.cgColor;
        self.layer.shadowOpacity = opacity
        self.layer.shadowRadius = 1;
        
    }
    
    /**
     获取视图宽
     
     - returns: 获取视图宽
     */
    public final func ext_width() -> CGFloat {
        return self.frame.width
    }
    
    /**
     获取视图高
     
     - returns: 获取视图高
     */
    public final func ext_height() -> CGFloat {
        return self.frame.height
    }
    
    /**
     获取视图  y坐标值
     
     - returns: y坐标值
     */
    public final func ext_top() -> CGFloat {
        return self.frame.minY
    }
    
    /**
     获取视图 y坐标值+高度的数值
     
     - returns: y坐标值+高度的数值
     */
    public final func ext_bottom() -> CGFloat {
        return self.frame.maxY
    }
    
    /**
     获取视图x坐标值
     
     - returns: x坐标值
     */
    public final func ext_left() -> CGFloat {
        return self.frame.minX
    }
    
    /**
     获取视图 x坐标值+宽度的数值
     
     - returns: x坐标值+宽度的数值
     */
    public final func ext_right() -> CGFloat {
        return self.frame.maxX
    }
    
    /**
     弹出模态视图控制器
     
     - parameter vc:              控制器
     - parameter backgroundColor: 背景色 可不传 有默认值
     - parameter animated:        是否动画 可不传 有默认值 默认无动画
     */
    public final func extShowModalVC(_ vc :UIViewController , backgroundColor :UIColor = UIColor.extRGBA(red: 66.0, green: 66.0, blue: 66.0, alpha: 0.4) , animated :Bool = false){
        
        guard let appDelegate = UIApplication.shared.delegate else {
            return
        }
        
        vc.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        
        if appDelegate.window != nil   {
         
            appDelegate.window??.rootViewController!.present(vc, animated: animated, completion: {
                
                //背景色 透明
                vc.view.backgroundColor  = backgroundColor
                
            })
            
        }
        
    }
    
    /**
     截图（超长视图）
     - parameter scrollView: 滚动视图scrollView tableView collectionView wkwebView.scrollView
     - parameter snapWidth: 截取宽度
     - parameter completion: 截图完成的回调
     */
    public func captureImage(_ scrollView: UIScrollView, snapWidth: CGFloat = UIScreen.main.bounds.size.width, completion: @escaping ((UIImage) -> Void)) {
        
        let savedFrame = self.frame
        let savedSize = savedFrame.size
        let maxSize = scrollView.contentSize
        var newWidth = snapWidth
        if newWidth < maxSize.width {
            newWidth = maxSize.width
        }
        let newHeight = newWidth * maxSize.height / maxSize.width
        let totalBounds = CGRect(origin: CGPoint.zero, size: CGSize(width: newWidth, height: newHeight))
        
        guard maxSize.height > savedSize.height || maxSize.width > savedSize.width else {
            // 单屏视图
            self.snapShotArea(rect: totalBounds, completion: completion)
            return
        }
        
        if let temperView = self.snapshotView(afterScreenUpdates: true) {
            
            let savedOffset = scrollView.contentOffset
            temperView.frame = CGRect(x: savedFrame.origin.x, y: savedFrame.origin.y, width: temperView.frame.size.width, height:  temperView.frame.size.height)
            self.superview?.addSubview(temperView)
            
            if savedSize.height < maxSize.height {
                scrollView.contentOffset = CGPoint(x: 0, y: maxSize.height-savedSize.height)
            }
            scrollView.contentOffset = CGPoint.zero
            self.snapShotArea(rect: totalBounds, completion: { (img) in
                completion(img)
                scrollView.contentOffset = savedOffset
                temperView.removeFromSuperview()
            })
        }
    }
    
    /**
     截图（单屏视图）
     - parameter rect: 截取尺寸
     - parameter completion: 截图完成的回调
     */
    public func snapShotArea(rect: CGRect, completion: @escaping ((UIImage) -> Void)) {
        let scale = UIScreen.main.scale
        var newRect = rect
        var newSize = rect.size
        if scale == 0.0 {
            
        } else {
            newSize.width = newSize.width * scale
            newSize.height = newSize.height * scale
            newRect.size = newSize
        }
        
        let bakFrame = self.frame
        self.frame = rect
        UIGraphicsBeginImageContextWithOptions(newSize, false, scale)
        
        let t = DispatchTime.now() + 0.3
        DispatchQueue.main.asyncAfter(deadline: t) {
            // 这里必须延迟绘制才能获得超长视图全部内容
            for subview in self.subviews {
                subview.drawHierarchy(in: subview.bounds, afterScreenUpdates: true)
            }
            var capturedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            if let ref = capturedImage?.cgImage?.cropping(to: newRect) {
                capturedImage = UIImage.init(cgImage: ref)
            }
            if capturedImage != nil {
                completion(capturedImage!)
            }
            self.frame = bakFrame
        }
    }
    
    /**
     Get the view's screen shot, this function may be called from any thread of your app.
     
     - returns: The screen shot's image.
     */
    func screenShot() -> UIImage? {
        
        guard frame.size.height > 0 && frame.size.width > 0 else {
            
            return nil
        }
        
        UIGraphicsBeginImageContextWithOptions(frame.size, false, 0)
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
    
    func screenShotwithFrame(_ frame : CGRect) -> UIImage? {
        
        guard frame.size.height > 0 && frame.size.width > 0 else {
            
            return nil
        }
        
        UIGraphicsBeginImageContextWithOptions(frame.size, false, 0)
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
    
    //MARK:添加view到self.view上，传个数组即可
    public func addSubViews(_ views : [UIView]){
        for view in views{
            self.addSubview(view)
        }
    }
    
    func convertViewToImage(_ view : UIView) -> UIImage{
        
        UIGraphicsBeginImageContext(view.bounds.size)
        
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, UIScreen.main.scale);
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
        
    }
    
//    //MARK:某个边添加边框
//    public func extBorderWithView(top : (Bool,CGFloat) = (false,0) ,bottom :  (Bool,CGFloat) = (false,0) ,left : (Bool,CGFloat) = (false,0) , right :  (Bool,CGFloat) = (false,0) , cgColor : CGColor = UIColor.clear.cgColor , borderWidth : CGFloat = 0){
//
//        if top.0{
//            let layer = CALayer()
//            layer.frame = CGRect.init(x: 0, y: 0, width: top.1, height: borderWidth)
//            layer.backgroundColor = cgColor
//            self.layer.addSublayer(layer)
//        }
//        if bottom.0{
//            let layer = CALayer()
//            layer.frame = CGRect.init(x: 0, y: 0, width: top.1, height: borderWidth)
//            layer.backgroundColor = cgColor
//            self.layer.addSublayer(layer)
//        }
//        if left.0{
//            let layer = CALayer()
//            layer.frame = CGRect.init(x: 0, y: 0, width: top.1, height: borderWidth)
//            layer.backgroundColor = cgColor
//            self.layer.addSublayer(layer)
//        }
//        if right.0{
//            let layer = CALayer()
//            layer.frame = CGRect.init(x: 0, y: 0, width: top.1, height: borderWidth)
//            layer.backgroundColor = cgColor
//            self.layer.addSublayer(layer)
//        }
//
//    }
    
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        UIColor.clear.setFill()
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        path.fill()
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    
    /**
    删除所有的子视图
    */
    func clearSubViews(){
        if self.subviews.count > 0{
            self.subviews.forEach { (view) in
                view.removeFromSuperview()
            }
        }
    }
    
    /**
     设置渐变
     
     - parameter colors: 色值
     *  有了frame设置才成功不要使用masony布局
     */
    public final func setGradientlayerColors(_ colors : Array<CGColor> ){
        
        let layer = CAGradientLayer()
        layer.frame = bounds
        layer.colors = (colors)
        layer.startPoint = CGPoint(x: 0, y: 1)
        layer.endPoint = CGPoint(x: 0, y: 0)
        self.layer.addSublayer(layer)

    }
    
    // UIView——》image
     func getImageFromView(view: UIView) -> UIImage {
    // 下面方法，第一个参数表示区域大小。第二个参数表示是否是非透明的。如果需要显示半透明效果，需要传NO，否则传YES。第三个参数就是屏幕密度了
      UIGraphicsBeginImageContextWithOptions(view.size, false, UIScreen.main.scale)
      let context = UIGraphicsGetCurrentContext()
      view.layer.render(in: context!)
      let image = UIGraphicsGetImageFromCurrentImageContext()
      UIGraphicsEndImageContext()
      return image!
    }
    

  
    public func shake(direction: BTShakeDirection = .horizontal, times: Int = 5, interval: TimeInterval = 0.1, offset: CGFloat = 2, completion: (() -> Void)? = nil) {
               
               //移动视图动画（一次）
               UIView.animate(withDuration: interval, animations: {
                   switch direction {
                       case .horizontal:
                           self.layer.setAffineTransform(CGAffineTransform(translationX: offset, y: 0))
                       case .vertical:
                           self.layer.setAffineTransform(CGAffineTransform(translationX: 0, y: offset))
                   }
                   
               }) { (complete) in
                   //如果当前是最后一次抖动，则将位置还原，并调用完成回调函数
                   if (times == 0) {
                       UIView.animate(withDuration: interval, animations: {
                           self.layer.setAffineTransform(CGAffineTransform.identity)
                       }, completion: { (complete) in
                           completion?()
                       })
                   }
                   
                   //如果当前不是最后一次，则继续动画，偏移位置相反
                   else {
                       self.shake(direction: direction, times: times - 1, interval: interval, offset: -offset, completion: completion)
                   }
               }
           }
    

}
