//
//  MainCollectionView.swift
//  Surf
//
//  Created by Andrey Chernyshev on 04.09.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import UIKit

final class MainCollectionView: UICollectionView {
    weak var mainCollectionDelegate: MainCollectionViewDelegate?
    
    private var elements = [MainCollectionElement]()
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        register(MainCollectionDirectCell.self, forCellWithReuseIdentifier: String(describing: MainCollectionDirectCell.self))
        
        delegate = self
        dataSource = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(elements: [MainCollectionElement]) {
        self.elements = elements
        
        reloadData()
    }
}

// MARK: UITableViewDelegate

extension MainCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let element = elements[indexPath.row]
        
        switch element {
        case .direct:
            return CGSize(width: frame.width - 64.scale, height: 248.scale)
        }
    }
}

// MARK: UITableViewDataSource

extension MainCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        elements.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let element = elements[indexPath.row]
        
        switch element {
        case .direct(let direct):
            let cell = dequeueReusableCell(withReuseIdentifier: String(describing: MainCollectionDirectCell.self), for: indexPath) as! MainCollectionDirectCell
            cell.delegate = mainCollectionDelegate
            cell.setup(element: direct)
            return cell
        }
    }
}
