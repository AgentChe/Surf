//
//  TagCellLayout.swift
//  TagCellLayout
//
//  Created by Ritesh-Gupta on 20/11/15.
//  Copyright © 2015 Ritesh. All rights reserved.
//

import UIKit

final class ChatsCollectionViewLayout: UICollectionViewLayout {
    var lineSpacing: CGFloat = 16.scale
    var cellWidth: CGFloat = 136.scale
    var cellLargeHeight = 278.scale
    var cellSmallHeight = 208.scale
    
	private var layoutAttributes: [UICollectionViewLayoutAttributes] = []
    
    private var lastYForFirstColumn: CGFloat = 0
    private var lastYForSecondColumn: CGFloat = 0
	
	override public func prepare() {
        super.prepare()
        
        layoutAttributes = [UICollectionViewLayoutAttributes]()
        
        lastYForFirstColumn = 0
        lastYForSecondColumn = 0
        
        basicLayoutSetup()
	}
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
		guard layoutAttributes.count > indexPath.row else {
            return nil
        }
        
		return layoutAttributes[indexPath.row]
	}
	
	override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
		guard !layoutAttributes.isEmpty else {
            return nil
        }
        
		return layoutAttributes
            .lazy
			.filter { rect.intersects($0.frame) }
	}
	
	override var collectionViewContentSize: CGSize {
        let width = collectionViewWidth - contentInset.left - contentInset.right
        
        let calculatedHeight = layoutAttributes
            .enumerated()
            .filter { index, _ -> Bool in ((index % 2) == 0) }
            .map { $1 }
            .reduce(0, { $0 + $1.frame.height })
       
        let rows = layoutAttributes
            .indices
            .filter { ($0 % 2) == 0 }
            .count
        let calculatedRowsInsets = CGFloat(rows - 1) * lineSpacing
        
        let height = calculatedHeight + calculatedRowsInsets + contentInset.top + contentInset.bottom
        
		return CGSize(width: width, height: height)
	}
}

//MARK: Private

private extension ChatsCollectionViewLayout {
    func basicLayoutSetup() {
        (0 ..< tagsCount).forEach {
            createLayoutAttributes(for: $0)
        }
    }
    
    func createLayoutAttributes(for index: Int) {
        var item = index + 1

        while item > 4 {
            item = item - 4
        }
        
        let x: CGFloat = (index % 2) == 0 ? 0 : collectionViewWidth - contentInset.left - contentInset.right - cellWidth
        let y: CGFloat = (index % 2) == 0 ? lastYForFirstColumn : lastYForSecondColumn
        let height: CGFloat = (item == 1 || item == 4) ? cellLargeHeight : cellSmallHeight
        
        var frame = CGRect()
        frame.size = CGSize(width: cellWidth, height: height)
        frame.origin = CGPoint(x: x, y: y)
        
        switch item {
        case 1:
            lastYForFirstColumn += cellLargeHeight
            if index > 1 {
                lastYForFirstColumn += lineSpacing
            }
        case 2:
            lastYForSecondColumn += cellSmallHeight
            if index > 1 {
                lastYForSecondColumn += lineSpacing
            }
        case 3:
            lastYForFirstColumn += cellSmallHeight
            if index > 1 {
                lastYForFirstColumn += lineSpacing
            }
        case 4:
            lastYForSecondColumn += cellLargeHeight
            if index > 1 {
                lastYForSecondColumn += lineSpacing
            }
        default:
            break
        }
        
        let indexPath = IndexPath(item: index, section: 0)
        let layoutAttribute = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        layoutAttribute.frame = frame
        layoutAttributes.append(layoutAttribute)
    }
	
	var collectionViewWidth: CGFloat {
        collectionView?.frame.size.width ?? 0
	}
    
    var contentInset: UIEdgeInsets {
        collectionView?.contentInset ?? .zero
    }
	
	var tagsCount: Int {
        collectionView?.numberOfItems(inSection: 0) ?? 0
    }
}
