//
//  EXAboutUsView.swift
//  Chainup
//
//  Created by zewu wang on 2019/3/26.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import UIKit
import RxSwift

class EXAboutUsView: UIView {
    
    lazy var tableViewRowDatas : [EXAboutEntity] = []

    lazy var tableView : UITableView = {
        let tableView = UITableView()
        tableView.extUseAutoLayout()
        tableView.extSetTableView(self, self)
        tableView.extRegistCell([EXAboutTC.classForCoder()], ["EXAboutTC"])
        return tableView
    }()
    
    lazy var updateBtn : EXButton = {
        let btn = EXButton()
        btn.extUseAutoLayout()
        btn.extSetCornerRadius(1.5)
        btn.extSetAddTarget(self, #selector(clickUpdateBtn))
        btn.backgroundColor = UIColor.ThemeBtn.highlight
        btn.setTitle(LanguageTools.getString(key: "personal_action_checkUpdate"), for: UIControlState.normal)
        btn.setTitleColor(UIColor.ThemeLabel.white, for: UIControlState.normal)
        return btn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubViews([tableView,updateBtn])
        tableView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.bottom.equalTo(updateBtn.snp.top).offset(-10)
        }
        updateBtn.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.bottom.equalToSuperview().offset(-30 - TABBAR_BOTTOM)
            make.height.equalTo(44)
        }
        
        getData()
    }
    
    //获取数据
    func getData(){
        let enti = EXAboutEntity()
        enti.title = LanguageTools.getString(key:"common_text_versionCode")
        let info = Bundle.main.infoDictionary
        
        if let str = info?["CFBundleShortVersionString"] as? String,let s = info?["CFBundleVersion"] as? String{
            enti.content = "V" + str + "(\(s))"
        }
        tableViewRowDatas.append(enti)
        tableView.reloadData()
        
        appApi.rx.request(AppAPIEndPoint.getAbout()).MJObjectMap(CommonAryModel.self).subscribe(onSuccess: {[weak self] (entity) in
            if let arr = entity.dictAry as? Array<[String : Any]>{
                for dict in arr{
                    let exentity = EXAboutEntity()
                    if let content = dict["content"] as? String{
                        exentity.content = content
                    }
                    if let title = dict["title"] as? String{
                        exentity.title = title
                    }
                    self?.tableViewRowDatas.append(exentity)
                }
                self?.tableView.reloadData()
            }
        }) { (error) in
            
        }.disposed(by: disposeBag)
        
    }
    
    //点击更新按钮
    @objc func clickUpdateBtn(){
        
        BusinessTools.checkVersion("1")
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension EXAboutUsView : UITableViewDelegate , UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 52
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewRowDatas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let entity = tableViewRowDatas[indexPath.row]
        let cell : EXAboutTC = tableView.dequeueReusableCell(withIdentifier: "EXAboutTC") as! EXAboutTC
        cell.setCell(entity)
        return cell
    }
}
