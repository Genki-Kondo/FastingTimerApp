//
//  SceneDelegate.swift
//  FastingTime
//
//  Created by 近藤元気 on 2021/05/29.
//

import UIKit

protocol backgroundTimerDelegate: class {
    //バックグラウンドの経過時間を渡す（時間）
    //func setCurrentHourTimer(_ elapsedHourTime:Int)
    //バックグラウンドの経過時間を渡す(分)
    func setCurrentTimer(_ elapsedTime:Int,_ elapsedHourTime:Int)
    //バックグラウンド時にタイマーを破棄
    func deleteTimer()
    //バックグラウンドへの移行を検知
    func checkBackground()
    //バックグラウンド中かどうかを示す
    var timerIsBackground:Bool { set get }
}
class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    //デリゲート
    weak var delegate: backgroundTimerDelegate?
    let ud = UserDefaults.standard
    
    //アプリ画面に復帰した時
    func sceneDidBecomeActive(_ scene: UIScene) {
        //タイマー起動中にバックグラウンドへ移行した時
        if delegate?.timerIsBackground == true {
            
            
            //delegate?.setCurrentHourTimer(publicHourTime)
            
            let calender = Calendar(identifier: .gregorian)
            let dateMin = ud.value(forKey: "経過時間(分)") as! Date
            let dateHour = ud.value(forKey: "経過時間(時間)") as! Date
            
            let date = Date()
            //経過した時間を計算
            let elapsedTimeMin = calender.dateComponents([.second], from: dateMin, to: date).second!
            let elapsedTimeHour = calender.dateComponents([.minute], from: dateHour, to: date).minute!
            //経過時間（elapsedTime）をTimeViewController.swiftに渡す
            delegate?.setCurrentTimer(elapsedTimeMin, elapsedTimeHour)
        }
    }
    
    //アプリ画面から離れる時（ホームボタン押下、スリープ）
    func sceneWillResignActive(_ scene: UIScene) {
        ud.set(Date(), forKey: "経過時間(分)")
        
        ud.set(Date(), forKey: "経過時間(時間)")
        
        //タイマー起動中からのバックグラウンドへの移行を検知
        delegate?.checkBackground()
        //タイマーを破棄
        delegate?.deleteTimer()
    }
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

//    func sceneDidBecomeActive(_ scene: UIScene) {
//        // Called when the scene has moved from an inactive state to an active state.
//        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
//    }
//
//    func sceneWillResignActive(_ scene: UIScene) {
//        // Called when the scene will move from an active state to an inactive state.
//        // This may occur due to temporary interruptions (ex. an incoming phone call).
//    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

