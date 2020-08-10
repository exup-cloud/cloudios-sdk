//
//  EXHomeListTC.swift
//  Chainup
//
//  Created by zewu wang on 2019/5/6.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import UIKit

class EXHomeListTC: UITableViewCell {

    typealias SlidingBlock = (Int) -> ()
    var slidingBlock : SlidingBlock?
    
    var tableViewRowData1 : [HomeListEntity] = []
    
    var tableViewRowData2 : [HomeListEntity] = []
    
    var tableViewRowData3 : [HomeListEntity] = []
    
    var switchArr : [String] = ["","",""]
    
    lazy var scrollView : UIScrollView = {
        let scrollView = UIScrollView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: 580))
        scrollView.contentSize = CGSize.init(width: SCREEN_WIDTH * 3, height: 580)
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isPagingEnabled = true
        scrollView.backgroundColor = UIColor.ThemeView.bg
        scrollView.bounces = false
        scrollView.delegate = self
        return scrollView
    }()
    
    //涨幅榜
    lazy var tableView1 : UITableView = {
        let tableView = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: 580))
        tableView.extRegistCell([EXHomeTC.classForCoder(),EXHomeDealListTC.classForCoder()], ["EXHomeTC","EXHomeDealListTC"])
        tableView.extSetTableView(self, self)
        tableView.backgroundColor = UIColor.ThemeView.bg
        tableView.isScrollEnabled = false
        return tableView
    }()
    
    //跌幅榜
    lazy var tableView2 : UITableView = {
        let tableView = UITableView.init(frame: CGRect.init(x: SCREEN_WIDTH, y: 0, width: SCREEN_WIDTH, height: 580))
        tableView.extSetTableView(self, self)
        tableView.extRegistCell([EXHomeTC.classForCoder(),EXHomeDealListTC.classForCoder()], ["EXHomeTC","EXHomeDealListTC"])
        tableView.backgroundColor = UIColor.ThemeView.bg
        tableView.isScrollEnabled = false
        return tableView
    }()
    
    //成交榜
    lazy var tableView3 : UITableView = {
        let tableView = UITableView.init(frame: CGRect.init(x: SCREEN_WIDTH * 2, y: 0, width: SCREEN_WIDTH, height: 580))
        tableView.extSetTableView(self, self)
        tableView.extRegistCell([EXHomeTC.classForCoder(),EXHomeDealListTC.classForCoder()], ["EXHomeTC","EXHomeDealListTC"])
        tableView.backgroundColor = UIColor.ThemeView.bg
        tableView.isScrollEnabled = false
        return tableView
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubViews([scrollView])
        scrollView.addSubViews([tableView1,tableView2,tableView3])
    }
    
    func setCell(_ index : Int , tableViewRowData : [HomeListEntity],type : String){
        switchArr[index] = type
        switch index {
        case 0:
            tableViewRowData1 = tableViewRowData
            tableView1.reloadData()
        case 1:
            tableViewRowData2 = tableViewRowData
            tableView2.reloadData()
        case 2:
            tableViewRowData3 = tableViewRowData
            tableView3.reloadData()
        default:
            break
        }
    }
    
    func setScrollViewSize(_ i : Int){
        if i == 0{
            scrollView.isHidden = true
        }else{
            scrollView.contentSize = CGSize.init(width: SCREEN_WIDTH * CGFloat(i), height: 580)
        }
    }
    
    func setScrollView(_ index : CGFloat){
        self.scrollView.setContentOffset(CGPoint.init(x: SCREEN_WIDTH * index, y: 0), animated: false)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == self.scrollView{
            let x = Int(scrollView.contentOffset.x / SCREEN_WIDTH)
            slidingBlock?(x)
        }
    }
    
}

extension EXHomeListTC : UITableViewDelegate , UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 58
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case tableView1:
            return tableViewRowData1.count >= 10 ? 10 : tableViewRowData1.count
        case tableView2:
            return tableViewRowData2.count >= 10 ? 10 : tableViewRowData2.count
        case tableView3:
            return tableViewRowData3.count >= 10 ? 10 : tableViewRowData3.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableView {
        case tableView1:
            let entity = tableViewRowData1[indexPath.row]
            if switchArr[0] == "deal"{
                let cell : EXHomeDealListTC = tableView.dequeueReusableCell(withIdentifier: "EXHomeDealListTC") as! EXHomeDealListTC
                cell.tag = 1000 + indexPath.row
                cell.setCell(entity)
                return cell
            }
            
            let cell : EXHomeTC = tableView.dequeueReusableCell(withIdentifier: "EXHomeTC") as! EXHomeTC
            cell.tag = 1000 + indexPath.row
            cell.setCell(entity)
            return cell
        case tableView2:
            let entity = tableViewRowData2[indexPath.row]
            if switchArr[1] == "deal"{
                let cell : EXHomeDealListTC = tableView.dequeueReusableCell(withIdentifier: "EXHomeDealListTC") as! EXHomeDealListTC
                cell.tag = 1000 + indexPath.row
                cell.setCell(entity)
                return cell
            }
            
            let cell : EXHomeTC = tableView.dequeueReusableCell(withIdentifier: "EXHomeTC") as! EXHomeTC
            cell.tag = 1000 + indexPath.row
            cell.setCell(entity)
            return cell
        case tableView3:
            let entity = tableViewRowData3[indexPath.row]
            if switchArr[2] == "deal"{
                let cell : EXHomeDealListTC = tableView.dequeueReusableCell(withIdentifier: "EXHomeDealListTC") as! EXHomeDealListTC
                cell.tag = 1000 + indexPath.row
                cell.setCell(entity)
                return cell
            }
            
            let cell : EXHomeTC = tableView.dequeueReusableCell(withIdentifier: "EXHomeTC") as! EXHomeTC
            cell.tag = 1000 + indexPath.row
            cell.setCell(entity)
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var entity:HomeListEntity?
        switch tableView {
        case tableView1:
            entity = tableViewRowData1[indexPath.row]
        case tableView2:
            entity = tableViewRowData2[indexPath.row]
        case tableView3:
            entity = tableViewRowData3[indexPath.row]
        default:
            break
        }
        
        if let choseEntity = entity {
//            let vc = EXMarketDetailVc.instanceFromStoryboard(name: StoryBoardNameMarket)
//            let index = Int(scrollView.contentOffset.x / SCREEN_WIDTH)
//            if switchArr.count <= index{
//                return
//            }
//            if switchArr[index] == "deal"{
//                let coinmapentity = PublicInfoManager.sharedInstance.getDealEntity(choseEntity.name)
//                vc.entity = coinmapentity
//            }else{
//                let coinmapentity = PublicInfoManager.sharedInstance.getCoinMapInfo(choseEntity.name)
//                vc.entity = coinmapentity
//            }
//            
//            self.yy_viewController?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}
