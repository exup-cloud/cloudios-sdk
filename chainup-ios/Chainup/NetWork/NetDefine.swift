//
//  NetDefine.swift
//  AppProject
//
//  Created by zewu wang on 2018/7/31.
//  Copyright © 2018年 zewu wang. All rights reserved.
//

import UIKit

 public class NetDefine: NSObject {

    //网站主部署的用于验证登录的接口 (api_1)
    //网站主部署的二次验证的接口 (api_2)

    //#if debug
    //https://rd1appapi.chaindown.com
    //https://appapi.bikicoin.pro
    //static let http_host_url = "https://appapi.biki.com/exchange-app-api/"//币币
    //staging2appapi.chaindown.com
    //staging2otcappapi.chaindown.com
    //appapi.mpuuss.top
    //http://appapird3.chaindown.com/

//    static let http_host_url = "https://appapi0001321.lcuiww.top/"
    static let http_host_url = "http://appapi.hiup.pro/"
    @objc static let  api_1 = http_host_url + "common/tartCaptcha"

    @objc class func domain_host_url() -> String{
        var hosturl = ""
        if let url = URL.init(string: EXNetworkDoctor.sharedManager.getAppAPIHost()) , let host = url.host{
            let index = host.positionOf(sub: ".")
            hosturl = host.extStringSub(NSRange.init(location: index, length: host.count - index))
        }
        return hosturl
    }


//    static let http_host_url_otc = "https://otcappapi0001006.hiup.pro/"//otc
//
//    static let wss_host_url = "wss://ws0001321.lcuiww.top/kline-api/ws"//币币ws

    static let http_host_url_otc = "http://otcappapi.hiup.pro/"//otc
    
    static let wss_host_url = "wss://ws.hiup.pro/kline-api/ws"//币币ws
    
    static let wss_host_url2 = "wss://ws2.hiup.pro/otc-chat/chatServer/"//otc聊天ws

    static let http_host_url_contract = "http://swap.hiup.pro/" //合约
    
    static let wss_host_contract = "ws://ws3.hiup.pro/wsswap/realTime" //合约ws
    
    static let http_host_url_redpacket = "http://service.hiup.pro/hongbaoapi/"//红包

    
    //公共
    static let common = "common/"
    
    static let index = "index"//首页
    
    static let header_symbol = "header_symbol"//头部币对24小时行情
    
    static let trade_list = "trade_list_v4"//涨跌幅榜和成交量榜单
    
    static let get_country_info = "get_country_info"//获取国家区号信息
    
    static let public_info = "public_info_v4"//公告接口
//    public_info_v4
    static let getVersion = "common/getVersion"//获取版本号
    /*
     1-手机号码注册
     2-绑定手机号码
     3-修改手机号码
     4-绑定邮箱
     5-修改登录密码
     6-设置资金密码
     7-修改资金密码
     8-设置交易验证
     9-修改密码
     10-提币
     11-添加数字货币地址
     12-修改数字货币地址
     13-数字货币提现
     14-关闭手机验证
     15-修改邮箱
     16-操作OpenApi
     24-找回密码
     25-手机登录
     26-关闭谷歌认证
     27-操作手势密码
     */
    static let smsValidCode = "smsValidCode"//获取手机验证码
    
    static let emailValidCode = "emailValidCode"//获取邮箱验证码
    
    static let contact_number = "contact_number"//获取电话
    
    static let user_info = "user_info"//用户基本信息
    
    static let upload_img = "upload_img"//上传图片
    
    static let terms = "terms"//服务条款 免责声明 隐私保护
        
    //登录注册
    static let user = "user/"//user
    
    static let register = "register"//注册第一步
    
    static let valid_code = "valid_code"//注册第二步
    
    static let confirm_pwd = "confirm_pwd"//注册第三步
    
    static let search_step_one = "search_step_one"//找回密码第一步
    
    static let search_step_two = "search_step_two"//找回密码第二步
    
    static let search_step_three = "search_step_three"//找回密码第三步
    
    static let search_step_four = "search_step_four"//找回密码第四步
    
    static let login_mobile = "login_in"//登录
    
    static let reg_mobile = "reg_mobile"//手机注册
    
    static let reg_email = "reg_email"//邮箱注册
    
    static let confirm_login = "confirm_login"//二次登录
    
    static let nickname_update = "nickname_update"//修改昵称
    
    static let auth_realname = "auth_realname"//实名认证
    
    static let password_update = "password_update"//修改密码
    
    static let google_verify = "google_verify"//开启谷歌验证
    
    static let close_google_verify = "close_google_verify"//关闭谷歌验证
    
    static let toopen_google_authenticator = "toopen_google_authenticator"//获取谷歌验证码
    
    static let open_handPwd_V2 = "open_handPwd_V2"//登录后开启手势密码2
    static let close_handPwd_verify = "close_handPwd_verify"//关闭手势密码
    static let close_mobile_verify = "close_mobile_verify"//关闭手机验证
    
    static let mobile_bind_save = "mobile_bind_save"//绑定手机
    
    static let mobile_update = "mobile_update"//修改手机
    
    static let open_mobile_verify = "open_mobile_verify"//开启手机验证
    
    static let email_bind_save = "email_bind_save"//绑定邮箱
    
    static let email_update = "email_update"//更换邮箱
    
    static let reset_password_step_one = "reset_password_step_one"//忘记密码1
    
    static let reset_password_step_two = "reset_password_step_two"//忘记密码2

    static let reset_password_step_three = "reset_password_step_three"//忘记密码3
    
    //个人信息
    static let message = "message/"//消息
    
    static let user_message = "user_message"//消息中心
    
    static let cms = "cms/"
    
    static let list = "list"//帮助中心
    
    static let info = "info"//帮助中心详情
    
    static let notice = "notice/"
    
    static let notice_info_list = "notice_info_list"//公告列表
    
    //资产
    static let finance = "finance/"
    
    static let account_balance = "account_balance"//获取资产
    
    static let get_charge_address = "get_charge_address" // 获取充值地址

    //成交
    static let trade = "trade/"
    
    static let list_by_order = "list_by_order"////根据订单号获取成交记录
    
    //交易
    static let order = "order/"
    
    static let list_new = "list/new"//获取当前委托
    
    static let entrust_history = "entrust_history"//获取历史委托
    
    static let create = "create"//创建订单
    
    static let cancel = "cancel"//取消订单
    
    //记录
    static let record = "record/"
    
    static let deposit_list = "deposit_list"//充值记录
    static let deposit_detail = "deposit_detail" //币宝流水记录
    static let withdraw_list = "withdraw_list"//提现记录
    
    static let other_transfer_list = "other_transfer_list_V2"//其他交易
    static let other_transfer_scene = "other_transfer_scene_V2" //其它流水-对应流水类型
    static let otc_transfer_list = "otc_transfer_list";

    //公共
    static let xpublic = "public/"
    
    //添加地址
    static let add_withdraw_addr = "addr/add_withdraw_addr"
    
    static let address_list = "addr/address_list"
    static let do_withdraw = "finance/do_withdraw"
    static let delete_withdraw_addr = "addr/delete_withdraw_addr"
    
    
    static let kv_common = "common/kv?key=h5_url"
    
    static let noticeDetail = "notice/detail"//app公告详情页

    static let isInviteCodeNeed = "common/isInviteCodeNeed" //查询后台是否开启邀请码必填
    static let clean_handPwd = "user/clean_handPwd" //清空用户手势密码
 

    static let pwd_same = "common/check_native_pwd" //  指纹或者人脸识别时，验证本地密码
    static let gesturePwd_is_same = "common/gesturePwd" //判断用户id与手势密码是否相符
    
    static let get_aboutus = "aboutUS" //关于我们
    
    static let rate = "rate" 

    //
    
   static let login_AI = "login_AI" //指纹或者人脸识别

    static let get_image_token = "get_image_token"//获取图片临时token

}

//otc
extension NetDefine{
    
    static let otc = "otc/"
    
    static let otc_search = "search" //首页
    
    static let confirm_order = "confirm_order"//确认打币
    
    static let complain_cancel = "complain_cancel"//取消申诉
    
    static let otc_public_info = "public_info"//公共接口
    static let capital_password_set = "capital_password/set" //设置资金密码
    
    static let wanted_detail = "wanted_detail"//广告详情
    
    static let buy_order_save = "buy_order_save"//生成购买订单
    
    static let sell_order_save = "sell_order_save"//生成出售订单
    
    static let capital_password_reset = "capital_password/reset" //-重置资金密码
    static let otc_payment_add = "payment/add"  //新增支付方式
    static let otc_payment_update = "payment/update" //-- 修改支付方式
    static let otc_payment_find = "payment/find" //  查询用户支付方式
    
    static let otc_payment_delete = "payment/delete" //-- 删除支付方式
    
    static let otc_payment_open = "payment/open" // 支付方式开关设置
    
    static let order_detail = "order_detail"//订单详情数据
    
    static let deposit_account = "finance/deposit_account" //币宝账户资产

    static let otc_account_list = "finance/otc_account_list"//场外账户
    
    static let otc_upload_qrcode = "common/upload_img_base64"  //二维码上传
    
    
    static let otc_person_relationship = "person_relationship" //- 获取黑名单-OK
    
    static let otc_user_contacts_remove = "user_contacts_remove" //- 从黑白名单移除-OK
    
    static let otc_user_contacts = "user_contacts" //添加
    
    
    static let otc_get_account_by_coin = "finance/get_account_by_coin" //-获取某币种的交易账户
    
    static let deposit_transfer =  "finance/deposit_transfer" //余额账户划转币宝账户接口

    static let otc_transfer =  "finance/otc_transfer" //场外资金划转
    
    static let otc_person_home_page =   "person_home_page" //- 个人主页用户基本信息显示-OK
    
    static let order_payed = "order_payed"//确认支付
    static let order_cancel = "order_cancel"//取消订单
    
    static let otc_complain_order =   "complain_order" //- 申诉修改订单状态 - OK
    
    //场外聊天
    static let chatMsg = "chatMsg/"
    
    static let otcmessage = "message"//场外聊天历史记录
    
    //问题
    static let question = "question/"
    
    static let details_problem = "details_problem"//问题详情页
    
    static let create_problem =  "question/create_problem" //-发起提问
    
    static let reply_create = "reply_create"//追加提问
    
    
    static let order_bystatus = "order/otc/bystatus" //- 根据订单状态查询场外订单
    
    
}

//合约
extension NetDefine{
    
    static let uri = ""
    
    static let capital_transfer = "capital_transfer"//划转
    
    static let contract_account_balance = "account_balance"//账户余额
    static let contract_public_info = "contract_public_info"//公共配置

    static let business_transation_list = "business_transation_list"//资金流水
    
//    static let account_balance = "account_balance"//账户余额
    
    static let hold_contract_list = "hold_contract_list"//用户未平仓合约
    
    static let tag_price = "tag_price"//标记价格
    
}
