//
//  RecordsTVCell.swift
//  Thrift
//
//  Created by Jervin Cruz on 3/15/18.
//  Copyright © 2018 Jervin Cruz. All rights reserved.
//

import UIKit

class RecordsTVCell: UITableViewCell {

    @IBOutlet weak var recordImage: UIImageView!
    @IBOutlet weak var recordName: UILabel!
    @IBOutlet weak var recordPrice: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
