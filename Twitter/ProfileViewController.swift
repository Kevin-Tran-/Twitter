//
//  ProfileViewController.swift
//  Twitter
//
//  Created by Kevin Tran on 2/21/16.
//  Copyright © 2016 Kevin Tran. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    var tweet: Tweet!
    
    @IBOutlet weak var headlineImage: UIImageView!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var screennameLabel: UILabel!
    @IBOutlet weak var taglineLabel: UILabel!
    @IBOutlet weak var tweetCountLabel: UILabel!
    @IBOutlet weak var followingCountLabel: UILabel!
    @IBOutlet weak var followerCountLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if tweet.user?.profileBannerURL != nil{
            headlineImage.setImageWithURL(NSURL(string: tweet.user!.profileBannerURL!)!)
        } else {
            //set image as something
        }
        
        userImage.setImageWithURL(NSURL(string: tweet.user!.profileImageUrl!)!)
        usernameLabel.text = tweet.user!.name!
        screennameLabel.text = tweet.user!.screenname!
        taglineLabel.text = tweet.user!.tagline!
        tweetCountLabel.text = "\(tweet.user!.statusesCount!) TWEETS"
        followingCountLabel.text = "\(tweet.user!.followingCount!) FOLLOWING"
        followerCountLabel.text = "\(tweet.user!.followerCount!) FOLLOWER"
    
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onBack(sender: UIBarButtonItem) {
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
