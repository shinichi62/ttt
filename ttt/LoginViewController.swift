//
//  LoginViewController.swift
//  ttt
//
//  Created by shinichi yamaguchi on 2017/08/01.
//  Copyright © 2017 shinichi yamaguchi. All rights reserved.
//

import UIKit
import Material

class LoginViewController: UIViewController {
    
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
        
        view.layout(btn).height(40).center(offsetY: -passwordField.height + 120).left(20).right(20)
    }
    
    /// Handle the resign responder button.
    @objc
    internal func handleResignResponderButton(button: UIButton) {
        emailField?.resignFirstResponder()
        passwordField?.resignFirstResponder()
        print(emailField.text ?? "")
        print(passwordField.text ?? "")
    }
    
    fileprivate func prepareEmailField() {
        emailField = ErrorTextField()
        emailField.placeholder = "Email"
        emailField.detail = "Error, incorrect email"
        emailField.detail = ""
        emailField.isClearIconButtonEnabled = true
        emailField.delegate = self
        emailField.isErrorRevealed = true
        view.layout(emailField).center(offsetY: -passwordField.height - 60).left(20).right(20)
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
