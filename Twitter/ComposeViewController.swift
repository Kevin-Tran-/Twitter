//
//  ComposeViewController.swift
//  Twitter
//
//  Created by Kevin Tran on 2/21/16.
//  Copyright © 2016 Kevin Tran. All rights reserved.
//

import UIKit

class ComposeViewController: UIViewController, UITextViewDelegate {

    var user: User!
    var tweets: [Tweet]!
    
    @IBOutlet weak var textLimit: UIBarButtonItem!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var screennameLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    
    var userImageURL: NSURL?
    var username: String?
    var screenname: String?
    
    var replyID: String?
    var tweetReference: Tweet!
    
    weak var firstViewController: TweetsViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView.delegate = self
    
        userImageURL = NSURL(string: user!.profileImageUrl!)!
        username = user!.name!
        screenname = user!.screenname!
        
        userImage.setImageWithURL(userImageURL!)
        userImage.layer.cornerRadius = 10;
        usernameLabel.text = username!
        screennameLabel.text = "@\(screenname!)"
        
        if tweetReference != nil {
            textView.text = "@\(tweetReference.user!.screenname!) "
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func onCancel(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // Send tweet using tweet api
    @IBAction func onTweet(sender: UIBarButtonItem) {
        let text = textView.text! as String!
        if (text.characters.count <= 120 && text.characters.count > 0) {
            
            // Set Twitter Api param
            var params: NSDictionary!
            if tweetReference != nil {
                params = ["status": text, "in_reply_to_status_id": tweetReference.id_str!] as NSDictionary
                print(tweetReference.id_str!)
            } else {
                params = ["status": text] as NSDictionary
            }
            
            TwitterClient.sharedInstance.tweetWithParam(params, completion: { (tweet, error) -> () in
                //sent successfully
                self.tweets.insert(Tweet(dictionary: tweet), atIndex: 0)
                print(tweet)
                self.firstViewController!.tweets = self.tweets
                self.dismissViewControllerAnimated(true, completion: nil)
            })
        } else if (text.characters.count > 120) {
            let alertController = UIAlertController(title: "Error", message: "Tweet exceed allowed amount", preferredStyle: .Alert)
            let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
            }
            // add the OK action to the alert controller
            alertController.addAction(OKAction)
            
            self.presentViewController(alertController, animated: true) {
            }
            
        } else {
            let alertController = UIAlertController(title: "Error", message: "Invalid tweet", preferredStyle: .Alert)
            // create an OK action
            let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
                // handle response here.
            }
            // add the OK action to the alert controller
            alertController.addAction(OKAction)
            
            self.presentViewController(alertController, animated: true) {
                // optional code for what happens after the alert controller has finished presenting
            }
        }
    }
    
    // Update max character
    func textViewDidChange(textView: UITextView) {
        textLimit.title = "\(textView.text!.characters.count)/120"
    }
    
    // pass back current tweet
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let nav = segue.destinationViewController as! UINavigationController
        let tweetsViewController = nav.topViewController as! TweetsViewController
        tweetsViewController.tweets = tweets
    }
}
