

import Foundation
typealias JSCallback = (String, Bool)->Void
class JSModel : EXBaseModel{
    
    var routerName = ""
    
}

class EXJsApiMethodSwift: NSObject {
    
    //arg是h5传过来的参数 json字符串 handler 回调
    @objc func exchangeInfo( _ arg:String, handler: JSCallback) {
        print("异步\(arg)")
        
        let dic = [
//           "exchange_token":XUserDefault.getVauleForKey(key: XUserDefault.token) as? String ?? "",
           "exchange_lan":BasicParameter.getPhoneLanguage(),
           "exchange_skin":EXThemeManager.isNight() ? "night" : "day"]
        handler(JSONSerialization.jsonDataFromDictToString(dic),true)
    }
    
    
    @objc func exchangeRouter(_ routerName : String , handler : JSCallback){
        if let model = JSModel.mj_object(withKeyValues: routerName){
            self.handleNative(model)
        }
    }
    
    func handleNative(_ model:JSModel, _ parameter:String = "") {
        
        if model.routerName == "login" {
            if XUserDefault.getToken() == nil{
                BusinessTools.modalLoginVC()
            }
        }else {
            if model.routerName == "singpasscancel" {
                //singpass不授权
                BasicParameter.firstVCDismiss()
                EXAlert.showWarning(msg: "common_text_cancelkyc".localized())
            }else if model.routerName ==  "kyccomplete" {
                //kyc完成认证
                BasicParameter.firstVCDismiss()
                if let topVc = BasicParameter.getFirstVC(){
                    let userInfo = EXRealNameThreeVC()
                    topVc.navigationController?.pushViewController(userInfo, animated: true)
                }
            }else if model.routerName ==  "choosekycfirst" {
                //kyc选择模板一(app本地模板)
                BasicParameter.firstVCDismiss()
                if let topVc = BasicParameter.getFirstVC(){
                    let userInfo = EXRealNameOneVC()
                    userInfo.mainView.regionEntity = RegionManager.sharedInstance.regionEntity
                    topVc.navigationController?.pushViewController(userInfo, animated: true)
                }
            }else {
                var router = ""
                if model.routerName == "idAuth" {
                    router = EXRouterActionKey.AuthRealName.rawValue
                }else if model.routerName == "modifySettings" {
                    router = EXRouterActionKey.SafeMoney.rawValue
                }else {
                    router = model.routerName
                }
                EXNavigationHandler.sharedHandler.commonJumpCommand(router,"")
            }
        }
    }
    
}
