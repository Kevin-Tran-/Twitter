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
    
    var tweet: Tweet!

    override func viewDidLoad() {
        super.viewDidLoad()

        usernameLabel.text = tweet.user!.name
        screennameLabel.text = "@\(tweet.user!.screenname!)"
        tweetDetailLabel.text = tweet.text
        userImage.setImageWithURL(NSURL(string: (tweet.user?.profileImageUrl)!)!)
        userImage.layer.cornerRadius = 10;
        
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "h:mm d MMM yy"
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

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onBack(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
