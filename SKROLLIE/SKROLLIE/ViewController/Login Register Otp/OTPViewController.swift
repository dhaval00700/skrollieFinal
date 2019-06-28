//
//  ViewController.swift
//  SKROLLIE
//
//  Created by Dhaval Bhanderi on 4/15/19.
//  Copyright © 2019 Dhaval Bhanderi. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import SVPinView
import AudioToolbox

class OTPViewController: BaseViewController,UITextFieldDelegate
{
    // MARK: - Outlets
    @IBOutlet weak var viewOtP: SVPinView!
    
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var btnChangeOtp: UIButton!
    @IBOutlet weak var btnResendOTP: UIButton!
    @IBOutlet weak var btnAlreadyAUser: UIButton!
    @IBOutlet weak var btnChangephonenum: UIButton!
    
    @IBOutlet weak var lblDisplayMobileNum: UILabel!
    @IBOutlet weak var lblErrorOtp: UILabel!
    @IBOutlet weak var lblor: UILabel!
    @IBOutlet weak var lblEnterthepinwesentto: UILabel!
    @IBOutlet weak var lblUserNum: UILabel!
    @IBOutlet weak var lblOr: UILabel!
    
    // MARK: - Properties
    var getDataMobileNum = String()
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
        viewOtP.becomeFirstResponderAtIndex = 0
        viewOtP.pinLength = 4
        viewOtP.textColor = UIColor.yellow
        viewOtP.shouldSecureText = false
        viewOtP.style = .underline
        
        viewOtP.borderLineColor = UIColor.yellow
        viewOtP.activeBorderLineColor = UIColor.yellow
        viewOtP.borderLineThickness = 3
        viewOtP.activeBorderLineThickness = 3
        
        viewOtP.font = UIFont.Regular(ofSize: 15)
        viewOtP.keyboardType = .phonePad
        viewOtP.isContentTypeOneTimeCode = true
        lblDisplayMobileNum.text = getDataMobileNum
        
        setupErrorMessage()
        setFont()
    }
    
    func setFont()
    {
        lblEnterthepinwesentto.font = UIFont.Bold(ofSize: 17)
        lblDisplayMobileNum.font = UIFont.Bold(ofSize: 17)
        btnResendOTP.titleLabel?.font = UIFont.Bold(ofSize: 16)
        btnChangephonenum.titleLabel?.font = UIFont.Bold(ofSize: 16)
        lblOr.font = UIFont.Bold(ofSize: 14)
        btnNext.titleLabel?.font = UIFont.Bold(ofSize: 16)
        btnAlreadyAUser.titleLabel?.font = UIFont.Regular(ofSize: 16)
    }
    
    func setupErrorMessage()
    {
        
        errorMessage.translatesAutoresizingMaskIntoConstraints = false
        errorMessage.font = UIFont.Regular(ofSize: 12)
        errorMessage.textColor = .red
        errorMessage.isHidden = true
        self.lblErrorOtp.addSubview(errorMessage)
        
        NSLayoutConstraint.activate([textField.leadingAnchor.constraint(equalTo: textField.leadingAnchor),
                                     textField.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 10.0)])
    }
    
    // MARK: - Action
    @IBAction func btnNext(_ sender: UIButton)
    {
        VerifyOTPFromServer()
    }
    
    @IBAction func btnAlreayAUser(_ sender: Any)
    {
        AppDelegate.sharedDelegate().setLogin()
    }
    @IBAction func btnChangeNumber(_ sender: UIButton)
    {
        performSegue(withIdentifier: "UnWineToMobile", sender: self)
    }
    @IBAction func btnResendOTP(_ sender: UIButton)
    {
        SendOTPFromServer()
    }
}

extension OTPViewController
{
    
    private func SendOTPFromServer() {
        
        
        _ = APIClient.SendOTP(mobileNumber: getDataMobileNum, success: { responseObj in
            let response = responseObj ?? [String : Any]()
            let responseData = ResponseDataModel(responseObj: response)
            
            if responseData.success {
                
                
                
            } else if !responseData.success {
                
                
            }
        })
    }
    
    private func VerifyOTPFromServer() {
        let pin = viewOtP.getPin()
        
        _ = APIClient.VerifyOTP(OTP: pin, success: { responseObj in
            let response = responseObj ?? [String : Any]()
            let responseData = ResponseDataModel(responseObj: response)
            
            if responseData.success {
                
                let vc = HomeViewController.instantiate(fromAppStoryboard: .Main)
                self.navigationController?.pushViewController(vc, animated: true)
                
                
            } else if !responseData.success {
                
                self.errorMessage.isHidden = false
                AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
                self.errorMessage.text = "invelid PIN"
            }
        })
    }
    
}
