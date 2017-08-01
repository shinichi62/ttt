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

    /// Prepares the resign responder button.
    fileprivate func prepareResignResponderButton() {
        let btn = RaisedButton(title: "Resign", titleColor: Color.blue.base)
        btn.addTarget(self, action: #selector(handleResignResponderButton(button:)), for: .touchUpInside)

        view.layout(btn).width(100).height(constant).top(40).right(20)
    }

    /// Handle the resign responder button.
    @objc
    internal func handleResignResponderButton(button: UIButton) {
        emailField?.resignFirstResponder()
        passwordField?.resignFirstResponder()
    }
    
}

extension ViewController {
    fileprivate func prepareEmailField() {
        emailField = ErrorTextField()
        emailField.placeholder = "Email"
        emailField.detail = "Error, incorrect email"
        emailField.isClearIconButtonEnabled = true
        emailField.delegate = self

        // Set the colors for the emailField, different from the defaults.
//        emailField.placeholderNormalColor = Color.amber.darken4
//        emailField.placeholderActiveColor = Color.pink.base
//        emailField.dividerNormalColor = Color.cyan.base
//        emailField.dividerActiveColor = Color.green.base
        // Set the text inset
//        emailField.textInset = 20

        let leftView = UIImageView()
        leftView.image = Icon.cm.audio
        emailField.leftView = leftView

        view.layout(emailField).center(offsetY: -passwordField.height - 60).left(20).right(20)
    }

    fileprivate func preparePasswordField() {
        passwordField = TextField()
        passwordField.placeholder = "Password"
        passwordField.detail = "At least 8 characters"
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