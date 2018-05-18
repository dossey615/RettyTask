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
    var UserInfo:[AccountInformation] = []
    var appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
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
            //取得した情報を配列に格納
                for i in (0..<json.count){
                    let getInfo = AccountInformation() //配列に格納するためのインスタンス生成
                    if json[i]["user"]["profile_image_url"].string != nil{
                        getInfo.image_url = json[i]["user"]["profile_image_url"].string!
                        }
                    if json[i]["user"]["name"].string != nil{
                        getInfo.name = json[i]["user"]["name"].string!
                    }
                    if json[i]["user"]["screen_name"].string != nil{
                        getInfo.scname = json[i]["user"]["screen_name"].string!
                        }
                    if json[i]["text"].string != nil{
                        getInfo.text = json[i]["text"].string!
                        }
                    self.UserInfo.append(getInfo)
                    self.appDelegate.flag = 1
                }
            } catch let jsonError as NSError {
                print("json error: \(jsonError.localizedDescription)")
            }
        }
    }
    
}
