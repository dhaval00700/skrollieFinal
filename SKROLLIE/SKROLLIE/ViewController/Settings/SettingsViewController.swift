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
    
    // MARK: - Properties
    
    // MARK: - LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupUI()
    }
    
    // MARK: - Methods
    private func setupUI() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onTap))
        self.view.addGestureRecognizer(tapGesture)
        btnDiscard.addCornerRadius(8)
        btnSave.addCornerRadius(8)
        btnLogout.addCornerRadius(btnLogout.frame.height/2.0)
        btnPublic.isSelected = true
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
    }
    
    @IBAction func onBtnLogOut(_ sender: Any) {
        self.dismiss(animated: true) {
            AppDelegate.sharedDelegate().setLogin()
        }
    }
}
