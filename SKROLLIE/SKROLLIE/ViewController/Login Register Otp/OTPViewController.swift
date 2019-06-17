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

class OTPViewController: UIViewController,UITextFieldDelegate
{
    
    //--------------------------------------------------------------
    // MARK: - Variable Declaration
    //--------------------------------------------------------------
    
    var getDataMobileNum = String()
    
    //Variable for Error message
    private let textField = UITextField()
    private let errorMessage = UILabel()
    
    //--------------------------------------------------------------
    // MARK: - Outlets
    //--------------------------------------------------------------
    
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
    
    //--------------------------------------------------------------
    // MARK: - View Methods
    //--------------------------------------------------------------
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
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
    
    //--------------------------------------------------------------
    // MARK: - Error message
    //--------------------------------------------------------------
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
    //--------------------------------------------------------------
    // MARK: - Action Methods
    //--------------------------------------------------------------
    
    @IBAction func btnNext(_ sender: UIButton)
    {
        WebserviceOFVerifyOtp()
    }
    
    @IBAction func btnAlreayAUser(_ sender: Any)
    {
        performSegue(withIdentifier: "UnwineToLogin", sender: self)
    }
    @IBAction func btnChangeNumber(_ sender: UIButton)
    {
        performSegue(withIdentifier: "UnWineToMobile", sender: self)
    }
    @IBAction func btnResendOTP(_ sender: UIButton)
    {
        WebserviceOFOtp()
    }
}

//--------------------------------------------------------------
// MARK: - APiCall
//--------------------------------------------------------------

extension OTPViewController
{
    func WebserviceOFOtp()
    {
        let datas = "idUser=\(AppPrefsManager.shared.getUserData().UserId)" + "&phone=\(getDataMobileNum)"
        
        webserviceForOTPinMobile(dictParams: datas as AnyObject){(result,  status) in
            if status
            {
                do
                {
                    print((result as! [String:AnyObject])["message"] as! String)
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
                print((result as! [String:AnyObject])["message"] as! String)
            }
        }
    }
    
    func WebserviceOFVerifyOtp()
    {
        let pin = viewOtP.getPin()
        let datas = "idUser=\(AppPrefsManager.shared.getUserData().UserId)" + "&OTP=\(pin)"
        
        webserviceForVerifyOTP(dictParams: datas as AnyObject){(result,  status) in
            if status
            {
                do
                {
                    print((result as! [String:AnyObject])["message"] as! String)
                    //                    UtilityClass.getAppDelegate().setLogin()
                    if let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController {
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                }
                    
                catch let DecodingError.dataCorrupted(context)
                {
                    print(context)
                } catch let DecodingError.keyNotFound(key, context)
                {
                    print("Key '\(key)' not found:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                } catch let DecodingError.valueNotFound(value, context)
                {
                    print("Value '\(value)' not found:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                } catch let DecodingError.typeMismatch(type, context)
                {
                    print("Type '\(type)' mismatch:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                } catch
                {
                    print("error: ", error)
                }
            }
            else
            {
                self.errorMessage.isHidden = false
                AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
                self.errorMessage.text = "invelid PIN"
                //(result as! [String:AnyObject])["message"] as? String
            }
        }
    }
}
