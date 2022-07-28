//
//  ViewController.swift
//  table
//
//  Created by Huy Hà on 7/27/22.
//

import UIKit

class ViewController: UIViewController {

    var apiService  = APIService()
    var searchUsers = [SearchUser]()

    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet weak var userTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configure()
    }
    func configure() -> Void {
        searchBar.text = ""
        userTableView.delegate = self
        userTableView.dataSource = self
        self.navigationItem.titleView = searchBar
        searchBar.delegate = self
        userTableView.separatorStyle = .none
        userTableView.showsVerticalScrollIndicator = false
        
    }
    
    func fetchUserData(completion: @escaping () -> ()) {

        // weak self - prevent retain cycles
        
        if searchBar.text != nil && validateUsername(str: searchBar.text!){
            apiService.getUserInfo(for: searchBar.text!) { [weak self] (result) in
                switch result {
                case .success(let user):
                    self?.searchUsers = user.items
                    if(self?.searchUsers.count == 0) {
                        let alert =  UIAlertController(title: "Not found user", message:"Try Again", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                        self?.present(alert, animated: true, completion: nil)
                    }
                    completion()
                case .failure(let error):
                    // Something is wrong with the JSON file
                    print("Error processing json data: \(error)")
                    
                }
            }
        }else {
            let alert =  UIAlertController(title: "Wrong format", message:"Input again", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    func validateUsername(str: String) -> Bool
    {
        do
        {
            let regex = try NSRegularExpression(pattern: "^[0-9a-zA-Z\\-]{1,18}$", options: .caseInsensitive)
            if regex.matches(in: str, options: [], range: NSMakeRange(0, str.count)).count > 0 {return true}
        }
        catch {}
        return false
    }
}



extension ViewController: UITableViewDelegate, UITableViewDataSource    {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! HomeCell
        cell.selectionStyle = .none
        cell.setCellWithValuesOf(searchUsers[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchUsers.count != 0 {
            return  searchUsers.count
        } else {
            return 0
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        userTableView.deselectRow(at: indexPath, animated: false)
    }
    
}

extension ViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        fetchUserData {
            print("ok")
            self.userTableView.reloadData()
            
        }
       
        searchBar.resignFirstResponder()
    }
}

