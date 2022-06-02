//
//  ViewControllerBuilder.swift
//  animated detail view
//
//  Created by likeadeveloper on 2/6/22.
//

import Foundation

final class ViewControllerBuilder {
    static func build(concreteDecorator: VCDecoratorProtocol) -> ViewController {
        let view = ViewController()
        view.decorator = concreteDecorator
        return view
    }
}
