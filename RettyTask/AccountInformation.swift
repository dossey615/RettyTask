//
//  AccountInformation.swift
//  RettyTask
//
//  Created by 土居将史 on 2018/05/13.
//  Copyright © 2018年 土居将史. All rights reserved.
//

import Foundation

//user情報を管理するクラス
class AccountInformation{
    
    //userのプロフ画像
    var image_url: String = ""
    //userの名前
    var name: String = ""
    //userのid
    var scname: String = ""
    //userのツイート文
    var text: String = ""
    //いいねの数
    var favorite_count: Int = 0
    //リツイート数
    var retweet_count: Int = 0

    
}
