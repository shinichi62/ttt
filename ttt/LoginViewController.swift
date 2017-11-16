//
//  LoginViewController.swift
//  ttt
//
//  Created by shinichi yamaguchi on 2017/08/01.
//  Copyright © 2017 shinichi yamaguchi. All rights reserved.
//

import UIKit
import Material
import Alamofire
import SwiftyJSON
import WatchConnectivity


class LoginViewController: UIViewController, WCSessionDelegate {

    /** Called when all delegate callbacks for the previously selected watch has occurred. The session can be re-activated for the now selected watch using activateSession. */
    @available(iOS 9.3, *)
    func sessionDidDeactivate(_ session: WCSession) {
        print("session sessionDidDeactivate")
    }

    /** Called when the session can no longer be used to modify or add any new transfers and, all interactive messages will be cancelled, but delegate callbacks for background transfers can still occur. This will happen when the selected watch is being changed. */
    @available(iOS 9.3, *)
    func sessionDidBecomeInactive(_ session: WCSession) {
        print("session sessionDidBecomeInactive")
    }

    /** Called when the session has completed activation. If session state is WCSessionActivationStateNotActivated there will be an error with more details. */
    @available(iOS 9.3, *)
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("session ios")
        print("receive::\(activationState)")
    }

    fileprivate var emailField: ErrorTextField!
    fileprivate var passwordField: TextField!

    /// A constant to layout the textFields.
    fileprivate let constant: CGFloat = 32

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        view.backgroundColor = Color.grey.lighten5

        preparePasswordField()
        prepareEmailField()
        prepareResignResponderButton()
        
        
        if (WCSession.isSupported()) {
            let session = WCSession.default()
            session.delegate = self as? WCSessionDelegate
            session.activate()
            
            
            let sendMessage = ["body":"sendApplicationContext"] //送信したいデータを設定
            do {
                try session.updateApplicationContext(sendMessage)
            } catch {
                print("updateApplicationContext error")
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension LoginViewController {
    /// Prepares the resign responder button.
    fileprivate func prepareResignResponderButton() {
        let btn = RaisedButton(title: "Login", titleColor: Color.blue.base)
        btn.addTarget(self, action: #selector(handleResignResponderButton(button:)), for: .touchUpInside)
        
    }
    
    /// Handle the resign responder button.
    @objc
    internal func handleResignResponderButton(button: UIButton) {
        emailField?.resignFirstResponder()
        passwordField?.resignFirstResponder()

        
        let user = emailField.text!
        let password = passwordField.text!

        var headers: HTTPHeaders = [:]
        
        if let authorizationHeader = Request.authorizationHeader(user: user, password: password) {
            headers[authorizationHeader.key] = authorizationHeader.value
        }

        do {
            let applicationDict = ["hoge" : "huga"]
            try WCSession.default().updateApplicationContext(applicationDict)
            print(applicationDict)
        } catch {
            // エラー処理
            print("session error")
        }

        // Get running time entry
        Alamofire.request("https://www.toggl.com/api/v8/me", headers: headers)
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    
                    print(value)

                    // Get start time
                    let json = JSON(value)
                    let api_token = json["data"]["api_token"].stringValue
                    UserDefaults.standard.set(api_token, forKey: "api_token")
                    
                    do {
                        let applicationDict = ["hoge" : "huga"]
                        try WCSession.default().updateApplicationContext(applicationDict)
                        print(applicationDict)
                    } catch {
                        // エラー処理
                        print("session error")
                    }

                case .failure(let error):
                    print(error)
                    return
                }
        }

        
        
        
        
        
    }
    
    fileprivate func prepareEmailField() {
        emailField = ErrorTextField()
        emailField.placeholder = "Email"
        emailField.detail = "Error, incorrect email"
        emailField.detail = ""
        emailField.isClearIconButtonEnabled = true
        emailField.delegate = self
        emailField.isErrorRevealed = true
    }

    func preparePasswordField() {
        passwordField = TextField()
        passwordField.placeholder = "Password"
        passwordField.detail = ""
        passwordField.clearButtonMode = .whileEditing
        passwordField.isVisibilityIconButtonEnabled = true

        // Setting the visibilityIconButton color.
        passwordField.visibilityIconButton?.tintColor = Color.green.base.withAlphaComponent(passwordField.isSecureTextEntry ? 0.38 : 0.54)

        view.layout(passwordField).center().left(20).right(20)
    }
}

extension UIViewController: TextFieldDelegate {
    public func textFieldDidEndEditing(_ textField: UITextField) {
        (textField as? ErrorTextField)?.isErrorRevealed = false
    }

    public func textFieldShouldClear(_ textField: UITextField) -> Bool {
        (textField as? ErrorTextField)?.isErrorRevealed = false
        return true
    }

    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        (textField as? ErrorTextField)?.isErrorRevealed = false
        return true
    }
}
