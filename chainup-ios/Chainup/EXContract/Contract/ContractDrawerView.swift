//
//  ContractDrawerView.swift
//  Chainup
//
//  Created by zewu wang on 2019/5/9.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import UIKit

class ContractDrawerView: UIView {
    
//    var tableViewDatas : [String : [ContractContentModel]] = [:]
    
    var tableViewDatas : [(String , [ContractContentModel])] = []
    
    var keys : [String] = []
    
    var vms : [ContractWsVm] = []
    
    typealias ClickCellBlock = (ContractContentModel) -> ()
    var clickCellBlock : ClickCellBlock?
    
    
    private static var sharedInstance: ContractDrawerView?
    
    //MARK:单例
    class func getSharedInstance() -> ContractDrawerView {
        guard let instance = sharedInstance else {
            sharedInstance = ContractDrawerView()
            sharedInstance?.reloadData()
            return sharedInstance!
        }
        instance.reloadData()
        return instance
    }
    
    class func clearSharedInstance(){
        sharedInstance = nil
    }
    
//    //MARK:单例
//    public static var sharedInstance : ContractDrawerView{
//        struct Static {
//            static let instance : ContractDrawerView = ContractDrawerView()
//        }
//        Static.instance.reloadData()
//        return Static.instance
//    }
    
    lazy var tableView : UITableView = {
        let tableView = UITableView()
        tableView.extUseAutoLayout()
        tableView.backgroundColor = UIColor.ThemeView.bg
        tableView.extSetTableView(self, self)
        tableView.extRegistCell([ContractDrawerTC.classForCoder()], ["ContractDrawerTC"])
        tableView.register(ContractDrawerSectionView.classForCoder(), forHeaderFooterViewReuseIdentifier: "ContractDrawerSectionView")
        return tableView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.ThemeView.bg
        addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(NAV_STATUS_HEIGHT)
            make.bottom.equalToSuperview().offset(-TABBAR_BOTTOM)
        }
    }
    
    func reloadData(){
        disConnectWS()
        tableViewDatas = ContractPublicInfoManager.manager.getAllContractFromResultMarketModels()
//        for key in tableViewDatas.keys{
//            self.keys.append(key)
//        }
        for key in tableViewDatas{
            self.keys.append(key.0)
        }
        startWS()
        tableView.reloadData()
    }
    
    //关闭ws
    func disConnectWS(){
        if vms.count > 0{
            for item in vms{
                item.disconnectws()
            }
        }
        vms.removeAll()
    }
    
    //链接ws
    func startWS(){
//        for key in tableViewDatas.keys{
//            if let arr = tableViewDatas[key] , arr.count > 0{
//                for entity in arr{
//                    let wsVm = ContractWsVm()
//                    wsVm.contractSymbol = entity.symbol
//                    wsVm.priceDecimal = entity.getPriceDecimal()
//                    wsVm.wsRequestData()
//                    wsVm.closePriceSubject.subscribe(onNext:{[weak self] tick in
//                        guard let mySelf = self else { return }
//                        entity.currentPrice = tick.close
//                        entity.rose_Color = tick.rose_Color
//                        mySelf.tableView.reloadData()
//                    }).disposed(by: disposeBag)
//                    vms.append(wsVm)
//                }
//            }
//        }
        for tuples in tableViewDatas{
            let arr = tuples.1
            if arr.count > 0{
                for entity in arr{
                    let wsVm = ContractWsVm()
                    wsVm.contractSymbol = entity.symbol
                    wsVm.priceDecimal = entity.getPriceDecimal()
                    wsVm.wsRequestData()
                    wsVm.closePriceSubject.subscribe(onNext:{[weak self] tick in
                        guard let mySelf = self else { return }
                        entity.currentPrice = tick.close
                        entity.rose_Color = tick.rose_Color
                        mySelf.tableView.reloadData()
                    }).disposed(by: disposeBag)
                    vms.append(wsVm)
                }
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension ContractDrawerView : UITableViewDelegate , UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
//        return tableViewDatas.keys.count
        return tableViewDatas.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 52
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let key = keys[section]
        let view : ContractDrawerSectionView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "ContractDrawerSectionView") as! ContractDrawerSectionView
        view.setView(key)
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 52
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        let key = self.keys[section]
//        if let arr = tableViewDatas[key]{
//            return arr.count
//        }
        //        return 0
        return tableViewDatas[section].1.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : ContractDrawerTC = tableView.dequeueReusableCell(withIdentifier: "ContractDrawerTC") as! ContractDrawerTC
//        if let arr = tableViewDatas[keys[indexPath.section]]{
//            cell.setCell(arr[indexPath.row])
//        }
        let entity = tableViewDatas[indexPath.section].1[indexPath.row]
        cell.setCell(entity)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let entity = tableViewDatas[indexPath.section].1[indexPath.row]
        self.clickCellBlock?(entity)
//        if let arr = tableViewDatas[keys[indexPath.section]]{
//            let entity = arr[indexPath.row]
//            self.clickCellBlock?(entity)
//        }
    }
}

class ContractDrawerTC : UITableViewCell{
    
    lazy var nameLabel : UILabel = {
        let label = UILabel()
        label.extUseAutoLayout()
        label.layoutIfNeeded()
        label.font = UIFont.ThemeFont.HeadRegular
        label.textColor = UIColor.ThemeLabel.colorLite
        return label
    }()
    
    lazy var priceLabel : UILabel = {
        let label = UILabel()
        label.extUseAutoLayout()
        label.font = UIFont.ThemeFont.BodyRegular
        label.textAlignment = .right
        label.text = "--"
        return label
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.extSetCell()
        contentView.addSubViews([nameLabel,priceLabel])
        nameLabel.snp.makeConstraints { (make) in
            make.height.equalTo(22)
            make.left.equalToSuperview().offset(15)
            make.centerY.equalToSuperview()
        }
        priceLabel.snp.makeConstraints { (make) in
            make.height.equalTo(16)
            make.right.equalToSuperview().offset(-15)
            make.centerY.equalToSuperview()
            make.left.equalTo(nameLabel.snp.right).offset(10)
        }
    }
    
    func setCell(_ entity : ContractContentModel){
        nameLabel.text = entity.getContractTitle()
        priceLabel.text = entity.currentPrice
        priceLabel.textColor = entity.rose_Color
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class ContractDrawerSectionView : UITableViewHeaderFooterView {

    lazy var nameLabel : UILabel = {
        let label = UILabel()
        label.extUseAutoLayout()
        label.font = UIFont.ThemeFont.BodyRegular
        label.textColor = UIColor.ThemeLabel.colorLite
        return label
    }()
    
    lazy var logoV : UIView = {
        let view = UIView()
        view.extUseAutoLayout()
        view.backgroundColor = UIColor.ThemeView.highlight
        return view
    }()
    
    lazy var lineV : UIView = {
        let view = UIView()
        view.extUseAutoLayout()
        view.backgroundColor = UIColor.ThemeView.seperator
        return view
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = UIColor.ThemeView.bg
        contentView.addSubViews([nameLabel,logoV,lineV])
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.centerY.equalToSuperview()
            make.height.equalTo(16)
        }
        logoV.snp.makeConstraints { (make) in
            make.height.equalTo(20)
            make.width.equalTo(3)
            make.left.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        lineV.snp.makeConstraints { (make) in
            make.height.equalTo(0.5)
            make.left.right.bottom.equalToSuperview()
        }
    }
    
    func setView(_ name : String){
        nameLabel.text = name
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
