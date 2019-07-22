//
//  RequestListViewController.swift
//  SKROLLIE
//
//  Created by PC on 22/07/19.
//  Copyright © 2019 Dhaval Bhanderi. All rights reserved.
//

import UIKit

class RequestListViewController: BaseViewController {

    @IBOutlet weak var tblRequestList: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupUI()
    }
    
    private func setupUI() {
        tblRequestList.register(UINib(nibName: "", bundle: nil), forCellReuseIdentifier: "")
    }
}
