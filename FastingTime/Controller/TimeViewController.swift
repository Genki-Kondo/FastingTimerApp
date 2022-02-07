//
//  TimeViewController.swift
//  FastingTime
//
//  Created by 近藤元気 on 2021/05/29
//テスト

import UIKit
import MBCircularProgressBar
import os
var publicHourTime = 0

class TimeViewController: UIViewController, backgroundTimerDelegate {
    
    
    var test : Int!
    
    var progressColorArray :[UIColor] = [.yellow,.orange,.systemPink,.green,.blue,.purple,.lightGray,.brown]
    var commentArray :[String] = ["ファスティング中","自由時間です"]
    
    
    //タイマー起動中にバックグラウンドに移行したか
    var timerIsBackground = false
    //現在の状況を判断する為のフラグ
    var eatingFlag = false
    var fastingFlag = false
    //食事を可能な時間を測るタイマー
    @IBOutlet var progressViewBar: MBCircularProgressBarView!
    
    @IBOutlet var startEartingBtn: UIButton!
    
    @IBOutlet var commentLabel: UILabel!
    @IBOutlet var hourLabel: UILabel!
    var hourCount = 0
    var fastingTimer :Timer = Timer()
    var TimerDisplayed = 0
    var elapsedTimeSave = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let center = UNUserNotificationCenter.current()
        
        // 通知の使用許可をリクエスト
        center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
        }
        //初期化
        progressViewBar.value = 0
        commentLabel.text = ""
        //最初はstartFastingBtnを非表示
        commentLabel.isHidden = true
        
        hourLabel.text = String(hourCount)
        
        //SceneDelegateを取得
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let sceneDelegate = windowScene.delegate as? SceneDelegate else {
            return
        }
        //デリゲートを設定
        sceneDelegate.delegate = self
        // プッシュ通知の許可を依頼する際のコード
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            // [.alert, .badge, .sound]と指定されているので、「アラート、バッジ、サウンド」の3つに対しての許可をリクエストした
            if granted {
                // 「許可」が押された場合
            } else {
                // 「許可しない」が押された場合
            }
        }
    }
    
    
    //食事開始ボタンタップ処理
    @IBAction func startEating(_ sender: Any) {
        //ファスティング開始通知
        LocalNotifFasting()
        
        fastingTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(Action1), userInfo: nil, repeats: true)
        eatingFlag = true
        commentLabel.isHidden = false
        commentLabel.text = commentArray[1]
        progressViewBar.progressColor = .red
        startEartingBtn.isHidden = true
    }
    func setCurrentHourTimer(_ elapsedHourTime: Int) {
        //        var hourCountSave = ""
        //        hourCountSave == hourLabel.text
        //        elapsedHourTime == Int(hourCountSave)
        hourLabel.text = String(elapsedHourTime)
    }
    func setCurrentTimer(_ elapsedTime: Int,_ elapsedHourTime: Int) {
        //残り時間から引数(バックグラウンドでの経過時間)を引く
        
        
        //６０分から最後に表示された時間を引く
        
        let leftMin = 60 - TimerDisplayed
        //もしバックグラウンドで経過した時間がleftMinを超えた場合の処理
        if elapsedTime >= leftMin{
            
            //経過した時間分を足す
            
            //            hourCount += elapsedHourTime
            //            print(elapsedHourTime)
            //            hourLabel.text = String(hourCount)
            //            print(hourCount)
            var elapsedTimeHour = 0
            //経過した時間分を足す
            elapsedTimeHour = elapsedHourTime + 1
            hourCount += elapsedTimeHour
            
            hourLabel.text = String(hourCount)
            //もしバックグラウンドで経過した時間が自由時間を超えた場合
            if hourCount <= 2{
                fastingFlag = true
            }
            //例えば４０分経過していて５０分間（バックグラウンドで）経過したら
            
            //あまり分を出し表示された時間に足す
            var elapsedTimeOver = 0
            //例　５０分をあぶり出す
            elapsedTimeOver = elapsedTime % 60
            //その５０分から残りの２０分を引く
            elapsedTimeOver -= leftMin
            //そしてでた３０分を足す
            TimerDisplayed = 0
            TimerDisplayed = elapsedTimeOver
            
            
        }else{
            TimerDisplayed += elapsedTime
        }
        
        
        print(elapsedTime)
        print(elapsedHourTime)
        print(TimerDisplayed)
        progressViewBar.value = CGFloat(TimerDisplayed)
        if hourCount >= 3 && eatingFlag == true{
            deleteTimer()
        }
        //再びタイマーを起動
        fastingTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(Action2), userInfo: nil, repeats: true)
    }
    
    func deleteTimer() {
        //起動中のタイマーを破棄
        //fastingTimerが起動中か確認
        if fastingTimer != nil  {
            fastingTimer.invalidate()
        }
    }
    
    func checkBackground() {
        //バックグラウンドへの移行を確認
        //fastingTimerが起動中か確認
        if fastingTimer != nil {
            timerIsBackground = true
        }
    }
    //ファスティング中の処理
    func FastingTime(){
        
        if fastingFlag == true{
            //ファスティング開始通知
//            LocalNotifFasting()
            
            commentLabel.textColor = .blue
            progressViewBar.progressColor = .blue
            //16時間経ったら食事開始ボタンが現れる
            if hourCount == 3{
                startEartingBtn.isHidden = false
                commentLabel.isHidden = true
                commentLabel.text = commentArray[1]
                eatingFlag = true
                fastingFlag = false
                hourCount = 0
                hourLabel.text = String(hourCount)
                deleteTimer()
            }
        }
    }
    //自由時間中の処理
    func EatingTime(){
        
        if eatingFlag == true{
            //自由時間の開始通知
//            LocalNotifFree()
            
            commentLabel.textColor = .red
            progressViewBar.progressColor = .red
            //8時間経ったら食事開始ボタンが消えファスティング開始
            if hourCount == 2{
                startEartingBtn.isHidden = true
                commentLabel.isHidden = false
                commentLabel.text = commentArray[0]
                eatingFlag = false
                fastingFlag = true
                hourCount = 0
                hourLabel.text = String(hourCount)
                
            }
        }
    }
    //決められた秒数ごとに呼び出されるメソッド
    @objc func Action1() {
        publicHourTime = Int(hourLabel.text!)!
        TimerDisplayed += 1
        progressViewBar.value = CGFloat(TimerDisplayed)
        //６０分経ったらタイマーを０に戻しhourCountを１増やす
        if TimerDisplayed == 60{
            
            progressViewBar.progressColor = progressColorArray[1]
            hourCount += 1
            hourLabel.text = String(hourCount)
            TimerDisplayed = 0
        }
        //ファスティング中の処理
        FastingTime()
        //自由時間中の処理
        EatingTime()
        
    }
    //決められた秒数ごとに呼び出されるメソッド(バックグラウンド再生時)
    @objc func Action2() {
        
        
        publicHourTime = Int(hourLabel.text!)!
        TimerDisplayed += 1
        progressViewBar.value = CGFloat(TimerDisplayed)
        //６０分経ったらタイマーを０に戻しhourCountを１増やす
        if TimerDisplayed == 60{
            
            progressViewBar.progressColor = progressColorArray[1]
            hourCount += 1
            hourLabel.text = String(hourCount)
            TimerDisplayed = 0
        }
        //ファスティング中の処理
        FastingTime()
        //自由時間中の処理
        EatingTime()
        
    }
    //ファスティング開始の通知
    func LocalNotifFasting(){
        os_log("setlocalNotfication")
                
                // notification's payload の設定
                let content = UNMutableNotificationContent()
                content.title = "ファスティング開始です"
                content.subtitle = "気合いだー"
                content.body = "たったの１６時間（睡眠時間も含む）."
                content.sound = UNNotificationSound.default
                
                // １回だけ
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 120, repeats: false)
                
         
                let request = UNNotificationRequest(identifier: "Fasting Time",
                                                             content: content,
                                                             trigger: trigger)
                // 通知の登録
                UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    //自由時間の通知
    func LocalNotifFree(){
        os_log("setlocalNotfication")
                
                // notification's payload の設定
                let content = UNMutableNotificationContent()
                content.title = "ファスティング終了です"
                content.subtitle = "自由ー時間デーす"
                content.body = "８時間を楽しみましょう."
                content.sound = UNNotificationSound.default
                
                // １回だけ
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 180, repeats: false)
                
         
                let request = UNNotificationRequest(identifier: "Free Time",
                                                             content: content,
                                                             trigger: trigger)
                // 通知の登録
                UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    // 通知の削除
    @IBAction func setLocalNoti(_ sender: Any) {
        
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["interval"])
    }
}
