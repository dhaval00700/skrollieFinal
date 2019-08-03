//
//  ForgotPasswordViewController.swift
//  SKROLLIE
//
//  Created by PC on 02/08/19.
//  Copyright © 2019 Dhaval Bhanderi. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class ForgotPasswordViewController: UIViewController {
    
    @IBOutlet weak var txtUsername: SkyFloatingLabelTextField!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var ViewUserName: UIView!
    
    private let errorMessageUser = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    // MARK: - Methods
    private func setupUI() {
        txtUsername.titleFormatter = { $0.lowercased() }
        
        ViewUserName.layer.borderColor =  UIColor.lightGray.cgColor
        ViewUserName.layer.borderWidth = 1.0
        ViewUserName.layer.cornerRadius = 3.0
        ViewUserName.layer.masksToBounds = true

        
        if let Logo = UIImage(named: "iconUserName"){
            
            txtUsername.addImage(image: Logo, direction: .Right, width: 25, height: 25, contentMode: .scaleAspectFit)
        }
        
        setFont()
    }
    
    func setFont()
    {
        txtUsername.font = UIFont.Regular(ofSize: 14)
        
    }
    
    func setupErrorMessage()
    {
        //Username
        errorMessageUser.translatesAutoresizingMaskIntoConstraints = false
        errorMessageUser.font = UIFont.Regular(ofSize: 12)
        errorMessageUser.textColor = .red
        errorMessageUser.isHidden = true
        
    }
    
    @IBAction func btnForgotPassword(_ sender: UIButton) {
        if txtUsername.text!.isEmpty {
            AppDelegate.sharedDelegate().window?.showToastAtBottom(message: "Enter Username or Email")
        } else {
            forgotPassword()
        }
    }
    
    @IBAction func onBtnBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - API Call
extension ForgotPasswordViewController {
    private func forgotPassword() {
        
        let parameter = ParameterRequest()
        parameter.addParameter(key: ParameterRequest.username, value: txtUsername.text)
        
        _ = APIClient.ForgotPassword(parameters: parameter.parameters, success: { responseObj in
            let response = responseObj ?? [String : Any]()
            let responseData = ResponseDataModel(responseObj: response)
            
            if responseData.success {
                AppDelegate.sharedDelegate().window?.showToastAtBottom(message: responseData.message)
                self.navigationController?.popViewController(animated: true)
            } else {
                AppDelegate.sharedDelegate().window?.showToastAtBottom(message: responseData.message)
            }
        })
    }
}
