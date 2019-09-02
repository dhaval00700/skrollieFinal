//
//  AllCommentViewController.swift
//  SKROLLIE
//
//  Created by Anji on 02/09/19.
//  Copyright © 2019 Dhaval Bhanderi. All rights reserved.
//

import UIKit

class AllCommentViewController: BaseViewController {
    
    @IBOutlet weak var tblForComment: UITableView!
    @IBOutlet weak var viwWriteReview: UIView!
    @IBOutlet weak var viwReply: UIView!
    @IBOutlet weak var lblReplyuserName: UILabel!
    @IBOutlet weak var txtWriteReview: UITextField!
    
    var subRply = false
    var subUserComment = UserComment()

    
    var arrUserComment = [UserComment]()
    var postId = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpUI()
        getAllComment()
        
    }
    
    private func setUpUI(){
        
        tblForComment.register(UINib(nibName: "AllCommentsTableViewCell", bundle: nil), forCellReuseIdentifier: "AllCommentsTableViewCell")
        tblForComment.dataSource = self
        tblForComment.delegate = self
        
        viwWriteReview.isHidden = true
        viwReply.isHidden = true
        
        
    }
    
    //MARK: - Click Events
    
    @IBAction func clickToBtnBack( _ sender : UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnCommentReply(_ sender: UIButton) {
        subRply = false
        self.viwReply.isHidden = false
        self.viwWriteReview.isHidden = false

        let obj = arrUserComment[sender.tag]
        lblReplyuserName.text = "Replying to " + obj.UserObj.username
    }
    
    @IBAction func btnSendComment(_ sender: UIButton) {
        self.view.endEditing(true)
        if !txtWriteReview.text!.isEmpty && !subRply {
            let obj = arrUserComment[sender.tag]
            sendComment(idComment: obj.idComment)
        } else if !txtWriteReview.text!.isEmpty && subRply {
            sendComment(idComment: subUserComment.idComment)
        }
    }
    
    @IBAction func btnClose(_ sender: UIButton) {
        self.view.endEditing(true)
        viwReply.isHidden = true
        viwWriteReview.isHidden = true

        txtWriteReview.text = ""
    }
    
    
}


extension AllCommentViewController {
    
    private func getAllComment() {
        
        _ = APIClient.GetAllComment(idPost: postId) { (responseObj) in
            let response = responseObj ?? [String : Any]()
            let responseData = ResponseDataModel(responseObj: response)
            self.arrUserComment.removeAll()
            if responseData.success {
                
                self.arrUserComment = UserComment.getArray(data: response["data"] as? [[String : Any]] ?? [[String : Any]]())
            }
            
            self.tblForComment.reloadData()
            
        }
    }
    
    private func sendComment(idComment:String) {
        self.showNetworkIndicator()
        
        let param = ParameterRequest()
        param.addParameter(key: ParameterRequest.idUser, value: AppPrefsManager.shared.getUserData().UserId)
        param.addParameter(key: ParameterRequest.idPost, value: postId)
        param.addParameter(key: ParameterRequest.Comment, value: txtWriteReview.text!)
        param.addParameter(key: ParameterRequest.idComment, value: idComment)
        
        _ = APIClient.SavePostComment(parameters: param.parameters) { (responseObj) in
            let response = responseObj ?? [String : Any]()
            let responseData = ResponseDataModel(responseObj: response)
            if responseData.success {
                self.txtWriteReview.text = ""
                self.viwReply.isHidden = true
                self.viwWriteReview.isHidden = true
                self.subRply = false

                self.getAllComment()
            }
            self.hideNewtworkIndicator()
        }
    }
}


// MARK: - UITableViewDelegate,UITableViewDataSource
extension AllCommentViewController: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return arrUserComment.count
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let currentObj = arrUserComment[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "AllCommentsTableViewCell", for: indexPath) as! AllCommentsTableViewCell
        
        cell.imgUser.imageFromURL(link: currentObj.UserObj.image, errorImage: profilePlaceHolder, contentMode: .scaleAspectFill)
        cell.lblUser.text = currentObj.UserObj.username
        cell.lblUserComment.text = currentObj.Comment
        
        cell.arrReplyComment = currentObj.LstReplayComment
        cell.reloadData()
        
        cell.dalegate = self
        
        cell.btnReply.tag = indexPath.row
        cell.btnReply.addTarget(self, action: #selector(btnCommentReply(_:)), for: .touchUpInside)
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return UITableView.automaticDimension
        
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
            return UITableView.automaticDimension
    }
}

extension AllCommentViewController: AllCommentsTableViewCellDelegate {
    func selectedReply(selectedObj: UserComment) {
        
        self.viwReply.isHidden = false
        self.viwWriteReview.isHidden = false
        
        lblReplyuserName.text = "Replying to " + selectedObj.UserObj.username
        
        subRply = true
        subUserComment = selectedObj
    }
}
