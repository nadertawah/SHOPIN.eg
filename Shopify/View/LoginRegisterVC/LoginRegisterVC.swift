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
        setUpUI()
    }

    //MARK: - IBOutlet(s)
    @IBOutlet weak var nameTextField: UITextField!
    
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
    @IBAction func loginRegisterBtnPressed(_ sender: Any)
    {
        if !emailTextField.text!.isEmpty && !passwordTextField.text!.isEmpty
        {
            if swipeLabel.text == "Swipe to Login"
            {
                if nameTextField.text!.isEmpty
                {
                    alert(title: "Error", message: "All fields are required!")
                }
                else
                {
                    //TODO: - Register new user
                    
                }
            }
            else
            {
                //TODO: - Login
                
                
            }
        }
       else
       {
           alert(title: "Error", message: "All fields are required!")
       }
    }
    
    func alert(title: String, message: String)
    {
        var alert = UIAlertController()
        alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        self.present(alert, animated: true)
    }
    
    //MARK: - Var(s)
    
    
    
    //MARK: - Helper Funcs
    func setUpUI()
    {
        //Set title
        title = "Register"
        
        //swipe to login/register
        let rightSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(self.swipe))
        rightSwipeGesture.direction = .right
        
        let lefttSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(self.swipe))
        lefttSwipeGesture.direction = .left

        
        self.view.addGestureRecognizer(rightSwipeGesture)
        self.view.addGestureRecognizer(lefttSwipeGesture)
        
    }
    
    @objc func swipe()
    {
        if swipeLabel.text == "Swipe to Login"
        {
            UIView.transition(with: self.loginRegisterBtn, duration: 0.5, options: [.transitionCrossDissolve], animations:
            {   [weak self] in
                self?.nameTextField.alpha = 0
                self?.loginRegisterBtn.shopifyBtn(title:"SIGN IN")
                self?.swipeLabel.text = "Swipe to Register"
                self?.title = "Login"
            })
        }
        else
        {
            UIView.transition(with: self.loginRegisterBtn, duration: 0.5, options: [.transitionCrossDissolve], animations:
            { [weak self] in
                self?.loginRegisterBtn.shopifyBtn(title:"SIGN UP")
                self?.nameTextField.alpha = 1
                self?.swipeLabel.text = "Swipe to Login"
                self?.title = "Register"
            })
        }
    }
    
    
    
}
