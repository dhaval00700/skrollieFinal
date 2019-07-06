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
    @IBOutlet weak var viwMainContainer: UIView!
    @IBOutlet weak var viwAccountTypeContainer: UIView!
    @IBOutlet weak var btnPublic: UIButton!
    @IBOutlet weak var btnPrivate: UIButton!
    @IBOutlet weak var lblEmail: SkyFloatingLabelTextField!
    @IBOutlet weak var lblCurrentPassword: SkyFloatingLabelTextField!
    @IBOutlet weak var lblNewPassword: SkyFloatingLabelTextField!
    @IBOutlet weak var lblConfirmPassword: SkyFloatingLabelTextField!
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
        self.view.addGestureRecognizer(tapGesture)
        btnDiscard.addCornerRadius(8)
        btnSave.addCornerRadius(8)
        btnLogout.addCornerRadius(btnLogout.frame.height/2.0)
        btnPublic.isSelected = true
        btnVerifyNow.isHidden = true
    }
    
    func setData() {
        lblAccountVerificationStatus.text = AppPrefsManager.shared.getUserProfileData().IsAccountVerify.description()
        if AppPrefsManager.shared.getUserProfileData().IsAccountVerify == AccountVerifyStatus.two {
            btnVerifyNow.isHidden = true
        } else {
            btnVerifyNow.isHidden = false
        }
    }
    
    // MARK: - Actions
    @objc func onTap() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onBtnPublic(_ sender: Any) {
    }
    
    @IBAction func onBtnPrivate(_ sender: Any) {
    }
    
    @IBAction func onBtnDiscard(_ sender: Any) {
    }
    
    @IBAction func onBtnSave(_ sender: Any) {
    }
    
    @IBAction func onBtnVerifyNow(_ sender: Any) {
        let navVc = storyboard?.instantiateViewController(withIdentifier: "VerificationBadgeVc") as! UINavigationController
        let vc = navVc.viewControllers.first as! VerificationBadgeViewController
        vc.delegate = self
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


extension SettingsViewController: VerificationBadgeViewControllerDelegate {
    func dismissAfterVerificationBadge() {
        delay(time: 0.05) {
            self.dismiss(animated: false, completion: nil)
        }
    }
}
