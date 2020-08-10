//
//  HiDebug+UIWindow.swift
//  Chainup
//
//  Created by liuxuan on 2019/2/27.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import UIKit

/// Post shaking notification while fetching motion event.
public extension UIWindow {
    
    open override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        
        if let event = event {
            if event.type == UIEventType.motion && event.subtype == UIEventSubtype.motionShake {
                NotificationCenter.default.post(name: Foundation.Notification.Name(rawValue: HiDebugNotification.HiDebugDidShakingNotification), object: self)
            }
        }
    }
}
