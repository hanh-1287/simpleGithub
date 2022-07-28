//
//  HomeCell.swift
//  table
//
//  Created by Huy Hà on 7/27/22.
//

import UIKit

class HomeCell: UITableViewCell {


    @IBOutlet weak var urlLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var viewCell: UIView!
    @IBOutlet weak var imageVoew: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
       
//        viewCell.layer.shadowOpacity = 1.0
//        viewCell.layer.shadowColor = UIColor.black.cgColor
//        viewCell.layer.shadowOffset = CGSize(width: 1, height: 1)
//        viewCell.layer.masksToBounds = false
        viewCell.layer.cornerRadius = 20
        viewCell.layer.borderWidth = 1
        viewCell.layer.borderColor = UIColor.black.cgColor
        imageVoew.layer.cornerRadius = imageVoew.frame.height/2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

    func setCellWithValuesOf(_ searchUser: SearchUser) {
        updateUI(imageURL: searchUser.avatar_url, name: searchUser.login, urlString: searchUser.html_url)

    }

    func updateUI(imageURL: String, name: String, urlString: String) {
        nameLabel.text = name
        
        urlLabel.text  = urlString
        guard let userImageURL = URL(string: imageURL) else {
            self.imageVoew.image = UIImage(named: "noImageAvailable")
            return
        }
        
        
        self.imageVoew.image = nil
        getImageDataFrom(url: userImageURL)
    }
    func getImageDataFrom(url: URL) {
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            // Handle Error
            if let error = error {
                print("DataTask error: \(error.localizedDescription)")
                return
            }
            guard let data = data else {
                // Handle Empty Data
                print("Empty Data")
                return
            }

            DispatchQueue.main.async {
                if let image = UIImage(data: data) {
                    self.imageVoew.image = image
                }
            }
        }.resume()
    }
}
