//
//  HomeRecommendedV.swift
//  Chainup
//
//  Created by zewu wang on 2019/3/13.
//  Copyright © 2019 zewu wang. All rights reserved.
//  首页推荐币对

import UIKit

class HomeRecommendedV: UIView {
    
    typealias ClickBlock = () -> ()
    var clickBlock : ClickBlock?
    var userSymbolsVM = UserSymbolsVM()
    var recommendedArray : [HomeRecommendedEntity] = []
    
    var collectionArray : [HomeRecommendedEntity] = []
    {
        didSet{
            self.addBtn.isEnabled = collectionArray.count > 0
        }
    }

    var timer : Timer?
    
    lazy var collectionV : UICollectionView = {
        let collectionV = UICollectionView.init(frame: CGRect.init(x: 15.5, y: 20, width: SCREEN_WIDTH - 31, height: 211) , collectionViewLayout: getCollectionLayout())
        //        collectionV.collectionViewLayout.invalidateLayout()
        collectionV.showsHorizontalScrollIndicator = false
        collectionV.showsVerticalScrollIndicator = false
        collectionV.register(HomeRecommendedCC.classForCoder(), forCellWithReuseIdentifier: "HomeRecommendedCC")
        collectionV.delegate = self
        collectionV.dataSource = self
        collectionV.backgroundColor = UIColor.ThemeView.bg
        return collectionV
    }()
    
    func getCollectionLayout() -> UICollectionViewFlowLayout{
        let width = (SCREEN_WIDTH - 57) / 3
        let collectionLayout = UICollectionViewFlowLayout.init()
        collectionLayout.scrollDirection = .vertical
        collectionLayout.minimumLineSpacing = 15
        collectionLayout.minimumInteritemSpacing = 13
//        collectionLayout.estimatedItemSize = CGSize.init(width: width, height: 98)
        collectionLayout.itemSize = CGSize.init(width: width, height: 98)
        return collectionLayout
    }
    
    lazy var addBtn : EXButton = {
        let btn = EXButton()
        btn.extUseAutoLayout()
        btn.isEnabled = false
        btn.extSetCornerRadius(1.5)
        btn.backgroundColor = UIColor.ThemeBtn.highlight
        btn.extSetAddTarget(self, #selector(clickAddBtn))
        btn.setTitle(LanguageTools.getString(key: "home_action_fastAdd"), for: UIControlState.normal)
        return btn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(collectionV)
        addSubview(addBtn)
        backgroundColor = UIColor.ThemeView.bg
        addBtn.snp.makeConstraints { (make) in
            make.top.equalTo(collectionV.snp.bottom).offset(40)
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.height.equalTo(44)
        }
        
        if timer != nil{
            timer?.invalidate()
            timer = nil
        }

        timer = Timer.init(timeInterval: 60, repeats: true, block: {[weak self](timer1) in
            if timer1 == self?.timer{
                self?.getRecommended()
            }
        })
        RunLoop.main.add(timer!, forMode: RunLoopMode.commonModes)
        
        getRecommended()
    }
    
    //收藏
    @objc func clickAddBtn(){
        var names = [String]()
        for entity in self.collectionArray{
            names.append(entity.symbol)
            XUserDefault.collectionCoinMap(entity.name)
        }
        //一件添加功能同步到线上
        
        let symbols = names.joined(separator: ",")
        userSymbolsVM.handSysmbols(operationType: "0", symbols: symbols)
        
        clickBlock?()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //获取推荐币种
    func getRecommended(){
        let server = EXNetworkDoctor.sharedManager.getAppAPIHost()
        let url = NetManager.sharedInstance.url(server, model: NetDefine.common, action: NetDefine.header_symbol)
        NetManager.sharedInstance.sendRequest(url, parameters: [:] , mothed: .get, isShowLoading : false  , success: {[weak self] (result, response, nil) in
            guard let mySelf = self else{return}
            if let result = result as? [String : Any]{
                if let data = result["data"] as? [[String : Any]]{
                    var arr : [HomeRecommendedEntity] = []
                    for dic in data{
                        let entity = HomeRecommendedEntity()
                        entity.setEntityWithDict(dic)
                        if entity.name != ""{
                            arr.append(entity)
                        }
                    }
                    if arr.count > 6{
                        mySelf.recommendedArray = [] + arr.prefix(upTo: 6)
                        mySelf.collectionArray = [] + arr.prefix(upTo: 6)
                    }else{
                        mySelf.recommendedArray = arr
                        mySelf.collectionArray = arr
                    }
                    mySelf.collectionV.reloadData()
                }
            }
        }, fail: { (state, error, nil) in
            
        })
    }
    
}

extension HomeRecommendedV : UICollectionViewDelegate,UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recommendedArray.count > 6 ? 6 : recommendedArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let entity = self.recommendedArray[indexPath.row]
        let cell : HomeRecommendedCC = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeRecommendedCC", for: indexPath) as! HomeRecommendedCC
        cell.setCell(entity)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? HomeRecommendedCC{
            if collectionArray.contains(cell.entity){
                if let index = collectionArray.index(of: cell.entity){
                    collectionArray.remove(at: index)
                    cell.checkMarkView.checked = false
                }
            }else{
                collectionArray.append(cell.entity)
                cell.checkMarkView.checked = true
            }
        }
    }
    
}
