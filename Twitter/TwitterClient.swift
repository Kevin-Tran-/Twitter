//
//  TwitterClient.swift
//  Twitter
//
//  Created by Kevin Tran on 2/13/16.
//  Copyright © 2016 Kevin Tran. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

let twitterConsumerKey = "Qo5XJj229HCkfi0Il6Z1yva13"
let twitterConsumerSecret = "Uw1lgZfNh11Lb85Uh8HPPcXcT8rc2jQFubavf85mfJBCDu4rrN"
let twitterBaseURL = NSURL(string: "https://api.twitter.com")

class TwitterClient: BDBOAuth1SessionManager {
    
    var loginCompletion: ((user: User?, error: NSError?) -> ())?
    
    class var sharedInstance: TwitterClient {
        struct Static {
            static let instance = TwitterClient(baseURL: twitterBaseURL, consumerKey: twitterConsumerKey, consumerSecret: twitterConsumerSecret)
        }
        return Static.instance
    }
    
    func loginWithCompletion(completion: (user: User?, error: NSError?) -> ()) {
        loginCompletion = completion
        
        // Fetch request token & redirect to authorization page
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
        TwitterClient.sharedInstance.fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string: "kevinuwtwitterdemo://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential!) -> Void in
            print("Got the request token")
            var authURL = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")
            UIApplication.sharedApplication().openURL(authURL!)
        }) { (error: NSError!) -> Void in
            print("Error getting the request token: \(error)")
            self.loginCompletion?(user: nil, error: error)
        }
    }
    
    func homeTimelineWithCompletion(count: Int, params: NSDictionary?, completion: (tweets: [Tweet]?, error: NSError?) -> ()) {
        GET("1.1/statuses/home_timeline.json?count=\(count)", parameters: params, success: { (operation: NSURLSessionDataTask, response: AnyObject?) -> Void in
            //print("home timeline: \(response)")
            var tweets = Tweet.tweetsWithArray(response as! [NSDictionary])
            completion(tweets: tweets, error: nil)
//            for tweet in tweets {
                //print("user: \(tweet.user!.name) username: \(tweet.user?.screenname) text: \(tweet.text), created: \(tweet.createdAt)")
//                let temp = tweet.secondsToTime()
//                print(temp)
//            }
        }, failure: { (operation: NSURLSessionDataTask?, error: NSError) -> Void in
                print("error getting home timeline")
            completion(tweets: nil, error: error)
        })
    }
    
    func UserTimelineWithCompletion(params: NSDictionary?, completion: (tweets: [Tweet]?, error: NSError?) -> ()) {
        GET("1.1/statuses/user_timeline.json", parameters: params, success: { (operation: NSURLSessionDataTask, response: AnyObject?) -> Void in
            //print("home timeline: \(response)")
            var tweets = Tweet.tweetsWithArray(response as! [NSDictionary])
            completion(tweets: tweets, error: nil)
//            for tweet in tweets {
//                print("user: \(tweet.user!.name) username: \(tweet.user?.screenname) text: \(tweet.text), created: \(tweet.createdAt)")
//                                let temp = tweet.secondsToTime()
//                                print(temp)
//            }
            }, failure: { (operation: NSURLSessionDataTask?, error: NSError) -> Void in
                print("error getting home timeline \(error)")
                completion(tweets: nil, error: error)
        })
    }
    
    func tweetWithParam(params: NSDictionary?, completion: (tweet: NSDictionary!, error: NSError?) -> ()) {
        POST("1.1/statuses/update.json", parameters: params, success: { (operation: NSURLSessionDataTask, response: AnyObject?) -> Void in
            print("User just tweeted successfully \(response)")
            var tweet = response as! NSDictionary!
            completion(tweet: tweet, error: nil)
            }, failure: { (operation: NSURLSessionDataTask?, error: NSError) -> Void in
                print("Failed tweet with error: \(error)")
                completion(tweet: nil, error: error)
        })
    }
    
    func openURL (url: NSURL){
        fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: BDBOAuth1Credential (queryString: url.query), success: { (accessToken: BDBOAuth1Credential!) -> Void in
            print("Got the access token")
            TwitterClient.sharedInstance.requestSerializer.saveAccessToken(accessToken)
            
            // Get current User
            TwitterClient.sharedInstance.GET("1.1/account/verify_credentials.json", parameters: nil, success: { (operation: NSURLSessionDataTask, response: AnyObject?) -> Void in
                //print("user: \(response)")
                var user = User(dictionary: response as! NSDictionary)
                User.currentUser = user
                print("user: \(user.name)")
                self.loginCompletion?(user: user, error: nil)
            }, failure: { (operation: NSURLSessionDataTask?, error: NSError) -> Void in
                print("error getting current user")
                self.loginCompletion?(user: nil, error: error)
            })
            
        }) { (error: NSError!) -> Void in
                print("Failed to receive access token \(error)")
                self.loginCompletion?(user: nil, error: error)
        }
    }
    
    func retweet (id_str: String) -> (){
        print(id_str)
        POST("1.1/statuses/retweet/\(id_str).json", parameters: nil, success: { (operation: NSURLSessionDataTask, response: AnyObject?) -> Void in
                print("Successfully retweet")
                //self.loginCompletion?(stwe: tweets, error: nil)

            }) { (operation: NSURLSessionDataTask?, error: NSError) -> Void in
                print("Failed to retweet \(error)")
                self.loginCompletion?(user: nil, error: error)
        }
    }
    
//    func unRetweet (tweet: Tweet) -> (){
//        var originalTweetId = ""
//        if tweet.retweeted == false {
//            print("tweet was not retweeted")
//            return
//        } else {
//            if tweet.retweeted == nil {
//                originalTweetId = tweet.id_str
//            }
//        }
//        print(id_str)
//        POST("1.1/statuses/unretweet/\(id_str).json", parameters: nil, success: { (operation: NSURLSessionDataTask, response: AnyObject?) -> Void in
//            print("Successfully retweet")
//            //self.loginCompletion?(stwe: tweets, error: nil)
//            
//            }) { (operation: NSURLSessionDataTask?, error: NSError) -> Void in
//                print("Failed to retweet \(error)")
//                self.loginCompletion?(user: nil, error: error)
//        }
//    }
    
    func favorite (id_str: String) -> (){
        print(id_str)
        POST("1.1/favorites/create.json?id=\(id_str)", parameters: nil, success: { (operation: NSURLSessionDataTask, response: AnyObject?) -> Void in
            print("Successfully favorited")
            //self.loginCompletion?(stwe: tweets, error: nil)
            
            }) { (operation: NSURLSessionDataTask?, error: NSError) -> Void in
                print("Failed to favorite \(error)")
                self.loginCompletion?(user: nil, error: error)
        }
    }
    
    func unFavorite (id_str: String) -> (){
        print(id_str)
        POST("1.1/favorites/destroy.json?id=\(id_str)", parameters: nil, success: { (operation: NSURLSessionDataTask, response: AnyObject?) -> Void in
            print("Successfully unfavorited")
            //self.loginCompletion?(stwe: tweets, error: nil)
            
            }) { (operation: NSURLSessionDataTask?, error: NSError) -> Void in
                print("Failed to unfavorite \(error)")
                self.loginCompletion?(user: nil, error: error)
        }
    }

}
