//
//  RegisterViewController.swift
//  SKROLLIE
//
//  Created by Dhaval Bhanderi on 4/15/19.
//  Copyright © 2019 Dhaval Bhanderi. All rights reserved.
//

import UIKit
import AudioToolbox
import SkyFloatingLabelTextField

class RegisterViewController: BaseViewController,UITextFieldDelegate
{
    // MARK: -  Outlets
    @IBOutlet weak var txtUserName: SkyFloatingLabelTextField!
    @IBOutlet weak var txtPassword: SkyFloatingLabelTextField!
    @IBOutlet weak var txtEmailAddress: SkyFloatingLabelTextField!
    @IBOutlet weak var txtBirthdate: SkyFloatingLabelTextField!
    
    @IBOutlet weak var viewUserName: UIView!
    @IBOutlet weak var viewPassword: UIView!
    @IBOutlet weak var viewEmail: UIView!
    @IBOutlet weak var viewBirthdate: UIView!
    
    @IBOutlet weak var lblRegister: UILabel!
    @IBOutlet weak var lblUsername: UILabel!
    @IBOutlet weak var lblPassword: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblBirthDate: UILabel!
    
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var btnAlreadyaUser: UIButton!
    
    // MARK: - Properties
    var datePicker : UIDatePicker!
    private let textField = UITextField()
    private let errorMessageUser = UILabel()
    private let errorMessagePassword = UILabel()
    private let errorMessageEmail = UILabel()
    private let errorMessageBirthDate = UILabel()
    
    // MARK: - LifeCycles
    override func viewDidLoad()
    {
        super.viewDidLoad()
        setupUI()
    }
    
    
    // MARK: -  Methods
    private func setupUI() {
        Setborder()
        
        txtEmailAddress.delegate = self
        txtUserName.delegate = self
        txtPassword.delegate = self
        
        txtUserName.titleFormatter = { $0.lowercased()}
        txtPassword.titleFormatter = { $0.lowercased()}
        txtEmailAddress.titleFormatter = { $0.lowercased()}
        txtBirthdate.titleFormatter = { $0.lowercased()}
        setupErrorMessage()
        setFont()
        
        txtBirthdate.addDatePicker()
    }
    
    func setFont()
    {
        lblRegister.font = UIFont.Bold(ofSize: 17)
        txtUserName.font = UIFont.Regular(ofSize: 14)
        txtPassword.font = UIFont.Regular(ofSize: 14)
        txtEmailAddress.font = UIFont.Regular(ofSize: 14)
        txtBirthdate.font = UIFont.Regular(ofSize: 14)
        btnNext.titleLabel?.font = UIFont.Bold(ofSize: 16)
        btnAlreadyaUser.titleLabel?.font = UIFont.Bold(ofSize: 15)
    }
    
    func setupErrorMessage()
    {
        //Username
        errorMessageUser.translatesAutoresizingMaskIntoConstraints = false
        errorMessageUser.font = UIFont.Regular(ofSize: 12)
        errorMessageUser.textColor = .red
        errorMessageUser.isHidden = true
        self.lblUsername.addSubview(errorMessageUser)
        //Password
        errorMessagePassword.translatesAutoresizingMaskIntoConstraints = false
        errorMessagePassword.font = UIFont.Regular(ofSize: 12)
        errorMessagePassword.textColor = .red
        errorMessagePassword.isHidden = true
        self.lblPassword.addSubview(errorMessagePassword)
        //Email
        errorMessageEmail.translatesAutoresizingMaskIntoConstraints = false
        errorMessageEmail.font = UIFont.Regular(ofSize: 12)
        errorMessageEmail.textColor = .red
        errorMessageEmail.isHidden = true
        self.lblEmail.addSubview(errorMessageEmail)
        //BirthDate
        errorMessageBirthDate.translatesAutoresizingMaskIntoConstraints = false
        errorMessageBirthDate.font = UIFont.Regular(ofSize: 12)
        errorMessageBirthDate.textColor = .red
        errorMessageBirthDate.isHidden = true
        self.lblBirthDate.addSubview(errorMessageBirthDate)
        
        NSLayoutConstraint.activate([textField.leadingAnchor.constraint(equalTo: textField.leadingAnchor),
                                     textField.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 10.0)])
    }
    
    func Setborder()
    {
        viewUserName.layer.borderColor =  UIColor.lightGray.cgColor
        viewUserName.layer.borderWidth = 1.0
        viewUserName.layer.cornerRadius = 3.0
        viewUserName.layer.masksToBounds = true
        viewPassword.layer.cornerRadius = 3.0
        viewPassword.layer.masksToBounds = true
        viewPassword.layer.borderColor =  UIColor.lightGray.cgColor
        viewPassword.layer.borderWidth = 1.0
        viewEmail.layer.borderColor =  UIColor.lightGray.cgColor
        viewEmail.layer.borderWidth = 1.0
        viewEmail.layer.cornerRadius = 3.0
        viewEmail.layer.masksToBounds = true
        viewBirthdate.layer.cornerRadius = 3.0
        viewBirthdate.layer.masksToBounds = true
        viewBirthdate.layer.borderColor =  UIColor.lightGray.cgColor
        viewBirthdate.layer.borderWidth = 1.0
        
        if let Logo = UIImage(named: "iconUserName"){
            
            txtUserName.addImage(image: Logo, direction: .Right, width: 25, height: 25, contentMode: .scaleAspectFit)
        }
        
        if let Logo = UIImage(named: "iconPassword"){
            
            txtPassword.addImage(image: Logo, direction: .Right, width: 25, height: 25, contentMode: .scaleAspectFit)
        }
        
        if let Logo = UIImage(named: "iconMail"){
            
            txtEmailAddress.addImage(image: Logo, direction: .Right, width: 25, height: 25, contentMode: .scaleAspectFit)
        }
        
        if let Logo = UIImage(named: "iconBirthdate"){
            
            txtBirthdate.addImage(image: Logo, direction: .Right, width: 25, height: 25, contentMode: .scaleAspectFit)
        }
    }
    
    @available(iOS 10.0, *)
    @objc func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason)
    {
        if textField == txtEmailAddress
        {
            let isEmailAddressValid = isValidEmailAddress(emailID: txtEmailAddress.text!)
            
            if (!isEmailAddressValid)
            {
                viewBirthdate.layer.borderColor =   UIColor.lightGray.cgColor
                viewBirthdate.layer.borderWidth = 1.0
                viewPassword.layer.borderColor =   UIColor.lightGray.cgColor
                viewPassword.layer.borderWidth = 1.0
                viewUserName.layer.borderColor =   UIColor.lightGray.cgColor
                viewUserName.layer.borderWidth = 1.0
                viewEmail.layer.borderColor =  UIColor.red.cgColor
                viewEmail.layer.borderWidth = 1.0
                errorMessagePassword.isHidden = true
                errorMessagePassword.text = ""
                errorMessageBirthDate.isHidden = true
                errorMessageBirthDate.text = ""
                errorMessageUser.isHidden = true
                errorMessageUser.text = ""
                errorMessageEmail.isHidden = false
                errorMessageEmail.text = "enter valide email"
                AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
                
                
            }
            else
            {
                webserviceOfEmailFormateCheck()
            }
        }
        
        if textField == txtUserName
        {
            if((txtUserName.text?.count)! < 2)
            {
                errorMessageBirthDate.isHidden = true
                errorMessageBirthDate.text = ""
                errorMessagePassword.isHidden = true
                errorMessagePassword.text = ""
                errorMessageEmail.isHidden = true
                errorMessageEmail.text = ""
                errorMessageUser.isHidden = false
                self.txtUserName.titleColor = UIColor.red
                errorMessageUser.text = "username must be at least 2 characters"
                viewPassword.layer.borderColor =  UIColor.lightGray.cgColor
                viewPassword.layer.borderWidth = 1.0
                viewEmail.layer.borderColor =   UIColor.lightGray.cgColor
                viewEmail .layer.borderWidth = 1.0
                viewBirthdate.layer.borderColor =   UIColor.lightGray.cgColor
                viewBirthdate.layer.borderWidth = 1.0
                viewUserName.layer.borderColor =  UIColor.red.cgColor
                viewUserName.layer.borderWidth = 1.0
                AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
                
            }
            else
            {
                CheckUSerNameValidAtServer()
            }
        }
        
        if textField == txtPassword
        {
            if(txtPassword.text?.count == 0)
            {
                errorMessageBirthDate.isHidden = true
                errorMessageBirthDate.text = ""
                errorMessageUser.isHidden = true
                errorMessageUser.text = ""
                errorMessageEmail.isHidden = true
                errorMessageEmail.text = ""
                errorMessagePassword.isHidden = false
                errorMessagePassword.text = "enter password"
                viewUserName.layer.borderColor =  UIColor.lightGray.cgColor
                viewUserName.layer.borderWidth = 1.0
                viewEmail.layer.borderColor =   UIColor.lightGray.cgColor
                viewEmail.layer.borderWidth = 1.0
                viewBirthdate.layer.borderColor =   UIColor.lightGray.cgColor
                viewBirthdate.layer.borderWidth = 1.0
                viewPassword.layer.borderColor =  UIColor.red.cgColor
                viewPassword.layer.borderWidth = 1.0
                AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
                
            }
            else if((txtPassword.text?.count)! < 6)
            {
                
                errorMessageBirthDate.isHidden = true
                errorMessageBirthDate.text = ""
                errorMessageUser.isHidden = true
                errorMessageUser.text = ""
                errorMessageEmail.isHidden = true
                errorMessageEmail.text = ""
                errorMessagePassword.isHidden = false
                errorMessagePassword.text = "passwords must be 6 characters long"
                viewUserName.layer.borderColor =   UIColor.lightGray.cgColor
                viewUserName.layer.borderWidth = 1.0
                viewEmail.layer.borderColor =   UIColor.lightGray.cgColor
                viewEmail.layer.borderWidth = 1.0
                viewBirthdate.layer.borderColor =  UIColor.lightGray.cgColor
                viewBirthdate.layer.borderWidth = 1.0
                viewPassword.layer.borderColor =  UIColor.red.cgColor
                viewPassword.layer.borderWidth = 1.0
                AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
                
            }
            else
            {
                errorMessageBirthDate.isHidden = true
                errorMessageBirthDate.text = ""
                errorMessageUser.isHidden = true
                errorMessageUser.text = ""
                errorMessageEmail.isHidden = true
                errorMessageEmail.text = ""
                errorMessagePassword.isHidden = true
                errorMessagePassword.text = ""
                viewUserName.layer.borderColor =   UIColor.lightGray.cgColor
                viewUserName.layer.borderWidth = 1.0
                viewEmail.layer.borderColor =   UIColor.lightGray.cgColor
                viewEmail.layer.borderWidth = 1.0
                viewBirthdate.layer.borderColor =  UIColor.lightGray.cgColor
                viewBirthdate.layer.borderWidth = 1.0
                viewPassword.layer.borderColor =  UIColor.lightGray.cgColor
                viewPassword.layer.borderWidth = 1.0
            }
        }
    }
    
    @IBAction func btnNext(_ sender: UIButton)
    {
        
        if validateAllFields()
        {
            registrationAtServer()
        }
    }
    @IBAction func btnAlreadyAUser(_ sender: UIButton)
    {
        navigationController?.popViewController(animated: true)
    }
    
    
    // MARK: - validation Email Methods
    
    func isValidEmailAddress(emailID: String) -> Bool
    {
        var returnValue = true
        let emailRegEx = "[A-Z0-9a-z.-_]+@[A-Za-z)-9.-]+\\.[A-Za-z]{2,3}"
        
        do{
            let regex = try NSRegularExpression(pattern: emailRegEx)
            let nsString = emailID as NSString
            let results = regex.matches(in: emailID, range: NSRange(location: 0, length: nsString.length))
            
            if results.count == 0
            {
                returnValue = false
            }
        }
        catch let error as NSError {
            print("invalid regex: \(error.localizedDescription)")
            returnValue = false
        }
        return returnValue
    }
    
    
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == txtUserName {
            let allowedCharacters = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz_1234567890"
            
            let allowedCharacterSet = CharacterSet(charactersIn: allowedCharacters)
            let typedCharacterSet = CharacterSet(charactersIn: string)
            let alphabet = allowedCharacterSet.isSuperset(of: typedCharacterSet)
            return alphabet
            
        }
        return true
    }
    
    // MARK: - validation
    
    
    func validateAllFields() -> Bool
    {
        
        
        
        if (txtUserName.text?.count == 0) && (txtPassword.text?.count == 0) && (txtEmailAddress.text?.count == 0) && (txtBirthdate.text?.count  == 0)
        {
            
            errorMessagePassword.isHidden = true
            errorMessagePassword.text = ""
            errorMessageEmail.isHidden = true
            errorMessageEmail.text = ""
            errorMessageUser.isHidden =  true
            errorMessageUser.text = ""
            errorMessageBirthDate.isHidden = false
            errorMessageBirthDate.text = "fill all details"
            viewUserName.layer.borderColor =  UIColor.red.cgColor
            viewUserName.layer.borderWidth = 1.0
            viewPassword.layer.borderColor =  UIColor.red.cgColor
            viewPassword.layer.borderWidth = 1.0
            viewEmail.layer.borderColor =  UIColor.red.cgColor
            viewEmail.layer.borderWidth = 1.0
            viewBirthdate.layer.borderColor =  UIColor.red.cgColor
            viewBirthdate.layer.borderWidth = 1.0
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
            return false
        }
            
        else if (self.txtUserName.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).count == 0)
        {
            errorMessageBirthDate.isHidden = true
            errorMessageBirthDate.text = ""
            errorMessagePassword.isHidden = true
            errorMessagePassword.text = ""
            errorMessageEmail.isHidden = true
            errorMessageEmail.text = ""
            errorMessageUser.isHidden = false
            errorMessageUser.text = "enter user name"
            viewPassword.layer.borderColor =   UIColor.lightGray.cgColor
            viewPassword.layer.borderWidth = 1.0
            viewEmail.layer.borderColor =   UIColor.lightGray.cgColor
            viewEmail .layer.borderWidth = 1.0
            viewBirthdate.layer.borderColor =   UIColor.lightGray.cgColor
            viewBirthdate.layer.borderWidth = 1.0
            viewUserName.layer.borderColor =  UIColor.red.cgColor
            viewUserName.layer.borderWidth = 1.0
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
            return false
        }
            
        else if(txtPassword.text?.count == 0)
        {
            errorMessageBirthDate.isHidden = true
            errorMessageBirthDate.text = ""
            errorMessageUser.isHidden = true
            errorMessageUser.text = ""
            errorMessageEmail.isHidden = true
            errorMessageEmail.text = ""
            errorMessagePassword.isHidden = false
            errorMessagePassword.text = "enter password"
            viewUserName.layer.borderColor =  UIColor.lightGray.cgColor
            viewUserName.layer.borderWidth = 1.0
            viewEmail.layer.borderColor =   UIColor.lightGray.cgColor
            viewEmail.layer.borderWidth = 1.0
            viewBirthdate.layer.borderColor =   UIColor.lightGray.cgColor
            viewBirthdate.layer.borderWidth = 1.0
            viewPassword.layer.borderColor =  UIColor.red.cgColor
            viewPassword.layer.borderWidth = 1.0
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
            return false
        }
        else if((txtPassword.text?.count)! < 6)
        {
            
            errorMessageBirthDate.isHidden = true
            errorMessageBirthDate.text = ""
            errorMessageUser.isHidden = true
            errorMessageUser.text = ""
            errorMessageEmail.isHidden = true
            errorMessageEmail.text = ""
            errorMessagePassword.isHidden = false
            errorMessagePassword.text = "passwords must be 6 characters long"
            viewUserName.layer.borderColor =   UIColor.lightGray.cgColor
            viewUserName.layer.borderWidth = 1.0
            viewEmail.layer.borderColor =   UIColor.lightGray.cgColor
            viewEmail.layer.borderWidth = 1.0
            viewBirthdate.layer.borderColor =  UIColor.lightGray.cgColor
            viewBirthdate.layer.borderWidth = 1.0
            viewPassword.layer.borderColor =  UIColor.red.cgColor
            viewPassword.layer.borderWidth = 1.0
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
            return false
        }
            
        else if  (self.txtEmailAddress.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).count == 0)
        {
            errorMessagePassword.isHidden = true
            errorMessagePassword.text = ""
            errorMessageBirthDate.isHidden = true
            errorMessageBirthDate.text = ""
            errorMessageUser.isHidden = true
            errorMessageUser.text = ""
            errorMessageEmail.isHidden = false
            errorMessageEmail.text = "please enter email"
            viewBirthdate.layer.borderColor =   UIColor.lightGray.cgColor
            viewBirthdate.layer.borderWidth = 1.0
            viewPassword.layer.borderColor =   UIColor.lightGray.cgColor
            viewPassword.layer.borderWidth = 1.0
            viewUserName.layer.borderColor =  UIColor.lightGray.cgColor
            viewUserName.layer.borderWidth = 1.0
            viewEmail.layer.borderColor =  UIColor.red.cgColor
            viewEmail.layer.borderWidth = 1.0
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
            
            return false
        }
        else if (txtBirthdate.text?.count == 0)
        {
            errorMessageEmail.isHidden = true
            errorMessageEmail.text = ""
            errorMessageUser.isHidden = true
            errorMessageUser.text = ""
            errorMessagePassword.isHidden = true
            errorMessagePassword.text = ""
            errorMessageBirthDate.isHidden = false
            errorMessageBirthDate.text = "enter birthdate"
            viewEmail.layer.borderColor =   UIColor.lightGray.cgColor
            viewEmail.layer.borderWidth = 1.0
            viewPassword.layer.borderColor =  UIColor.lightGray.cgColor
            viewPassword.layer.borderWidth = 1.0
            viewUserName.layer.borderColor =   UIColor.lightGray.cgColor
            viewUserName.layer.borderWidth = 1.0
            viewBirthdate.layer.borderColor =  UIColor.red.cgColor
            viewBirthdate.layer.borderWidth = 1.0
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
            
            return false
        }
        
        return true
    }
}


// MARK: -  Webservie Call

extension RegisterViewController
{
    
    private func registrationAtServer() {
        
        let parameter = ParameterRequest()
        
       
        let newDateString = txtBirthdate.text!.getDateWithFormate(formate: "MMM dd, yyyy", timezone: TimeZone.current.abbreviation()!)
        let newNsDate = newDateString.getDateStringWithFormate("yyyy-MM-dd", timezone: TimeZone.current.abbreviation()!)
        
    
        parameter.addParameter(key: ParameterRequest.username, value: txtUserName.text)
        parameter.addParameter(key: ParameterRequest.password, value: txtPassword.text)
        parameter.addParameter(key: ParameterRequest.emailaddress, value: txtEmailAddress.text)
        parameter.addParameter(key: ParameterRequest.Birthdate, value: newNsDate)

        
        _ = APIClient.Register(parameters: parameter.parameters, success: { responseObj in
            let response = responseObj ?? [String : Any]()
            let responseData = ResponseDataModel(responseObj: response)
            
            if responseData.success {
                AppPrefsManager.shared.saveUserProfileData(model: UserProfileModel(data: response["data"] as? [String : Any] ?? [String : Any](), totalTodayPost: "", totalForeverPost: ""))
                let vc = MobileNumberAddVc.instantiate(fromAppStoryboard: .Main)
                self.navigationController?.pushViewController(vc, animated: true)
            } else if !responseData.success {
                AppDelegate.sharedDelegate().window?.showToastAtBottom(message: responseData.message)
            }
        })
    }
    
    
    private func webserviceOfEmailFormateCheck() {
        
        _ = APIClient.CheckEmailAddress(email: txtEmailAddress.text!, success: { responseObj in
            let response = responseObj ?? [String : Any]()
            let responseData = ResponseDataModel(responseObj: response)
            
            if responseData.success {
                self.errorMessageEmail.isHidden = true
                self.errorMessageEmail.text = ""
                self.viewEmail.layer.borderColor =  UIColor.lightGray.cgColor
                self.viewEmail.layer.borderWidth = 1.0
                self.txtEmailAddress.errorMessage = ""
                self.txtEmailAddress.titleColor = UIColor.green
                self.verifyEMailAtServer()
                
            } else if !responseData.success {
                self.errorMessageEmail.isHidden = false
                self.errorMessageEmail.text = "enter valide email"
                AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
                self.viewEmail.layer.borderColor =  UIColor.red.cgColor
                self.viewEmail.layer.borderWidth = 1.0
                self.txtEmailAddress.titleColor = UIColor.red
               
            }
        })
    }

    
    private func verifyEMailAtServer() {
        
        _ = APIClient.VerifyEmailAddress(email: txtEmailAddress.text!, success: { responseObj in
            let response = responseObj ?? [String : Any]()
            let responseData = ResponseDataModel(responseObj: response)
            
            if responseData.success {
                self.errorMessageEmail.isHidden = false
                self.errorMessageEmail.text =  "email already in use"
                AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
                self.viewEmail.layer.borderColor =  UIColor.red.cgColor
                self.viewEmail.layer.borderWidth = 1.0
                self.txtEmailAddress.titleColor = UIColor.red
                
            } else if !responseData.success {
                self.errorMessageEmail.isHidden = true
                self.errorMessageEmail.text = ""
                self.viewEmail.layer.borderColor =  UIColor.lightGray.cgColor
                self.viewEmail.layer.borderWidth = 1.0
                self.txtEmailAddress.errorMessage = ""
                self.txtEmailAddress.titleColor = UIColor.green
                
            }
        })
    }
    
    private func CheckUSerNameValidAtServer() {
        
        _ = APIClient.VerifyUserName(username: txtUserName.text!, success: { responseObj in
            let response = responseObj ?? [String : Any]()
            let responseData = ResponseDataModel(responseObj: response)
            
            if responseData.success {
                self.errorMessageUser.isHidden = false
                self.errorMessageUser.text =  "try a different username"
                
                self.viewUserName.layer.borderColor =  UIColor.lightGray.cgColor
                self.viewUserName.layer.borderWidth = 1.0
                self.txtUserName.titleColor = UIColor.red
                AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
                
            } else if !responseData.success {
                self.errorMessageUser.isHidden = true
                self.errorMessageUser.text =  ""
                self.viewUserName.layer.borderColor = UIColor.lightGray.cgColor
                self.viewUserName.layer.borderWidth = 1.0
                self.txtUserName.errorMessage = ""
                self.txtUserName.titleColor = UIColor.green
                
            }
        })
    }
    
}

extension UIDevice {
    static func vibrate() {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
    }
}

