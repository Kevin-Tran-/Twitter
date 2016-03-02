//
//  TweetCell.swift
//  Twitter
//
//  Created by Kevin Tran on 2/14/16.
//  Copyright © 2016 Kevin Tran. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screennameLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var typeImage: UIImageView!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var retweetLabel: UILabel!
    @IBOutlet weak var favoriteLabel: UILabel!
    
    weak var firstViewController: UIViewController!
    
    // Set view
    var tweet: Tweet!{
        didSet {
            nameLabel.text = tweet.user?.name
            screennameLabel.text = "@\(tweet.user!.screenname!)"
            descriptionLabel.text = tweet.text
            profileImage.setImageWithURL(NSURL(string: (tweet.user?.profileImageUrl)!)!)
            timestampLabel.text = tweet.secondsToTime() 
            self.setButtonState()
            
            setTweetStat()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // Load state to be used if local variable changes
    func setTweetStat(){
        let formatter = NSNumberFormatter()
        formatter.numberStyle = .DecimalStyle
        
        if tweet.retweetCount > 0 {
            retweetLabel.text = "\(formatter.stringFromNumber(tweet.retweetCount!)!)"
            retweetLabel.hidden = false
        } else {
            retweetLabel.hidden = true
        }
        
        if tweet.favoriteCount > 0 {
            favoriteLabel.text = "\(formatter.stringFromNumber(tweet.favoriteCount!)!)"
            favoriteLabel.hidden = false
        } else {
            favoriteLabel.hidden = true
        }
    }
    
    // Set button state
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
    
    // Set Favorite Api and change local variables
    @IBAction func onFavorite(sender: UIButton) {
        if tweet != nil {
            if (tweet.favorited == true) {
                TwitterClient.sharedInstance.unFavorite(tweet.id_str!)
                favoriteButton.setImage(UIImage(named: "like-action-off"), forState: .Normal)
                tweet.favorited = false
                tweet.favoriteCount! -= 1
                setTweetStat()
            } else {
                TwitterClient.sharedInstance.favorite(tweet.id_str!)
                favoriteButton.setImage(UIImage(named: "like-action-on-red"), forState: .Normal)
                tweet.favorited = true
                tweet.favoriteCount! += 1
                setTweetStat()
            }
        }
    }
    
    // Set Retweet Api and change local variables
    @IBAction func onRetweet(sender: UIButton) {
        if tweet != nil {
            if (tweet.retweeted == false) {
                TwitterClient.sharedInstance.retweet(tweet.id_str!)
                retweetButton.setImage(UIImage(named: "retweet-action-on-green"), forState: .Normal)
                tweet.retweetCount! += 1
                tweet.retweeted = true
                setTweetStat()
            }
        }
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }


}
