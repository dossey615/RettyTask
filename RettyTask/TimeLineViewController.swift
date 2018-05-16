//
//  TimeLineViewController.swift
//  RettyTask
//
//  Created by 土居将史 on 2018/05/10.
//  Copyright © 2018年 土居将史. All rights reserved.
//

import UIKit
import TwitterKit

class ViewController: UIViewController/*, UITableViewDataSource, UITableViewDelegate*/{
 
    @IBOutlet weak var tableView: UITableView!
    
    var tweet: [String] = []
    let twitter_instance = TwitterAPI()
 
    override func viewDidLoad() {
        super.viewDidLoad()
        twitter_instance.GetOuth()
//        tableView.delegate = self
//        tableView.dataSource = self
    }
    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
//        return 100
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cellName", for:indexPath) as UITableViewCell
//        return cell
//    }
//    
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
