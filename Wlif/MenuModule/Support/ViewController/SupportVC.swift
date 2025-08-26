//
//  SupportVC.swift
//  Wlif
//
//  Created by OSX on 07/08/2025.
//

import UIKit

class SupportVC: UIViewController {
    
    let viewModel = SupportViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        self.navigationController?.navigationBar.isHidden = true
        bind()
        viewModel.getSupport()
    }
    
    func bind() {
        viewModel.isLoading.bind { [weak self] isLoading in
            guard let self = self,
                  let isLoading = isLoading else {
                return
            }
            DispatchQueue.main.async {
                if isLoading {
                    self.showLoadingIndicator()
                } else {
                    self.hideLoadingIndicator()
                }
            }
        }
    }
    
    
    @IBAction func didTapEmailBtn(_ sender: Any) {
        if let email = viewModel.support?.email, let url = URL(string: "mailto:\(email)") {
            UIApplication.shared.open(url)
        }
    }
    
    @IBAction func didTapCallBtn(_ sender: Any) {
        guard let phone = viewModel.support?.phone,
              let phoneURL = URL(string: "tel://\(phone)"),
              UIApplication.shared.canOpenURL(phoneURL) else {
            return
        }
        UIApplication.shared.open(phoneURL)
    }
    
    @IBAction func didTapWhatsAppBtn(_ sender: Any) {
        if let number = viewModel.support?.whatsapp, let url = URL(string: "https://wa.me/\(number)") {
            UIApplication.shared.open(url)
        }
    }
    
    @IBAction func didTapSocialMediaBtn(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SocialMediaVC") as! SocialMediaVC
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true)
    }
    
    
    @IBAction func didTapSubmitTicket(_ sender: Any) {
        
    }
    
    @IBAction func didTapBackBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
