//
//  EXSendVerificationCode.swift
//  Chainup
//
//  Created by zewu wang on 2019/4/12.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import UIKit

class EXSendVerificationCode: NSObject {
    static let changepassword = "5"//修改登录密码验证码
    static let moblieforget = "24"//手机忘记验证码
    static let emailforget = "3"//邮箱忘记验证码
    static let regist = "1"//注册账号
    static let moblielogin = "25"//手机登录验证码
    static let emaillogin = "4"//邮箱登录验证码
    static let changeotcpw = "6"//设置资金密码验证码
    static let closegoogleAndmoblie = "27"//关闭谷歌和手机认证
    static let updateemailwithemail = "15"//绑定邮箱 新老邮箱验证
    static let updateemailwithphone = "4"//绑定邮箱 手机验证
    static let updatephonewithphone = "3"//绑定手机 手机验证
    static let addNewAddress = "11"//添加币币地址
    static let updateNewAddress = "12"//修改币币地址
    static let withDraw = "13"//添加币币地址
    static let otcAddPayment = "28"// otc添加支付方式
    static let b2cwithDraw = "32"//法币提现
    static let b2caddbank = "30"//法币添加银行卡
    static let b2ceditbank = "31"//法币修改银行卡
}

class EXMailVerificationCode: NSObject {
    static let registerByEmail = "1"//邮箱注册
    static let bindEmail = "2"//绑定邮箱
    static let findPwd = "3"//找回密码
    static let emailLogin = "4"//邮箱登陆
    static let relogin = "9"//二次登陆
    static let addCoinAddr = "13"//添加充币地址
    static let modifyEmail = "15"//修改邮箱
    static let loginRemind = "16"//登陆提醒
    static let withDraw = "17"//提现
}
