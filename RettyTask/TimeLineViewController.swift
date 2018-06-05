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
    @IBOutlet weak var mytweet: UIButton!

    
    var UserInfo:[AccountInformation] = [] //全tweet情報を含んだ配列
    var appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate //Appdelegateによる認証フラグ管理
    

    
    
    @IBAction func log_check(_ sender: Any) {
        GetOuth()
    }
    //tweetbuttonが押された時のメソッド
    @IBAction func sendtweet(_ sender: Any) {
        TWTRComposer().show(from: self) { _ in }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //自作セルをテーブルビューに登録する。
        let tweetXib = UINib(nibName:"TweetTableViewCell", bundle:nil)
        tableView.register(tweetXib, forCellReuseIdentifier:"TweetCell")
        mytweet.isEnabled = (appDelegate.flag == 1)//認証前にボタンを押せないように設定
        tableView.delegate = self
        tableView.dataSource = self
        self.GetOuth()
    }
    
    //セルの高さを指定
//    func tableView(_ table: UITableView,
//                   heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 130.0
//    }
    
    //セルの数を指定
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return self.UserInfo.count
    }

    //セルの内容設定
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell", for:indexPath) as! TweetTableViewCell
    //認証成功後のセル作成
        if appDelegate.flag == 1{
        /*---- AlamofireImageによりURLから画像を取得 ----*/
            let targetURL = URL(string: self.UserInfo[indexPath.row].image_url)
            cell.UserImage.af_setImage(withURL: targetURL!)
        /*-------------------------------------------*/
            //ツイッターの情報をそれぞれ代入
            cell.UserName.text = self.UserInfo[indexPath.row].name
            cell.UserScreenName.text = "@" + self.UserInfo[indexPath.row].scname
            cell.UserTweet.text = self.UserInfo[indexPath.row].text
            cell.RetweetCount.text = String(self.UserInfo[indexPath.row].retweet_count)
            cell.FavoriteCount.text = String(self.UserInfo[indexPath.row].favorite_count)
            cell.UserTweet.sizeToFit()
        }else{
            //起動時、ダミーデータを挿入し、セルの型を作っておく
            cell.UserImage.image = UIImage(named: "NoImage")
            cell.UserName.text = "no data"
            cell.UserScreenName.text = "no data"
            cell.UserTweet.text = "no data"
            cell.RetweetCount.text = "0"
            cell.FavoriteCount.text = "0"
        }
        cell.layoutIfNeeded()
                return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // UITableViewCellの高さを自動で取得する値
        tableView.estimatedRowHeight = 170 //セルの高さ
        return UITableViewAutomaticDimension //自動設定
    }

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
        let params = ["user_id":session.userID,"count": "100"]
        
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
                    //条件が一致した際、インスタンスに代入し、最終的にユーザー単位でUseInfo配列で管理
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
                    if json[i]["favorite_count"].int != nil{
                        getInfo.favorite_count = json[i]["favorite_count"].int!
                    }
                    if json[i]["retweet_count"].int != nil{
                        getInfo.retweet_count = json[i]["retweet_count"].int!
                    }
                    self.UserInfo.append(getInfo)
                }
                self.appDelegate.flag = 1
                self.tableView.reloadData() //テーブルデータの再読み込み
                self.mytweet.isEnabled = (self.appDelegate.flag == 1) //tweetbuttonを押せるようにする
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
