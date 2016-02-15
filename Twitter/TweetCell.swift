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
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    
    
    var tweet: Tweet!{
        didSet {
            nameLabel.text = tweet.user?.name
            screennameLabel.text = "@\(tweet.user!.screenname!)"
            descriptionLabel.text = tweet.text
            profileImage.setImageWithURL(NSURL(string: (tweet.user?.profileImageUrl)!)!)
            timestampLabel.text = tweet.secondsToTime() //need to format better
            self.setButtonState()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
//         Initialization code
    }
    
    func setButtonState() {
        if tweet != nil {
            if (tweet.retweeted == true) {
                retweetButton.setImage(UIImage(named: "retweet-action-on-green"), forState: .Normal)
            } else {
                retweetButton.setImage(UIImage(named: "retweet-action_default"), forState: .Normal)
            }
            if (tweet.favorited == true) {
                favoriteButton.setImage(UIImage(named: "like-action-on-red"), forState: .Normal)
            } else {
                favoriteButton.setImage(UIImage(named: "like-action-off"), forState: .Normal)
            }
        }
    }

    @IBAction func onFavorite(sender: UIButton) {
        if tweet != nil {
            TwitterClient.sharedInstance.favorite(tweet.id_str!)
            favoriteButton.setImage(UIImage(named: "like-action-on-red"), forState: .Normal)

        }
    }
    @IBAction func onRetweet(sender: UIButton) {
        if tweet != nil {
            TwitterClient.sharedInstance.retweet(tweet.id_str!)
            retweetButton.setImage(UIImage(named: "retweet-action-on-green"), forState: .Normal)
        }
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
