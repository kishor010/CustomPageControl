//
//  ViewController.swift
//  CustomPageIndicator
//
//  Created by Kishor Pahalwani on 15/10/20.
//  Copyright © 2020 Kishor Pahalwani. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var stackViewPageControl: PageControl!
    @IBOutlet weak var stackViewPageControlWidth: NSLayoutConstraint!
    
    var pageIndex = 0
    var numberOfPages = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupPageControl()
        setStackViewPageControlWidth()
    }
    
    fileprivate func setupPageControl() {
        stackViewPageControl.currentPage = 0
        stackViewPageControl.numberOfPages = numberOfPages
    }
    
    fileprivate func setStackViewPageControlWidth() {
        let frameForPageControl = self.view.frame.size.width - 60
        let widthOfAllPageControls = 12.5 * Float(numberOfPages)
        if widthOfAllPageControls > Float(frameForPageControl) {
            stackViewPageControlWidth.constant = frameForPageControl
        }
        else {
            stackViewPageControlWidth.constant = CGFloat(widthOfAllPageControls)
        }
    }

    @IBAction func btnChangeTabs(_ sender: Any) {
        if pageIndex >= numberOfPages - 1 {
            pageIndex = 0
        }
        else {
            pageIndex += 1
        }
        stackViewPageControl.currentPage = pageIndex
    }
}

//MARK:- #1
class CustomPageControl: UIPageControl {

    @IBInspectable var currentPageImage: UIImage?

    @IBInspectable var otherPagesImage: UIImage?

    override var numberOfPages: Int {
        didSet {
            updateDots()
        }
    }

    override var currentPage: Int {
        didSet {
            updateDots()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        pageIndicatorTintColor = .clear
        currentPageIndicatorTintColor = .clear
        clipsToBounds = false
    }

    private func updateDots() {

        for (index, subview) in subviews.enumerated() {
            let imageView: UIImageView
            if let existingImageview = getImageView(forSubview: subview) {
                imageView = existingImageview
            } else {
                imageView = UIImageView(image: otherPagesImage)

                imageView.center = subview.center
                subview.addSubview(imageView)
                subview.clipsToBounds = false
            }
            imageView.image = currentPage == index ? currentPageImage : otherPagesImage
        }
    }

    private func getImageView(forSubview view: UIView) -> UIImageView? {
        if let imageView = view as? UIImageView {
            return imageView
        } else {
            let view = view.subviews.first { (view) -> Bool in
                return view is UIImageView
            } as? UIImageView

            return view
        }
    }
}

//MARK:- #2
class MyPageControl: UIPageControl {
    let locationArrow: UIImage = UIImage(named: "SelectedPage")!
    let pageCircle: UIImage = UIImage(named: "UnselectedPage")!

    override var numberOfPages: Int {
        didSet {
            updateDots()
        }
    }

    override var currentPage: Int {
        didSet {
            updateDots()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.pageIndicatorTintColor = UIColor.clear
        self.currentPageIndicatorTintColor = UIColor.clear
        self.clipsToBounds = false
    }

    func updateDots() {
        var i = 0
        for view in self.subviews {
            var imageView = self.imageView(forSubview: view)
            if imageView == nil {
                if i == 0 {
                    imageView = UIImageView(image: locationArrow)
                } else {
                    imageView = UIImageView(image: pageCircle)
                }
                imageView!.center = view.center
                view.addSubview(imageView!)
                view.clipsToBounds = false
            }
            if i == self.currentPage {
                imageView!.alpha = 1.0
            } else {
                imageView!.alpha = 0.5
            }
            i += 1
        }
    }

    fileprivate func imageView(forSubview view: UIView) -> UIImageView? {
        var dot: UIImageView?
        if let dotImageView = view as? UIImageView {
            dot = dotImageView
        } else {
            for foundView in view.subviews {
                if let imageView = foundView as? UIImageView {
                    dot = imageView
                    break
                }
            }
        }
        return dot
    }
}

/**
 If adding via storyboard, you should not need to set a width and height constraint for this view,
 just set a placeholder for each so autolayout doesnt complain and this view will size itself once its populated with pages at runtime
 */
//MARK:- #3
class PageControl: UIStackView {

    @IBInspectable var currentPageImage: UIImage = UIImage(named: "SelectedPage")!
    @IBInspectable var pageImage: UIImage = UIImage(named: "UnselectedPage")!
    /**
     Sets how many page indicators will show
     */
    var numberOfPages = 3 {
        didSet {
            layoutIndicators()
        }
    }
    /**
     Sets which page indicator will be highlighted with the **currentPageImage**
     */
    var currentPage = 0 {
        didSet {
            setCurrentPageIndicator()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        axis = .horizontal
        distribution = .equalSpacing
        alignment = .center

        layoutIndicators()
    }

    private func layoutIndicators() {

        for i in 0..<numberOfPages {

            let imageView: UIImageView

            if i < arrangedSubviews.count {
                imageView = arrangedSubviews[i] as! UIImageView // reuse subview if possible
            } else {
                imageView = UIImageView()
                addArrangedSubview(imageView)
            }

            if i == currentPage {
                imageView.image = currentPageImage
            } else {
                imageView.image = pageImage
            }
        }

        // remove excess subviews if any
        let subviewCount = arrangedSubviews.count
        if numberOfPages < subviewCount {
            for _ in numberOfPages..<subviewCount {
                arrangedSubviews.last?.removeFromSuperview()
            }
        }
    }

    private func setCurrentPageIndicator() {

        for i in 0..<arrangedSubviews.count {

            let imageView = arrangedSubviews[i] as! UIImageView

            if i == currentPage {
                imageView.image = currentPageImage
            } else {
                imageView.image = pageImage
            }
        }
    }
}

//MARK:- #4
class CustomDotPageControlProg: UIPageControl {

    override var currentPage: Int {
        didSet {
            updateDots()
        }
    }

    override func sendAction(_ action: Selector, to target: Any?, for event: UIEvent?) {
        super.sendAction(action, to: target, for: event)
        updateDots()
    }

    private func updateDots() {
        let currentDot = subviews[currentPage]
        let largeScaling = CGAffineTransform(scaleX: 2.3, y: 1.2)
        let smallScaling = CGAffineTransform(scaleX: 1.0, y: 1.0)

        subviews.forEach {
            // Apply the large scale of newly selected dot.
            // Restore the small scale of previously selected dot.
            $0.transform = $0 == currentDot ? largeScaling : smallScaling
        }
    }

    override func updateConstraints() {
        super.updateConstraints()
        // We rewrite all the constraints
        rewriteConstraints()
    }

    private func rewriteConstraints() {
        let systemDotSize: CGFloat = 7.0
        let systemDotDistance: CGFloat = 16.0

        let halfCount = CGFloat(subviews.count) / 2
        subviews.enumerated().forEach {
            let dot = $0.element
            dot.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.deactivate(dot.constraints)
            NSLayoutConstraint.activate([
                dot.widthAnchor.constraint(equalToConstant: systemDotSize),
                dot.heightAnchor.constraint(equalToConstant: systemDotSize),
                dot.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0),
                dot.centerXAnchor.constraint(equalTo: centerXAnchor, constant: systemDotDistance * (CGFloat($0.offset) - halfCount))
            ])
        }
    }
}
