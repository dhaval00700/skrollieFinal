//
//  AllCommentsTableViewCell.swift
//  SKROLLIE
//
//  Created by Apexa on 28/05/19.
//  Copyright © 2019 Dhaval Bhanderi. All rights reserved.
//

import UIKit


protocol delegateSelectOfComment {
}

class AllCommentsTableViewCell: UITableViewCell,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var lblUser: UILabel!
    @IBOutlet weak var lblUserComment: UILabel!
    @IBOutlet weak var lctSubCommentTableHeight: NSLayoutConstraint!
    @IBOutlet weak var tblSubComment: UITableView!
    
    var aryUserList = [String]()
    var aryImg = [String]()
    var imgOfUser = String()
    var Username = String()
    var delegateOfSelectedComment : delegateSelectOfComment!
    
    override func awakeFromNib(){
        super.awakeFromNib()
        
        tblSubComment.delegate = self
        tblSubComment.dataSource = self
        
        tblSubComment.register(UINib(nibName: "CommentItemTableViewCell", bundle: nil), forCellReuseIdentifier: "CommentItemTableViewCell")
        
        aryUserList = ["@horedude","@doggylover","@happyCampper"]
        aryImg = ["img6","img6","img6"]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return aryImg.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentItemTableViewCell", for: indexPath) as! CommentItemTableViewCell
        
        imgOfUser = aryImg[indexPath.row]
        Username = aryUserList[indexPath.row]
        
        cell.imgUser.image = UIImage.init(named: imgOfUser)
        cell.lblUser.text = Username
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
         return 70.0
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70.0
    }
    
    override func setSelected(_ selected: Bool, animated: Bool){
        super.setSelected(selected, animated: animated)
    }
}
