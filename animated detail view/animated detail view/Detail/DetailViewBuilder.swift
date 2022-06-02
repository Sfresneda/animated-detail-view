//
//  DetailViewBuilder.swift
//  animated detail view
//
//  Created by likeadeveloper on 2/6/22.
//

import Foundation

final class DetailViewBuilder {
    static func build(concreteDecorator: DetailDecoratorProtocol) -> DetailViewController {
        let view = DetailViewController()
        view.decorator = concreteDecorator
        return view
    }
}
