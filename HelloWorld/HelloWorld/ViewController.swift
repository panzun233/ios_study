//
//  ViewController.swift
//  HelloWorld
//
//  Created by Zun Pan on 2020/06/03.
//  Copyright © 2020 Zun Pan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var myLabel: UILabel!
    override func viewDidLoad() {
    
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func buttonPushed(_ sender: Any) {
        if myLabel.isHidden == true{
            myLabel.isHidden = false
        }else{
            myLabel.isHidden = true
        }
    }
    
}

