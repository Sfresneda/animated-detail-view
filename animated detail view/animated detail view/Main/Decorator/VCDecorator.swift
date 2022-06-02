//
//  VCDecorator.swift
//  animated detail view
//
//  Created by likeadeveloper on 2/6/22.
//

import UIKit

protocol VCDecoratorProtocol {
    var collectionViewLayout: UICollectionViewLayout { get }
}

struct Decorator {
    private var decorator: VCDecoratorProtocol

    init(decorator: VCDecoratorProtocol) {
        self.decorator = decorator
    }
}

extension Decorator: VCDecoratorProtocol {
    var collectionViewLayout: UICollectionViewLayout {
        decorator.collectionViewLayout
    }
}
