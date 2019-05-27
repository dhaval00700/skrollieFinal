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

class MobileNumberAddVc: UIViewController,UITextFieldDelegate
{
    
    //-------------------------------------------------------------
    // MARK: - Variable
    //-------------------------------------------------------------
    
    //Variable for Error message
    private let textField = UITextField()
    private let errorMessage = UILabel()
    
    //-------------------------------------------------------------
    // MARK: - Outlet
    //-------------------------------------------------------------
    
    @IBOutlet weak var lblVerifyMobilenum: UILabel!
    @IBOutlet weak var lblErrorofMobile: UILabel!
    @IBOutlet weak var ViewOfMobile: UIView!
    
    @IBOutlet weak var txtMobileNum: SkyFloatingLabelTextField!
    
    @IBOutlet weak var btnAlreadyAUser: UIButton!
    @IBOutlet weak var btnRequestVerificationPin: UIButton!
    
    //-------------------------------------------------------------
    // MARK: - view Method
    //-------------------------------------------------------------
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        txtMobileNum.becomeFirstResponder()
        ViewOfMobile.layer.borderColor =  UIColor.lightGray.cgColor
        ViewOfMobile.layer.borderWidth = 1.0
        txtMobileNum.delegate = self
        
        if let Logo = UIImage(named: "iconMobile")
        {
            txtMobileNum.withImage(direction: .Right, image: Logo)
        }
        txtMobileNum.titleFormatter = { $0.lowercased() }
        
        setupErrorMessage()
        setFont()
    }
    
    //--------------------------------------------------------------
    // MARK: - Function Of Viewdidload
    //--------------------------------------------------------------
    func setFont()
    {
        lblVerifyMobilenum.font = UIFont.Bold(ofSize: 17)
        txtMobileNum.font = UIFont.Regular(ofSize: 14)
        btnAlreadyAUser.titleLabel?.font = UIFont.Regular(ofSize: 15)
        btnRequestVerificationPin.titleLabel?.font = UIFont.Bold(ofSize: 16)
    }
    
    //--------------------------------------------------------------
    // MARK: -  Error message
    //--------------------------------------------------------------
    
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
    
    //--------------------------------------------------------------
    // MARK: - UnWine Segue
    //--------------------------------------------------------------
    
    @IBAction func unwindToContainerMobile(segue: UIStoryboardSegue){}
    
    
    //-------------------------------------------------------------
    // MARK: - validation of Mobile num Length
    //-------------------------------------------------------------
    
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
    
    //-------------------------------------------------------------
    // MARK: - validation
    //-------------------------------------------------------------
    
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
    
    //--------------------------------------------------------------
    // MARK: - Button Action
    //--------------------------------------------------------------
    @IBAction func btnRequestVerificationPin(_ sender: Any)
    {
        if validateAllFields()
        {
            
            webServiceoFMobileNum()
        }
    }
    @IBAction func btnAlreayAUser(_ sender: Any)
    {
        performSegue(withIdentifier: "SegueMobileNumVcToLogin", sender: self)
    }
    
    //--------------------------------------------------------------
    // MARK: - Prepare
    //--------------------------------------------------------------
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if (segue.identifier == "SegueToVerificationPin")
        {
            
            let otp = segue.destination as! OTPViewController
            
            otp.getDataMobileNum = txtMobileNum.text!
        }
    }
    
    
}

//--------------------------------------------------------------
//Mark: -  Extenstion Webservice Methods
//--------------------------------------------------------------
extension MobileNumberAddVc
{
    //MOBILE NUMBER EXIST OR NOT CHECK API
    
    func webServiceoFMobileNum()
    {
        let PhoneNum = "phone=\(txtMobileNum.text!)"
        
        webserviceForVerifyMobileNumExistorNot(dictParams: PhoneNum as AnyObject){(result,  status) in
            if status
            {
                do
                {
                    self.errorMessage.isHidden = false
                    self.errorMessage.text = "mobile number already exist"
                    self.ViewOfMobile.layer.borderColor =  UIColor.red.cgColor
                    self.ViewOfMobile.layer.borderWidth = 1.0
                    self.txtMobileNum.titleColor = UIColor.red
                    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
                    
                }
                    
                catch let DecodingError.dataCorrupted(context)
                {
                    print(context)
                }
                catch let DecodingError.keyNotFound(key, context)
                {
                    print("Key '\(key)' not found:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                }
                catch let DecodingError.valueNotFound(value, context)
                {
                    print("Value '\(value)' not found:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                }
                catch let DecodingError.typeMismatch(type, context)
                {
                    print("Type '\(type)' mismatch:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                }
                catch
                {
                    print("error: ", error)
                }
            }
                
            else
            {
                self.errorMessage.isHidden = true
                self.errorMessage.text = ""
                self.ViewOfMobile.layer.borderColor = UIColor.lightGray.cgColor
                self.ViewOfMobile.layer.borderWidth = 1.0
                self.txtMobileNum.errorMessage = ""
                self.txtMobileNum.titleColor = UIColor.green
                self.WebserviceOFOtp()
            }
        }
    }
    
    
    func WebserviceOFOtp()
    {
        let idpass = (SingleToneClass.sharedInstance.loginDataStore["data"] as! AnyObject)
        var sdas = String()
        if let userIDString = idpass["id"] as? String
        {
            sdas = "\(userIDString)"
        }
        
        if let userIDInt = idpass["id"] as? Int
        {
            sdas = "\(userIDInt)"
        }
        let datas = "idUser=\(sdas)" + "&phone=\(txtMobileNum.text!)"
        print(datas)
        webserviceForOTPinMobile(dictParams: datas as AnyObject){(result,  status) in
            if status
            {
                do {
                    
                    print((result as! [String:AnyObject])["message"] as! String)
                    self.performSegue(withIdentifier: "SegueToVerificationPin", sender: self)
                    
                }
                    
                catch let DecodingError.dataCorrupted(context)
                {
                    print(context)
                }
                catch let DecodingError.keyNotFound(key, context)
                {
                    print("Key '\(key)' not found:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                }
                catch let DecodingError.valueNotFound(value, context)
                {
                    print("Value '\(value)' not found:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                }
                catch let DecodingError.typeMismatch(type, context)
                {
                    print("Type '\(type)' mismatch:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                }
                catch {
                    print("error: ", error)
                }
            }
            else
            {
                self.errorMessage.isHidden = false
                self.errorMessage.text = (result as! [String:AnyObject])["message"] as? String
                self.ViewOfMobile.layer.borderColor =  UIColor.red.cgColor
                self.ViewOfMobile.layer.borderWidth = 1.0
                
            }
        }
    }
}
