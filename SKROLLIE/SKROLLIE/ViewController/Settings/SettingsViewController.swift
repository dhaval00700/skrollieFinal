//
//  SettingsViewController.swift
//  SKROLLIE
//
//  Created by PC on 27/06/19.
//  Copyright © 2019 Dhaval Bhanderi. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class SettingsViewController: BaseViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var viwBackground: UIView!
    @IBOutlet weak var viwMainContainer: UIView!
    @IBOutlet weak var viwAccountTypeContainer: UIView!
    @IBOutlet weak var btnPublic: UIButton!
    @IBOutlet weak var btnPrivate: UIButton!
    @IBOutlet weak var txtEmail: SkyFloatingLabelTextField!
    @IBOutlet weak var txtCurrentPassword: SkyFloatingLabelTextField!
    @IBOutlet weak var txtNewPassword: SkyFloatingLabelTextField!
    @IBOutlet weak var txtConfirmPassword: SkyFloatingLabelTextField!
    @IBOutlet weak var btnDiscard: UIButton!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var lblAccountVerificationStatus: UILabel!
    @IBOutlet weak var btnSupport: UIButton!
    @IBOutlet weak var btnVerifyNow: UIButton!
    @IBOutlet weak var btnLogout: UIButton!
    @IBOutlet weak var btnBlockList: UIButton!
    
    // MARK: - Properties
    
    // MARK: - LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setData()
    }
    
    // MARK: - Methods
    private func setupUI() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onTap))
        viwBackground.addGestureRecognizer(tapGesture)
        btnDiscard.addCornerRadius(8)
        btnSave.addCornerRadius(8)
        btnLogout.addCornerRadius(btnLogout.frame.height/2.0)
        btnPublic.isSelected = true
        btnVerifyNow.isHidden = true
        txtEmail.isUserInteractionEnabled = false
        txtEmail.text = AppPrefsManager.shared.getUserProfileData().emailaddress
    }
    
    private func setData() {
        lblAccountVerificationStatus.text = AppPrefsManager.shared.getUserProfileData().IsAccountVerify.description()
        if AppPrefsManager.shared.getUserProfileData().IsAccountVerify == AccountVerifyStatus.two {
            btnVerifyNow.isHidden = true
        } else {
            btnVerifyNow.isHidden = false
        }
    }
    
    private func resetAll() {
        txtCurrentPassword.text = ""
        txtNewPassword.text = ""
        txtConfirmPassword.text = ""
    }
    
    private func isValid() -> Bool {
        if txtCurrentPassword.text != nil && txtCurrentPassword.text!.isEmpty {
            AppDelegate.sharedDelegate().window?.showToastAtBottom(message: "Enter Current Password")
            return false
        } else if txtNewPassword.text != nil && txtNewPassword.text!.isEmpty {
            AppDelegate.sharedDelegate().window?.showToastAtBottom(message: "Enter New Password")
            return false
        } else if txtConfirmPassword.text != nil && txtConfirmPassword.text!.isEmpty {
            AppDelegate.sharedDelegate().window?.showToastAtBottom(message: "Enter Confirm Password")
            return false
        } else if txtNewPassword.text! != txtConfirmPassword.text! {
            AppDelegate.sharedDelegate().window?.showToastAtBottom(message: "Passwords are not match")
            return false
        } else {
            return true
        }
    }
    
    // MARK: - Actions
    @objc func onTap() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onBtnPublic(_ sender: Any) {
        btnPublic.isSelected = true
        btnPrivate.isSelected = false
    }
    
    @IBAction func onBtnPrivate(_ sender: Any) {
        btnPublic.isSelected = false
        btnPrivate.isSelected = true
    }
    
    @IBAction func onBtnDiscard(_ sender: Any) {
        resetAll()
    }
    
    @IBAction func onBtnSave(_ sender: Any) {
        if isValid() {
            changePassword()
        }
    }
    
    @IBAction func onBtnVerifyNow(_ sender: Any) {
        let navVc = storyboard?.instantiateViewController(withIdentifier: "VerificationBadgeVc") as! UINavigationController
        navVc.modalPresentationStyle = .overFullScreen
        self.present(navVc, animated:true, completion: nil)
        
    }
    
    @IBAction func onBtnLogOut(_ sender: Any) {
        self.dismiss(animated: true) {
            AppDelegate.sharedDelegate().setLogin()
        }
    }
    
    @IBAction func onBtnDrag(_ sender: Any) {
        onTap()
    }
    
    @IBAction func onBtnBlockList(_ sender: Any) {
        let navVc = BlockListViewController.instantiate(fromAppStoryboard: .Main)
        self.navigationController?.pushViewController(navVc, animated: true)
    }
}


extension SettingsViewController {
    private func changePassword() {
        
        let param = ParameterRequest()
        param.addParameter(key: ParameterRequest.UserId, value: AppPrefsManager.shared.getUserData().UserId)
        param.addParameter(key: ParameterRequest.oldpassword, value: txtCurrentPassword.text!)
        param.addParameter(key: ParameterRequest.password, value: txtNewPassword.text!)
        param.addParameter(key: ParameterRequest.confirmpassword, value: txtConfirmPassword.text!)
        
        _ = APIClient.ChangePassword(parameters: param.parameters) { (responseObj) in
            let response = responseObj ?? [String : Any]()
            let responseData = ResponseDataModel(responseObj: response)
            if responseData.success {
                let obj = AppPrefsManager.shared.getUserData()
                obj.token = responseData.token
                AppPrefsManager.shared.saveUserData(model: obj)
                AppDelegate.sharedDelegate().window?.showToastAtBottom(message: "Password is Changed!")
            }
        }
    }
}
