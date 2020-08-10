//
//  WebVC.swift
//  Chainup
//
//  Created by zewu wang on 2018/8/18.
//  Copyright © 2018年 zewu wang. All rights reserved.
//

import UIKit
import WebKit

class WebVC: NavCustomVC,WKNavigationDelegate {
    
    var urlStr = ""
    typealias DissMissBlock = () -> ()
    var missBlock : DissMissBlock?
    
    private var cookies: [String] {
        let dic = NetManager.sharedInstance.getHeaderParams()
        return dic.map { "\($0)=\($1)" }
    }

    private var cookieScript: String {
        return cookies.map { "document.cookie='\($0);\(cookieAttributes())';" }.joined()
    }
    
    private func cookieAttributes() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE, dd-MMM-yyyy HH:mm:ss zzz"
        formatter.locale = Locale(identifier: "en_US")
        formatter.timeZone = TimeZone(identifier: "GMT")
        let expireDate = Date(timeIntervalSinceNow: (60 * 60 * 24 * 30))
        let expireString = formatter.string(from: expireDate)
        return "domain=\(NetDefine.domain_host_url()); expires=\(expireString); path=/ ;"
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.missBlock?()
    }
    lazy var webView : DWKWebView = {
        let config = WKWebViewConfiguration()
        config.allowsInlineMediaPlayback = true
        config.preferences = WKPreferences()
//        let titleJScript = "var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width,initial-scale=1,user-scalable=no'); document.getElementsByTagName('head')[0].appendChild(meta);"
//        let wkUScript = WKUserScript.init(source: titleJScript , injectionTime:WKUserScriptInjectionTime.atDocumentEnd, forMainFrameOnly: true)
        
//        let forbiddenLongPressJS = "document.documentElement.style.webkitTouchCallout='none';document.documentElement.style.webkitUserSelect='none';"// 禁用WKWebView自带的长按弹出菜单
        let userContentController = WKUserContentController()
//        userContentController.addUserScript(wkUScript)
        userContentController.add(EXScriptMessageProxy(delegate: self), name: EXJsHandler.handlerName)
        
        let cookieScript = WKUserScript(source: self.cookieScript,
                                        injectionTime: .atDocumentStart,
                                        forMainFrameOnly: false)
        userContentController.addUserScript(cookieScript)
        config.userContentController = userContentController
        
        
//        let view = EXCookieWebView.init(frame: CGRect.zero, configuration: config, useRedirectCookieHandling: true)
        let view = DWKWebView.init(frame: CGRect.zero, configuration: config)
        view.extUseAutoLayout()

        if #available(iOS 9.0, *) {
            view.allowsBackForwardNavigationGestures = true
        } else {
            /*
             在iOS 8下， 先设置WKWebView的
             webView.allowsBackForwardNavigationGestures = YES;
             然后再设置为NO的话
             webView.allowsBackForwardNavigationGestures = NO;
             只要手指一碰屏幕，就会出现Crash
             */
            view.allowsBackForwardNavigationGestures = false
        }
        view.navigationDelegate = self
        //解决网页底部黑边问题
//        view.backgroundColor = UIColor.clear
        view.isOpaque = false //不设置这个值 页面背景始终是白色
        view.autoresizingMask = .flexibleHeight
        
        view.addJavascriptObject(EXJsApiMethodSwift(), namespace: nil)
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.clear
        // Do any additional setup after loading the view.
        contentView.addSubview(webView)
        XHUDManager.sharedInstance.loading()
        webView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        //用登录密码
        handleNoti()
    }
    
    func handleNoti() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(loginSuccess), name: Notification.Name(rawValue: "EXLoginSuccess"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(loginCanceled), name: Notification.Name(rawValue: "EXCancelLogin"), object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func loginSuccess() {
        // reload
        self.reload()
    }
    
    func reload() {
        let cookieScript = WKUserScript(source: self.cookieScript,
                                        injectionTime: .atDocumentStart,
                                        forMainFrameOnly: false)
        self.webView.configuration.userContentController.addUserScript(cookieScript)
        
        if let url = URL.init(string: percentEncode(self.urlStr)) , urlStr.hasPrefix("http"){
            var request = URLRequest.init(url:url)
            request.setValue(cookies.joined(separator: ";"), forHTTPHeaderField: "Cookie")
            self.webView.load(request)
        }
    }
    
    @objc func loginCanceled() {
        self.popBack()
    }
    
    override func setNavCustomV() {
        self.navtype = .listtitle
    }
    
    func percentEncode(_ str: String) -> String {
          var charSet = CharacterSet.urlQueryAllowed
          charSet.insert(charactersIn: "#")
          let encodingURL = str.addingPercentEncoding(withAllowedCharacters: charSet)!
          return encodingURL
      }
    
    func loadUrl(_ urlStr : String){
        if urlStr.isEmpty {
            return
        }
        if let url = URL.init(string: percentEncode(urlStr)) , urlStr.hasPrefix("http"){
            var handledUrl = percentEncode(urlStr)
            if let _ = url.query {
                handledUrl = handledUrl + "&isapp=1&ua=ios" + "&lan=" + BasicParameter.phoneLanguage
            }else {
                handledUrl = handledUrl + "?isapp=1&ua=ios" + "&lan=" + BasicParameter.phoneLanguage
            }
            self.urlStr = handledUrl
            var request = URLRequest.init(url:URL.init(string: handledUrl)!)
            request.setValue(cookies.joined(separator: ";"), forHTTPHeaderField: "Cookie")
            print(handledUrl)
            self.webView.load(request)
        }else{
            self.urlStr = urlStr
            self.webView.loadHTMLString(urlStr, baseURL: nil)
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
    }
    
    func dismiss(){
        XHUDManager.sharedInstance.dismissWithDelay {
            
        }
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let url = navigationAction.request.url{
            if url.scheme != "http" && url.scheme != "https"{
                if UIApplication.shared.canOpenURL(url){
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }
        }
        decisionHandler(WKNavigationActionPolicy.allow)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        print("navigationResponse Response = \(navigationResponse.response)")
        self.dismiss()
        decisionHandler(.allow)
    }
}


extension WebVC: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == EXJsHandler.handlerName {
            if let actionName = message.body as? String {
                switch actionName {
                case EXJsActionName.login:
                    BusinessTools.modalLoginVC("1")
                default:
                    break
                }
            }
        }
    }
}
