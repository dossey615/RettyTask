//
//  TimeLineViewController.swift
//  RettyTask
//
//  Created by 土居将史 on 2018/05/10.
//  Copyright © 2018年 土居将史. All rights reserved.
//

import UIKit
import TwitterKit
import AlamofireImage

class TimeLineViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{
 
    @IBOutlet weak var tableView: UITableView!
    var appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var tweet: [String] = []
    let twitter_instance = TwitterAPI()
 
    override func viewDidLoad() {
        super.viewDidLoad()
//        tableView.delegate = self
//        tableView.dataSource = self
        twitter_instance.GetOuth(table: tableView)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        
        if appDelegate.flag == 1{
        let cell = tableView.dequeueReusableCell(withIdentifier: "tweetCell", for:indexPath) as! TwitterTableViewCell
        
            let targetURL = URL(string: self.twitter_instance.UserInfo[indexPath.row].image_url)
            cell.TwIcon.af_setImage(withURL: targetURL!)
            cell.TwName.text = self.twitter_instance.UserInfo[indexPath.row].name
            cell.TwId.text = self.twitter_instance.UserInfo[indexPath.row].scname
            cell.TwText.text = self.twitter_instance.UserInfo[indexPath.row].text
        
        return cell
        }else{
            return UITableViewCell()
        }
    }
    
//    // cellがタップされたのを検知したときに実行する処理
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print("セルがタップされたよ！")
//    }
//    
//    // セルの見積もりの高さを指定する処理
//    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 200
//    }
//    
//    // セルの高さ指定をする処理
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        // UITableViewCellの高さを自動で取得する値
//        return UITableViewAutomaticDimension
//        
//    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
