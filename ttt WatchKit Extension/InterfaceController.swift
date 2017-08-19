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
import WatchConnectivity


class InterfaceController: WKInterfaceController, WCSessionDelegate {

    /** Called when the session has completed activation. If session state is WCSessionActivationStateNotActivated there will be an error with more details. */
    @available(watchOS 2.2, *)
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("session xxx")
        print("receive::\(activationState)")
    }
    
    @IBOutlet var myTimer: WKInterfaceTimer!
    @IBOutlet var myButton: WKInterfaceButton!

    let user = "xxxxx"
    var isStart = false
    var timeEntryId = ""

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
        
        if (WCSession.isSupported()) {
            let session = WCSession.default()
            session.delegate = self as? WCSessionDelegate
            session.activate()
        }
    }
    
    func session(session: WCSession, didReceiveApplicationContext applicationContext: [String : AnyObject]) {
        // 処理
        print(AnyObject.self)
        print("session watch")
    }
    
    func session(_ session: WCSession,
                 didReceiveApplicationContext applicationContext: [String : Any]){
        
        print("session watch2")
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        if UserDefaults.standard.object(forKey: "api_token") != nil {
            print(UserDefaults.standard.string(forKey: "api_token")!)
        } else {
            print("no api token")
        }

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
                    self.timeEntryId = json["data"]["id"].stringValue
                    if start_date.isEmpty {
                        // Stop timer
                        self.myTimer.stop()
                        self.myTimer.setDate(Date())
                        UserDefaults.standard.set("", forKey: "start_date")
                        self.updateComplication()
                        self.isStart = false
                        self.myButton.setTitle("Start")
                        return
                    }
                    
                    self.isStart = true

                    self.myButton.setTitle("Stop")
                    
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
    
    @IBAction func touchMyButton() {
        print("Touch")
        
        if isStart {
            self.stopTimeEntry()
        } else {
            self.startTimeEntry()
        }
        
    }
    
    func startTimeEntry() {
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
        
        // Start a time entry
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
                    self.timeEntryId = json["data"]["id"].stringValue
                    if start_date.isEmpty {
                        // Stop timer
                        self.myTimer.stop()
                        self.myTimer.setDate(Date())
                        UserDefaults.standard.set("", forKey: "start_date")
                        self.updateComplication()
                        self.isStart = false
                        self.myButton.setTitle("Start")
                        return
                    }
                    
                    self.isStart = true
                    
                    self.myButton.setTitle("Stop")
                    
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
    
    func stopTimeEntry() {
        let password = "api_token"
        
        var headers: HTTPHeaders = [:]
        
        if let authorizationHeader = Request.authorizationHeader(user: user, password: password) {
            headers[authorizationHeader.key] = authorizationHeader.value
        }
        
        // Stop a time entry
        Alamofire.request("https://www.toggl.com/api/v8/time_entries/"+self.timeEntryId+"/stop", method: .put, encoding: JSONEncoding.default, headers: headers)
            .responseJSON { response in
                print("Result: \(response.result)")
                if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                    print("Data: \(utf8Text)") // original server data as UTF8 string
                }
                switch response.result {
                case .success(let value):
                    // Get start time
                    let json = JSON(value)
                    let startDate = json["data"]["start"].stringValue
                    self.timeEntryId = json["data"]["id"].stringValue

                    // Stop timer
                    self.myTimer.stop()
                    self.myTimer.setDate(Date())
                    UserDefaults.standard.set("", forKey: "start_date")
                    self.updateComplication()
                    self.isStart = false
                    self.myButton.setTitle("Start")
                    return

                case .failure(let error):
                    print(error)
                    return
                }
        }
    }
    
    func updateComplication() {
        // Update complication
        for complication in CLKComplicationServer.sharedInstance().activeComplications! {
            CLKComplicationServer.sharedInstance().reloadTimeline(for: complication)
        }
    }
    
}
