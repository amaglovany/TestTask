//
//  ContributorsViewController.swift
//  GitTest
//
//  Created by Developer on 4/19/19.
//  Copyright © 2019 Developer. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class ContributorsViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - properties
    private var contributors: [Contributor]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self

        fetchFromAPI(owner: "Alamofire", repo: "Alamofire") { [weak self] contributors in
            self?.contributors = contributors
            
            DispatchQueue.main.async {
                self?.tableView?.reloadData()
            }
        }
    }
    
    func fetchFromAPI(owner: String, repo: String, completion: @escaping ([Contributor]) -> ()) {
        
        ContributorsAPI.fetchContributors(owner: owner, repo: repo, completion: { [weak self] (contributors, error) in
            guard error == nil else {
                let ac = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
                self?.present(ac, animated: true)
                return
            }
            
            guard let contributors = contributors else {
                print("Something went wrong")
                return
            }
            completion(contributors)
        })
    }
}


// MARK: - UITableViewDelegate, UITableViewDataSource
extension ContributorsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.contributors?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "contributorCell") as? ContributorTableViewCell {
            cell.configureWith(self.contributors?[indexPath.row])
            return cell
        } else {
            return ContributorTableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
}
