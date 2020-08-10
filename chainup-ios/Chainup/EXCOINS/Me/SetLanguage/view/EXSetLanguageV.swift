//
//  EXSetLanguageV.swift
//  Chainup
//
//  Created by zewu wang on 2019/3/25.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import UIKit

class EXSetLanguageV: UIView {
    
    var language : LanguageEnity?

    var dataArray:[LanguageListEntity] = []

    lazy var tableView : UITableView = {
        let tableView = UITableView()
        tableView.extUseAutoLayout()
        tableView.extSetTableView(self, self)
        tableView.extRegistCell([EXSetLanguageTC.classForCoder()], ["EXSetLanguageTC"])
        return tableView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        setData()
    }
    
    func setData(){
        
        language = PublicInfoManager.sharedInstance.getLanaguageList()
        
        dataArray = language?.lanList ?? []
        
        
        if let language = LanguageTools.shareInstance.def.object(forKey: UserLanguage) as? String{
            
            for i in 0..<dataArray.count{
                
                if language.range(of: "zh") != nil{
                    
                    if language.range(of: "zh-Hant") != nil{
                        print(dataArray[i].id)
                        if dataArray[i].id == "el-GR"{
                            
                            dataArray[i].selected = true
                        }else{
                            dataArray[i].selected = false
                            
                        }
                    }else if language.range(of: "zh-Hans") != nil{
                        
                        if dataArray[i].id == "zh-CN"{
                            
                            dataArray[i].selected = true
                        }else{
                            dataArray[i].selected = false
                            
                        }
                        
                        
                    }
                }else{
                    
                    if LanguageTools.shareInstance.supportLan(language){
                        if dataArray[i].id == language{
                            dataArray[i].selected = true
                        }else{
                            dataArray[i].selected = false
                        }
                    }else {
                        if dataArray[i].id == "en-US"{
                            dataArray[i].selected = true
                        }else{
                            dataArray[i].selected = false
                        }
                    }
                }
            }
        }else{
            
            for i in 0..<dataArray.count{
                
                if language?.defLan.range(of: "zh") != nil{
                    
                    if language?.defLan.range(of: "el_GR") != nil{
                        
                        if  dataArray[i].id.range(of: "zh-Hant") != nil{
                            
                            dataArray[i].selected = true
                            
                        }else{
                            dataArray[i].selected = false
                            
                        }
                    }else{
                        if dataArray[i].id.range(of: "zh-Hans") != nil{
                            
                            dataArray[i].selected = true
                            
                        }else{
                            dataArray[i].selected = false
                            
                        }
                    }
                }else{
                    if language?.defLan == dataArray[i].id{
                        
                        dataArray[i].selected = true
                        
                    }else{
                        dataArray[i].selected = false
                        
                    }
                }
                
                
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension EXSetLanguageV : UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 52
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let entity = dataArray[indexPath.row]
        let cell : EXSetLanguageTC = tableView.dequeueReusableCell(withIdentifier: "EXSetLanguageTC") as! EXSetLanguageTC
        cell.setCell(entity)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        LanguageTools.shareInstance.setLanguage(langeuage: dataArray[indexPath.row].id)
        tableView.reloadData()
        
//        OTCPublicInfo.sharedInstance.getData()
//        ContractPublicInfoManager.manager.requestContractPublicInfo()
        PublicInfo.sharedInstance.getData()
        //清理抽屉单例
        ContractDrawerView.clearSharedInstance()
        
        let window = UIApplication.shared.keyWindow
        let nav = AppDelegate().initNavBarV()
        window?.rootViewController = nav
        self.yy_viewController?.navigationController?.popViewController(animated: true)
    }
}
