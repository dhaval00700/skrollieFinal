//
//  NotificationViewController.swift
//  SKROLLIE
//
//  Created by PC on 01/10/19.
//  Copyright © 2019 Dhaval Bhanderi. All rights reserved.
//

import UIKit

class NotificationViewController: BaseViewController {

    @IBOutlet weak var viwBackground: UIView!
    @IBOutlet weak var btnDismiss: UIButton!
    @IBOutlet weak var tblNotification: UITableView!
    @IBOutlet weak var lctTblNotificationHeight: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupUI()
    }
    
    private func setupUI() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onTap))
        viwBackground.addGestureRecognizer(tapGesture)
        tblNotification.register(UINib(nibName: "NotificatioonTableViewCell", bundle: nil), forCellReuseIdentifier: "NotificatioonTableViewCell")
        tblNotification.dataSource = self
        tblNotification.delegate = self
        tblNotification.reloadData()
        tblNotification.layoutIfNeeded()
        lctTblNotificationHeight.constant = tblNotification.contentSize.height
    }
    
    @objc func onTap() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onBtnDrag(_ sender: Any) {
        onTap()
    }
}

extension NotificationViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificatioonTableViewCell") as! NotificatioonTableViewCell
        cell.lblComment.text = "asbdhjk"
        cell.lblDate.text = "12/12/2019"
        cell.imgPost.image = #imageLiteral(resourceName: "iconMail")
        cell.imgProfile.image = #imageLiteral(resourceName: "img3")
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
