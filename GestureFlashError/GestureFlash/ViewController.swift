//
//  ViewController.swift
//  GestureFlash
//
//  Created by Zun Pan on 2020/06/15.
//  Copyright © 2020 Pan Zun. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var highScore1label: UILabel!
    
    @IBOutlet weak var highScore2label: UILabel!
    
    @IBOutlet weak var highScore3label: UILabel!
    
    override func viewDidAppear(_ animated: Bool) {
        //Userへアクセスする
        let defaults = UserDefaults.standard
        //スコアを取得し、ダブル型に変換
        let highScore1 = defaults.double(forKey: "highScore1")
        let highScore2 = defaults.double(forKey: "highScore2")
        let highScore3 = defaults.double(forKey: "highScore3")
        //デバッグメッセージ
        NSLog("ハイスコア: 1位-%f 2位-%f 3位-%f", highScore1,highScore2, highScore3)
        //ハイスコアが存在する場合０ではない場合は一覧に表示
        if highScore1 != 0 {
           highScore1label.text = String(format: "%.3f 秒", highScore1)
        }
        if highScore2 != 0 {
            highScore2label.text = String(format: "%.3f 秒", highScore2)
        }
        if highScore3 != 0 {
            highScore3label.text = String(format: "%.3f 秒", highScore3)
        }
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func backView(segue: UIStoryboardSegue){
        
    }



}

