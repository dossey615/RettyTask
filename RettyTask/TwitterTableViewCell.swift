//
//  TwitterTableViewCell.swift
//  RettyTask
//
//  Created by 土居将史 on 2018/05/18.
//  Copyright © 2018年 土居将史. All rights reserved.
//

import UIKit

class TwitterTableViewCell: UITableViewCell {
    
    @IBOutlet weak var TwIcon: UIImageView!
    @IBOutlet weak var TwName: UILabel!
    @IBOutlet weak var TwScname: UILabel!
    @IBOutlet weak var TwText: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
