//
//  FilterCell.swift
//  Photo Collage Maker
//
//  Created by Grapes Infosoft on 14/09/19.
//  Copyright © 2019 Grapes Infosoft. All rights reserved.
//

import UIKit

class FilterCell: UICollectionViewCell {

    @IBOutlet weak var imgCommon: UIImageView!
    @IBOutlet weak var btnFilters: UIButton!
    @IBOutlet weak var lblTitles: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}

enum Text: String {
    case teste1 = "teste1"
    case teste2 = "teste2"
}

extension String {
    init(text: Text) {
        self = text.rawValue
    }
}
