//
//  TweetsViewController.swift
//  Twitter
//
//  Created by Kevin Tran on 2/14/16.
//  Copyright © 2016 Kevin Tran. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {

    var tweets: [Tweet]?
    var user: User!
    
    @IBOutlet weak var tableView: UITableView!
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate

    
    var isMoreDataLoading = false
    var loadingMoreView:InfiniteScrollActivityView?
    var count = 40
    
    var refreshControl: UIRefreshControl!       //add refresh on drag

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        
        // Navigation color
        navigationController?.navigationBar.barTintColor = UIColorFromRGB(0x326ada)
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        navigationController!.navigationBar.tintColor = UIColor.whiteColor()

        
        // Set up Infinite Scroll loading indicator
        let frame = CGRectMake(0, tableView.contentSize.height, tableView.bounds.size.width, InfiniteScrollActivityView.defaultHeight)
        loadingMoreView = InfiniteScrollActivityView(frame: frame)
        loadingMoreView!.hidden = true
        tableView.addSubview(loadingMoreView!)
        
        var insets = tableView.contentInset;
        insets.bottom += InfiniteScrollActivityView.defaultHeight;
        tableView.contentInset = insets

        // Do any additional setup after loading the view.
        networkRequest()
        
        print("Tweet View Controller loaded")        
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "onRefresh", forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
    }
    
    override func viewDidAppear(animated: Bool) {
        print("Tweet View Controller appeared")
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func networkRequest(){
        TwitterClient.sharedInstance.homeTimelineWithCompletion(20, params: nil) { (tweets, error) -> () in
            self.tweets = tweets
            self.tableView.reloadData()
        }
    }
    
    // This method causes program to not load properly due to rate limit
    func loadMoreData() {
        print(count)
        if count < 200 {
            TwitterClient.sharedInstance.homeTimelineWithCompletion(count, params: nil) { (tweets, error) -> () in
                self.tweets = tweets
                
                // Update flag
                self.isMoreDataLoading = false
                
                // Stop the loading indicator
                self.loadingMoreView!.stopAnimating()
                
                print("current count \(self.count)")
                // Reload the tableView now that there is new data
                self.tableView.reloadData()
                self.count += 20

            }
        }
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if (!isMoreDataLoading) {
            // Calculate the position of one screen length before the bottom of the results
            let scrollViewContentHeight = tableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
            
            // When the user has scrolled past the threshold, start requesting
            if(scrollView.contentOffset.y > scrollOffsetThreshold && tableView.dragging) {
                isMoreDataLoading = true
                
                // Update position of loadingMoreView, and start loading indicator
                let frame = CGRectMake(0, tableView.contentSize.height, tableView.bounds.size.width, InfiniteScrollActivityView.defaultHeight)
                loadingMoreView?.frame = frame
                loadingMoreView!.startAnimating()
                
                // Code to load more results
                loadMoreData()
            }
        }
    }
    
    func UIColorFromRGB(rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tweets != nil {
            return tweets!.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCellWithIdentifier("TweetCell", forIndexPath: indexPath) as! TweetCell
        cell.tweet = tweets![indexPath.row]
        print(indexPath.row)
        
        return cell
    }
    
    func onRefresh() {
        self.networkRequest()
        print("Refreshing Tweets")
        self.refreshControl.endRefreshing()
        print("Refreshing Complete")
    }

    @IBAction func onLogout(sender: UIButton) {
        User.currentUser?.logout()
    }
    
    @IBAction func onTap(sender: UITapGestureRecognizer) {
        self.performSegueWithIdentifier("tweetDetailSegue", sender: self)

    }
    @IBAction func onProfileClick(sender: UIButton) {
    }
    
    
    @IBAction func onSelfProfile(sender: UIBarButtonItem) {
        self.performSegueWithIdentifier("selfProfileSegue", sender: self)
    }
    
    @IBAction func onTweetClick(sender: UIBarButtonItem) {
        self.performSegueWithIdentifier("tweetSegue", sender: self)
        
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

        
        if (segue.identifier == "tweetDetailSegue") {
            let cell = sender as! UITableViewCell
            let indexPath = tableView.indexPathForCell((cell))
            let tweet = tweets![indexPath!.row]
            
            let nav = segue.destinationViewController as! UINavigationController
            let detailViewController = nav.topViewController as! TweetDetailViewController
            detailViewController.tweet = tweet
            print("prepare for seque called on Tweet Details")
        }
        if (segue.identifier == "profileSegue") {
            let cell = sender as! UIButton
            let buttonCell = cell.superview?.superview as! UITableViewCell
            let indexPath = tableView.indexPathForCell((buttonCell))
            let tweet = tweets![indexPath!.row]
            
            let nav = segue.destinationViewController as! UINavigationController
            let profileViewController = nav.topViewController as! ProfileViewController
            
            profileViewController.user = tweet.user
            
//            let params = ["screen_name": "\(tweet.user!.screenname!)"] as NSDictionary
//            TwitterClient.sharedInstance.UserTimelineWithCompletion(params, completion: { (tweets, error) -> () in
//                profileViewController.tweet = tweets
//            })
            
        }
        if (segue.identifier == "selfProfileSegue") {
            let nav = segue.destinationViewController as! UINavigationController
            let profileViewController = nav.topViewController as! ProfileViewController
            profileViewController.user = User.currentUser
        }
        
        if (segue.identifier == "tweetSegue") {
            let nav = segue.destinationViewController as! UINavigationController
            let composeViewController = nav.topViewController as! ComposeViewController
            composeViewController.user = User.currentUser
            composeViewController.tweets = tweets
            composeViewController.firstViewController = self
        }

    }

}
