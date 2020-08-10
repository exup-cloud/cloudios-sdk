//
//  ImagePreviewVC.swift
//  ImagePreview
//
//  Created by zewu wang on 2018/10/19.
//  Copyright © 2018 zewu wang. All rights reserved.
//

import UIKit
import YYWebImage

enum ImagePreviewVCType {
    case urlString
    case image
}

//图片浏览控制器
class ImagePreviewVC: NavCustomVC {
    
    var copyType = "1"//是否有保存按钮
    
    var type = ImagePreviewVCType.urlString
    
    //保存按钮
    lazy var copyBtn : UIButton = {
        let btn = UIButton()
        btn.extUseAutoLayout()
        btn.extSetTitle("保存图片", 16, UIColor.ThemeView.highlight, UIControlState.normal)
        btn.extSetCornerRadius(2)
        btn.backgroundColor = UIColor.ThemeView.bg
        btn.extSetBorderWidth(1, color: UIColor.ThemeView.highlight)
        btn.extSetAddTarget(self, #selector(clickSaveQrCodeImgBtn))
        return btn
    }()
    
    //存储图片数组
    var images:[String] = []
    
    var imageimage:[UIImage] = []
    
    //默认显示的图片索引
    var index:Int = 0
    
    //用来放置各个图片单元
    var collectionView:UICollectionView!
    
    //collectionView的布局
    var collectionViewLayout: UICollectionViewFlowLayout!
    
    //页控制器（小圆点）
    var pageControl : UIPageControl!
    
//    //初始化
//    init(images:[String], index:Int = 0,){
//        self.images = images
//        self.index = index
//
//        super.init(nibName: nil, bundle: nil)
//    }
    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    //初始化
    override func viewDidLoad() {
        super.viewDidLoad()
        //背景设为黑色
        self.view.backgroundColor = UIColor.black
        
        //collectionView尺寸样式设置
        collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.minimumLineSpacing = 0
        collectionViewLayout.minimumInteritemSpacing = 0
        //横向滚动
        collectionViewLayout.scrollDirection = .horizontal
        
        //collectionView初始化
        collectionView = UICollectionView(frame: self.view.bounds,
                                          collectionViewLayout: collectionViewLayout)
        collectionView.backgroundColor = UIColor.black
        collectionView.register(ImagePreviewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPagingEnabled = true
        //不自动调整内边距，确保全屏
        if #available(iOS 11.0, *) {
            collectionView.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        self.view.addSubview(collectionView)
        
        if copyType == "1"{
            self.view.addSubview(copyBtn)
            
            copyBtn.snp.makeConstraints { (make) in
                make.centerX.equalToSuperview()
                make.bottom.equalToSuperview().offset(-30)
                make.height.equalTo(30)
                make.width.equalTo(100)
            }
            
        }
        
        //将视图滚动到默认图片上
        let indexPath = IndexPath(item: index, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .left, animated: false)
        
        //设置页控制器
        pageControl = UIPageControl()
        pageControl.isHidden = true
        pageControl.center = CGPoint(x: UIScreen.main.bounds.width/2,
                                     y: UIScreen.main.bounds.height - 20)
        if type == .urlString{
            pageControl.numberOfPages = images.count
        }else{
            pageControl.numberOfPages = imageimage.count
        }
        pageControl.isUserInteractionEnabled = false
        pageControl.currentPage = index
        view.addSubview(self.pageControl)
    }
    
    //视图显示时
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //隐藏导航栏
//        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.navCustomView.isHidden = true
    }
    
    //视图消失时
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //显示导航栏
//        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navCustomView.isHidden = false
    }
    
    //隐藏状态栏
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    //将要对子视图布局时调用（横竖屏切换时）
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        //重新设置collectionView的尺寸
        collectionView.frame.size = self.view.bounds.size
        collectionView.collectionViewLayout.invalidateLayout()
        
        //将视图滚动到当前图片上
        let indexPath = IndexPath(item: self.pageControl.currentPage, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .left, animated: false)
        
        //重新设置页控制器的位置
        pageControl.center = CGPoint(x: UIScreen.main.bounds.width/2,
                                     y: UIScreen.main.bounds.height - 20)
    }
    
    //MARK:点击保存二维码
    @objc func clickSaveQrCodeImgBtn(){
        if let cellV = collectionView.visibleCells[0] as? ImagePreviewCell{
            if let img = cellV.imageView.image{
                UIImageWriteToSavedPhotosAlbum(img, self, #selector(saveImg), nil)
                return
            }
        }
        
        ProgressHUDManager.showFailWithStatus(LanguageTools.getString(key: "save_fail"))
    }
    
    @objc func saveImg(image:UIImage,didFinishSavingWithError error:NSError?,contextInfo:AnyObject) {
        if error != nil{
            ProgressHUDManager.showFailWithStatus(LanguageTools.getString(key: "save_fail"))
            return
        }
        ProgressHUDManager.showSuccessWithStatus(LanguageTools.getString(key: "save_succcess"))
        //        alert.dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

//ImagePreviewVC的CollectionView相关协议方法实现
extension ImagePreviewVC:UICollectionViewDelegate, UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout{
    
    //collectionView单元格创建
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath)
        -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell",
                                                          for: indexPath) as! ImagePreviewCell
//            let image = UIImage(named: self.images[indexPath.row])
            if type == ImagePreviewVCType.urlString{
                if let url = URL.init(string: self.images[indexPath.row]){
                    cell.imageView.yy_setImage(with: url, options: YYWebImageOptions.allowBackgroundTask)
                }
            }else{
                cell.imageView.image = self.imageimage[indexPath.row]
            }
            
            cell.clickCellBlock = {[weak self]() in
                guard let mySelf = self else{return}
                mySelf.view.bringSubview(toFront: mySelf.navCustomView)
                mySelf.navCustomView.isHidden = !mySelf.navCustomView.isHidden
            }
            return cell
    }
    
    //collectionView单元格数量
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        if type == ImagePreviewVCType.urlString{
            return self.images.count
        }else{
            return self.imageimage.count
        }
    }
    
    //collectionView单元格尺寸
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return self.view.bounds.size
    }
    
    //collectionView里某个cell将要显示
    func collectionView(_ collectionView: UICollectionView,
                        willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        if let cell = cell as? ImagePreviewCell{
            //由于单元格是复用的，所以要重置内部元素尺寸
            cell.resetSize()
        }
    }
    
    //collectionView里某个cell显示完毕
    func collectionView(_ collectionView: UICollectionView,
                        didEndDisplaying cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        //当前显示的单元格
        let visibleCell = collectionView.visibleCells[0]
        //设置页控制器当前页
        self.pageControl.currentPage = collectionView.indexPath(for: visibleCell)!.item
    }
}
