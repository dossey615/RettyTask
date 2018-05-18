//
//  TimeLineViewController.swift
//  RettyTask
//
//  Created by 土居将史 on 2018/05/10.
//  Copyright © 2018年 土居将史. All rights reserved.
//

import UIKit
import TwitterKit
import SwiftyJSON
import AlamofireImage

class TimeLineViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{
 
    @IBOutlet weak var tableView: UITableView!
    var UserInfo:[AccountInformation] = []
    var appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var tweet: [String] = []
    //let twitter_instance = TwitterAPI()
 
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        self.GetOuth()
    }
    
    //セルの高さを指定
    func tableView(_ table: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return self.UserInfo.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "TwitterTableViewCell") as! TwitterTableViewCell
        if appDelegate.flag == 1{
            let targetURL = URL(string: self.UserInfo[indexPath.row].image_url)
            print(self.UserInfo[indexPath.row].image_url)
            cell.TwIcon.af_setImage(withURL: targetURL!)
            cell.TwName.text = self.UserInfo[indexPath.row].name
            cell.TwScname.text = "@" + self.UserInfo[indexPath.row].scname
            cell.TwText.text = self.UserInfo[indexPath.row].text
        }else{
            cell.TwIcon.image = UIImage(named: "NoImage")
            cell.TwName.text = "no data"
            cell.TwScname.text = "no data"
            cell.TwText.text = "no data"
        }
                return cell
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        // UITableViewCellの高さを自動で取得する値
//        tableView.estimatedRowHeight = 100 //セルの高さ
//        return UITableViewAutomaticDimension //自動設定
//    }
    
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
            self.GetTimeline(session: session)
        }
    }
    
    //APIを叩き、設定されたアカウントからタイムラインを取得
    func GetTimeline(session: TWTRSession){
        var clientError: NSError?
        let client = TWTRAPIClient.withCurrentUser()
        let URLEndpoint = "https://api.twitter.com/1.1/statuses/user_timeline.json"
        let params = ["user_id":session.userID,"count": "2"]
        
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
                }
                self.appDelegate.flag = 1
                self.tableView.reloadData()
                
            } catch let jsonError as NSError {
                print("json error: \(jsonError.localizedDescription)")
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
