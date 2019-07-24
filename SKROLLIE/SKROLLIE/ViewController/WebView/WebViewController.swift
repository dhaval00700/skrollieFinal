//
//  WebViewController.swift
//  SKROLLIE
//
//  Created by PC on 24/07/19.
//  Copyright © 2019 Dhaval Bhanderi. All rights reserved.
//

import UIKit

class WebViewController: BaseViewController {

    @IBOutlet weak var webView: UIWebView!
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
        webView.delegate = self
        
        let request = NSURLRequest(url: NSURL(string: webUrl)! as URL)
        webView.loadRequest(request as URLRequest)
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
//MARK: - UIWebViewDelegate Methods
extension WebViewController: UIWebViewDelegate
{
    
    func webViewDidStartLoad(_ webView: UIWebView)
    {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    
    func webViewDidFinishLoad(_ webView: UIWebView)
    {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error)
    {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}
