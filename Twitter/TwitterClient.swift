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
    
    class var sharedInstance: TwitterClient {
        struct Static {
            static let instance = TwitterClient(baseURL: twitterBaseURL, consumerKey: twitterConsumerKey, consumerSecret: twitterConsumerSecret)
        }
        return Static.instance
    }

}
