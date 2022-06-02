//
//  DetailDecorator.swift
//  animated detail view
//
//  Created by likeadeveloper on 2/6/22.
//

import UIKit

protocol DetailDecoratorProtocol {
    var initialHeightForTopContainer: CGFloat { get set }
    var topOffsetForTopContainer: CGFloat { get }
    var isTopContainerDraggable: Bool { get }
    var minDraggablePosition: CGFloat { get }
    var infoViewController: InfoViewControllerProtocol { get }
    var shouldShowOverlay: Bool { get }

    func setupNavigationBar(_ bar: UINavigationBar)
}

extension DetailDecoratorProtocol {
    var minDraggablePosition: CGFloat {
        initialHeightForTopContainer
        - initialHeightForTopContainer
        * 0.1
    }
    var topOffsetForTopContainer: CGFloat {
        100
    }
}

struct DetailDecorator {
    private var decorator: DetailDecoratorProtocol

    init(decorator: DetailDecoratorProtocol) {
        self.decorator = decorator
    }
}

extension DetailDecorator: DetailDecoratorProtocol {
    var initialHeightForTopContainer: CGFloat {
        get {
            decorator.initialHeightForTopContainer
        }
        set {
            decorator.initialHeightForTopContainer = newValue
        }
    }
    var topOffsetForTopContainer: CGFloat {
        decorator.topOffsetForTopContainer
    }
    var isTopContainerDraggable: Bool {
        decorator.isTopContainerDraggable
    }
    var minDraggablePosition: CGFloat {
        decorator.minDraggablePosition
    }
    var infoViewController: InfoViewControllerProtocol {
        decorator.infoViewController
    }
    var shouldShowOverlay: Bool {
        decorator.shouldShowOverlay
    }

    func setupNavigationBar(_ bar: UINavigationBar) {
        decorator.setupNavigationBar(bar)
    }
}
