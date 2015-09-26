//
//  AccountCell.swift
//  TwitterSample
//
//  Created by OsadaTakuya on 2015/09/26.
//  Copyright © 2015年 Sample. All rights reserved.
//

import UIKit

class AccountCell: UITableViewCell {

    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var id: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    /**
     * セルの内容を更新する
     */
    func update(iconImage: UIImage?, name: String?, id: String?) {
        icon.image = iconImage
        self.name.text = name
        self.id.text = id
    }

}
