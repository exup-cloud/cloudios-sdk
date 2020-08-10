//
//  EXMEView.swift
//  Chainup
//
//  Created by zewu wang on 2019/3/23.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import UIKit

class EXMEView: UIView {

    lazy var infoView : EXMEInfoView = {
        let view = EXMEInfoView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: 130))
        view.reloadView()
        return view
    }()
    
    var tableViewNameDatas : [(String , String)] = []
    
    var tableViewRowDatas : [EXMEEntity] = []

    lazy var tableView : UITableView = {
        let tableView = UITableView()
        tableView.extUseAutoLayout()
        tableView.extSetTableView(self, self)
        tableView.bounces = false
        tableView.extRegistCell([EXMETC.classForCoder(),UITableViewCell.classForCoder()], ["EXMETC","UITableViewCell"])
        tableView.tableHeaderView = infoView
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
        
        if PublicInfoEntity.sharedInstance.haveOTC == "1"{
            tableViewNameDatas = [("common_action_inviteFriend".localized(),"personal_Invitegoodfriends"),("",""),(LanguageTools.getString(key: "personal_text_message"),"personal_mail"),(LanguageTools.getString(key: "personal_text_notice"),"personal_notice"),(LanguageTools.getString(key: "personal_text_helpcenter"),"personal_helpcenter"),("",""),(LanguageTools.getString(key: "personal_text_safetycenter"),"personal_securitycenter"),(LanguageTools.getString(key: "personal_text_setting"),"personal_setting"),(LanguageTools.getString(key: "personal_text_blacklist"),"personal_blacklist"),(LanguageTools.getString(key: "personal_text_aboutus"),"personal_aboutus")]
        }else{
            tableViewNameDatas = [("common_action_inviteFriend".localized(),"personal_Invitegoodfriends"),("",""),(LanguageTools.getString(key: "personal_text_message"),"personal_mail"),(LanguageTools.getString(key: "personal_text_notice"),"personal_notice"),(LanguageTools.getString(key: "personal_text_helpcenter"),"personal_helpcenter"),("",""),(LanguageTools.getString(key: "personal_text_safetycenter"),"personal_securitycenter"),(LanguageTools.getString(key: "personal_text_setting"),"personal_setting"),(LanguageTools.getString(key: "personal_text_aboutus"),"personal_aboutus")]
        }
        
        if PublicInfoEntity.sharedInstance.online_service_url != ""{//如果有在线客服
            tableViewNameDatas.insert(("personal_text_onlineservice".localized(), "personal_onlineservice"), at: 4)
        }

        var arr : [EXMEEntity] = []
        for tuple in tableViewNameDatas{
            let entity = EXMEEntity()
            entity.name = tuple.0
            entity.imgName = tuple.1
            arr.append(entity)
        }
        tableViewRowDatas = arr
        tableView.reloadData()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension EXMEView : UITableViewDelegate , UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let entity = tableViewRowDatas[indexPath.row]
        if entity.name == ""{
            return 10
        }else{
            return 52
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewRowDatas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let entity = tableViewRowDatas[indexPath.row]
        if entity.name != ""{
            let cell : EXMETC = tableView.dequeueReusableCell(withIdentifier: "EXMETC") as! EXMETC
            if entity.name == "personal_text_helpcenter".localized() || entity.name == "common_action_inviteFriend".localized(){
                cell.setCell(entity,lineVHidden : true)
            }else{
                cell.setCell(entity,lineVHidden : false)
            }
            return cell
        }
        let cell : UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell") ?? UITableViewCell()
        cell.contentView.backgroundColor = UIColor.ThemeNav.bg
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        return cell
       
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let entity = tableViewRowDatas[indexPath.row]
        switch entity.name {
       
        case LanguageTools.getString(key: "personal_text_setting"):
            let vc = EXSetVC()
            self.yy_viewController?.navigationController?.pushViewController(vc, animated: true)
        case LanguageTools.getString(key: "personal_text_helpcenter"):
            if PublicInfoEntity.sharedInstance.app_help_center != ""{//后台设置了帮助中心
                let web = WebVC()
                web.loadUrl(PublicInfoEntity.sharedInstance.app_help_center)
                self.yy_viewController?.navigationController?.pushViewController(web, animated: true)
            }else{
                let vc = EXHelpVC()
                self.yy_viewController?.navigationController?.pushViewController(vc, animated: true)
            }
        case LanguageTools.getString(key: "personal_text_notice"):
            let vc = EXAnnouncementVC()
            self.yy_viewController?.navigationController?.pushViewController(vc, animated: true)
        case LanguageTools.getString(key: "personal_text_aboutus"):
            let vc = EXAboutUsVC()
            self.yy_viewController?.navigationController?.pushViewController(vc, animated: true)
        case "personal_text_onlineservice".localized():
            let vc = WebVC()
            vc.loadUrl(PublicInfoEntity.sharedInstance.online_service_url)
            self.yy_viewController?.navigationController?.pushViewController(vc, animated: true)
        default:
            if XUserDefault.getToken() == nil{
                BusinessTools.modalLoginVC()
                return
            }
            switch entity.name{
            case LanguageTools.getString(key: "personal_text_safetycenter"):
                let vc = EXSecurityCenterVC()
                self.yy_viewController?.navigationController?.pushViewController(vc, animated: true)
            case LanguageTools.getString(key: "personal_text_message"):
                let vc = EXAppMailVC()
                self.yy_viewController?.navigationController?.pushViewController(vc, animated: true)
            case LanguageTools.getString(key: "personal_text_blacklist"):
                let vc = EXShieldingVC()
                self.yy_viewController?.navigationController?.pushViewController(vc, animated: true)
            case LanguageTools.getString(key: "common_action_inviteFriend"):
                let vc = EXInviteVC()
                self.yy_viewController?.navigationController?.pushViewController(vc, animated: true)
            default:
                break
            }
        }
    }
}
