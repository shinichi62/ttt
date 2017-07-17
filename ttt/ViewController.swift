//
//  ViewController.swift
//  ttt
//
//  Created by shinichi yamaguchi on 2017/07/12.
//  Copyright © 2017 shinichi yamaguchi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tokenField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if UserDefaults.standard.object(forKey: "api_token") != nil {
            print(UserDefaults.standard.string(forKey: "api_token")!)
        }
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func tapSaveButton(_ sender: Any) {
        print("tap save button!" + tokenField.text!)
        UserDefaults.standard.set(tokenField.text!, forKey: "api_token")
    }

}

