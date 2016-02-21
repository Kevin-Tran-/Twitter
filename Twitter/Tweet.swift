//
//  Tweet.swift
//  Twitter
//
//  Created by Kevin Tran on 2/14/16.
//  Copyright © 2016 Kevin Tran. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    var user: User?
    var text: String?
    var createdAtString: String?
    var createdAt: NSDate?
    var calcTime: String?
    var id_str: String?
    var retweeted: Bool?
    var favorited: Bool?
    var reply_id: String?
    var favoriteCount: Int?
    var retweetCount: Int?
    
    let secs = 60
    let mins = 60
    let hours = 24
    
    init(dictionary: NSDictionary) {
        user = User(dictionary: dictionary["user"] as! NSDictionary)
        text = dictionary["text"] as? String
        createdAtString = dictionary["created_at"] as? String
        id_str = dictionary["id_str"] as? String
        retweeted = dictionary["retweeted"] as? Bool
        favorited = dictionary["favorited"] as? Bool
        reply_id = dictionary["reply_id"] as? String
        favoriteCount = dictionary["favorite_count"] as? Int
        retweetCount = dictionary["retweet_count"] as? Int
        
        
        var formatter = NSDateFormatter()
        formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
        createdAt = formatter.dateFromString(createdAtString!)
        print(id_str)
//        print(dictionary)
//        let temp = secondsToTime(createdAt!)
//        calcTime = temp
//        print(calcTime)
        
    }
    
    func secondsToTime() -> String {
        let today = NSDate()
        var sec = Int(today.timeIntervalSinceDate(createdAt!))
        if sec > 518400 { //greater than 6 days
            var formatter = NSDateFormatter()
            formatter.dateStyle = NSDateFormatterStyle.ShortStyle
            return formatter.stringFromDate(createdAt!)
        }
        
        if sec > 86400 { // greater than 24 hours
            sec /= (mins*secs*hours)
            let s = "\(sec)d"
            return s
        }
        
        if sec > 3600 { // greater than 1h
            sec /= (secs*mins)
            let s = "\(sec)h"
            return s
        }
        
        sec = sec / secs
        let s = "\(sec)m"
        return s
    }
    
    class func tweetsWithArray(array: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        
        for dictionary in array {
            tweets.append(Tweet(dictionary: dictionary))
        }
        
        return tweets
    }
}
