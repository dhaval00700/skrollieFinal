//
//  SearchViewController.swift
//  SKROLLIE
//
//  Created by PC on 01/08/19.
//  Copyright © 2019 Dhaval Bhanderi. All rights reserved.
//

import UIKit
import Alamofire

class SearchViewController: BaseViewController {

    @IBOutlet weak var clvSearchFriend: UICollectionView!
    @IBOutlet weak var txtSearch: UISearchBar!
    
    private var arrSearchUserList = [UserFriendList]()
    var dataRequest : DataRequest?
    var searchString = ""
    private var isDataLoading = false
    private var continueLoadingData = true
    private var skip = 0
    private var take = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpUI()
    }
    
    //MARK: - Methods
    func setUpUI() {
        
        txtSearch.showsCancelButton = false
        
        let searchBarStyle = txtSearch.value(forKey: "searchField") as? UITextField
        searchBarStyle?.clearButtonMode = .never
        
        clvSearchFriend.register(UINib(nibName: "SearchItemCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SearchItemCollectionViewCell")
        clvSearchFriend.delegate = self
        clvSearchFriend.dataSource = self
        clvSearchFriend.reloadData()
        txtSearch.delegate = self
        
    }
    
    func doSearch() {
        self.arrSearchUserList.removeAll()
        isDataLoading = false
        continueLoadingData = true
        skip = 0
        take = 10
        searchFriend()
    }
    
    //MARK: - actions
    @IBAction func onBtnBack(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
}

extension SearchViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrSearchUserList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchItemCollectionViewCell", for: indexPath) as! SearchItemCollectionViewCell
        let currentObj = arrSearchUserList[indexPath.row]
        cell.lblUserName.text = currentObj.username
        cell.imgUserPhoto.imageFromURL(link: currentObj.image, errorImage: #imageLiteral(resourceName: "img3"), contentMode: .scaleAspectFill)
         cell.btnConnect.isHidden = false
        cell.btnConnect.isUserInteractionEnabled = true
        if currentObj.FriendStatus.lowercased() == FriendStatus.Disconnect.lowercased() {
            cell.btnConnect.setTitle("Connect", for: .normal)
        }
        if currentObj.FriendStatus.lowercased() == FriendStatus.Friend.lowercased() {
            cell.btnConnect.isHidden = true
        }
        if currentObj.FriendStatus.lowercased() == FriendStatus.UnFriend.lowercased() {
            cell.btnConnect.setTitle("Connect", for: .normal)
        }
        if currentObj.FriendStatus.lowercased() == FriendStatus.Requested.lowercased() {
            cell.btnConnect.setTitle("Connect Requested", for: .normal)
            cell.btnConnect.isUserInteractionEnabled = false
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth = (collectionView.frame.width - (5 * 3)) / 2.0
        return CGSize(width: itemWidth, height: 124)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}


extension SearchViewController : UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        searchString = (searchBar.text! as NSString).replacingCharacters(in: range, with: text).encode()
        searchString = searchString.replacingOccurrences(of: "\n", with: "")
        doSearch()
        
        return true
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.showsCancelButton = true
        return true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.showsCancelButton = false
        self.view.endEditing(true)
        doSearch()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        self.view.endEditing(true)
    }
}


extension SearchViewController {
    
    private func searchFriend() {
        
        if(isDataLoading || !continueLoadingData) {
            return
        }
        
        isDataLoading = true
        
        dataRequest?.cancel()
        dataRequest = APIClient.GetUserBySearch(limit: take, page: skip, searchText: searchString) { (respopnseObject) in
            
            let response = respopnseObject ?? [String : Any]()
            let responseData = ResponseDataModel(responseObj: response)
            if responseData.success {
                
                let objectData = response["data"] as? [[String: Any]] ?? [[String: Any]]()
                let tempAray = UserFriendList.getArray(data: objectData)
                
                self.arrSearchUserList.append(contentsOf: tempAray)
                
                self.skip += 1

                if tempAray.count < 10 {
                    self.continueLoadingData = false
                }
                
                self.clvSearchFriend.reloadData()
            }
            self.isDataLoading = false
        }
    }
}
