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
    
    var tweet: Tweet!{
        didSet {
            usernameLabel.text = tweet.user?.name
            screennameLabel.text = "@\(tweet.user!.screenname!)"
            tweetDetailLabel.text = tweet.text
            userImage.setImageWithURL(NSURL(string: (tweet.user?.profileImageUrl)!)!)
            timeLabel.text = tweet.secondsToTime()
            retweetCountLabel.text = "\(tweet.retweetCount) RETWEETS"
            likeCountLabel.text = "\(tweet.favoriteCount) LIKES"
            //self.setButtonState()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
