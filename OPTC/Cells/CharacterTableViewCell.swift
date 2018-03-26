//
//  RowCell.swift
//  OPTC
//
//  Created by Prashant on 2/19/18.
//  Copyright © 2018 Prashant. All rights reserved.
//

import UIKit

class CharacterTableViewCell: UITableViewCell {
    
    @IBOutlet weak var cImage: UIImageView!
    @IBOutlet weak var cName: UILabel!
    @IBOutlet weak var cType: UILabel!
    @IBOutlet weak var cRarity: UILabel!
    @IBOutlet weak var cHp: UILabel!
    @IBOutlet weak var cAtk: UILabel!
    @IBOutlet weak var cRcv: UILabel!
        
    static var nib: UINib {
        return UINib(nibName: "CharacterTableViewCell", bundle: nil)
    }
    static var reuseIdentifier: String = "CharacterTableViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        
    }
    
    func configureTableCell(with cViewModel: CharacterViewModel) {
        cImage.loadImage(cViewModel.imageUrl)
        cName.text = cViewModel.name
        cType.text = cViewModel.type
        cRarity.text = cViewModel.rarity
    }
}
