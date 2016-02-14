//
//  TweetCell.swift
//  Twitter
//
//  Created by Kevin Tran on 2/14/16.
//  Copyright © 2016 Kevin Tran. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell {
    
    @IBOutlet weak var retweetLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screennameLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var typeImage: UIImageView!
    
    
    var tweet: Tweet!{
        didSet {
            nameLabel.text = tweet.user?.name
            screennameLabel.text = tweet.user?.screenname
            descriptionLabel.text = tweet.text
            profileImage.setImageWithURL(NSURL(string: (tweet.user?.profileImageUrl)!)!)
            
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
