//
//  LoginViewController.swift
//  Wlif
//
//  Created by OSX on 01/07/2025.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var numberTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var errorMessage: UILabel!
    @IBOutlet weak var outerStack: UIStackView!
    @IBOutlet weak var loginStack: UIStackView!
    @IBOutlet weak var mobileNumberStack: UIStackView!
    
    
    private lazy var validator = LoginValidator()
    private lazy var viewModel = LoginViewModel(validator: validator)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {
//            let vc = self.storyboard?.instantiateViewController(withIdentifier: "OTPViewController") as! OTPViewController
//            self.navigationController?.pushViewController(vc, animated: true)
//        })
    }
    
    func setUI() {
        outerStack.semanticContentAttribute = .forceLeftToRight
        loginStack.semanticContentAttribute = .forceLeftToRight
        mobileNumberStack.semanticContentAttribute = .forceLeftToRight
        //numberTextField.semanticContentAttribute = .forceLeftToRight
    }

    func login() {
        
        loginButton.isEnabled = false
        
        errorMessage.text = ""
        
        viewModel.processLogin(mobileNumber: numberTextField.text ?? "") { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let loginModel):
                    print(loginModel)
                    self?.navigateToHome()
                case .failure(let error):
                    self?.errorMessage.text = error.localizedDescription
                }
                self?.loginButton.isEnabled = true
            }
        }
    }
    
    func navigateToHome() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "OTPViewController") as! OTPViewController
        vc.otpViewModel.userData = viewModel.userData
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func didTapLoginBtn(_ sender: Any) {
        login()
    }
}

