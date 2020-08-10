//
//  HiDebugActionSheet.swift
//  Chainup
//
//  Created by liuxuan on 2019/3/8.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import UIKit

class HiDebugActionSheet: UIViewController {
    @IBOutlet var actionSheet: EXActionSheetView!
    var test: UIView = UIView()
    var filterData = [String:String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        test.backgroundColor = UIColor.red
    }
    
    @IBAction func actionSheet(_ sender: Any) {
        let sheet = EXActionSheetView()
        sheet.configButtonTitles(buttons: ["按钮A","按钮B","按钮C","按钮D"])
        sheet.actionIdxCallback = {[weak self] tag in
            self?.testSecurity()
        }
        EXAlert.showSheet(sheetView:sheet)
    }
    
    func testSecurity() {

    }
    
    @IBAction func textfieldSheet(_ sender: Any) {
//        let sheet = EXActionSheetView()
//        sheet.itemBtnCallback = {[weak self] key in
//            EXAlert.showFail(msg: "123")
//        }
//        sheet.configTextfields(title: "资金密码", itemModels:self.models())
//        sheet.actionFormCallback = {[weak self] formDic in
//            print(formDic)
//        }
//        self.view.addSubview(sheet)
//
//        sheet.snp.makeConstraints { (make) in
//            make.bottom.equalToSuperview()
//            make.left.right.equalToSuperview()
//        }
        
        let sheet = EXContractPositionSheet()
        sheet.bindInfos(contractPositionNumber: "123", assignedPosition: "345", avaliablePosition:"34566", symbol: "sdfj")
        sheet.onPositionCallback = {[weak self](str , bool) in
            if bool == true{//增加保证金
//                self?.transferMargin(entity.contractId, amount: "+" + str)
            }else{//减少保证金
//                self?.transferMargin(entity.contractId, amount: "-" + str)
            }
        }
//        EXAlert.showSheet(sheetView: sheet)
        
        EXAlert.showSheet(sheetView:sheet)
    }
    
    @IBAction func dropMenuAction(_ sender: Any) {
        let dropView = EXFilterView()
        dropView.delegate = self
        dropView.show(inView: self.view, position: CGPoint(x: 0, y: 64))
        dropView.filterParams = self.filterData
        dropView.reloadData()
    }
    
    func models()->[EXInputSheetModel] {
        let model = EXInputSheetModel.setModel(key:"key1",placeHolder: "输入资金密码", type: .input, privacyMode: true,keyBoard:.numberPad)
        let model4 = EXInputSheetModel.setModel(key:"key1",placeHolder: "输入资金密码", type: .paste, privacyMode: true,keyBoard:.numberPad)

        let model3 = EXInputSheetModel.setModel(key:"key3",placeHolder: "输入资金密码", type: .sms, privacyMode: true,keyBoard:.decimalPad)

        let model2 = EXInputSheetModel.setModel(withTitle:"790215001@qq.com",key:"key2",placeHolder: "邮箱验证码", type: .sms)
        return[model,model3,model2,model4]
    }
    
    @IBAction func failDrop(_ sender: Any) {
        EXAlert.showFail(msg: "失败消息")

    }
    
    @IBAction func successDrop(_ sender: Any) {
        EXAlert.showSuccess(msg: "成功消息")

    }
    
    @IBAction func warningDrop(_ sender: Any) {
        EXAlert.showWarning(msg: "是旅客大幅减少了大家看法老师的快捷方式来对抗肌肤脸上的开发建设带来几分苦涩的")
    }
    
    @IBAction func normal(_ sender: Any) {
        let view = EXNormalAlert()
        view.configAlert(title: "弹窗弹窗测试测窗弹窗测试测窗弹窗测试测窗弹窗测试测试",message:"弹窗弹窗测试测窗弹窗测试测窗弹窗测试测窗弹窗测试测试")
        EXAlert.showAlert(alertView: view)
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

extension HiDebugActionSheet : EXFilterViewDelegate {
    
    func filterConfirm(params: [String : String]) {
        self.filterData = params
    }
    
    func filterDataSource() -> [EXFilterDataModel] {
        let items = EXFilterItem.getItem(titles: ["common_action_sendall".localized(),"otc_action_buy".localized(),"otc_action_sell".localized()], valueKeys: ["1","2","3"])
        //折叠
        let foldModel
            = EXFilterDataModel.getFoldModel(key: "tradeType", title: "filter_fold_transactionType".localized(), contents: items)
        
        let coinitems = EXFilterItem.getItem(titles: ["人民币","美元","日元","欧元"], valueKeys: ["cny","usd","jpy","euo"])
        //一半输入,一半折叠
        let mixModel = EXFilterDataModel.getMixModel(title: "交易单位", leftKey: "symbol", rightKey: "unit", leftplaceHolder: "filter_input_coinsymbol".localized(), rightItems: coinitems)

        //折叠
        let item2 = EXFilterItem.getItem(titles: ["全部","已完成","待付款","待放行","已取消","申诉中"], valueKeys: ["1","2","3","4","5","6"])
        let foldModel2
            = EXFilterDataModel.getFoldModel(key: "moneyType", title: "filter_fold_transactionType".localized(), contents:item2)
        
        //日期
        let dateModel = EXFilterDataModel.getDateModel(beginDateKey: "begin", endDateKey: "end", title: "date")
        
        //开关
        let onOffModel = EXFilterDataModel.getSwitchModel(key: "onoff", title: "隐藏小额资产")
        
        //单纯输入框
        let inputModel = EXFilterDataModel.getInputModel(key: "writesomthing", title: "输入啥", placeHolder: "请输入", unit:"cny")
        
        //单纯选择
        let selectModel = EXFilterDataModel.getSelectionModel(key: "search", title: "币对", placeHolder:"BTC/USDT")

        return [foldModel,mixModel,foldModel2,dateModel,onOffModel,inputModel,selectModel]
    }
    
    func didSelectAtIdxPath(idx: IndexPath) {
        
//        let vc = HiDebugHubController .instanceFromStoryboard(name: "HiDebug")
//        self.navigationController?.pushViewController(vc, animated: true)

    }
    
}
