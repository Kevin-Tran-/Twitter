//
//  ProfileViewController.swift
//  Twitter
//
//  Created by Kevin Tran on 2/21/16.
//  Copyright © 2016 Kevin Tran. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var tweets: [Tweet]!
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
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
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
        self.tableView.delegate = self
        self.tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        headerView.frame.size.height
            = followerCountLabel.frame.origin.y + 80
        var params: NSDictionary!

        params = ["user_id": user.id!] as NSDictionary
        
        TwitterClient.sharedInstance.UserTimelineWithCompletion(params) { (tweets, error) -> () in
            if error == nil {
                self.tweets = tweets
                self.tableView.reloadData()
            }
        }
    }
    
    func setProfile(){

        if headlineURL != nil{
            headlineImage.setImageWithURL(headlineURL!)
            headlineImage.hidden = false
        } else {
            headlineImage.backgroundColor = UIColor.blueColor()
            //headlineImage.hidden = true
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

    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tweets != nil {
            return tweets!.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("ProfileTweetCell", forIndexPath: indexPath) as! ProfileTweetCell
        cell.tweet = tweets![indexPath.row]
        print(indexPath.row)
        
        return cell
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onBack(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}
