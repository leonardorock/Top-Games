//
//  GamesCollectionViewFlowLayout.swift
//  Top Games
//
//  Created by Leonardo Oliveira on 2/11/18.
//  Copyright © 2018 Leonardo Oliveira. All rights reserved.
//

import UIKit

class GamesCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    override init() {
        super.init()
        itemSize = GameCollectionViewCell.size
        scrollDirection = .vertical
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func prepare() {
        super.prepare()
        setupCollectionViewCellSpacing()
    }
    
    private func setupCollectionViewCellSpacing() {
        let width = collectionView!.contentSize.width - collectionView!.safeAreaInsets.right - collectionView!.safeAreaInsets.left
        let spacing = spaceBetweenCells(minimumSpace: 16.0, cellWidth: itemSize.width, collectionViewWidth: width)
        minimumLineSpacing = spacing
        minimumInteritemSpacing = spacing
        sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
    }
    
    private func spaceBetweenCells(forCellsCount cellCount: Int? = nil, minimumSpace: CGFloat = 0.0, cellWidth: CGFloat, collectionViewWidth: CGFloat) -> CGFloat {
        let numberOfCells: CGFloat
        if let cellCount = cellCount { numberOfCells = CGFloat(cellCount) }
        else { numberOfCells = (collectionViewWidth / cellWidth).rounded(.down) }
        let space = ((collectionViewWidth - numberOfCells * cellWidth) / (numberOfCells + 1)).rounded(FloatingPointRoundingRule.down)
        if minimumSpace > space {
            return spaceBetweenCells(forCellsCount: Int(numberOfCells - 1), minimumSpace: minimumSpace, cellWidth: cellWidth, collectionViewWidth: collectionViewWidth)
        } else {
            return space
        }
    }
    
}
