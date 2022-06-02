//
//  TransitionDetailCoordinator.swift
//  animated detail view
//
//  Created by likeadeveloper on 2/6/22.
//

import UIKit

final class TransitionDetailCoordinator: NSObject {
    enum Direction: Int {
        case up
        case down
        case undefined
    }
    enum Lifecycle {
        case start
        case begining
        case end
    }
    enum State: Equatable {
        case open
        case closed

        static prefix func !(_ state: State) -> State {
            return state == .open ? .closed : .open
        }
    }

    private weak var infoViewController: InfoViewControllerProtocol!
    private weak var overlayView: UIView?
    private lazy var panGestureRecognizer = createPanGestureRecognizer()
    private lazy var tapGestureRecognizer = createTapGestureRecognizer()
    private var runningAnimators = [UIViewPropertyAnimator]()

    private var state: State = .closed
    private var animationLifecycle: Lifecycle = .end

    private lazy var totalAnimationDistance: CGFloat = {
        guard let infoViewController = infoViewController else { return .zero }

        return infoViewController.view.bounds.height
        - infoViewController.view.safeAreaInsets.bottom
        - infoViewController.initialHeight
    }()
    private var maxAnimationVerticalPosition: CGFloat {
        infoViewController.parent?.view.safeAreaInsets.top ?? .zero
    }

    var isClosed: (() -> Void)?
    var isOpened: (() -> Void)?

    init(infoViewController: InfoViewControllerProtocol, overlay: UIView? = nil) {
        self.infoViewController = infoViewController
        overlayView = overlay
        super.init()

        infoViewController.view.addGestureRecognizer(panGestureRecognizer)
        infoViewController.view.addGestureRecognizer(tapGestureRecognizer)
        overlay?.addGestureRecognizer(tapGestureRecognizer)

        updateUI(with: state)
    }
}

// MARK: - Tap and Pan gestures handling
private extension TransitionDetailCoordinator {
    @objc
    func didPanInfoView(sender: UIPanGestureRecognizer) {
        guard let view = sender.view else { return }

        switch sender.state {
        case .began:
            animationLifecycle = .start
            startInteractiveTransition(for: !state)
        case .changed:
            animationLifecycle = .begining
            let translation = sender.translation(in: view)
            updateInteractiveTransition(distanceTraveled: translation.y)
        default:
            animationLifecycle = .end
            let velocity = sender.velocity(in: view)
            continueInteractiveTransition(velocity: velocity)
        }
    }
    @objc
    func didTapInfoView(recognizer: UITapGestureRecognizer) {
        animateTransition(for: !state)
    }

    /// Starts transition and pauses on pan .begin
    /// - Parameter state: Animator State
    func startInteractiveTransition(for state: State) {
        animateTransition(for: state)
        runningAnimators.pauseAnimations()
        updateOverlayVisibility()
    }
    /// Scrubs transition on pan .changed
    /// - Parameter distanceTraveled: Gesture transition value
    func updateInteractiveTransition(distanceTraveled: CGFloat) {
        var fraction = distanceTraveled / totalAnimationDistance
        if state == .open { fraction *= -1 }
        runningAnimators.fractionComplete = fraction
    }
    /// Continues or reverse transition on pan .ended
    /// - Parameter velocity: Gesture transition velocity
    func continueInteractiveTransition(velocity: CGPoint) {
        let direction = directionFromVelocity(velocity)
        let directionState: State = direction == .up
        ? .open
        : .closed

        abruptCancelTransition()
        startInteractiveTransition(for: directionState)

        runningAnimators.continueAnimations()
    }
    /// Cancel all animators and clean animators array
    func abruptCancelTransition() {
        runningAnimators.cancelAnimations()
        runningAnimators.removeAll()
    }
    /// Perform all animations with animators
    /// - Parameter newState: Animator State
    func animateTransition(for newState: State) {
        state = newState
        runningAnimators = createTransitionAnimators(with: TransitionDetailCoordinator.animationDuration)
        runningAnimators.startAnimations()
    }
    /// Transform transition velocity into direction
    /// - Parameter velocity: Gesture transition velocity
    /// - Returns: Gesture direction
    func directionFromVelocity(_ velocity: CGPoint) -> Direction {
        guard velocity != .zero else { return .undefined }

        let isVertical = abs(velocity.y) > abs(velocity.x)
        var derivedDirection: Direction = .undefined

        if isVertical {
            derivedDirection = velocity.y < .zero
            ? .up
            : .down
        }

        return derivedDirection
    }
    /// Execute open/close closure when all animators finish
    func launchActionsOnFinish() {
        switch state {
        case .open:
            isOpened?()
        case .closed:
            isClosed?()
        }
    }
}

// MARK: - UIGestureRecognizerDelegate
extension TransitionDetailCoordinator: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return runningAnimators.isEmpty
    }

    private func createPanGestureRecognizer() -> UIPanGestureRecognizer {
        let recognizer = UIPanGestureRecognizer()
        recognizer.addTarget(self, action: #selector(didPanInfoView(sender:)))
        recognizer.delegate = self
        return recognizer
    }
    private func createTapGestureRecognizer() -> UITapGestureRecognizer {
        let recognizer = UITapGestureRecognizer()
        recognizer.addTarget(self, action: #selector(didTapInfoView(recognizer:)))
        recognizer.delegate = self
        return recognizer
    }
}

// MARK: - Animators
private extension TransitionDetailCoordinator {

    static let animationDuration = TimeInterval(0.3)

    func createTransitionAnimators(with duration: TimeInterval) -> [UIViewPropertyAnimator] {
        switch state {
        case .open:
            return [
                openInfoViewAnimator(with: duration),
                fadeInOverlayAnimator(with: duration),
                fadeInInfoViewAnimator(with: duration)
            ]
        case .closed:
            return [
                closeInfoViewAnimator(with: duration),
                fadeOutInfoViewAnimator(with: duration),
                fadeOutOverlayAnimator(with: duration)
            ]
        }
    }
    func openInfoViewAnimator(with duration: TimeInterval) -> UIViewPropertyAnimator {
        let animator = UIViewPropertyAnimator(duration: duration, dampingRatio: 1.0)
        addAnimation(to: animator, animations: {
            self.updateInfoViewContainer(with: self.state)
        })
        return animator
    }
    func fadeInInfoViewAnimator(with duration: TimeInterval) -> UIViewPropertyAnimator {
        let animator = UIViewPropertyAnimator(duration: duration, curve: .easeIn)
        addKeyframeAnimation(to: animator, withRelativeStartTime: 0.0, relativeDuration: 0.5) {
            self.updateInfoView(with: self.state)
        }
        animator.scrubsLinearly = false
        return animator
    }
    func fadeInOverlayAnimator(with duration: TimeInterval) -> UIViewPropertyAnimator {
        let animator = UIViewPropertyAnimator(duration: duration, curve: .easeIn)
        addKeyframeAnimation(to: animator, withRelativeStartTime: 0.0, relativeDuration: 0.5) {
            self.updateOverlay(with: self.state)
        }
        animator.scrubsLinearly = false
        return animator
    }
    func closeInfoViewAnimator(with duration: TimeInterval) ->  UIViewPropertyAnimator {
        let animator = UIViewPropertyAnimator(duration: duration, dampingRatio: 0.9)
        addAnimation(to: animator, animations: {
            self.updateInfoViewContainer(with: self.state)
        })
        return animator
    }
    func fadeOutInfoViewAnimator(with duration: TimeInterval) -> UIViewPropertyAnimator {
        let animator = UIViewPropertyAnimator(duration: duration, curve: .easeOut)
        addKeyframeAnimation(to: animator, withRelativeStartTime: 0.5, relativeDuration: 0.5) {
            self.updateInfoView(with: self.state)
        }
        animator.scrubsLinearly = false
        return animator
    }
    func fadeOutOverlayAnimator(with duration: TimeInterval) -> UIViewPropertyAnimator {
        let animator = UIViewPropertyAnimator(duration: duration, curve: .easeOut)
        addKeyframeAnimation(to: animator, withRelativeStartTime: 0.5, relativeDuration: 0.5) {
            self.updateOverlay(with: self.state)
        }
        animator.scrubsLinearly = false
        return animator
    }
    func addAnimation(to animator: UIViewPropertyAnimator, animations: @escaping () -> Void) {
        animator.addAnimations { animations() }
        animator.addCompletion({ [weak self] _ in
            animations()
            self?.runningAnimators.remove(animator)

            self?.updateOverlayVisibility()
            self?.launchActionsOnFinish()
        })
    }
    func addKeyframeAnimation(to animator: UIViewPropertyAnimator,
                              withRelativeStartTime frameStartTime: Double = 0.0,
                              relativeDuration frameDuration: Double = 1.0,
                              animations: @escaping () -> Void) {
        animator.addAnimations {
            UIView.animateKeyframes(withDuration: 0, delay: 0, options:[], animations: {
                UIView.addKeyframe(withRelativeStartTime: frameStartTime, relativeDuration: frameDuration) {
                    animations()
                }
            })
        }
        animator.addCompletion({ [weak self] _ in
            animations()
            self?.runningAnimators.remove(animator)
        })
    }
}

// MARK: - UI state rendering
private extension TransitionDetailCoordinator {
    func updateUI(with state: State) {
        updateInfoView(with: state)
        updateOverlay(with: state)
        updateInfoViewContainer(with: state)
    }
    func updateOverlay(with state: State) {
        overlayView?.alpha = state == .open
        ? 1
        : .zero
    }
    func updateInfoView(with state: State) {
        guard let infoViewController = infoViewController else { return }

        infoViewController.view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]

        let cornerRadius: CGFloat = infoViewController.view.safeAreaInsets.bottom > infoViewController.initialHeight
        ? 20
        : .zero

        infoViewController.view.layer.cornerRadius = state == .open
        ? cornerRadius
        : .zero
    }
    func updateInfoViewContainer(with state: State) {
        infoViewController?.view.transform = state == .open
        ? CGAffineTransform(translationX: .zero, y: infoViewController.topOffset)
        : CGAffineTransform(translationX: .zero, y: totalAnimationDistance)
    }
    func updateOverlayVisibility() {
        let mustBeHidden = state == .closed
        switch animationLifecycle {
        case .start:
            guard state == .open else { return }
            overlayView?.isHidden = mustBeHidden
        case .end:
            guard state == .closed else { return }
            overlayView?.isHidden = mustBeHidden
        default:
            break
        }
    }
}
