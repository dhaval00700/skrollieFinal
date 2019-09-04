//
//  MobileNumberAddVc.swift
//  SKROLLIE
//
//  Created by Dhaval Bhanderi on 5/9/19.
//  Copyright © 2019 Dhaval Bhanderi. All rights reserved.
//

import UIKit
import AudioToolbox
import SkyFloatingLabelTextField
import MRCountryPicker

class MobileNumberAddVc: BaseViewController
{
    // MARK: - Outlet
    @IBOutlet weak var lblVerifyMobilenum: UILabel!
    @IBOutlet weak var lblErrorofMobile: UILabel!
    @IBOutlet weak var ViewOfMobile: UIView!
    @IBOutlet weak var ViewOfCode: UIView!

    @IBOutlet weak var txtMobileNum: SkyFloatingLabelTextField!
    @IBOutlet weak var btnAlreadyAUser: UIButton!
    @IBOutlet weak var btnRequestVerificationPin: UIButton!
    @IBOutlet weak var txtCountryCode: SkyFloatingLabelTextField!

    var countryPicker: MRCountryPicker!

    // MARK: - Properies
    private let textField = UITextField()
    private let errorMessage = UILabel()
    
    // MARK: - LifeCycles
    override func viewDidLoad()
    {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - Methods
    private func setupUI() {
        txtMobileNum.becomeFirstResponder()
        ViewOfMobile.layer.borderColor =  UIColor.lightGray.cgColor
        ViewOfMobile.layer.borderWidth = 1.0
        ViewOfCode.layer.borderColor =  UIColor.lightGray.cgColor
        ViewOfCode.layer.borderWidth = 1.0
        txtMobileNum.delegate = self
        
        if let Logo = UIImage(named: "iconMobile")
        {
            txtMobileNum.addImage(image: Logo, direction: .Right, width: 25, height: 25, contentMode: .scaleAspectFit)
        }
        txtMobileNum.titleFormatter = { $0.lowercased() }
        
        countryPicker = MRCountryPicker()
        countryPicker.countryPickerDelegate = self
        countryPicker.showPhoneNumbers = true
        let locale = Locale.current
        let code = locale.regionCode
        countryPicker.setCountry(code!.uppercased())
        
        txtCountryCode.inputView = countryPicker
        
        let keyboardToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.bounds.size.width, height: 44))
        keyboardToolbar.barStyle = .black
        keyboardToolbar.tintColor = UIColor.white
        
        let barButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(clickToKeyboardToolbarDone))
        
        let flex = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        
        let items = [flex, barButtonItem]
        keyboardToolbar.setItems(items, animated: true)
        
        txtCountryCode.inputAccessoryView = keyboardToolbar
        
        setupErrorMessage()
        setFont()
    }
    
    @objc func clickToKeyboardToolbarDone()
    {
        if(txtCountryCode.isFirstResponder)
        {
            
        }
        
        view.endEditing(true)
    }
    
    func setFont()
    {
        lblVerifyMobilenum.font = UIFont.Bold(ofSize: 17)
        txtMobileNum.font = UIFont.Regular(ofSize: 14)
        btnAlreadyAUser.titleLabel?.font = UIFont.Regular(ofSize: 15)
        btnRequestVerificationPin.titleLabel?.font = UIFont.Bold(ofSize: 16)
    }
    
    func setupErrorMessage()
    {
        
        errorMessage.translatesAutoresizingMaskIntoConstraints = false
        
        errorMessage.font = UIFont.Regular(ofSize: 12)
        errorMessage.textColor = .red
        errorMessage.isHidden = true
        self.lblErrorofMobile.addSubview(errorMessage)
        NSLayoutConstraint.activate([textField.leadingAnchor.constraint(equalTo: textField.leadingAnchor),
                                     textField.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 10.0)])
    }
    
    func validateAllFields() -> Bool
    {
        
        if txtMobileNum.text!.isEmpty {
            errorMessage.isHidden = false
            errorMessage.text = "enter mobile number"
            ViewOfMobile.layer.borderColor =  UIColor.red.cgColor
            ViewOfMobile.layer.borderWidth = 1.0
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
            
            return false
        }
        else if(txtMobileNum.text?.count)! < 10
        {
            errorMessage.isHidden = false
            errorMessage.text = "mobile number must be 10 characters long"
            ViewOfMobile.layer.borderColor =  UIColor.red.cgColor
            ViewOfMobile.layer.borderWidth = 1.0
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
            
            return false
        }
        return true
    }
    
    
    // MARK: - Action
    @IBAction func btnRequestVerificationPin(_ sender: Any)
    {
        if validateAllFields()
        {
            
            webServiceoFMobileNum()
            
        }
    }
    @IBAction func btnAlreayAUser(_ sender: Any)
    {
        AppDelegate.sharedDelegate().setLogin()
    }
}

extension MobileNumberAddVc : UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        if textField == txtMobileNum
        {
            let resultText: String? = (textField.text as NSString?)?.replacingCharacters(in: range, with: string)
            
            if resultText!.count >= 11
            {
                return false
            }
            else
            {
                return true
            }
            
        }
        return true
    }
}

extension MobileNumberAddVc {
    private func webServiceoFMobileNum() {
        let str = txtCountryCode.text! +  txtMobileNum.text!

        _ = APIClient.CheckMobileNumber(mobileNumber: str, success: { responseObj in
            let response = responseObj ?? [String : Any]()
            let responseData = ResponseDataModel(responseObj: response)
            
            if responseData.success {
                self.errorMessage.isHidden = false
                self.errorMessage.text = "mobile number already exist"
                self.ViewOfMobile.layer.borderColor =  UIColor.red.cgColor
                self.ViewOfMobile.layer.borderWidth = 1.0
                self.txtMobileNum.titleColor = UIColor.red
                AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
                
            } else if !responseData.success {
                self.errorMessage.isHidden = true
                self.errorMessage.text = ""
                self.ViewOfMobile.layer.borderColor = UIColor.lightGray.cgColor
                self.ViewOfMobile.layer.borderWidth = 1.0
                self.txtMobileNum.errorMessage = ""
                self.txtMobileNum.titleColor = UIColor.green
                self.SendOTPFromServer()
                
            }
        })
    }
    
    private func SendOTPFromServer() {
        let str = txtCountryCode.text!.replacingOccurrences(of: "+", with: "") +  txtMobileNum.text!
        _ = APIClient.SendOTP(mobileNumber: str, success: { responseObj in
            let response = responseObj ?? [String : Any]()
            let responseData = ResponseDataModel(responseObj: response)
            
            if responseData.success {
                
                let vc  =  OTPViewController.instantiate(fromAppStoryboard: .Main)
                vc.getDataMobileNum = self.txtMobileNum.text!
                self.navigationController?.pushViewController(vc, animated: true)
                
            } else if !responseData.success {
                self.errorMessage.isHidden = false
                self.errorMessage.text = responseData.message
                self.ViewOfMobile.layer.borderColor =  UIColor.red.cgColor
                self.ViewOfMobile.layer.borderWidth = 1.0
                
            }
        })
    }
}


//MARK: - MRCountryPickerDelegate
extension MobileNumberAddVc: MRCountryPickerDelegate
{
    func countryPhoneCodePicker(_ picker: MRCountryPicker, didSelectCountryWithName name: String, countryCode: String, phoneCode: String, flag: UIImage)
    {
        txtCountryCode.text = phoneCode //+ " " + name
    }
}
