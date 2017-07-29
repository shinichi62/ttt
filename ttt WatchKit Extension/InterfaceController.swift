//
//  InterfaceController.swift
//  ttt WatchKit Extension
//
//  Created by shinichi yamaguchi on 2017/07/12.
//  Copyright © 2017 shinichi yamaguchi. All rights reserved.
//

import WatchKit
import Foundation
import Alamofire
import SwiftyJSON

class InterfaceController: WKInterfaceController {
    
    @IBOutlet var myTimer: WKInterfaceTimer!

    let user = "xxxxx"

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()

        let password = "api_token"
        
        var headers: HTTPHeaders = [:]
        
        if let authorizationHeader = Request.authorizationHeader(user: user, password: password) {
            headers[authorizationHeader.key] = authorizationHeader.value
        }
        
        // Get running time entry
        Alamofire.request("https://www.toggl.com/api/v8/time_entries/current", headers: headers)
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    // Get start time
                    let json = JSON(value)
                    let start_date = json["data"]["start"].stringValue
                    if start_date.isEmpty {
                        // Stop timer
                        self.myTimer.stop()
                        self.myTimer.setDate(Date())
                        UserDefaults.standard.set("", forKey: "start_date")
                        self.updateComplication()
                        return
                    }

                    // Convert string to date
                    let iSO8601DateFormatter = ISO8601DateFormatter()
                    let date = iSO8601DateFormatter.date(from: start_date)!

                    // Set start time
                    self.myTimer.start()
                    self.myTimer.setDate(date)
                    
                    // Update complication
                    UserDefaults.standard.set(date, forKey: "start_date")
                    self.updateComplication()
                case .failure(let error):
                    print(error)
                    return
                }
        }
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    func updateComplication() {
        // Update complication
        for complication in CLKComplicationServer.sharedInstance().activeComplications! {
            CLKComplicationServer.sharedInstance().reloadTimeline(for: complication)
        }
    }

    @IBAction func touchButton() {
        print("Touch")
        
        let password = "api_token"
        
        let parameters: Parameters = [
            "time_entry": [
                "created_with": "test"
            ]
        ]
        
        var headers: HTTPHeaders = [:]
        
        if let authorizationHeader = Request.authorizationHeader(user: user, password: password) {
            headers[authorizationHeader.key] = authorizationHeader.value
        }
        
        // Get running time entry
        Alamofire.request("https://www.toggl.com/api/v8/time_entries/start", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .responseJSON { response in
                print("Result: \(response.result)")
                if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                    print("Data: \(utf8Text)") // original server data as UTF8 string
                }
                switch response.result {
                case .success(let value):
                    // Get start time
                    let json = JSON(value)
                    let start_date = json["data"]["start"].stringValue
                    if start_date.isEmpty {
                        // Stop timer
                        self.myTimer.stop()
                        self.myTimer.setDate(Date())
                        UserDefaults.standard.set("", forKey: "start_date")
                        self.updateComplication()
                        return
                    }
                    
                    // Convert string to date
                    let iSO8601DateFormatter = ISO8601DateFormatter()
                    let date = iSO8601DateFormatter.date(from: start_date)!
                    
                    // Set start time
                    self.myTimer.start()
                    self.myTimer.setDate(date)
                    
                    // Update complication
                    UserDefaults.standard.set(date, forKey: "start_date")
                    self.updateComplication()
                case .failure(let error):
                    print(error)
                    return
                }
        }
        
    }
    
}
