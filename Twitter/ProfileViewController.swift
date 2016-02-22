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
    var user: User!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var headlineImage: UIImageView!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var screennameLabel: UILabel!
    @IBOutlet weak var taglineLabel: UILabel!
    @IBOutlet weak var tweetCountLabel: UILabel!
    @IBOutlet weak var followingCountLabel: UILabel!
    @IBOutlet weak var followerCountLabel: UILabel!
    
    var headlineURL: NSURL?
    var userImageURL: NSURL?
    var username: String?
    var screenname: String?
    var tagline: String?
    var tweetcount: Int?
    var followingCount: Int?
    var followerCount: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if tweet != nil {
            if tweet.user?.profileBannerURL != nil{
                headlineURL = NSURL(string: tweet.user!.profileBannerURL!)!
            } else {
                //set image as something
            }
            userImageURL = NSURL(string: tweet.user!.profileImageUrl!)!
            username = tweet.user!.name!
            screenname = tweet.user!.screenname!
            tagline = tweet.user!.tagline!
            tweetcount = tweet.user!.statusesCount!
            followingCount = tweet.user!.followingCount!
            followerCount = tweet.user!.followerCount!
        }
        if user != nil{
            if user.profileBannerURL != nil{
                headlineURL = NSURL(string: user.profileBannerURL!)!
            } else {
                //set image as something
            }
            userImageURL = NSURL(string: user!.profileImageUrl!)!
            username = user!.name!
            screenname = user!.screenname!
            tagline = user!.tagline!
            tweetcount = user!.statusesCount!
            followingCount = user!.followingCount!
            followerCount = user!.followerCount!
        }
        setProfile()

    }
    
    func setProfile(){

        if headlineURL != nil{
            headlineImage.setImageWithURL(headlineURL!)
            headlineImage.hidden = false
        } else {
            headlineImage.hidden = true
        }
        userImage.setImageWithURL(userImageURL!)
        userImage.layer.cornerRadius = 10;
        usernameLabel.text = username!
        screennameLabel.text = "@\(screenname!)"
        taglineLabel.text = tagline!
        
        let formatter = NSNumberFormatter()
        formatter.numberStyle = .DecimalStyle
        
        let att = [NSFontAttributeName: UIFont.boldSystemFontOfSize(13.0)]
        var attributedString = NSMutableAttributedString(string: "\nTWEETS")
        
        let boldStatus = NSMutableAttributedString(string: "\(formatter.stringFromNumber(tweetcount!)!)", attributes:att)
        boldStatus.appendAttributedString(attributedString)
        tweetCountLabel.attributedText = boldStatus
        
        attributedString = NSMutableAttributedString(string: "\nFOLLOWING")
        let followingStatus = NSMutableAttributedString(string: "\(formatter.stringFromNumber(followingCount!)!)", attributes:att)
        followingStatus.appendAttributedString(attributedString)
        followingCountLabel.attributedText = followingStatus
        
        attributedString = NSMutableAttributedString(string: "\nFOLLOWERS")
        let followerStatus = NSMutableAttributedString(string: "\(formatter.stringFromNumber(followerCount!)!)", attributes:att)
        followerStatus.appendAttributedString(attributedString)
        followerCountLabel.attributedText = followerStatus
        
        //scrollView.contentSize = self.contentView.bounds.size//CGSize(width: scrollView.frame.size.width, height: contentView.frame.origin.y + contentView.frame.size.height)
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
