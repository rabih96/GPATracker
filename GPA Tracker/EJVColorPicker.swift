//
//  ColorSelectionView.swift
//  DrawingApp
//
//  Created by Ethan Vaughan on 2/8/17.
//  Copyright © 2017 Ethan James Vaughan. All rights reserved.
//

import UIKit

fileprivate class FlowyLayout : UICollectionViewFlowLayout {
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        let collectionViewBounds = self.collectionView?.bounds ?? CGRect.zero
        let itemWidth = self.itemSize.width > 0 ? self.itemSize.width : 1
        
        let attributes = super.layoutAttributesForElements(in: rect)?.map { (attributes) -> UICollectionViewLayoutAttributes in
            let modified = attributes.copy() as! UICollectionViewLayoutAttributes
            let intersection = attributes.frame.intersection(collectionViewBounds)
            
            let proportion = intersection.isNull ? 0 : intersection.width / itemWidth
            modified.alpha = proportion
            modified.transform = CGAffineTransform(scaleX: proportion, y: proportion)
            return modified
        }
        
        return attributes
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
}

fileprivate class ColorCell: UICollectionViewCell {
    static let identifier = "ColorCell"
    static let size = CGSize(width: 30, height: 30)
    
    class SelectionIndicatorView: UIView {
        init () {
            super.init(frame: CGRect.zero)
            self.commonInit()
        }
        
        required public init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
            self.commonInit()
        }
        
        override var intrinsicContentSize: CGSize {
            let cellSize = ColorCell.size
            return CGSize(width: cellSize.width / 3, height: cellSize.width / 3)
        }
        
        func commonInit() {
            self.backgroundColor = UIColor.white
            self.layer.cornerRadius = self.intrinsicContentSize.width / 2
        }
    }
    
    var color: UIColor? {
        didSet {
            self.backgroundColor = color
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        self.layer.cornerRadius = type(of: self).size.width / 2;
    }
    
    override var isSelected: Bool {
        didSet {
            let indicatorTag = 12345
            
            if isSelected {
                if self.contentView.viewWithTag(indicatorTag) == nil {
                    let indicatorView = SelectionIndicatorView()
                    indicatorView.translatesAutoresizingMaskIntoConstraints = false
                    indicatorView.tag = indicatorTag
                    indicatorView.transform = CGAffineTransform(scaleX: 0, y: 0)
                    self.contentView.addSubview(indicatorView)
                    indicatorView.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor).isActive = true
                    indicatorView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true
                    
                    UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, animations: {
                        indicatorView.transform = CGAffineTransform.identity
                    })
                }
            } else {
                if let indicatorView = self.contentView.viewWithTag(indicatorTag) {
                    indicatorView.removeFromSuperview()
                }
            }
        }
    }
}

public protocol EJVColorPickerDelegate: class {
    func colorPicker(_ view: EJVColorPicker, didSelect color: UIColor)
}

public class EJVColorPicker: UIView, UICollectionViewDataSource, UICollectionViewDelegate {
    
    public var colors: [UIColor] = [] {
        didSet {
            self.collectionView.reloadData()
            if colors.count > 0 {
                self.collectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: false, scrollPosition: [])
            }
        }
    }
    public var selectedColor: UIColor? {
        return self.collectionView.indexPathsForSelectedItems?.first.map { return self.colors[$0.item] }
    }
    public weak var delegate: EJVColorPickerDelegate?
    
    private let collectionView: UICollectionView
    
    private enum InitMethod {
        case frame
        case coder(NSCoder)
    }
    
    private init(method: InitMethod) {
        let layout = FlowyLayout()
        layout.itemSize = ColorCell.size
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        layout.scrollDirection = .horizontal
        self.collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        
        switch method {
            case .frame: super.init(frame: CGRect.zero)
            case let .coder(decoder): super.init(coder: decoder)!
        }
        
        self.collectionView.register(ColorCell.self, forCellWithReuseIdentifier: ColorCell.identifier)
        self.collectionView.backgroundColor = UIColor.clear
        self.collectionView.showsHorizontalScrollIndicator = false
        
        self.addSubview(self.collectionView)
        self.collectionView.translatesAutoresizingMaskIntoConstraints = false
        self.collectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        self.collectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        self.collectionView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        self.collectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
    }
    
    convenience init(colors: [UIColor]) {
        self.init(method: .frame)
        self.colors = colors
    }
    
    required convenience public init?(coder aDecoder: NSCoder) {
        self.init(method: .coder(aDecoder))
    }
    
    // MARK: - View methods
    
    override public var intrinsicContentSize: CGSize {
        return CGSize(width: UIViewNoIntrinsicMetric, height: ColorCell.size.height)
    }
    
    // MARK: - Collection view data source
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.colors.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ColorCell.identifier, for: indexPath) as! ColorCell
        
        cell.color = self.colors[indexPath.row]
        
        return cell
    }
    
    // MARK: - Collection view delegate
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.colorPicker(self, didSelect: self.colors[indexPath.item])
    }
}
