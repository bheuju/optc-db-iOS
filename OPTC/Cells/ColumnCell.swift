//
//  RowCell.swift
//  OPTC
//
//  Created by Prashant on 2/16/18.
//  Copyright © 2018 Prashant. All rights reserved.
//

import UIKit

enum CellTypes {
    case idCell
    case titleCell
    case starCell
    case otherCell
    
    var sizeRatio: CGFloat {
        switch self {
        case .idCell:
            return 1.0
        case .titleCell:
            return 6.0
        case .starCell:
            return 3.0
        case .otherCell:
            return 2.0
        }
    }
    
    func getScreenWidth() -> CGFloat {
        return UIScreen.main.bounds.size.width
    }
    
    var width: CGFloat {
        let divisor = CellTypes.idCell.sizeRatio * 1.0 + CellTypes.titleCell.sizeRatio * 1.0 + CellTypes.starCell.sizeRatio * 1.0 + CellTypes.otherCell.sizeRatio * 4.0
        let screenWidth = getScreenWidth()
        print((screenWidth / divisor) * sizeRatio)
        return (screenWidth / divisor) * sizeRatio
    }
}

class ColumnCell: UICollectionViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var leftImageView: UIImageView!
    @IBOutlet weak var labelLeadingConstraint: NSLayoutConstraint!
    
     //UIDevice.current.orientation.isLandscape ? UIScreen.main.bounds.size.height :

    static var nib: UINib {
        return UINib(nibName: "ColumnCell", bundle: nil)
    }
    static var reuseIdentifier: String = "ColumnCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureCell(withIndexPath indexPath: IndexPath, data: OPTCCharacter) {
        switch indexPath.row {
        case 0:
            loadCell(withImage: false, text: String(data.id))
        case 1:
            loadCell(withImage: true, text: data.name, id: data.id)
        case 2:
            loadCell(withImage: false, text: data.type)
        case 3:
            loadCell(withImage: false, text: String(data.stars))
        case 4:
            loadCell(withImage: false, text: String(describing: data.hp.value!))
        case 5:
            loadCell(withImage: false, text: String(describing: data.atk.value!) )
        case 6:
            loadCell(withImage: false, text: String(describing: data.rcv.value!))
        default:
            loadCell(withImage: false, text: "Error")
        }
    }
    
    func loadImage(withId id: Int) {
        let id = String(format: "%04d", arguments: [id])
        leftImageView.loadImage(URL(string: "http://onepiece-treasurecruise.com/wp-content/uploads/f\(id).png")!)
    }
    
    func loadCell(withImage displayImage: Bool, text: String, id: Int? = nil) {
        if !displayImage {
            leftImageView.image = nil
            labelLeadingConstraint.constant = 10
            titleLabel.text = text
        } else {
            loadImage(withId: id!)
            labelLeadingConstraint.constant = 94
            titleLabel.text = text
        }
    }
}
