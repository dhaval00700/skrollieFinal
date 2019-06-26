//
//  CellUserProfileSectionTableViewCell.swift
//  SKROLLIE
//
//  Created by PC on 20/06/19.
//  Copyright © 2019 Dhaval Bhanderi. All rights reserved.
//

import UIKit

class CellUserProfileSectionTableViewCell: UITableViewCell {

    //MARK: Outlets
    @IBOutlet weak var lblTitle: UILabel!
    
    //MARK: Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func ConfigureCellWithData(_ data: String) {
        lblTitle.text = data
    }
}
