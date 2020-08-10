//
//  PageWheelView.swift
//  Chainup
//
//  Created by zewu wang on 2018/11/6.
//  Copyright © 2018 zewu wang. All rights reserved.
//  轮播图

import UIKit

let pagewheelHeight = SCREEN_WIDTH / 375 * 234//轮播图高度

let pagewheelrect : CGRect = {
    var cg : CGRect = CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: pagewheelHeight)
    if EXHomeViewModel.status() == .three{
         cg = CGRect.init(x: 15, y: 0, width: SCREEN_WIDTH - 30, height: SCREEN_WIDTH / 375 * 60)
    }
    return cg
}()

class PageWheelView: UIView {
    
    var timer : Timer?
    
    var rowDatas : [CmsAppAdvertEntity] = [CmsAppAdvertEntity()]//数据源
    
    var index = 0
    
    lazy var collectionV : UICollectionView = {
        let collectionV = UICollectionView.init(frame: pagewheelrect , collectionViewLayout: getCollectionLayout())
        collectionV.showsHorizontalScrollIndicator = false
        collectionV.backgroundColor = UIColor.ThemeView.bg
//        collectionV.extUseAutoLayout()
        collectionV.isPagingEnabled = true
        collectionV.register(PageWheelVCV.classForCoder(), forCellWithReuseIdentifier: "PageWheelVCV")
        collectionV.delegate = self
        collectionV.bounces = false
        collectionV.dataSource = self
        collectionV.backgroundColor = UIColor.ThemeView.bg
        return collectionV
    }()
    
    func getCollectionLayout() -> UICollectionViewFlowLayout{
        let collectionLayout = UICollectionViewFlowLayout.init()
        collectionLayout.scrollDirection = .horizontal
        collectionLayout.minimumLineSpacing = 0
        collectionLayout.itemSize = CGSize.init(width: pagewheelrect.width, height: pagewheelrect.height)
        return collectionLayout
    }
    
    //指示器
    lazy var pageControl : EXPageControl = {
        let pageControl = EXPageControl()
        pageControl.extUseAutoLayout()
        pageControl.isHidden = true
        pageControl.isUserInteractionEnabled = false
        pageControl.unselectColor = UIColor.ThemePageControl.bannerUnselect.withAlphaComponent(0.5)
        pageControl.selectColor = UIColor.ThemePageControl.bannerSelect
        pageControl.numberOfPages = rowDatas.count
        return pageControl
    }()
    
    //数字指示器
    lazy var numControl : EXHomePageNumControl = {
        let numControl = EXHomePageNumControl()
        numControl.extUseAutoLayout()
        numControl.isHidden = true
        return numControl
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(collectionV)
        addSubViews([pageControl,numControl])
        pageControl.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-10)
            make.height.equalTo(2)
            make.left.right.equalToSuperview()
        }
        numControl.snp.makeConstraints { (make) in
            make.height.equalTo(23)
            make.width.equalTo(21)
            make.right.bottom.equalToSuperview().offset(-15)
        }
//        collectionV.snp.makeConstraints { (make) in
//            make.edges.equalToSuperview()
//        }
        if EXHomeViewModel.status() == .one{
            pageControl.isHidden = false
        }else if EXHomeViewModel.status() == .two{
            numControl.isHidden = false
        }else if EXHomeViewModel.status() == .three{
            
        }
    }
    
    func setView(_ entity : HomeEntity){
        let arr = entity.cmsAppAdvertList
        if arr.count > 0{
            rowDatas = arr
            collectionV.reloadData()
            if arr.count > 1{
                if let f = arr.first{
                    rowDatas.append(f)
                }
                if let l = arr.last{
                    rowDatas.insert(l, at: 0)
                }
//                collectionV.scrollToItem(at: IndexPath.init(row: 1, section: 0), at: UICollectionViewScrollPosition.left, animated: false)
                initTimer()
            }
            pageControl.numberOfPages = arr.count
        }else{
            rowDatas = [CmsAppAdvertEntity()]
            self.collectionV.reloadData()
            stopTimer()
        }
    }
    
    //开始定时器
    func startTimer(_ t : TimeInterval = 2){
        timer?.fireDate = Date.init(timeIntervalSinceNow: t)
    }
    
    func initTimer(){
        if timer != nil{
            timer?.invalidate()
            timer = nil
        }
        timer = Timer.init(timeInterval: 5, repeats: true, block: {[weak self] (timer) in
            guard let mySelf = self else{return}
            if timer == mySelf.timer{
                mySelf.index = mySelf.index + 1
                if mySelf.collectionV.numberOfItems(inSection: 0) <= mySelf.index{//容错，如果大于了，则滑到显示的第一个
                     mySelf.collectionV.scrollToItem(at: IndexPath.init(item: 1 , section: 0), at: UICollectionViewScrollPosition.left, animated: true)
                }else{
                    mySelf.collectionV.scrollToItem(at: IndexPath.init(item: mySelf.index , section: 0), at: UICollectionViewScrollPosition.left, animated: true)
                }
            }
        })
        RunLoop.main.add(timer!, forMode: RunLoopMode.commonModes)
    }
    
    //暂停定时器
    func pasueTimer(){
        timer?.fireDate = Date.distantFuture
    }
    
    //停止定时器
    func stopTimer(){
        if timer != nil{
            timer?.invalidate()
            timer = nil
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension PageWheelView : UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return rowDatas.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let entity = rowDatas[indexPath.row]
        let cell : PageWheelVCV = collectionView.dequeueReusableCell(withReuseIdentifier: "PageWheelVCV", for: indexPath) as! PageWheelVCV
        cell.tag = 1000 + indexPath.row
        cell.setCell(entity)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let entity = rowDatas[indexPath.row]
        HomeGOTO().gotoVC(self.yy_viewController, tnativeUrl: entity.nativeUrl, httpUrl: entity.httpUrl)
    }
    
}

extension PageWheelView : UIScrollViewDelegate{
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        //开始拖拽，暂停定时器
        self.pasueTimer()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        //停止拖拽，恢复定时器
        self.startTimer()
    }
    
    //监听手动减速完成
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let offsetx : CGFloat = scrollView.contentOffset.x
        let page : Int = Int(offsetx/pagewheelrect.width)
        index = page
        if page == 0{//滑到了第一页
            index = rowDatas.count - 2
            collectionV.contentOffset = CGPoint.init(x: CGFloat(index) * pagewheelrect.width, y: 0)
            pageControl.currentPage = pageControl.numberOfPages
        }else if page >= rowDatas.count - 1{//滑到了最后一页
            index = 1
            collectionV.contentOffset = CGPoint.init(x: CGFloat(index) * pagewheelrect.width, y: 0)
            pageControl.currentPage = 0
        }else{
            pageControl.currentPage = page - 1
        }
        numControl.setView("\(index)")
    }
    
    //滚动动画结束
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        scrollViewDidEndDecelerating(scrollView)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
    }
}

class EXHomePageNumControl : UIView{
    
    lazy var imgV : UIImageView = {
        let imgV = UIImageView()
        imgV.extUseAutoLayout()
        imgV.image = UIImage.themeImageNamed(imageName: "banner_control")
        return imgV
    }()
    
    lazy var numLabel : UILabel = {
        let label = UILabel()
        label.extUseAutoLayout()
        label.layoutIfNeeded()
        label.text = "1"
        label.textAlignment = .center
        label.font = UIFont.ThemeFont.SecondaryRegular
        label.textColor = UIColor.ThemePageControl.bannerUnselect
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubViews([imgV,numLabel])
        imgV.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        numLabel.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.height.equalTo(14)
        }
    }
    
    func setView(_ num : String){
        numLabel.text = num
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

class EXPageControl : UIView{
    
    var currentPage = 0
    {
        didSet{
            setView()
        }
    }
    
    var numberOfPages = 0
    {
        didSet{
            addView()
        }
    }
    
    var unselectColor = UIColor.clear
    
    var selectColor = UIColor.clear
    
    var pageArr : [UIView] = []
    
    lazy var backView : UIView = {
        let view = UIView()
        view.extUseAutoLayout()
        view.backgroundColor = UIColor.clear
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(backView)
    }
    
    func addView(){
        var arr : [UIView] = []
        backView.clearSubViews()//移除所有的子视图
        for i in 0..<numberOfPages{
            let view = UIView()
            view.extUseAutoLayout()
            backView.addSubview(view)
            view.snp.makeConstraints { (make) in
                make.left.equalToSuperview().offset(i * 15)
                make.height.equalTo(2)
                make.width.equalTo(15)
                make.top.equalToSuperview()
            }
            arr.append(view)
        }
        pageArr = arr
        backView.snp.remakeConstraints { (make) in
            make.centerX.top.bottom.equalToSuperview()
            make.width.equalTo(numberOfPages * 15)
        }
        setView()
    }
    
    func setView(){
        for i in 0..<pageArr.count{
            if currentPage == i {
                pageArr[i].backgroundColor = selectColor
            }else{
                pageArr[i].backgroundColor = unselectColor
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
