//
//  LoginRegisterVC.swift
//  Shopify
//
//  Created by Nader Said on 22/06/2022.
//

import UIKit

class LoginRegisterVC: UIViewController
{
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //set UI
        setUpUI()
    }

    //MARK: - IBOutlet(s)
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var phoneNumberTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var loginRegisterBtn: UIButton!
    {
        didSet
        {
            loginRegisterBtn.shopifyBtn(title: "SIGN UP")
        }
    }
    
    @IBOutlet weak var swipeLabel: UILabel!
    
    
    //MARK: - IBAction(s)
    @IBAction func emailTFChanged(_ sender: UITextField)
    {
        sender.text = sender.text?.lowercased()
    }
    @IBAction func loginRegisterBtnPressed(_ sender: Any)
    {
        if !emailTextField.text!.isEmpty && !passwordTextField.text!.isEmpty
        {
            if swipeLabel.text == "Swipe to Login"
            {
                if nameTextField.text!.isEmpty && !phoneNumberTextField.text!.isEmpty
                {
                    let alert = Alerts.instance.showAlert(title: "", message: "All fields are required!")
                    self.present(alert, animated: true)
                }
                else
                {
                    // Register new user
                    VM.register(name: nameTextField.text!, email: emailTextField.text!, password: passwordTextField.text!,phone: phoneNumberTextField.text!)
                    { [weak self] resulMsg in
                        
                        DispatchQueue.main.async
                        {
                            [weak self] in
                            let alert = Alerts.instance.showAlert(title: "", message: resulMsg)
                            self?.present(alert, animated: true)
                        }
                    }
                }
            }
            else
            {
                // Login
                VM.login(email: emailTextField.text!, password: passwordTextField.text!)
                { [weak self] resulMsg,LoggedIn  in
                    
                    DispatchQueue.main.async
                    {
                        [weak self] in
                        
                        var alert = UIAlertController()
                        alert = UIAlertController(title: "", message: resulMsg, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: .default)
                                        {
                            _ in
                            if LoggedIn {self?.navigationController?.popViewController(animated: true)}})
                        
                        self?.present(alert, animated: true)
                    
                    }
                }
            }
        }
       else
       {
           let alert = Alerts.instance.showAlert(title: "", message: "All fields are required!")
           self.present(alert, animated: true)
       }
    }
    
    //MARK: - Var(s)
    var VM : LoginRegisterVM!
    
    
    //MARK: - Helper Funcs
    func setUpUI()
    {
        //Set title
        title = "Register"
        
        //swipe to login/register
        let rightSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(self.swipe))
        rightSwipeGesture.direction = .right
        
        let leftSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(self.swipe))
        leftSwipeGesture.direction = .left

        //Add Gestures
        self.view.addGestureRecognizer(rightSwipeGesture)
        self.view.addGestureRecognizer(leftSwipeGesture)
        self.hideKeyboardWhenTappedAround()
        
    }
    
    @objc func swipe()
    {
        if swipeLabel.text == "Swipe to Login"
        {
            UIView.animate(withDuration: 0.5)
            {[weak self] in
                self?.nameTextField.alpha = 0
                self?.phoneNumberTextField.alpha = 0
                self?.loginRegisterBtn.shopifyBtn(title:"SIGN IN")
                self?.swipeLabel.text = "Swipe to Register"
                self?.title = "Login"
            }
        }
        else
        {
            UIView.animate(withDuration: 0.5)
            {[weak self] in
                self?.loginRegisterBtn.shopifyBtn(title:"SIGN UP")
                self?.nameTextField.alpha = 1
                self?.phoneNumberTextField.alpha = 1
                self?.swipeLabel.text = "Swipe to Login"
                self?.title = "Register"
            }
        }
    }
}
