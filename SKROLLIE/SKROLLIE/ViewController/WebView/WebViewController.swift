//
//  WebViewController.swift
//  SKROLLIE
//
//  Created by PC on 24/07/19.
//  Copyright © 2019 Dhaval Bhanderi. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: BaseViewController {

    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var btnBack: UIButton!
    
    
    var webUrl = ""
    
    //MARK: - View  Life Cycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    
    //MARK: - Methods
    private func setupUI()
    {
        self.navigationItem.titleView = nil
        webView.reload()
        let request = NSURLRequest(url: NSURL(string: webUrl)! as URL)
        webView.load(request as URLRequest)
    }
    
    
    @IBAction func onBtnBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    //MARK: -
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
