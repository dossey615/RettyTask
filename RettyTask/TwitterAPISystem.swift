//
//  TwitterAPISystem.swift
//  RettyTask
//
//  Created by 土居将史 on 2018/05/10.
//  Copyright © 2018年 土居将史. All rights reserved.
//

import Foundation
import TwitterKit
import SwiftyJSON

class TwitterAPI: NSObject {
    
    var APIsession: TWTRSession?
    var tweets_instance = tweets()
    
    //Twetter機能を使うための認証メソッド
    func GetOuth(){
        TWTRTwitter.sharedInstance().logIn { session, error in
            guard let session = session else {
                if let error = error {
                    print("エラーが起きました => \(error.localizedDescription)")
                }
                return
            }
            print("@\(session.userName)でログインしました")
            self.APIsession = session
            self.GetTimeline()
             print(self.tweets_instance.name)
        }
    }
    
    //APIを叩き、設定されたアカウントからタイムラインを取得
    func GetTimeline(){
        var clientError: NSError?
        let client = TWTRAPIClient.withCurrentUser()
        let URLEndpoint = "https://api.twitter.com/1.1/statuses/user_timeline.json"
        let params = ["user_id":self.APIsession!.userID,"count": "2"]
        
        //requestの設定
        let request = client.urlRequest(
            withMethod: "GET",
            urlString: URLEndpoint,
            parameters: params,
            error: &clientError
        )
        
        //URLを使い、APIにrequest
        client.sendTwitterRequest(request) { (response, data, connectionError) -> Void in
            if connectionError != nil {
                print("Error: \(String(describing: connectionError))")
            }
            //connct成功時,tweetのjsondataをAPIにより取得
            do {
                var json = try JSON(data: data!)
                print(json)
                for i in (0..<json.count){
                if json[i]["text"].string != nil{
                    self.tweets_instance.text.append(json[i]["text"].string!)
                }
                if json[i]["profile_image_url"].string != nil{
                    self.tweets_instance.image_url.append(json[i]["profile_image_url"].string!)
                }
                if json[i]["screen_name"].string != nil{
                    self.tweets_instance.scname.append(json[i]["screen_name"].string!)
                }
                if json[i]["name"].string != nil{
                    self.tweets_instance.name.append(json[i]["name"].string!)
                }
                }
                //設定した条件によりtweetを取得
//                let son = try JSONSerialization.jsonObject(with: data!, options: []) as! NSArray
//                print(son)
                
            } catch let jsonError as NSError {
                print("json error: \(jsonError.localizedDescription)")
            }
        }
    }
}
