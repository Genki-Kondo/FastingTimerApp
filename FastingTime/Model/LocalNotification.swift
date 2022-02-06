//
//  Local Notification.swift
//  FastingTime
//
//  Created by 近藤元気 on 2021/06/08.
//

import Foundation
class LocalNotification{
    
    func UNUserNotificationCenter(){
        // プッシュ通知の許可を依頼する際のコード
        UNUserNotificationCenter.current().requestAuthorization([.alert, .badge, .sound]) { (granted, error) in
            // [.alert, .badge, .sound]と指定されているので、「アラート、バッジ、サウンド」の3つに対しての許可をリクエストした
            if granted {
                // 「許可」が押された場合
            } else {
                // 「許可しない」が押された場合
            }
        }
    }
    
}
