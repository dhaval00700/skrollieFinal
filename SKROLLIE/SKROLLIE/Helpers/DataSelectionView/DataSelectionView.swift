//
//  DataSelectionView.swift
//  Trustfund
//
//  Created by Smit Patel on 19/03/19.
//  Copyright © 2019 Smit Patel. All rights reserved.
//

import UIKit

@objc protocol DataSelectionViewDataSource: class {
    func numberOfRows() -> Int
    @objc optional func dataSelectionView(dataToShowAt indexPath: IndexPath) -> String
    @objc optional func dataSelectionView(isDataSelectedAt indexPath: IndexPath) -> Bool
    @objc optional func dataSelectionView(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell?
}

protocol DataSelectionViewDelegate: class {
    func dataSelectionView(tableView: UITableView, didSelectRowAt indexPath: IndexPath)
}

class DataSelectionView: UIView {

    // MARK: - Outlets
    @IBOutlet weak var mainContainerView: UIView!
    @IBOutlet weak var headerContainerView: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var tblData: UITableView!
    @IBOutlet weak var tblDataHeightConstraint: NSLayoutConstraint!
    
    // MARK: - Properties
    weak var dataSource: DataSelectionViewDataSource?
    weak var delegate: DataSelectionViewDelegate?
    
    // MARK: - Lifecycles
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    // MARK: - Functions
    class func constructView(owner: Any?) -> DataSelectionView {
        let nib = UINib(nibName: "DataSelectionView", bundle: nil)
        let view = nib.instantiate(withOwner: owner, options: nil)[0] as! DataSelectionView
        return view
    }
    
    private func setupUI() {
        mainContainerView.layer.cornerRadius = 10.0
        mainContainerView.layer.masksToBounds = true
        
        tblData.register(UINib(nibName: "DataSelectionTableViewCell", bundle: nil), forCellReuseIdentifier: "DataSelectionTableViewCell")
        tblData.dataSource = self
        tblData.delegate = self
    }
    
    func setTitle(title: String) {
        lblTitle.text = title
    }
    
    func reloadData() {
        tblData.reloadData()
        tblData.layoutIfNeeded()
        tblDataHeightConstraint.constant = tblData.contentSize.height
    }
    
    // MARK: - Actions
    @IBAction func onBtnClose(_ sender: Any) {
        self.removeFromSuperview()
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

extension DataSelectionView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let dataSource = dataSource else {
            return 0
        }
        return dataSource.numberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = dataSource?.dataSelectionView?(tableView: tableView, cellForRowAt: indexPath) {
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DataSelectionTableViewCell") as! DataSelectionTableViewCell
        cell.lblData.text = dataSource?.dataSelectionView?(dataToShowAt: indexPath)
        cell.accessoryView = nil
        if let isDataSelected = dataSource?.dataSelectionView?(isDataSelectedAt: indexPath), isDataSelected {
            cell.accessoryView = UIImageView(image: UIImage(named: "ic_check"))
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.dataSelectionView(tableView: tableView, didSelectRowAt: indexPath)
        self.removeFromSuperview()
    }
}
