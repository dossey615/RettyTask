//
//  TweetTableViewCell.swift
//  RettyTask
//
//  Created by 土居将史 on 2018/05/22.
//  Copyright © 2018年 土居将史. All rights reserved.
//

import UIKit

class TweetTableViewCell: UITableViewCell {
    @IBOutlet weak var UserImage: UIImageView!
    @IBOutlet weak var UserName: UILabel!
    @IBOutlet weak var UserScreenName: UILabel!
    @IBOutlet weak var UserTweet: UILabel!
    @IBOutlet weak var FavoriteButton: UIButton!
    @IBOutlet weak var FavoriteCount: UILabel!
    @IBOutlet weak var RetweetButton: UIButton!
    @IBOutlet weak var RetweetCount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
