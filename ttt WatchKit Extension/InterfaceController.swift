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


class InterfaceController: WKInterfaceController {
    
    @IBOutlet var myTimer: WKInterfaceTimer!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
        myTimer.start()
        myTimer.setDate(Date(timeIntervalSinceNow: TimeInterval(-210)))

        // Get running time entry
        Alamofire.request("https://www.toggl.com/api/v8/time_entries/current")
            .authenticate(user: tokenxxx, password: api_token )
            .responseJSON { response in
                print("Request: \(String(describing: response.request))")   // original url request
                print("Response: \(String(describing: response.response))") // http url response
                print("Result: \(response.result)")                         // response serialization result

                if let json = response.result.value {
                    print("JSON: \(json)") // serialized json response
                }

                if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                    print("Data: \(utf8Text)") // original server data as UTF8 string
            }
        }

        // Get running time entry
        //let toggl = Toggl('tokenxxx')
        //let entry = toggl.getRunningTImeEntry()
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
}
