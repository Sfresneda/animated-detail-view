//
//  Array.swift
//  animated detail view
//
//  Created by likeadeveloper on 2/6/22.
//

import UIKit

extension Array where Element: UIViewPropertyAnimator {
    var isReversed: Bool {
        set {
            forEach { $0.isReversed = newValue }
        }
        get {
            assertionFailure("The getter is not supported!")
            return false
        }
    }
    var fractionComplete: CGFloat {
        set {
            forEach { $0.fractionComplete = newValue }
        }
        get {
            assertionFailure("The getter is not supported!")
            return 0
        }
    }

    func startAnimations() {
        forEach { $0.startAnimation() }
    }
    func pauseAnimations() {
        forEach { $0.pauseAnimation() }
    }
    func continueAnimations(withTimingParameters parameters: UITimingCurveProvider? = nil, durationFactor: CGFloat = 0) {
        forEach { $0.continueAnimation(withTimingParameters: parameters, durationFactor: durationFactor) }
    }
    func cancelAnimations() {
        forEach { $0.stopAnimation(true) }
    }
    func reverse() {
        forEach { $0.isReversed = !$0.isReversed }
    }
    mutating func remove(_ element: Element) {
        self = self.filter { $0 != element }
    }
}
