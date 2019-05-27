
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

class LoginViewController: UIViewController,UITextFieldDelegate
{
    
    //--------------------------------------------------------------
    // MARK: - Variable Declaration
    //--------------------------------------------------------------
    
    //Variable for Error message
    private let textField = UITextField()
    private let errorMessageUser = UILabel()
    private let errorMessagePassword = UILabel()
    
    //--------------------------------------------------------------
    //MARK: -  Outlet
    //--------------------------------------------------------------
    
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
    
    //--------------------------------------------------------------
    //MARK: - View Methods
    //--------------------------------------------------------------
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        SetBorder()
        txtUsername.titleFormatter = { $0.lowercased() }
        txtPassword.titleFormatter = { $0.lowercased() }
        
        txtUsername.text = "bini"
        txtPassword.text = "123456"
        
        setupErrorMessage()
        setFont()
    }
    
    //--------------------------------------------------------------
    //MARK: - Func Didload Dataset
    //--------------------------------------------------------------
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
    
    //--------------------------------------------------------------
    //MARK: - Error message
    //--------------------------------------------------------------
    
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
    func SetBorder()
    {
        ViewUserName.layer.borderColor =  UIColor.lightGray.cgColor
        ViewUserName.layer.borderWidth = 1.0
        ViewUserName.layer.cornerRadius = 3.0
        ViewUserName.layer.masksToBounds = true
        
        viewPassword.layer.borderColor =  UIColor.lightGray.cgColor
        viewPassword.layer.borderWidth = 1.0
        viewPassword.layer.cornerRadius = 3.0
        viewPassword.layer.masksToBounds = true
        
        txtUsername.delegate = self
        
        if let Logo = UIImage(named: "iconUserName"){
            
            txtUsername.withImage(direction: .Right, image: Logo)
        }
        
        if let Logo = UIImage(named: "iconPassword"){
            
            txtPassword.withImage(direction: .Right, image: Logo)
        }
        
        
    }
    //--------------------------------------------------------------
    //MARK: - UnWine Segue
    //--------------------------------------------------------------
    
    @IBAction func unwindToContainerVC(segue: UIStoryboardSegue){}
    
    //--------------------------------------------------------------
    // MARK: - Action Methods
    //--------------------------------------------------------------
    @IBAction func btnRegister(_ sender: Any)
    {
        performSegue(withIdentifier: "SegueToRegister", sender: self)
    }
    
    @IBAction func btnLogin(_ sender: UIButton)
    {
        if validateAllFields()
        {
            WebserviceOfLogin()
        }
        
    }
    
    @IBAction func btnForgotPass(_ sender: UIButton)
    {
        
    }
    
    //--------------------------------------------------------------
    //MARK: -
    //--------------------------------------------------------------
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
    //--------------------------------------------------------------
    // MARK: - Webservice Methods
    //--------------------------------------------------------------
    
    func WebserviceOfLogin()
    {
        
        var dictdata = [String:AnyObject]()
        
        dictdata[keyAllKey.kUsername] = txtUsername.text as AnyObject
        dictdata[keyAllKey.kPassword] = txtPassword.text as AnyObject
        
        webserviceForLogin(dictdata as AnyObject) { (result, success) in
            print(result)
            if(success)
            {
                dictdata = (result as! [String : AnyObject])
                
                SingleToneClass.sharedInstance.loginDataStore = dictdata
                
                print((result as! [String:AnyObject])["message"] as! String)
                
                self.performSegue(withIdentifier: "SegueToLoginToHome", sender: self)
                
            }
            else if success == false
            {
                
                if result["message"] as! String == "OTP"
                {
                    dictdata = (result as! [String : AnyObject])
                    
                    SingleToneClass.sharedInstance.loginDataStore = dictdata
                    let idpass = (SingleToneClass.sharedInstance.loginDataStore["data"] as AnyObject)
                    
                       print("wellcome back")
                }
                else
                {
                    self.errorMessagePassword.isHidden = false
                    self.errorMessagePassword.text = "invalid username or password."//((result as! [String:AnyObject])["message"] as! String)
                    self.viewPassword.layer.borderColor =  UIColor.red.cgColor
                    self.viewPassword.layer.borderWidth = 1.0
                    self.ViewUserName.layer.borderColor =  UIColor.red.cgColor
                    self.ViewUserName .layer.borderWidth = 1.0
                    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
                }
            }
        }
    }
}

