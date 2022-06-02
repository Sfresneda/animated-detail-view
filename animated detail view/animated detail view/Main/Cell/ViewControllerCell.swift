//
//  ViewControllerCell.swift
//  animated detail view
//
//  Created by likeadeveloper on 2/6/22.
//

import UIKit

final class ViewControllerCell: UICollectionViewCell {
    static var reuseIdentifier: String = {
        String(describing: ViewControllerCell.self)
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
}

private extension ViewControllerCell {
    func setupView() {
        contentView.backgroundColor = .systemGray2
    }
}
