//
//  PlayViewController.swift
//  GestureFlash
//
//  Created by Zun Pan on 2020/06/15.
//  Copyright © 2020 Pan Zun. All rights reserved.
//

import UIKit

class PlayViewController: UIViewController {
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var completedGesturesLabel: UILabel!
    
    @IBOutlet weak var gestureImage: UIImageView!
    //ゲームの経過時間を計測
    var startTime = NSDate()
    //こなしたジェスチャーの数を管理
    var completedGestures = Int()
    //現在の問題で、発見すべきジェスチャーを記録
    var currentGesture = Int()
    //経過時間を画面に表示するためのタイマー
    var timer = Timer()
    var timerCount = Double()
    
    //Segueを発動し、時間を計測
       override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
           //時間を計測
           var elapsedTime = startTime.timeIntervalSinceNow
           elapsedTime = -(elapsedTime)
           
           //結果表示画面の変数「time」に値を渡す
           if segue.identifier == "toResultView" {
               let rvc = segue.destination as! ResultViewController
               rvc.time = elapsedTime
           }
       }
       
       
       //次の問題を表示
       func nextProblem() {
           //問題が30に達している場合
           if completedGestures == 30 {
               //結果表示画面へのSegueを始動
               self.performSegue(withIdentifier: "toResultView", sender: self)
           } else {
               //配列にジェスチャーを示す画像取り込み
               let gestureIcons = [
                   UIImage(named: "swipe-right"),
                   UIImage(named: "swipe-left"),
                   UIImage(named: "swipe-up"),
                   UIImage(named: "pinch-in"),
                   UIImage(named: "pinch-out"),
                   UIImage(named: "rotate-right"),
                   UIImage(named: "rotate-left")
               ]
               //乱数で次のジェスチャーを配置
               currentGesture = Int(arc4random() % 7)
               NSLog("got new gesture current: %d", currentGesture)
               //画像を交換、問題番号を更新
               gestureImage.image = gestureIcons[currentGesture]
               completedGesturesLabel.text = String(format: "%d", completedGestures)
           }
       }
       
       
       
       
       
       
       
       
       
       override func viewDidLoad() {
           super.viewDidLoad()

           //ジェスチャーの数を０に
           completedGestures = 0
           //Gesture Recognizersをセット
           self.setGestureRecognizers()
           //最初の問題を表示
           self.nextProblem()
           
           
           //タイマー起動
           //0.1秒ごとにONTimer
           timerCount = 0
           timer = Timer.scheduledTimer(
               timeInterval: 0.1,
               target: self,
               selector: #selector(PlayViewController.onTimer(timer:)),
               userInfo: nil,
               repeats: true
           )
           
       }
       
       //タイマー更新
       @objc func onTimer(timer: Timer) {
           timerCount = timerCount + 0.1
           timeLabel.text = String(format: "%.1f", timerCount)
       }
       

       func setGestureRecognizers() {
           //Pinch（2本の指でつまむ）の認識
           let pinchRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(PlayViewController.pinchDetected(sender:)))
           self.view.addGestureRecognizer(pinchRecognizer)
           //Rotate（2本の指で回転）の認識
           let rotationRecognizer = UIRotationGestureRecognizer(target: self, action: #selector(PlayViewController.rotationDetected(sender:)))
           self.view.addGestureRecognizer(rotationRecognizer)
           //右向きのSwipe（1本指でなぞる）の認識
           let swipeRightRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(PlayViewController.swipeRightDetected(sender:)))
           swipeRightRecognizer.direction = UISwipeGestureRecognizer.Direction.right
           self.view.addGestureRecognizer(swipeRightRecognizer)
           //左向きのSwipe（1本指でなぞる）の認識
           let swipeLeftRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(PlayViewController.swipeLeftDetected(sender:)))
           swipeLeftRecognizer.direction = UISwipeGestureRecognizer.Direction.left
           self.view.addGestureRecognizer(swipeLeftRecognizer)
           //上向きのSwipe（1本指でなぞる）の認識
           let swipeUpRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(PlayViewController.swipeUpDetected(sender:)))
           swipeUpRecognizer.direction = UISwipeGestureRecognizer.Direction.up
           self.view.addGestureRecognizer(swipeUpRecognizer)
           
       }
       
       
       //右向きスワイプ
       @objc func swipeRightDetected(sender: UIGestureRecognizer) {
           NSLog("右向きSwipe")
           NSLog("current: %d", currentGesture)
           //正解が右向きSwipe（0番）なら
           if currentGesture == 0 {
               NSLog("NEXT")
               completedGestures += 1
               self.nextProblem()
           }
       }
       //左向きスワイプ
       @objc func swipeLeftDetected(sender: UIGestureRecognizer) {
           NSLog("左向きSwipe")
           NSLog("current: %d", currentGesture)
           //正解が右向きSwipe（0番）なら
           if currentGesture == 1 {
               NSLog("NEXT")
               completedGestures += 1
               self.nextProblem()
           }
       }
       //上向きスワイプ
       @objc func swipeUpDetected(sender: UIGestureRecognizer) {
           NSLog("上向きSwipe")
           NSLog("current: %d", currentGesture)
           //正解が右向きSwipe（0番）なら
           if currentGesture == 2{
               NSLog("NEXT")
               completedGestures += 1
               self.nextProblem()
           }
       }
       
       
       
       //回転動作
       @objc func rotationDetected(sender: UIRotationGestureRecognizer) {
           //回転具合
           let radians = sender.rotation
           //度に変換
           let degrees = radians * CGFloat(180/Double.pi)
           if degrees > 90 {
               NSLog("時計回りにRotate degrees: %f", degrees)
               NSLog("current: %d", currentGesture)
               //正解が時計回りRotate（6番）なら
               if currentGesture == 5 {
                   NSLog("NEXT")
                   completedGestures += 1
                   self.nextProblem()
               }
           } else if degrees < -90 {
               NSLog("反時計回りにRotate degrees: %f", degrees)
               NSLog("current: %d", currentGesture)
               //正解が時計回りRotate（7番）なら
               if currentGesture == 6 {
                   NSLog("NEXT")
                   completedGestures += 1
                   self.nextProblem()
               }
           }
       }
       
       @objc func pinchDetected(sender: UIPinchGestureRecognizer) {
           //指の相対距離
           let scale = sender.scale
           if scale > 2.4 {
               NSLog("外向きにPinch scale: %f", scale)
               NSLog("current: %d", currentGesture)
               //外向き　５番
               if currentGesture == 4 {
                   NSLog("NEXT")
                   completedGestures += 1
                   self.nextProblem()
               }
           } else if scale < 0.4 {
               NSLog("内向きにPinch scale: %f", scale)
               NSLog("current: %d", currentGesture)
               //内向き　４番
               if currentGesture == 3 {
                   NSLog("NEXT")
                   completedGestures += 1
                   self.nextProblem()
               }
           }
       }
       


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
