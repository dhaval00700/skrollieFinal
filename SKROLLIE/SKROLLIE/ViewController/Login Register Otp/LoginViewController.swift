
//
//  LoginViewController.swift
//  SKROLLIE
//
//  Created by Dhaval Bhanderi on 4/15/19.
//  Copyright © 2019 Dhaval Bhanderi. All rights reserved.
//

import UIKit
import AudioToolbox
import SkyFloatingLabelTextField

class LoginViewController: BaseViewController
{
    // MARK: - Outlets
    @IBOutlet weak var ViewUserName: UIView!
    @IBOutlet weak var viewPassword: UIView!
    
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblPassword: UILabel!
    @IBOutlet weak var lblRegiter: UILabel!
    @IBOutlet weak var lblThorughthelenswithtwimoji: UILabel!
    @IBOutlet weak var lblConnectwithfriendsndLive: UILabel!
    @IBOutlet weak var lblLoginTitle: UILabel!
    
    @IBOutlet weak var txtUsername: SkyFloatingLabelTextField!
    @IBOutlet weak var txtPassword: SkyFloatingLabelTextField!
    
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btnForgotPass: UIButton!
    
    // MARK: - Properties
    private let textField = UITextField()
    private let errorMessageUser = UILabel()
    private let errorMessagePassword = UILabel()
    
    // MARK: - LifeCycles
    override func viewDidLoad()
    {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.isNavigationBarHidden = true
    }
    
    // MARK: - Methods
    private func setupUI() {
        setBorder()
        txtUsername.titleFormatter = { $0.lowercased() }
        txtPassword.titleFormatter = { $0.lowercased() }
        
        if isDevelopmentMode {
            txtUsername.text = "bini"
            txtPassword.text = "123456"
        }
        
        setupErrorMessage()
        setFont()
    }
    
    func setFont()
    {
        lblLoginTitle.font = UIFont.Bold(ofSize: 17)
        txtUsername.font = UIFont.Regular(ofSize: 14)
        txtPassword.font = UIFont.Regular(ofSize: 14)
        
        btnLogin.titleLabel?.font = UIFont.Bold(ofSize: 16)
        btnForgotPass.titleLabel?.font = UIFont.Regular(ofSize: 15)
        lblRegiter.font = UIFont.Bold(ofSize: 16)
        
        lblConnectwithfriendsndLive.font = UIFont.Bold(ofSize: 16)
        lblThorughthelenswithtwimoji.font = UIFont.Bold(ofSize: 16)
        
    }
    
    func setupErrorMessage()
    {
        //Username
        errorMessageUser.translatesAutoresizingMaskIntoConstraints = false
        errorMessageUser.font = UIFont.Regular(ofSize: 12)
        errorMessageUser.textColor = .red
        errorMessageUser.isHidden = true
        self.lblUserName.addSubview(errorMessageUser)
        
        //Password
        errorMessagePassword.translatesAutoresizingMaskIntoConstraints = false
        errorMessagePassword.font = UIFont.Regular(ofSize: 12)
        errorMessagePassword.textColor = .red
        errorMessagePassword.isHidden = true
        self.lblPassword.addSubview(errorMessagePassword)
        
    }
    func setBorder()
    {
        ViewUserName.layer.borderColor =  UIColor.lightGray.cgColor
        ViewUserName.layer.borderWidth = 1.0
        ViewUserName.layer.cornerRadius = 3.0
        ViewUserName.layer.masksToBounds = true
        
        viewPassword.layer.borderColor =  UIColor.lightGray.cgColor
        viewPassword.layer.borderWidth = 1.0
        viewPassword.layer.cornerRadius = 3.0
        viewPassword.layer.masksToBounds = true
        
        if let Logo = UIImage(named: "iconUserName"){
            
            txtUsername.addImage(image: Logo, direction: .Right, width: 25, height: 25, contentMode: .scaleAspectFit)
        }
        
        if let Logo = UIImage(named: "iconPassword"){
            
            txtPassword.addImage(image: Logo, direction: .Right, width: 25, height: 25, contentMode: .scaleAspectFit)
        }
        
        
    }
    
    func validateAllFields() -> Bool
    {
        if (txtUsername.text?.count == 0) && (txtPassword.text?.count == 0)
        {
            errorMessageUser.isHidden = true
            errorMessageUser.text = ""
            errorMessagePassword.isHidden = false
            errorMessagePassword.text = "fill all details"
            ViewUserName.layer.borderColor =  UIColor.red.cgColor
            ViewUserName.layer.borderWidth = 1.0
            viewPassword.layer.borderColor =  UIColor.red.cgColor
            viewPassword.layer.borderWidth = 1.0
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
            return false
        }
        else if (self.txtUsername.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).count == 0)
        {
            errorMessagePassword.isHidden = true
            errorMessagePassword.text = ""
            errorMessageUser.isHidden = false
            errorMessageUser.text = "enter user name"
            viewPassword.layer.borderColor =   UIColor.lightGray.cgColor
            viewPassword.layer.borderWidth = 1.0
            ViewUserName.layer.borderColor =  UIColor.red.cgColor
            ViewUserName .layer.borderWidth = 1.0
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
            return false
        }
            
        else if (self.txtPassword.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).count == 0){
            
            errorMessageUser.isHidden = true
            errorMessageUser.text = ""
            errorMessagePassword.isHidden = false
            errorMessagePassword.text = "enter password"
            viewPassword.layer.borderColor =  UIColor.red.cgColor
            viewPassword.layer.borderWidth = 1.0
            ViewUserName.layer.borderColor =   UIColor.lightGray.cgColor
            ViewUserName .layer.borderWidth = 1.0
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
            return false
        }
            
        else if((txtPassword.text?.count)! < 6)
        {
            errorMessageUser.isHidden = true
            errorMessageUser.text = ""
            errorMessagePassword.isHidden = false
            errorMessagePassword.text = "passwords must be 6 characters long"
            viewPassword.layer.borderColor =  UIColor.red.cgColor
            viewPassword.layer.borderWidth = 1.0
            ViewUserName.layer.borderColor =  UIColor.lightGray.cgColor
            ViewUserName .layer.borderWidth = 1.0
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
            return false
        }
        return true
    }
    
    // MARK: - Actions
    @IBAction func btnRegister(_ sender: Any)
    {
        let vc = RegisterViewController.instantiate(fromAppStoryboard: .Main)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnLogin(_ sender: UIButton)
    {
        if validateAllFields()
        {
            signIn()
        }
        
    }
    
    @IBAction func btnForgotPass(_ sender: UIButton)
    {
        
    }
}

// MARK: - API Call
extension LoginViewController {
    private func signIn() {
        
        let parameter = ParameterRequest()
        parameter.addParameter(key: ParameterRequest.username, value: txtUsername.text)
        parameter.addParameter(key: ParameterRequest.password, value: txtPassword.text)
        
        _ = APIClient.LogIn(parameters: parameter.parameters, success: { responseObj in
            let response = responseObj ?? [String : Any]()
            let responseData = ResponseDataModel(responseObj: response)
            
            if responseData.success {
                let loginModel = LoginModel(data: response)
                
                AppPrefsManager.shared.setIsUserLogin(isUserLogin: true)
                AppPrefsManager.shared.saveUserData(model: loginModel)
                
                let vc = HomeViewController.instantiate(fromAppStoryboard: .Main)
                self.navigationController?.pushViewController(vc, animated: true)
                
            } else if !responseData.success {
                if responseData.message == "OTP" {
                    AppPrefsManager.shared.saveUserData(model: LoginModel(data: response["data"] as? [String : Any] ?? [String : Any]()))
                    let vc = MobileNumberAddVc.instantiate(fromAppStoryboard: .Main)
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                } else {
                    self.errorMessagePassword.isHidden = false
                    self.errorMessagePassword.text = responseData.message
                    self.viewPassword.layer.borderColor =  UIColor.red.cgColor
                    self.viewPassword.layer.borderWidth = 1.0
                    self.ViewUserName.layer.borderColor =  UIColor.red.cgColor
                    self.ViewUserName .layer.borderWidth = 1.0
                    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
                }
            }
        })
    }
}
