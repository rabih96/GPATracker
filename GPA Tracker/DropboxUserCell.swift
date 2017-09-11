//
//  DropboxUserCell.swift
//  GPA Diary
//
//  Created by Rabih Mteyrek on 4/19/17.
//  Copyright © 2017 Rabih Mteyrek. All rights reserved.
//

import UIKit
import SwiftyDropbox

class DropboxUserCell: UITableViewCell {

    @IBOutlet weak var dropboxImageView: UIImageView!
    @IBOutlet weak var UserName: UILabel!
    @IBOutlet weak var backupTime: UILabel!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        dropboxImageView.layer.cornerRadius = 30
        dropboxImageView.layer.masksToBounds = true
        
        if let client = DropboxClientsManager.authorizedClient {
            client.users.getCurrentAccount().response{ response, error in
                self.UserName.text = response?.name.displayName
                if let photoURL = response?.profilePhotoUrl {
                    let url = URL(string: photoURL)
                    let data = try? Data(contentsOf: url!)
                    self.dropboxImageView.image = UIImage(data: data!)
                }
                self.loadingIndicator.stopAnimating()
            }
        }else{
            self.loadingIndicator.stopAnimating()
            self.UserName.text = "Sign into Dropbox"
            self.backupTime.text = "I'll be waiting"
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
