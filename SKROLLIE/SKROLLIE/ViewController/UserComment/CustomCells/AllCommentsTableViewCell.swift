//
//  AllCommentsTableViewCell.swift
//  SKROLLIE
//
//  Created by Apexa on 28/05/19.
//  Copyright © 2019 Dhaval Bhanderi. All rights reserved.
//

import UIKit

protocol AllCommentsTableViewCellDelegate {
    func selectedReply(selectedObj: UserComment)
}

class AllCommentsTableViewCell: UITableViewCell,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var lblUser: UILabel!
    @IBOutlet weak var lblUserComment: UILabel!
    @IBOutlet weak var lctSubCommentTableHeight: NSLayoutConstraint!
    @IBOutlet weak var tblSubComment: UITableView!
    @IBOutlet weak var btnReply: UIButton!

    
    var imgOfUser = String()
    var Username = String()
    var arrReplyComment = [UserComment]()
    var dalegate : AllCommentsTableViewCellDelegate?
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        
        tblSubComment.delegate = self
        tblSubComment.dataSource = self
        
        tblSubComment.register(UINib(nibName: "CommentItemTableViewCell", bundle: nil), forCellReuseIdentifier: "CommentItemTableViewCell")
        
       
    }
    
    func reloadData() {
        tblSubComment.reloadData()
        tblSubComment.layoutIfNeeded()
        lctSubCommentTableHeight.constant = tblSubComment.contentSize.height
    }
    
    @objc func selectedReply(_ sender: UIButton) {
        let currentobj = arrReplyComment[sender.tag]
        dalegate?.selectedReply(selectedObj: currentobj)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrReplyComment.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentItemTableViewCell", for: indexPath) as! CommentItemTableViewCell
        let currentObj = arrReplyComment[indexPath.row]
        cell.imgUser.imageFromURL(link: currentObj.UserObj.image, errorImage: profilePlaceHolder, contentMode: .scaleAspectFill)
        cell.lblUser.text = currentObj.UserObj.username
        cell.lblUserComment.text = currentObj.Comment
        cell.btnReply.tag = indexPath.row
        cell.btnReply.addTarget(self, action: #selector(selectedReply), for: .touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
         return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func setSelected(_ selected: Bool, animated: Bool){
        super.setSelected(selected, animated: animated)
    }
}
