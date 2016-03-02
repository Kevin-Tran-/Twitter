//
//  TweetDetailViewController.swift
//  Twitter
//
//  Created by Kevin Tran on 2/18/16.
//  Copyright © 2016 Kevin Tran. All rights reserved.
//

import UIKit

class TweetDetailViewController: UIViewController {

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var replyButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var screennameLabel: UILabel!
    @IBOutlet weak var tweetDetailLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var likeCountLabel: UILabel!
    
    weak var firstViewController: TweetsViewController?
    
    var tweet: Tweet!
    var tweets: [Tweet]!

    override func viewDidLoad() {
        super.viewDidLoad()

        usernameLabel.text = tweet.user!.name
        screennameLabel.text = "@\(tweet.user!.screenname!)"
        tweetDetailLabel.text = tweet.text
        userImage.setImageWithURL(NSURL(string: (tweet.user?.profileImageUrl)!)!)
        userImage.layer.cornerRadius = 10;
        
        setTweetCount()
        setButtonState()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Back action, dismiss view
    @IBAction func onBack(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // Set mutable string
    func setTweetCount(){
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "h:mm a    d MMM yy"
        let time = dateFormatter.stringFromDate(tweet.createdAt!)
        timeLabel.text = time
        
        let formatter = NSNumberFormatter()
        formatter.numberStyle = .DecimalStyle
        
        let att = [NSFontAttributeName: UIFont.boldSystemFontOfSize(13.0)]
        var attributedString = NSMutableAttributedString(string: " RETWEETS")
        
        let boldRetweet = NSMutableAttributedString(string: "\(formatter.stringFromNumber(tweet.retweetCount!)!)", attributes:att)
        boldRetweet.appendAttributedString(attributedString)
        retweetCountLabel.attributedText = boldRetweet
        
        attributedString = NSMutableAttributedString(string: " LIKES")
        let boldLikes = NSMutableAttributedString(string: "\(formatter.stringFromNumber(tweet.favoriteCount!)!)", attributes:att)
        boldLikes.appendAttributedString(attributedString)
        likeCountLabel.attributedText = boldLikes
    }
    
    // Set button state for current and local variable change
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

    // Retweet Api action
    @IBAction func onRetweet(sender: UIButton) {
        if tweet != nil {
            TwitterClient.sharedInstance.retweet(tweet.id_str!)
            retweetButton.setImage(UIImage(named: "retweet-action-on-green"), forState: .Normal)
            tweet.retweetCount! += 1
            setTweetCount()
        }
    }
    
    // Favorite Api action
    @IBAction func onFavorite(sender: UIButton) {
        if tweet != nil {
            if (tweet.favorited == true) {
                TwitterClient.sharedInstance.unFavorite(tweet.id_str!)
                favoriteButton.setImage(UIImage(named: "like-action-off"), forState: .Normal)
                tweet.favorited = false
                tweet.favoriteCount! -= 1
                setTweetCount()
            } else {
                TwitterClient.sharedInstance.favorite(tweet.id_str!)
                favoriteButton.setImage(UIImage(named: "like-action-on-red"), forState: .Normal)
                tweet.favorited = true
                tweet.favoriteCount! += 1
                setTweetCount()
            }
            
        }
    }
    
    // Segue to message composure
    @IBAction func onReply(sender: UIButton) {
        self.performSegueWithIdentifier("detailsTweetSegue", sender: sender)
    }
    
    // Pass current tweet info
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "detailsTweetSegue") {
            
            let nav = segue.destinationViewController as! UINavigationController
            let composeViewController = nav.topViewController as! ComposeViewController
            composeViewController.user = User.currentUser
            composeViewController.tweetReference = tweet
            composeViewController.tweets = tweets
            composeViewController.firstViewController = self.firstViewController
        }
    }
    

}
