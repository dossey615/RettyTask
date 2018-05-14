//
//  AccountInformation.swift
//  RettyTask
//
//  Created by 土居将史 on 2018/05/13.
//  Copyright © 2018年 土居将史. All rights reserved.
//

import Foundation

class tweets{
    
    var image_url: [String] = []
    var name: [String] = []
    var scname: [String] = []
    var text: [String] = []
    
    func getCount() -> Int{
        return name.count
    }
    
}
