//
//  RecommendedView.swift
//  Chainup
//
//  Created by zewu wang on 2018/11/6.
//  Copyright © 2018 zewu wang. All rights reserved.
//  推荐页

import UIKit

class RecommendedView: UIView {
    
    var rowDatas : [HomeRecommendedEntity] = []
    
    lazy var collectionCCSize : (CGFloat,CGFloat) = {
        if EXHomeViewModel.status() == .one{
            return (160,80)
        }else if EXHomeViewModel.status() == .two{
            return (129,146)
        }
        return (0,0)
    }()
    lazy var collectionV : UICollectionView = {
        let collectionV = UICollectionView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: collectionCCSize.1) , collectionViewLayout: getCollectionLayout())
        collectionV.showsHorizontalScrollIndicator = false
        collectionV.backgroundColor = UIColor.ThemeView.bg
//        collectionV.extUseAutoLayout()
        collectionV.register(RecommendCVC.classForCoder(), forCellWithReuseIdentifier: "RecommendCVC")
        collectionV.delegate = self
        collectionV.dataSource = self
        collectionV.backgroundColor = UIColor.ThemeView.bg
        return collectionV
    }()
    
    func getCollectionLayout() -> UICollectionViewFlowLayout{
        let collectionLayout = UICollectionViewFlowLayout.init()
        collectionLayout.scrollDirection = .horizontal
        collectionLayout.minimumLineSpacing = 0
        collectionLayout.itemSize = CGSize.init(width: collectionCCSize.0, height: collectionCCSize.1)
        return collectionLayout
    }
    
    lazy var bottomV : UIView = {
        let view = UIView()
        view.extUseAutoLayout()
        view.backgroundColor = UIColor.ThemeNav.bg
        return view
    }()
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.ThemeView.bg
        addSubViews([collectionV,bottomV])
        bottomV.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(collectionV.snp.bottom)
            make.height.equalTo(10)
        }
//        collectionV.snp.makeConstraints { (make) in
//            make.edges.equalToSuperview()
//        }
    }
    
    func setView(_ arr : [HomeRecommendedEntity]){
        rowDatas = arr
        collectionV.reloadData()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension RecommendedView :  UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return rowDatas.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let entity = rowDatas[indexPath.row]
        let cell : RecommendCVC = collectionView.dequeueReusableCell(withReuseIdentifier: "RecommendCVC", for: indexPath) as! RecommendCVC
        cell.setCell(entity)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let entity = rowDatas[indexPath.row]
//        let vc = EXMarketDetailVc.instanceFromStoryboard(name: StoryBoardNameMarket)
//        let coinmapentity = PublicInfoManager.sharedInstance.getCoinMapInfo(entity.name)
//        vc.entity = coinmapentity
//        self.yy_viewController?.navigationController?.pushViewController(vc, animated: true)
    }
    
} 
