//
//  SearchView.swift
//  AppProject
//
//  Created by zewu wang on 2018/8/6.
//  Copyright © 2018年 zewu wang. All rights reserved.
//

import UIKit

class SearchEntity: SuperEntity {
    var name = ""
    
    var img = ""
    
    var state = "0"
    
}

enum SearchType {
    case addCoinMap//添加币对
    case searchCoinMap//搜索币对
    case searchCoinMapCashflow//搜索流水币对
}

class SearchView: UIView {

    lazy var searchHeadV : SearchHeadV = {
        let view = SearchHeadV()
        view.clickCancelBlock = {[weak self] () in
            guard let mySelf = self else{return}
            mySelf.setTmpArray()
            mySelf.reloadSearchView(mySelf.tmpArray)
        }
        return view
    }()
    
    typealias ClickCellBlock = (SearchEntity) -> ()
    var clickCellBlock : ClickCellBlock?//点击cell的回调
    var tableViewRowDatas : [SearchEntity] = []
    
    var searchType = SearchType.addCoinMap
    
    typealias ClickCancelBtnBlock = () -> ()//点击取消按钮的回调
    var clickCancelBtnBlock : ClickCancelBtnBlock?
    
    var tmpArray : [SearchEntity] = []
    
    //搜索的背景
    lazy var topSearchView : UIView = {
        let view = UIView()
        view.extUseAutoLayout()
        view.backgroundColor = UIColor.ThemeView.bg
        return view
    }()
    
    //搜索栏
    lazy var searchBar1 : UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.extUseAutoLayout()
        searchBar.barTintColor = UIColor.ThemeView.bg
        searchBar.layer.borderColor = UIColor.ThemeView.bg.cgColor
        searchBar.subviews.first?.subviews.last?.backgroundColor = UIColor.ThemeView.bg
        searchBar.tintColor = UIColor.ThemeLabel.colorDark
        if let textfield = searchBar.value(forKey: "searchField") as? UITextField{
//        if let textfield = searchBar.subviews.first?.subviews.last as? UITextField{
            textfield.setPlaceHolderAtt(LanguageTools.getString(key: "common_action_searchCoinPair"), color: UIColor.ThemeLabel.colorDark, font: 14)
            textfield.textColor = UIColor.ThemeLabel.colorMedium
            textfield.font = UIFont.ThemeFont.BodyRegular
            textfield.setModifyClearButton()
//            textfield.backgroudView.extSetCornerRadius(2)
        }
        searchBar.layer.borderWidth = 1
        searchBar.delegate = self
        searchBar.setImage(UIImage.themeImageNamed(imageName: "search"), for: UISearchBarIcon.search, state: UIControlState.normal)
        return searchBar
    }()
    
    //取消按钮
    lazy var cancelBtn : UIButton = {
        let btn = UIButton()
        btn.extUseAutoLayout()
        btn.setEnlargeEdgeWithTop(10, left: 10, bottom: 10, right: 10)
        btn.extSetTitle(LanguageTools.getString(key: "common_text_btnCancel"), titleColor: UIColor.ThemeLabel.colorMedium)
        btn.extSetAddTarget(self, #selector(clickCancelBtn))
        btn.titleLabel?.font = UIFont.ThemeFont.BodyRegular
        btn.setTitleColor(UIColor.ThemeLabel.colorMedium, for: UIControlState.normal)
        return btn
    }()
    
    //空页面
    lazy var emptyView : EmptyPageView = {
        let view = EmptyPageView()
        view.extUseAutoLayout()
        view.addBtn.setImage(UIImage.themeImageNamed(imageName: "quotes_norecord"), for: UIControlState.normal)
        view.clickLabelBlock = {[weak self] in
            BasicParameter.getVersionForPublicInfo()
        }
        return view
    }()
    
    //展示页
    lazy var tableView : UITableView = {
        let tableView = UITableView()
        tableView.extUseAutoLayout()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.extRegistCell([SearchTC.classForCoder(),SearchChooseImgVTC.classForCoder(),SearchAddTC.classForCoder()], ["SearchTC","SearchChooseImgVTC","SearchAddTC"])
        tableView.backgroundColor = UIColor.ThemeView.bg
        return tableView
    }()
    
    lazy var bottomV : UIView = {
        let view = UIView()
        view.extUseAutoLayout()
        view.backgroundColor = UIColor.ThemeView.seperator
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.ThemeView.bg
        addSubViews([topSearchView , tableView,emptyView,bottomV])
        topSearchView.addSubViews([searchBar1, cancelBtn])
        addConstraints()
        reloadEmptyView()
    }
    
    func reloadEmptyView(){
        if let text = self.searchBar1.text , text.count > 0{
            emptyView.label.attributedText = NSMutableAttributedString().add(string: "common_tip_nodata".localized() + ",", attrDic: [NSAttributedStringKey.font : UIFont.ThemeFont.BodyRegular , NSAttributedStringKey.foregroundColor : UIColor.ThemeLabel.colorMedium]).add(string: "common_text_refresh".localized(), attrDic: [NSAttributedStringKey.font : UIFont.ThemeFont.BodyRegular , NSAttributedStringKey.foregroundColor : UIColor.ThemeLabel.colorHighlight])
        }else{
            emptyView.label.attributedText = NSMutableAttributedString().add(string: "common_tip_nodata".localized(), attrDic: [NSAttributedStringKey.font : UIFont.ThemeFont.BodyRegular , NSAttributedStringKey.foregroundColor : UIColor.ThemeLabel.colorMedium])
        }
    }
    
    func addConstraints() {
        topSearchView.snp.makeConstraints { (make) in
            make.left.right.equalTo(self)
            make.top.equalTo(NAV_TOP + 20) 
            make.height.equalTo(44)
        }
        
        searchBar1.snp.makeConstraints { (make) in
            make.left.equalTo(self.topSearchView)
            make.right.equalTo(cancelBtn.snp.left).offset(-10)
            make.top.equalTo(self.topSearchView).offset(10)
            make.height.equalTo(30)
        }
        
        cancelBtn.snp.makeConstraints { (make) in
            make.right.equalTo(self.topSearchView).offset(-10)
            make.height.equalTo(16)
            make.width.lessThanOrEqualTo(100)
            make.centerY.equalTo(self.searchBar1)
        }
        
        bottomV.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.height.equalTo(0.5)
            make.top.equalTo(cancelBtn.snp.bottom).offset(14)
        }
        
        tableView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(topSearchView.snp.bottom)
        }
        
        emptyView.snp.makeConstraints { (make) in
            make.edges.equalTo(tableView)
        }
        //收到接口返回成功的通知
        PublicInfo.sharedInstance.subject.asObserver().subscribe {[weak self] (event) in
//            if let e = event.element , e == 1{
                guard let mySelf = self else{return}
                if let text = mySelf.searchBar1.text {
                    mySelf.searchBar(mySelf.searchBar1, textDidChange: text)
                }
//            }
            }.disposed(by: disposeBag)
    }
    
    func reloadSearchView(_ arr : [SearchEntity]){
        self.tableViewRowDatas = arr
        self.tableView.reloadData()
        isShowEmptyView(tableViewRowDatas.count > 0 ? false : true)
    }
    
    func setTmpArray(){
        let searchArray = XUserDefault.getSearchArray()
        var array : [CoinMapEntity] = []
        for name in searchArray{
            let entity = PublicInfoManager.sharedInstance.getCoinMapInfo(name) 
            array.append(entity)
        }
//        let PublicInfoManager.sharedInstance.getAllCoinMapInfo()
        var arr : [SearchEntity] = []
        for item in array{
            let entity = SearchEntity()
            entity.name = item.name
            entity.img = item.coinListEntity.icon
            arr.append(entity)
        }
        tmpArray = arr
    }
    
    //MARK:是否展示空页面
    func isShowEmptyView(_ show : Bool){
        tableView.isHidden = show
        emptyView.isHidden = !show
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

extension SearchView : UITableViewDelegate , UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return searchHeadV
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if self.searchType == .addCoinMap{
            if self.searchBar1.text == ""{
                return 33
            }
        }
        return 0
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewRowDatas.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 48
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let entity = tableViewRowDatas[indexPath.row]
        switch searchType {
        case .addCoinMap:
            let cell : SearchAddTC = tableView.dequeueReusableCell(withIdentifier: "SearchAddTC") as! SearchAddTC
            cell.setCellWithEntity(entity)
            return cell
        case .searchCoinMap:
            let cell : SearchTC = tableView.dequeueReusableCell(withIdentifier: "SearchTC") as! SearchTC
            cell.setCellWithEntity(entity)
            return cell
        case .searchCoinMapCashflow:
            let cell : SearchChooseImgVTC = tableView.dequeueReusableCell(withIdentifier: "SearchChooseImgVTC") as! SearchChooseImgVTC
            cell.setCellWithEntity(entity)
            return cell
        default:
            break
        }
       
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.searchType == .addCoinMap{
            let entity = tableViewRowDatas[indexPath.row]
            XUserDefault.setSearchArray(entity.name)
//            setTmpArray()
//            reloadSearchView(tmpArray)
            self.searchBar1.text = ""
            
            clickCellBlock?(entity)

//            let transactionDetailsVC = EXMarketDetailVc.instanceFromStoryboard(name: StoryBoardNameMarket)
//            let coinmapentity = PublicInfoManager.sharedInstance.getCoinMapInfo(entity.name)
//            transactionDetailsVC.entity = coinmapentity
//            self.yy_viewController?.navigationController?.pushViewController(transactionDetailsVC, animated: true)
        }else{
            let entity = tableViewRowDatas[indexPath.row]
            clickCellBlock?(entity)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.endEditing(true)
    }
    
}

extension SearchView : UISearchBarDelegate{
    //点击取消按钮
    @objc func clickCancelBtn(){
        clickCancelBtnBlock?()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchType == .searchCoinMapCashflow{
            if searchText == ""{
                reloadSearchView(tmpArray)
            }else{
                var array : [SearchEntity] = []
                for item in  PublicInfoManager.sharedInstance.getSearchCoinList(searchText){
                    let entity = SearchEntity()
                    entity.name = item.name
                    entity.img = item.icon
                    array.append(entity)
                }
                reloadSearchView(array)
            }
        }else{
            if searchText == ""{
                reloadSearchView(tmpArray)
            }else{
                var array : [SearchEntity] = []
                for item in  PublicInfoManager.sharedInstance.getSearchCoinMapList(searchText){
                    let entity = SearchEntity()
                    entity.name = item.name
                    entity.img = item.coinListEntity.icon
                    entity.state = XUserDefault.whetherCollectionCoinMap(item.name) ? "1" : "0"
                    array.append(entity)
                }
                reloadSearchView(array)
            }
        }
        reloadEmptyView()
    }
}
