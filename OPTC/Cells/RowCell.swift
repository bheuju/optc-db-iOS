//
//  RowCell.swift
//  OPTC
//
//  Created by Prashant on 2/19/18.
//  Copyright © 2018 Prashant. All rights reserved.
//

import UIKit

class RowCell: UITableViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
    var character: OPTCCharacter!
    static var nib: UINib {
        return UINib(nibName: "RowCell", bundle: nil)
    }
    static var reuseIdentifier: String = "RowCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.register(ColumnCell.nib, forCellWithReuseIdentifier: ColumnCell.reuseIdentifier)
        collectionView.isScrollEnabled = false
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    func configureTableCell(withCharacter data: OPTCCharacter) {
        self.character = data
        self.collectionView.reloadData()
    }
}

extension RowCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ColumnCell.reuseIdentifier, for: indexPath) as? ColumnCell {
            cell.configureCell(withIndexPath: indexPath, data: character)
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        switch indexPath.row {
        case 0:
             return CGSize(width: CellTypes.idCell.width, height: 50)
        case 1:
            return CGSize(width: CellTypes.titleCell.width, height: 50)
        case 2:
            return CGSize(width: CellTypes.starCell.width, height: 50)
        default:
            return CGSize(width: CellTypes.otherCell.width, height: 50)
        }
        
    }
    
    
    
}
