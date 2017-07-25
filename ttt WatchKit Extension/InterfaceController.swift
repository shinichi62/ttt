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
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
        myTimer.start()
        myTimer.setDate(Date(timeIntervalSinceNow: TimeInterval(-210)))
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()

        let user = "xxxxx"
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
                    let json = JSON(value)
                    print("Json: \(json["data"]["start"])")
                    
                    let iSO8601DateFormatter = ISO8601DateFormatter()
                    let string = json["data"]["start"].stringValue
                    let date = iSO8601DateFormatter.date(from: string)!
                    print(date)
                    
                    self.myTimer.setDate(date)
                case .failure(let error):
                    print(error)
                }
        }
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
}
