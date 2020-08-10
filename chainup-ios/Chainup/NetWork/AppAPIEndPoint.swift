//
//  AppAPIEndPoint.swift
//  Chainup
//
//  Created by liuxuan on 2019/1/9.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import Moya

enum AppAPIEndPoint {
    case listSymbal //用户推荐自选列表
    case update_symbol(operationType:String,symbols:String) //自选添加
    case publicInfo
    case getInvitationImgs //获取邀请图片
    case tradeLimitInfo(symbol : String)//获取交易限制文案
    case loginOne(mobileNumber : String , loginPword : String , geetest_challenge : String ,geetest_seccode : String,geetest_validate: String , verificationType : String)//登录第一步
    case loginTwo(token : String , checkType: String , authCode : String , googleCode:String?,smsCode:String?,emailCode:String?,idCardCode:String?)//登录第二步
    case quickLogin(quickToken:String)//生物识别登录
    case handLogin(quickToken:String ,handPwd:String)//手势登录
    case handOpen(quickToken:String ,handPwd:String, afterLogin:Bool)//开启手势
    case getsmsValidCode(token : String , operationType : String , countryCode : String , mobile  : String )//获取手机验证码
    case getemailVallidCode(email : String , operationType : String , token : String)//获取邮箱验证码
    
    case registGetsmsValidCode(token : String , operationType : String , countryCode : String , mobile  : String,verificationType: String, geetest_challenge: String, geetest_seccode: String, geetest_validate: String)//获取注册手机验证码
    case registGetemailVallidCode(email : String , operationType : String , token : String,verificationType: String, geetest_challenge: String, geetest_seccode: String, geetest_validate: String)//获取注册邮箱验证码
    
    case userInfo()//获取个人信息
    case registerOne(verificationType : String , geetest_challenge : String , geetest_seccode : String , geetest_validate : String , email : String , mobile : String, country : String )//注册第一步
    case registerTwo(registerCode : String , numberCode : String)//注册第二步
    case registerThree(registerCode : String , loginPword : String , newPassword : String , invitedCode : String)//注册第三步
    case forgetPwOne(verificationType : String , geetest_challenge : String , geetest_seccode : String , geetest_validate : String , registerCode : String)//忘记密码第一步
//    case forgetPwOne(verificationType : String ,mobileNumber : String , geetest_challenge : String , geetest_seccode : String , geetest_validate : String , email: String)//忘记密码第一步
    case forgetPwTwo(token : String , numberCode : String)//忘记密码第二步
//    case forgetPwTwo(token : String , smsCode : String , emailCode : String)//忘记密码第二步
    case forgetPwThree(token : String , certifcateNumber : String , googleCode : String)//忘记密码第三步
    case forgetPwFour(token : String , loginPword : String , newPassword : String)//忘记密码第四步
    case updateNickname(nickname : String)//更新昵称
    case getAbout()//获取关于我们
    case getAppMail(messageType : String , pageSize : String , page : String)//获取站内信
    case getNewEntrustList(symbol : String , pageSize : String , page : String)//获取当前委托
    case otcOrderHistory(page:String,type:String?,symbol:String?,currency:String?,status:String?,begin:String?,end:String?,pageSize:String?)//otc订单列表
    case getHistoryEntrustList(symbol : String , pageSize : String , page : String , isShowCanceled : String , side : String , type : String , startTime : String , endTime : String)//获取历史委托
    case createOrder(side : String , type : String , volume : String , price : String , symbol : String)//创建币币订单
    case cancelOrder(orderId : String , symbol : String)//取消币币订单
    case changepassword(loginPword : String , newLoginPword : String , smsAuthCode : String , googleCode : String ,IdentificationNumber : String)//重置登录密码
    case getGoogle()//获取谷歌信息
    case openGoogle(loginPwd : String , googleCode : String , googleKey : String)//绑定谷歌验证
    case closeGoogle(smsValidCode : String ,googleCode : String)//关闭谷歌认证
    case openMoblieValidation()//开启手机认证
    case closeMoblie(smsValidCode : String ,googleCode : String)//关闭手机验证
    case bindEmail(smsValidCode : String ,googleCode : String ,emailValidCode : String ,email : String )//绑定邮箱
    case updateEmail(emailOldValidCode : String , emailNewValidCode : String ,smsValidCode : String ,googleCode : String ,emailValidCode : String ,email : String )//修改邮箱
    case bindPhone(googleCode : String , countryCode : String , mobileNumber : String , smsAuthCode : String)//绑定手机
    case updatePhone(authenticationCode : String , googleCode : String , countryCode : String , mobileNumber : String , smsAuthCode : String)//修改手机
    case openGesture(loginPwd : String , smsValidCode : String , googleCode : String , uid : String)//打开手势
    case closeGesture(loginPwd : String , smsValidCode : String , googleCode : String)//关闭手势
    case openQuick(loginPwd : String , smsValidCode : String , googleCode : String , uid : String)//打开快捷
    case getmessageType(messageType : String)//获取站内信
    case createProblem(rqType:String,rqDescribe:String,imageDataStr:String?,rqUnreleased:String?,rqUnpaid:String?)
    case getNotice(page : String,pagesize : String)//获取公告
    case getNoReadMessageCount//未读站内信
    case getHelp//获取帮助中心
    case financeAccountList//法外账户余额
    case authRealname(countryCode : String , certificateType : String ,userName : String ,certificateNumber : String , firstPhoto : String , secondPhoto : String , thirdPhoto : String , familyName : String , name : String,numberCode : String)//实名认证
    case coinIntroduce(coinSymbol:String)
    case getHome//获取首页信息
    case accountBalance(coinSymbols:String?)
    case getChargeAddress(symbol:String)
    case transferScene
    case transferList(coinSymbol:String?,transactionScene:String,startTime:String?,endTime:String?,page:String)
    case addressList(coinSymbol:String)
    case addWithdrawAddress(address:String,label:String,smsValidCode:String?,emailValidCode:String?,googleCode:String?,coinSymbol:String,trustOption:Bool)
    case validateWithDrawAddr(address:String,symbol:String)
    case doWithDraw(address:String,trustType:Int?,remark:String,symbol:String,fee:String,amount:String,smsVaildCode:String?,googleValidCode:String?,emailValidCode:String?,addressID:String?)
    case financeOtcTransfer(fromAccount:String,toAccount:String,amount:String,coinSymbol:String)
    case cancelWithDraw(withDrawId:String)
    case depositCancelWithDraw(withDrawId:String)//b2c充值撤销
    case withdrawCancelWithDraw(withDrawId:String)//b2c提现撤销
    case deleteWithDrawAddr(ids:String,googleCode:String?,smsCode:String?)
    case messageUpdateStatus(id : String)//消息设置为已读
    case totalAccountBalance//总资产
    case kycGetToken//获取kyc的信息
    case kycGetWriting//获取kyc人工的信息
    case getUpdateVersion//获取接口版本号
    case getEntrustHistorySearch(page : String , pageSize : String , entrust : String , side : String , symbol : String , orderType : String , status : String , isShowCanceled : String , quote : String , type : String)//获取历史委托
    case create_overcharge_onekey(symbol : String)//解锁卖出
    case b2cBalance(symbol : String)//b2c法币资产列表
    case getUserBankList(symbol : String , page : String , pageSize : String)//b2c用户提现银行
    case getFiatWithdrawList(symbol : String , page : String , pageSize : String, startTime : String? , endTime : String?)//获取法币提现列表
    case getFiatDepoistList(symbol : String , page : String , pageSize : String,startTime : String? , endTime : String?)//获取法币充值列表
    case fiatDeposit(symbol : String , transferVoucher : String , amount : String)//法币充值
    case getAllBank(symbol : String)//法币查询平台支持提现银行列表
    case getUserBank(id : String)//查询用户提现银行
    case fiatWithdraw(symbol : String ,userWithdrawBankId : String ,amount : String ,smsAuthCode : String ,googleCode : String)//法币提现
    case getCompanyBankInfo(symbol : String)//查询平台充值银行信息
    case addUserBank(bankId:String,bankSub:String,cardNo:String,name:String,symbol:String,smsAuthCode:String,googleCode:String)//添加用户提现银行
    case editUserBank(id:String,bankId:String,bankSub:String,cardNo:String,name:String,symbol:String,smsAuthCode:String,googleCode:String)//编辑用户提现银行
    case deleteUserBank(id : String)//删除用户提现银行
    case getLeverBalance(symbol : String)//根据币对获取
    case getLeverOrderHistory(page : String ,pageSize : String , symbol : String , isShowCanceled : String ,side : String,type : String)//获取杠杆历史委托
    case getLeverOrderCurrent(symbol : String , pageSize : String ,page : String)//获取杠杆当前委托
    case cancelLeverOrder(orderId : String , symbol : String)//取消杠杆订单
    case creatLeverOrder(side : String ,type : String ,volume : String ,price : String ,symbol : String)//创建杠杆订单
    case leverageBalance//杠杆账户列表
    case leverBorrowHistory(symbol : String,startTime : String?,endTime : String?,page:String,pageSize : String?)//历史记录（已归还记录）
    case leverCurrentBorrow(symbol : String,startTime : String?,endTime : String?,page:String,pageSize : String?)//当前申请
    case leverFinanceBorrow(symbol : String, coin : String, amount : String)//借贷
    case leverFinanceReturn(id : String, amount : String)//归还
    case leverFinanceSymbolInfo(symbol : String)//根据币对获取杠杆币对信息
    case leverTransferRecord(symbol : String,coinSymbol : String, transactionType : String,page : String,pageSize : String?)//划转记录
    case leverFinanceTransfer(fromAccount : String,toAccount : String,amount : String,coinSymbol : String,symbol : String)//杠杆划转
    case leverReturnInfo(id : String,page : String,pageSize : String?)//归还明细
    case swapTransfer(type:String,amount:String,bound:String)
    case getCost(symbol:String)
    case etfFaqInfo
    case etfNetValue(base:String,quote:String)//获取etf净值
    case kycConfig
    case getTradeListByOrder(order_id : String,symbol : String,pageSize : String,page : String)//获取币币交易历史委托详情
    case getLeverTradeListByOrder(order_id : String,symbol : String,pageSize : String,page : String)//获取杠杆交易历史委托详情
    case securityFaceToken
    case securityAuthInfo
    case securityAuthCheck(idNumber:String,userName:String,withdrawId:String)
    case gameOpenUrl(gameId:String,token:String)
    case follow_set(trade_currency_id:String,total:String,is_stop_deficit:String,stop_deficit:String,is_stop_profit:String,stop_profit:String,symbol:String,follow_immediately:String,currency:String,timestamp:String,trade_currency:String) // 开始跟单
    case follow_stop(follow_id:String,timestamp:String) // 结束跟单
    case coAgentIndex
    case commonPublic
    case saveAppPushDeveice(cid:String)
    case saveAppPushUser(type:String)
    case userPushSwitch
    case followliveInfo(uid:String)
}


extension AppAPIEndPoint : TargetType {
    
    var baseURL: URL {
//        //todo
//        switch self {
//        case .coAgentIndex:
//            return URL.init(string: "https://www.xfnh.com/")!
//        case .commonPublic:
//            return URL.init(string: "https://www.xfnh.com/")!
//        default:
//            return URL.init(string: EXNetworkDoctor.sharedManager.getAppAPIHost())!
//        }

        return URL.init(string: EXNetworkDoctor.sharedManager.getAppAPIHost())!
    }
    
    var path: String {
        switch self {
        case .publicInfo:
            return "public_info_v4"
        case .listSymbal:
            return "optional/list_symbol"
        case.update_symbol:
            return "optional/update_symbol"
        case .getInvitationImgs:
            return "common/getInvitationImgs"
        case .tradeLimitInfo:
            return "order/trade_limit_info"
        case .loginOne:
            return "user/login_in"
        case .loginTwo:
            return "user/confirm_login"
        case .quickLogin:
            return "app-auth/user/quick_login"
        case .handLogin:
            return "app-auth/user/hand_login"
        case .handOpen(_,_,let afterLogin):
            if afterLogin {
                
                return "auth/app/user/open_hand"
            }else {
                return "auth/app/user/open_hand_two"
            }
        case .getsmsValidCode:
            return "v4/common/smsValidCode"
//            return "common/smsValidCode"
        case .registGetsmsValidCode:
            return "v4/common/smsValidCode"
        case .getemailVallidCode:
            return "v4/common/emailValidCode"
//            return "common/emailValidCode"
        case .registGetemailVallidCode:
            return "v4/common/emailValidCode"
        case .userInfo:
            return "common/user_info"
        case .registerOne:
            return "user/register"
        case .registerTwo:
            return "user/valid_code"
        case .registerThree:
            return "user/confirm_pwd"
        case .forgetPwOne:
            return "user/search_step_one"
        case .forgetPwTwo:
            return "user/search_step_two"
        case .forgetPwThree:
            return "user/search_step_three"
        case .forgetPwFour:
            return "user/search_step_four"
        case .updateNickname:
            return "user/nickname_update"
        case .getAbout:
            return "common/aboutUS"
        case .getAppMail:
            return "message/user_message"
        case .getNewEntrustList:
            return "order/list/new"
        case .otcOrderHistory:
            return "order/otc/bystatus_v4"
        case .getHistoryEntrustList:
            return "v4/order/entrust_history"
        case .createOrder:
            return "order/create"
        case .cancelOrder:
            return "order/cancel"
        case .changepassword:
            return "user/password_update_v4"
        case .getGoogle:
            return "user/toopen_google_authenticator"
        case .openGoogle:
            return "user/google_verify"
        case .closeGoogle:
            return "user/close_google_verify"
        case .openMoblieValidation:
            return "user/open_mobile_verify"
        case .closeMoblie:
            return "user/close_mobile_verify"
        case .bindEmail:
            return "user/email_bind_save"
        case .updateEmail:
            return "user/email_update"
        case .bindPhone:
            return "user/mobile_bind_save"
        case .updatePhone:
            return "user/mobile_update"
        case .openGesture:
            return "auth/app/user/open_hand_one"
        case .closeGesture:
            return "auth/app/user/close_hand"
        case .getmessageType:
            return "message/user_message"
        case .createProblem:
            return "question/create_problem"
        case .getNotice:
            return "notice/notice_info_list"
        case .authRealname:
            return "user/v4/auth_realname"
        case .getNoReadMessageCount:
            return "message/get_no_read_message_count"
        case .getHelp:
            return "cms/list"
        case .financeAccountList:
            return "finance/v4/otc_account_list"
        case .coinIntroduce:
            return "common/coinSymbol_introduce"
        case .getHome:
            return "common/index"
        case .accountBalance:
            return "finance/v5/account_balance"
        case .getChargeAddress:
            return "finance/get_charge_address"
        case .transferScene:
            return "record/ex_transfer_scene_v4"
        case .transferList:
            return "record/ex_transfer_list_v4"
        case .addressList:
            return "addr/address_list"
        case .addWithdrawAddress:
            return "addr/add_withdraw_addr_v4"
        case .doWithDraw:
            return "finance/do_withdraw_v4"
        case .validateWithDrawAddr:
            return "addr/add_withdraw_addr_validate_v4"
        case .financeOtcTransfer:
            return "finance/otc_transfer"
        case .cancelWithDraw:
            return "finance/cancel_withdraw"
        case .depositCancelWithDraw:
            return "fiat/cancel_deposit"
        case .withdrawCancelWithDraw:
            return  "fiat/cancel_withdraw"
        case .deleteWithDrawAddr:
            return "addr/delete_withdraw_addr"
        case .openQuick:
            return "common/check_native_pwd"
        case .messageUpdateStatus:
            return "message/message_update_status"
        case .totalAccountBalance:
            return "finance/total_account_balance"
        case .kycGetToken:
            return "kyc/Api/getToken"
        case .kycGetWriting:
            return "kyc/Api/getUploadImgCopywriting"
        case .getUpdateVersion:
            return "common/getUpdateVersion"
        case .getEntrustHistorySearch:
            return "order/entrust_search"
        case .create_overcharge_onekey:
            return "order/create_overcharge_onekey"
        case .b2cBalance:
            return "fiat/balance"
        case .getUserBankList:
            return "user/bank/user_bank_list"
        case .getFiatWithdrawList:
            return "fiat/withdraw/list"
        case .getFiatDepoistList:
            return "fiat/deposit/list"
        case .fiatDeposit:
            return "fiat/deposit"
        case .getAllBank:
            return "bank/all"
        case .getUserBank:
            return "user/bank/get"
        case .fiatWithdraw:
            return "fiat/withdraw"
        case .getCompanyBankInfo:
            return "company/bank/info"
        case .addUserBank:
            return "user/bank/add"
        case .editUserBank:
            return "user/bank/edit"
        case .deleteUserBank:
            return "user/bank/delete"
        case .getLeverBalance:
            return "lever/finance/symbol/balance"
        case .getLeverOrderHistory:
            return "lever/order/history"
        case .getLeverOrderCurrent:
            return "lever/order/list/new"
        case .cancelLeverOrder:
            return "lever/order/cancel"
        case .creatLeverOrder:
            return "lever/order/create"
        case .leverageBalance:
            return "lever/finance/balance"
        case .leverBorrowHistory:
            return "lever/borrow/history"
        case .leverCurrentBorrow:
            return "lever/borrow/new"
        case .leverFinanceBorrow:
            return "lever/finance/borrow"
        case .leverFinanceReturn:
            return "lever/finance/return"
        case .leverFinanceSymbolInfo:
            return "lever/finance/symbol/balance"
        case .leverTransferRecord:
            return "lever/finance/transfer/list"
        case .leverFinanceTransfer:
            return "lever/finance/transfer"
        case .leverReturnInfo:
            return "lever/return/info"
        case .swapTransfer:
            return "app/co_transfer"
        case .getCost:
            return "cost/Getcost"
        case .etfFaqInfo:
            return "etfAct/faqInfo"
        case .etfNetValue:
            return "etfAct/netValue"
        case .kycConfig:
            return "kyc/config"
        case .getTradeListByOrder:
            return "trade/list_by_order"
        case .getLeverTradeListByOrder:
            return "lever/trade/list_by_order"
        case .securityFaceToken:
            return "security/get_face_token"
        case .securityAuthInfo:
            return "security/get_identity_auth_info"
        case .securityAuthCheck:
            return "security/identity_auth_info_check"
        case .gameOpenUrl:
            return "game/appplay"
        case .follow_set:
            return "inner/follow/set"
        case .follow_stop:
            return "inner/follow/stop"
        case .commonPublic:
            return "app-increment-api/common/public"
        case .coAgentIndex:
            return "app-increment-api/co/agent/index"
        case .saveAppPushDeveice:
            return "appPush/saveAppPushDevice"
        case .userPushSwitch:
            return "appPush/userPushSwitch"
        case .saveAppPushUser:
            return "appPush/saveAppPushUser"
        case .followliveInfo:
            return "app-increment-api/co/trade/income_info"
        }
    }
    
    var method: Moya.Method {        
        switch self {
        case .getAbout:
            return .get
        default:
            return .post
        }
    }
    
    var sampleData: Data {
        return "".data(using: String.Encoding.utf8)!
    }
    
    var task: Task {
        var parameters: [String: Any] = [:]
        switch self {
        case .publicInfo:
            break
        case .listSymbal:
            break
        case.update_symbol(let operationType, let symbols):
            parameters["operationType"] = operationType
            parameters["symbols"] = symbols
           
        case .getInvitationImgs:
            break
        case .tradeLimitInfo(let symbol):
            parameters["symbol"] = symbol
        case .loginOne(let mobileNumber, let loginPword, let geetest_challenge ,let geetest_seccode ,let geetest_validate, let verificationType):
            parameters["mobileNumber"] = mobileNumber
            parameters["loginPword"] = loginPword
            parameters["geetest_challenge"] = geetest_challenge
            parameters["geetest_seccode"] = geetest_seccode
            parameters["geetest_validate"] = geetest_validate
            if verificationType != ""{
                parameters["verificationType"] = verificationType
            }
        case .loginTwo(let token , let checkType , let authCode, let googleCode, let smsCode, let emailCode, let idCardCode):
            parameters["token"] = token
            parameters["checkType"] = checkType
            parameters["authCode"] = authCode
            if let gCode = googleCode {
                parameters["googleCode"] = gCode
            }
            if let sCode = smsCode {
                parameters["smsCode"] = sCode
            }
            if let eCode = emailCode {
                parameters["emailCode"] = eCode
            }
            if let idCode = idCardCode {
                parameters["idCardCode"] = idCode
            }
        case .quickLogin(let quickToken):
            parameters["quicktoken"] = quickToken
        case .handLogin(let quickToken ,let handPwd):
            parameters["quicktoken"] = quickToken
            parameters["handPwd"] = handPwd
        case .handOpen(let quickToken ,let handPwd, let afterLogin):
            if afterLogin {
                parameters["quicktoken"] = quickToken
                
            }else {
                parameters["token"] = quickToken
            }
            parameters["handPwd"] = handPwd
        case .getsmsValidCode(let token , let operationType , let countryCode , let mobile):
            if token != ""{
                parameters["token"] = token
            }
            if countryCode != ""{
                parameters["countryCode"] = countryCode
            }
            if mobile != ""{
                parameters["mobile"] = mobile
            }
            parameters["operationType"] = operationType
        case .registGetsmsValidCode(let token ,let operationType ,let countryCode ,let mobile,let verificationType,let geetest_challenge, let geetest_seccode,let geetest_validate):
            if token != ""{
                parameters["token"] = token
            }
            if countryCode != ""{
                parameters["countryCode"] = countryCode
            }
            if mobile != ""{
                parameters["mobile"] = mobile
            }
            parameters["operationType"] = operationType
            
            parameters["verificationType"] = verificationType
            parameters["geetest_challenge"] = geetest_challenge
            parameters["geetest_seccode"] = geetest_seccode
            parameters["geetest_validate"] = geetest_validate
            
        case .registGetemailVallidCode(let email,let operationType,let token,let verificationType,let geetest_challenge,let geetest_seccode,let geetest_validate):
            if email != ""{
                parameters["email"] = email
            }
            parameters["operationType"] = operationType
            if token != ""{
                parameters["token"] = token
            }
            
            parameters["verificationType"] = verificationType
            parameters["geetest_challenge"] = geetest_challenge
            parameters["geetest_seccode"] = geetest_seccode
            parameters["geetest_validate"] = geetest_validate
            
        case .getemailVallidCode(let email , let operationType , let token):
            if email != ""{
                parameters["email"] = email
            }
            parameters["operationType"] = operationType
            if token != ""{
                parameters["token"] = token
            }
        case .userInfo():
            break
        case .registerOne(let verificationType  ,let  geetest_challenge  ,let  geetest_seccode  ,let  geetest_validate  ,let  email  ,let  mobile ,let  country ):
            if email != ""{
                parameters["email"] = email
            }
            if verificationType != ""{
                parameters["verificationType"] = verificationType
            }
            if mobile != ""{
                parameters["mobile"] = mobile
            }
            if country != ""{
                parameters["country"] = country
            }
            parameters["geetest_challenge"] = geetest_challenge
            parameters["geetest_seccode"] = geetest_seccode
            parameters["geetest_validate"] = geetest_validate
        case .registerTwo(let registerCode , let numberCode):
            parameters["registerCode"] = registerCode
            parameters["numberCode"] = numberCode
        case .registerThree(let registerCode ,let loginPword ,let newPassword ,let invitedCode):
            parameters["registerCode"] = registerCode
            parameters["loginPword"] = loginPword
            parameters["newPassword"] = newPassword
            parameters["invitedCode"] = invitedCode
        case .forgetPwOne(let verificationType ,let geetest_challenge ,let geetest_seccode ,let geetest_validate ,let registerCode):
            parameters["verificationType"] = verificationType
            parameters["registerCode"] = registerCode
            parameters["geetest_challenge"] = geetest_challenge
            parameters["geetest_seccode"] = geetest_seccode
            parameters["geetest_validate"] = geetest_validate
//        case .forgetPwOne(let verificationType ,let mobileNumber ,let  geetest_challenge ,let  geetest_seccode , let geetest_validate ,let email)://忘记密码第一步
//            if email != ""{
//                parameters["email"] = email
//            }
//            if mobileNumber != ""{
//                parameters["mobileNumber"] = mobileNumber
//            }
//            parameters["verificationType"] = verificationType
//            parameters["geetest_challenge"] = geetest_challenge
//            parameters["geetest_seccode"] = geetest_seccode
//            parameters["geetest_validate"] = geetest_validate
        case .forgetPwTwo(let token ,let numberCode):
            parameters["token"] = token
            parameters["numberCode"] = numberCode
//        case .forgetPwTwo(let token ,let smsCode ,let emailCode)://忘记密码第二步
//            parameters["token"] = token
//            if smsCode != ""{
//                parameters["smsCode"] = smsCode
//            }
//            if emailCode != ""{
//                parameters["emailCode"] = emailCode
//            }
        case .forgetPwThree(let token ,let certifcateNumber ,let googleCode):
            parameters["token"] = token
            if certifcateNumber != ""{
                parameters["certifcateNumber"] = certifcateNumber
            }
            if googleCode != ""{
                parameters["googleCode"] = googleCode
            }
        case .forgetPwFour(let token ,let loginPword ,let newPassword ):
            parameters["token"] = token
            parameters["loginPword"] = loginPword
            parameters["newPassword"] = newPassword
        case .updateNickname(let nickname):
            parameters["nickname"] = nickname
        case .getAbout:
            break
        case .getAppMail(let messageType ,let pageSize ,let page):
            parameters["messageType"] = messageType
            parameters["pageSize"] = pageSize
            parameters["page"] = page
        case .getNewEntrustList(let symbol, let pageSize , let page):
            parameters["symbol"] = symbol
            parameters["pageSize"] = pageSize
            parameters["page"] = page
        case .otcOrderHistory(let page,let type, let symbol, let currency,let status,let begin,let end,let pageSize):
            parameters["page"] = page
            if let size = pageSize {
                parameters["pageSize"] = size
            }else {
                parameters["pageSize"] = "20"
            }
    
            if let symbol = symbol,!symbol.isEmpty {
                parameters["coinSymbol"] = symbol
            }
            if let currency = currency, currency != "ALL",currency.count > 0 {
                parameters["payCoin"] = currency
            }
            if let status = status, status != "ALL" {
                parameters["status"] = status
            }
            if let tradeType = type, tradeType != "ALL" {
                parameters["tradeType"] = tradeType
            }
            if let startTime = begin, let endTime = end,startTime.count > 0, endTime.count > 0 {
                parameters["startTime"] = startTime
                parameters["endTime"] = endTime
            }
            break
        case .getHistoryEntrustList(let symbol, let pageSize , let page ,let isShowCanceled ,let side ,let type ,let startTime ,let endTime):
            parameters["symbol"] = symbol
            parameters["pageSize"] = pageSize
            parameters["page"] = page
            parameters["isShowCanceled"] = isShowCanceled
            parameters["side"] = side
            parameters["type"] = type
            parameters["startTime"] = startTime
            parameters["endTime"] = endTime
        case .createOrder(let side ,let type ,let volume ,let price ,let symbol):
            parameters["side"] = side
            parameters["type"] = type
            parameters["volume"] = volume
            parameters["price"] = price
            parameters["symbol"] = symbol
        case .cancelOrder(let orderId ,let symbol):
            parameters["orderId"] = orderId
            parameters["symbol"] = symbol
        case .changepassword(let loginPword ,let newLoginPword ,let smsAuthCode ,let googleCode , let IdentificationNumber):
            parameters["loginPword"] = loginPword
            parameters["newLoginPword"] = newLoginPword
            parameters["smsAuthCode"] = smsAuthCode
            parameters["googleCode"] = googleCode
            if IdentificationNumber != ""{
                parameters["IdentificationNumber"] = IdentificationNumber
            }
        case .getGoogle():
            break
        case .openGoogle(let loginPwd ,let googleCode ,let googleKey):
            parameters["loginPwd"] = loginPwd
            parameters["googleCode"] = googleCode
            parameters["googleKey"] = googleKey
        case .closeGoogle(let smsValidCode ,let googleCode):
            parameters["smsValidCode"] = smsValidCode
            parameters["googleCode"] = googleCode
        case .openMoblieValidation():
            break
        case .closeMoblie(let smsValidCode ,let googleCode):
            parameters["smsValidCode"] = smsValidCode
            parameters["googleCode"] = googleCode
        case .bindEmail(let smsValidCode,let googleCode,let emailValidCode,let email):
            parameters["smsValidCode"] = smsValidCode
            parameters["googleCode"] = googleCode
            parameters["emailValidCode"] = emailValidCode
            parameters["email"] = email
        case .updateEmail(let emailOldValidCode,let emailNewValidCode,let smsValidCode,let googleCode,let emailValidCode,let email):
            parameters["emailOldValidCode"] = emailOldValidCode
            parameters["emailNewValidCode"] = emailNewValidCode
            parameters["smsValidCode"] = smsValidCode
            parameters["googleCode"] = googleCode
            parameters["emailValidCode"] = emailValidCode
            parameters["email"] = email
        case .bindPhone(let googleCode ,let countryCode ,let mobileNumber ,let smsAuthCode):
            if googleCode != ""{
                parameters["googleCode"] = googleCode
            }
            parameters["countryCode"] = countryCode
            parameters["mobileNumber"] = mobileNumber
            parameters["smsAuthCode"] = smsAuthCode
        case .updatePhone(let authenticationCode ,let googleCode ,let countryCode ,let mobileNumber ,let smsAuthCode):
            parameters["googleCode"] = googleCode
            parameters["countryCode"] = countryCode
            parameters["mobileNumber"] = mobileNumber
            parameters["smsAuthCode"] = smsAuthCode
            parameters["authenticationCode"] = authenticationCode
        case .openGesture(let loginPwd,let smsValidCode,let googleCode , let uid):
            parameters["loginPwd"] = loginPwd
            if smsValidCode != ""{
                parameters["smsValidCode"] = smsValidCode
            }
            if googleCode != ""{
                parameters["googleCode"] = googleCode
            }
            parameters["uid"] = uid
            parameters["nativePwd"] = loginPwd
        case .closeGesture(let loginPwd,let smsValidCode,let googleCode):
            parameters["loginPwd"] = loginPwd
            parameters["smsValidCode"] = smsValidCode
            parameters["googleCode"] = googleCode
        case .getmessageType(let messageType):
            parameters["messageType"] = messageType
        case .createProblem(let rqType, let rqDescribe, let imageDataStr, let rqUnreleased, let rqUnpaid):
            parameters["rqType"] = rqType
            parameters["rqDescribe"] = rqDescribe
            if let imgUrl = imageDataStr {
                parameters["imageDataStr"] = imgUrl
            }
            if let unreleased = rqUnreleased {
                parameters["rqUnreleased"] = unreleased
            }
            if let unpaid = rqUnpaid {
                parameters["rqUnpaid"] = unpaid
            }
        case .getNotice(let page,let pagesize):
            parameters["page"] = page
            parameters["pagesize"] = pagesize
        case .authRealname(let countryCode ,let certificateType ,let userName ,let certificateNumber ,let firstPhoto ,let secondPhoto ,let thirdPhoto , let familyName , let name , let numberCode):
            parameters["countryCode"] = countryCode
            parameters["certificateType"] = certificateType
            if userName != ""{
                parameters["userName"] = userName
            }
            if familyName != ""{
                parameters["familyName"] = familyName
            }
            if name != ""{
                parameters["name"] = name
            }
            parameters["certificateNumber"] = certificateNumber
            parameters["firstPhoto"] = firstPhoto
            parameters["secondPhoto"] = secondPhoto
            parameters["thirdPhoto"] = thirdPhoto
            parameters["numberCode"] = numberCode
        case .getNoReadMessageCount:
            break
        case .getHelp:
            break
        case .financeAccountList:
            break
        case .coinIntroduce(let coinSymbol):
            parameters["coinSymbol"] = coinSymbol
        case .getHome:
            break
        case .accountBalance(let coinsymbols):
            if let symbol = coinsymbols {
                parameters["coinSymbols"] = symbol
            }
            break
        case .getChargeAddress(let symbol):
            parameters["symbol"] = symbol
        case .transferScene:
            break
        case .transferList(let coinSymbol, let transactionScene, let startTime, let endTime, let page):
            parameters["transactionScene"] = transactionScene
            parameters["page"] = page
            parameters["pageSize"] = "20"
            if let begin = startTime, let end = endTime {
                parameters["startTime"] = begin
                parameters["endTime"] = end
            }
            if let symbol = coinSymbol {
                 parameters["coinSymbol"] = symbol
            }
        case .addressList(let coinSymbol):
            parameters["coinSymbol"] = coinSymbol
        case .addWithdrawAddress(let address, let label, let smsValidCode,let emailValidCode, let googleCode, let coinSymbol, let trust):
            parameters["address"] = address
            parameters["coinSymbol"] = coinSymbol
            parameters["label"] = label
            parameters["trustType"] = trust ? "1" : "0"
            if let sms = smsValidCode {
                parameters["smsValidCode"] = sms
            }
            if let emailCode = emailValidCode {
                parameters["emailValidCode"] = emailCode
            }
            if let google = googleCode {
                parameters["googleValidCode"] = google
            }
        case .doWithDraw(let address, let trustType, let remark, let symbol, let fee,let amount,let smsVaildCode, let googleValidCode, let emailValidCode, let addressID):
            parameters["address"] = address
            parameters["label"] = remark
            parameters["symbol"] = symbol
            parameters["fee"] = fee
            parameters["amount"] = amount
            
            if let trust = trustType {
                parameters["trustType"] = trust
            }
            if let sms = smsVaildCode {
                parameters["smsValidCode"] = sms
            }
            if let emailCode = emailValidCode {
                parameters["emailValidCode"] = emailCode
            }
            if let google = googleValidCode {
                parameters["googleCode"] = google
            }
            if let addressid = addressID,addressid.count > 0 {
                parameters["addressId"] = addressid
            }
        case .validateWithDrawAddr(let address, let symbol):
            parameters["address"] = address
            parameters["coinSymbol"] = symbol
        case .financeOtcTransfer(let fromAccount, let toAccount, let amount, let coinSymbol):
            parameters["fromAccount"] = fromAccount
            parameters["toAccount"] = toAccount
            parameters["amount"] = amount
            parameters["coinSymbol"] = coinSymbol
        case .cancelWithDraw(let withDrawId):
            parameters["withdrawId"] = withDrawId
        case .depositCancelWithDraw(let withDrawId):
            parameters["id"] = withDrawId
        case .withdrawCancelWithDraw(let withDrawId):
            parameters["id"] = withDrawId
        case .deleteWithDrawAddr(let ids, let googleCode, let smsCode):
            parameters["ids"] = ids
            if let sms = smsCode {
                parameters["smsValidCode"] = sms
            }
            if let google = googleCode {
                parameters["googleCode"] = google
            }
        case .openQuick(let loginPwd,let smsValidCode,let googleCode , let uid):
            parameters["loginPwd"] = loginPwd
            if smsValidCode != ""{
                parameters["smsValidCode"] = smsValidCode
            }
            if googleCode != ""{
                parameters["googleCode"] = googleCode
            }
            parameters["uid"] = uid
            parameters["nativePwd"] = loginPwd
        case .messageUpdateStatus(let id):
            parameters["id"] = id
        case .totalAccountBalance:
            break
        case .kycGetToken:
            break
        case .kycGetWriting:
            break
        case .getUpdateVersion:
            break
        case .getEntrustHistorySearch(let page ,let pageSize ,let entrust ,let side ,let symbol ,let orderType ,let status ,let isShowCanceled ,let quote ,let type):
            parameters["page"] = page
            parameters["pageSize"] = pageSize
            parameters["entrust"] = entrust
            parameters["orderType"] = orderType

            if side != ""{
                parameters["side"] = side
            }
            if symbol != ""{
                parameters["symbol"] = symbol
            }
            if status != ""{
                parameters["status"] = status
            }
            if isShowCanceled != ""{
                parameters["isShowCanceled"] = isShowCanceled
            }
            if quote != ""{
                parameters["quote"] = quote
            }
            if type != ""{
                parameters["type"] = type
            }
        case .create_overcharge_onekey(let symbol):
            parameters["symbol"] = symbol
        case .b2cBalance(let symbol) :
            if symbol != ""{
                parameters["symbol"] = symbol
            }
        case .getUserBankList(let symbol, let page, let pageSize):
            parameters["symbol"] = symbol
            parameters["page"] = page
            parameters["pageSize"] = pageSize
        case .getFiatWithdrawList(let symbol ,let page ,let pageSize,let startTime ,let endTime):
            parameters["symbol"] = symbol
            parameters["page"] = page
            parameters["pageSize"] = pageSize
            if let startTime = startTime,startTime.count > 0{
                parameters["startTime"] = startTime
            }
            if let endTime = endTime, endTime.count > 0 {
                parameters["endTime"] = endTime
            }
        case .getFiatDepoistList(let symbol ,let page ,let pageSize,let startTime ,let endTime):
            parameters["symbol"] = symbol
            parameters["page"] = page
            parameters["pageSize"] = pageSize
            if let startTime = startTime,startTime.count > 0{
                parameters["startTime"] = startTime
            }
            if let endTime = endTime, endTime.count > 0 {
                parameters["endTime"] = endTime
            }
        case .fiatDeposit(let symbol ,let transferVoucher ,let amount):
            parameters["symbol"] = symbol
            parameters["transferVoucher"] = transferVoucher
            parameters["amount"] = amount
        case .getAllBank(let symbol):
            parameters["symbol"] = symbol
        case .getUserBank(let id):
            parameters["id"] = id
        case .fiatWithdraw(let symbol,let userWithdrawBankId ,let amount ,let smsAuthCode ,let googleCode):
            parameters["symbol"] = symbol
            parameters["userWithdrawBankId"] = userWithdrawBankId
            parameters["amount"] = amount
            if smsAuthCode != ""{
                parameters["smsAuthCode"] = smsAuthCode
            }
            if googleCode != ""{
                parameters["googleCode"] = googleCode
            }
        case .getCompanyBankInfo(let symbol):
            parameters["symbol"] = symbol
        case .addUserBank(let bankId,let bankSub,let cardNo,let name,let symbol,let smsAuthCode,let googleCode):
            parameters["bankId"] = bankId
            parameters["bankSub"] = bankSub
            parameters["cardNo"] = cardNo
            parameters["name"] = name
            parameters["symbol"] = symbol
            if smsAuthCode != ""{
                parameters["smsAuthCode"] = smsAuthCode
            }
            if googleCode != ""{
                parameters["googleCode"] = googleCode
            }
        case .editUserBank(let id,let bankId,let bankSub,let cardNo,let name,let symbol,let smsAuthCode,let googleCode):
            parameters["id"] = id
            parameters["bankId"] = bankId
            parameters["bankSub"] = bankSub
            parameters["cardNo"] = cardNo
            parameters["name"] = name
            parameters["symbol"] = symbol
            if smsAuthCode != ""{
                parameters["smsAuthCode"] = smsAuthCode
            }
            if googleCode != ""{
                parameters["googleCode"] = googleCode
            }
        case .deleteUserBank(let id):
            parameters["id"] = id
        case .getLeverBalance(let symbol):
            parameters["symbol"] = symbol
        case .getLeverOrderHistory(let page ,let pageSize ,let symbol ,let isShowCanceled ,let side , let type):
            parameters["page"] = page
            parameters["pageSize"] = pageSize
            parameters["symbol"] = symbol
            if isShowCanceled != ""{
                parameters["isShowCanceled"] = isShowCanceled
            }
            if side != ""{
                parameters["side"] = side
            }
            if type != ""{
                parameters["type"] = type
            }
        case .getLeverOrderCurrent(let symbol ,let pageSize ,let page):
            parameters["page"] = page
            parameters["pageSize"] = pageSize
            parameters["symbol"] = symbol
        case .cancelLeverOrder(let orderId ,let symbol):
            parameters["orderId"] = orderId
            parameters["symbol"] = symbol
        case .creatLeverOrder(let side ,let type ,let volume ,let price ,let symbol):
            parameters["side"] = side
            parameters["type"] = type
            parameters["volume"] = volume
            parameters["price"] = price
            parameters["symbol"] = symbol
        case .leverageBalance:
             break
        case let .leverBorrowHistory(symbol, startTime, endTime, page, pageSize):
            parameters["symbol"] = symbol
            parameters["page"] = page
            if let startTime = startTime,let endTime = endTime,startTime.count > 0, endTime.count > 0 {
                parameters["startTime"] = startTime
                parameters["endTime"] = endTime
            }
            if let pageSize = pageSize {
                parameters["pageSize"] = pageSize
            }else {
                parameters["pageSize"] = "20"//默认
            }
        case let .leverCurrentBorrow(symbol, startTime, endTime, page, pageSize):
            parameters["symbol"] = symbol
            parameters["page"] = page
            if let startTime = startTime,let endTime = endTime,startTime.count > 0, endTime.count > 0 {
                parameters["startTime"] = startTime
                parameters["endTime"] = endTime
            }
            if let pageSize = pageSize {
                parameters["pageSize"] = pageSize
            }else {
                parameters["pageSize"] = "20"//默认
            }
        case let .leverFinanceBorrow(symbol, coin, amount):
            parameters["symbol"] = symbol
            parameters["coin"] = coin
            parameters["amount"] = amount
        case let .leverFinanceReturn(id, amount):
            parameters["id"] = id
            parameters["amount"] = amount
        case let .leverFinanceSymbolInfo(symbol):
            parameters["symbol"] = symbol
        case let .leverTransferRecord(symbol,coinSymbol, transactionType, page, pageSize):
            parameters["symbol"] = symbol
            parameters["coinSymbol"] = coinSymbol
            parameters["transactionType"] = transactionType
            parameters["page"] = page
            if let pageSize = pageSize {
                parameters["pageSize"] = pageSize
            }
        case let .leverFinanceTransfer(fromAccount, toAccount, amount, coinSymbol, symbol):
            parameters["fromAccount"] = fromAccount
            parameters["toAccount"] = toAccount
            parameters["amount"] = amount
            parameters["coinSymbol"] = coinSymbol
            parameters["symbol"] = symbol
        case let .leverReturnInfo(id, page, pageSize):
            parameters["id"] = id
            parameters["page"] = page
             if let pageSize = pageSize {
               parameters["pageSize"] = pageSize
            }
        case let .swapTransfer(type, amount, bound):
            parameters["transferType"] = type
            parameters["amount"] = amount
            parameters["coinSymbol"] = bound
            break
        case let .getCost(symbol):
            parameters["symbol"] = symbol
        case .etfFaqInfo:
            break
        case .etfNetValue(let base , let quote):
            parameters["base"] = base
            parameters["quote"] = quote
        case .kycConfig:
            break
        case .getTradeListByOrder(let order_id,let symbol ,let pageSize ,let page):
            parameters["order_id"] = order_id
            parameters["symbol"] = symbol
            parameters["pageSize"] = pageSize
            parameters["page"] = page
        case .getLeverTradeListByOrder(let order_id,let symbol ,let pageSize ,let page):
            parameters["order_id"] = order_id
            parameters["symbol"] = symbol
            parameters["pageSize"] = pageSize
            parameters["page"] = page
        case .securityAuthInfo:
            break
        case .securityFaceToken:
            break
        case .securityAuthCheck(let idNumber, let userName, let withdrawId):
            parameters["idNumber"] = idNumber
            parameters["userName"] = userName
            parameters["withdrawId"] = withdrawId
            break
        case let .gameOpenUrl(gameId,token):
            parameters["gameId"] = gameId
            parameters["token"] = token
            break
        case .follow_set(let trade_currency_id,let  total,let  is_stop_deficit, let  stop_deficit,let  is_stop_profit,let  stop_profit,let  symbol, let  follow_immediately, let currency, let timestamp, let trade_currency):
            parameters["trade_currency_id"] = trade_currency_id
            parameters["total"] = total
            parameters["is_stop_deficit"] = is_stop_deficit
            parameters["stop_deficit"] = stop_deficit
            parameters["is_stop_profit"] = is_stop_profit
            parameters["stop_profit"] = stop_profit
            parameters["symbol"] = symbol
            parameters["follow_immediately"] = follow_immediately
            parameters["currency"] = currency
            parameters["timestamp"] = timestamp
            parameters["trade_currency"] = trade_currency
            break
        case .follow_stop(let follow_id, let timestamp):
            parameters["follow_id"] = follow_id
            parameters["timestamp"] = timestamp
            break
        case .coAgentIndex:
            break
        case .commonPublic:
            break
        case .saveAppPushDeveice(let cid):
            parameters["cid"] = cid
        case .userPushSwitch:
            break
        case .saveAppPushUser(let type):
            parameters["type"] = type
            break
        case .followliveInfo(let uid):
            parameters["uid"] = uid
            break
        }
        
        
        if self.method == .post {
            return .requestParameters(parameters: NetManager.sharedInstance.handleParamter(parameters), encoding: JSONEncoding.default)
        }else {
            switch self {
            case .getAbout:
                return .requestParameters(parameters: NetManager.sharedInstance.handleParamter(parameters), encoding:URLEncoding.queryString )
            default:
                return .requestParameters(parameters: NetManager.sharedInstance.handleParamter(parameters), encoding:URLEncoding.httpBody )
            }
        }
    }
    
    var headers: [String : String]? {
        let header = NetManager.sharedInstance.getHeaderParams()
        return header
    }
    
}
