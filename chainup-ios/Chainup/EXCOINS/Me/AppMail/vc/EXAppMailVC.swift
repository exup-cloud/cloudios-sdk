//
//  EXAppMailVC.swift
//  Chainup
//
//  Created by zewu wang on 2019/3/26.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import UIKit
import RxSwift

class EXAppMailVC: NavCustomVC , EXFilterViewDelegate , EXEmptyDataSetable{
    
    var filterData = [String:String]()

    var typeList : [EXMessageTypesEntity] = []
    
    var type = "0"
    
    let dropView = EXFilterView()
    
    lazy var mainView : EXAppMailView = {
        let view = EXAppMailView()
        view.extUseAutoLayout()
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        contentView.addSubViews([mainView])
        mainView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        getData()
        self.exEmptyDataSet(mainView.tableView)
    }
    
    func getData(){
        appApi.rx.request(AppAPIEndPoint.getAppMail(messageType: type, pageSize: "100", page: "1")).MJObjectMap(EXAppMailAllEntity.self).subscribe(onSuccess: {[weak self] (entity) in
            guard let mySelf = self else{return}
            mySelf.typeList = entity.typeList
            mySelf.mainView.tableViewRowDatas = entity.userMessageList
            for e in mySelf.mainView.tableViewRowDatas{
                for dentity in mySelf.typeList{
                    if e.messageType == dentity.tid{
                        e.messageTitle = dentity.title
                        break
                    }
                }
            }
            self?.mainView.tableView.reloadData()
            self?.messageUpdateStatus()
        }) { (error) in
            
            }.disposed(by: disposeBag)
    }
    
    //清除信息
    func messageUpdateStatus(){
        appApi.hideAutoLoading()
        appApi.rx.request(AppAPIEndPoint.messageUpdateStatus(id: "0")).MJObjectMap(EXBaseModel.self).subscribe(onSuccess: { (model) in

        }, onError: nil).disposed(by: disposeBag)
    }
    
    override func setNavCustomV() {
        self.setTitle(LanguageTools.getString(key: "personal_text_message"))
        self.xscrollView = mainView.tableView
        let btn = UIButton()
        btn.setImage(UIImage.themeImageNamed(imageName: "screening"), for: UIControlState.normal)
        btn.extSetAddTarget(self, #selector(clickBtn))
        self.navCustomView.addSubview(btn)
        btn.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.navCustomView.popBtn)
            make.width.equalTo(14)
            make.height.equalTo(17)
            make.right.equalToSuperview().offset(-18)
        }
        self.lastVC = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        dropView.dismissFilter()
    }
    
    //点击筛选
    func clickBtn(){
        if dropView.isShow == true{
            return
        }
        dropView.delegate = self
        dropView.show(inView: self.view, position: CGPoint(x: 0, y: NAV_SCREEN_HEIGHT))
        dropView.filterParams = self.filterData
        dropView.reloadData()
    }
    
    func filterConfirm(params: [String : String]) {
        self.filterData = params
        if let type = params["type"]{
            self.type = type
            getData()
        }
    }
    
    func filterDataSource() -> [EXFilterDataModel] {
        var titlearr : [String] = []
        var tidarr : [String] = []
        for entity in self.typeList{
            titlearr.append(entity.title)
            tidarr.append(entity.tid)
        }
        let items = EXFilterItem.getItem(titles: titlearr, valueKeys: tidarr)
        //折叠
        let foldModel
            = EXFilterDataModel.getFoldModel(key: "type", title: "filter_fold_messageType".localized(), contents: items)
        return [foldModel]
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
