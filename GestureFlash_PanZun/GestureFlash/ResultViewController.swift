//
//  ViewController.swift
//  GestureFlash
//
//  Created by Zun Pan on 2020/06/15.
//  Copyright © 2020 Pan Zun. All rights reserved.
//

import UIKit

class ResultViewController: UIViewController {

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var newHighScoreLabel: UILabel!
    
    //経過時間を取得
    var time = TimeInterval()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        timeLabel.text = String(format: "%.3f 秒", time)
        //スコアをチェック
        self.checkHighScore()
    }
    

    func checkHighScore() {
        //ハイスコア比較　偽にしておく
        var newHighScore = false
        //ハイスコア更新ラベルは非表示
        newHighScoreLabel.isHidden = true
        //データ領域にアクセス
        let defaults = UserDefaults.standard
        //ハイスコアを取得し、double型に変換
        var highScore1 = defaults.double(forKey: "highScore1")
        var highScore2 = defaults.double(forKey: "highScore2")
        var highScore3 = defaults.double(forKey: "highScore3")
        
        //記録が既にある場合、今回の記録が当てはまる場所に挿入
        //1位より早い場合
        if highScore1 != 0 && time <= highScore1 {
            highScore3 = highScore2
            highScore2 = highScore1
            highScore1 = time
            newHighScore = true
            //2位より早い場合
        } else if highScore2 != 0 && time <= highScore2 {
            highScore3 = highScore2
            highScore2 = time
            newHighScore = true
            //3位より早い場合
        } else if highScore3 != 0 && time <= highScore3 {
            highScore3 = time
            newHighScore = true
        }
            //ハイスコアがまだない場合
            //1位がまだない場合
        else if highScore1 == 0 {
            highScore1 = time
            newHighScore = true
            //2位に値がなく、1位よりも遅い場合
        } else if highScore2 == 0 && time >= highScore1 {
            highScore2 = time
            newHighScore = true
            //3位に値がなく、2位よりも遅い場合
        } else if highScore3 == 0 && time >= highScore2 {
            highScore3 = time
            newHighScore = true
        }
        //新しいハイスコアをデータ領域に保存
        defaults.set(highScore1, forKey: "highScore1")
        defaults.set(highScore2, forKey: "highScore2")
        defaults.set(highScore3, forKey: "highScore3")
        
        //ハイスコアが更新された場合ラベルを表示
        if newHighScore == true {
            newHighScoreLabel.isHidden = false
        }
    }

}
