//
//  EXChangeHostVC.swift
//  Chainup
//
//  Created by chainup on 2020/6/16.
//  Copyright © 2020 ChainUP. All rights reserved.
//

import UIKit

class EXChangeHostVC: NavCustomVC {
    
    var links : [String]? = nil
    private var dataSource = [EXHostEntity]()
    private var pingTimer : Timer? = nil
    private var countDownTimer:Timer? = nil
    private var countDownValue = 0
    private var pendingPings = [EXPing]()
    
    lazy var tableView : UITableView = {
        let tableView = UITableView()
        tableView.extUseAutoLayout()
        tableView.extSetTableView(self, self)
        tableView.extRegistCell([EXChangeHostTableViewCell.classForCoder()], ["EXChangeHostTableViewCell"])
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contentView.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        initializeDataSource()
        initializeTimers()
        
        pingTimer?.fire()
//        countDownTimer?.fire()
        
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        for item in dataSource {
            if item.selected, item.status == .success {
                
                EXNetworkDoctor.sharedManager.changeCurrentHost(selectedHost: item.host)
            }
        }
        
        pingTimer?.invalidate()
//        countDownTimer?.invalidate()
        
        stopPing()
    }
    private func stopPing() {
        for item in pendingPings {
            item.stop()
        }
    }
    private func startPing() {
        
        for i in 0..<dataSource.count {
            dataSource[i].status = .testing
        }
        for item in pendingPings {
            item.startPinging()
        }
        tableView.reloadData()
    }
    
    private func initializeDataSource() {
        guard let hosts = links else {
            return
        }
        
        let appapiHost = EXNetworkDoctor.sharedManager.getAppAPIHost()
        let wsApiHost = EXNetworkDoctor.sharedManager.getKlineWs()
        let oldDomain = appapiHost.hostStr()
        let wsOldDomain = wsApiHost.hostStr()
        for (i,host) in hosts.enumerated() {
            let urlString = appapiHost.replacingOccurrences(of: oldDomain, with: host)
            let wsUrlString = wsApiHost.replacingOccurrences(of: wsOldDomain, with: host)
            
            let hostStatus = EXHostEntity(name: "\(LanguageTools.getString(key: "customSetting_action_host"))\(i+1)", status: .none, host: host, selected: host == oldDomain)
            dataSource.append(hostStatus)
            
            let ping = EXPing(host: host,address: urlString, wsAddress:wsUrlString)
            ping.delegate = self
            pendingPings.append(ping)
        }
    }
    
    private func initializeTimers() {
        pingTimer = Timer.scheduledTimer(withTimeInterval: 10, repeats: true) { _ in
            self.countDownValue = 0
            self.startPing()
        }
//        countDownTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (_) in
//            self.countDownValue += 1
//
//        })
    }
    
    override func setNavCustomV() {
        self.setTitle("\(LanguageTools.getString(key: "customSetting_action_changeHost"))")

        self.xscrollView = tableView
        self.lastVC = true
    }
    
    private func resetDataSourceSelectedStatus() {
        for i in 0..<dataSource.count {
            dataSource[i].selected = false
        }
    }
}

extension EXChangeHostVC : EXPingDelegate {
    func ping(_ ping: EXPing, didReceive entity: EXPingEntity) {
        
        for (i,item) in dataSource.enumerated() {
            if item.host == entity.host {
                if item.status != .unusable {
                    
                    dataSource[i].responseTimeStr = "\(entity.rtt())/\(entity.wsRtt())"
                    dataSource[i].status = .success
                }
                break;
            }
        }
        tableView.reloadData()
    }
    
    func ping(_ ping: EXPing, didFail entity: EXPingEntity) {
        
        for (i,item) in dataSource.enumerated() {
            if item.host == entity.host {
                dataSource[i].status = .unusable
                break;
            }
        }
        tableView.reloadData()
    }
}

extension EXChangeHostVC : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 52
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "EXChangeHostTableViewCell")! as! EXChangeHostTableViewCell
        let cellData = dataSource[indexPath.row]
        cell.setCell(cellData.name, status: cellData.statusStr(), isHint: cellData.selected)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        let data = dataSource[indexPath.row]
        if  data.status == .unusable || data.status == .testing {
            //提醒
            EXAlert.showFail(msg: "\(LanguageTools.getString(key: "customSetting_action_host"))\(data.statusStr())")
            return;
        }
        
        resetDataSourceSelectedStatus()
        dataSource[indexPath.row].selected = true
        tableView.reloadData()
    }
    
}
