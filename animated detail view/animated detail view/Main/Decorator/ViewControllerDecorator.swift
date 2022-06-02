//
//  ViewControllerDecorator.swift
//  animated detail view
//
//  Created by likeadeveloper on 2/6/22.
//

import UIKit

struct ViewControllerDecorator: VCDecoratorProtocol {
    private var itemsPerGroup: Int = 2

    var collectionViewLayout: UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                              heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 1, leading: 1, bottom: 1, trailing: 1)


        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                               heightDimension: .fractionalWidth(1/3))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                     subitem: item,
                                                     count: itemsPerGroup)
        group.contentInsets = NSDirectionalEdgeInsets(top: 1, leading: 1, bottom: 1, trailing: 1)

        let section = NSCollectionLayoutSection(group: group)

        let layout = UICollectionViewCompositionalLayout(section: section)

        return layout
    }
}

