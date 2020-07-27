//
//  ProposedCollectionView.swift
//  FAWN
//
//  Created by Andrey Chernyshev on 23/04/2020.
//  Copyright © 2020 Алексей Петров. All rights reserved.
//

import UIKit

final class ProposedInterlocutorsCollectionView: UICollectionView {
    weak var proposedInterlocutorsDelegate: ProposedInterlocutorsCollectionViewDelegate?
    
    private var elements: [ProposedInterlocutor] = [] {
        willSet(newValue) {
            guard newValue.count != elements.count else {
                return
            }
            
            proposedInterlocutorsDelegate?.proposedInterlocutorsCollectionView(changed: newValue.count)
        }
    }
    
    private let queue = DispatchQueue(label: "proposed_interlocutor_table_queue")
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        register(ProposedInterlocutorCollectionCell.self, forCellWithReuseIdentifier: String(describing: ProposedInterlocutorCollectionCell.self))
        
        dataSource = self
        delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Data source

extension ProposedInterlocutorsCollectionView {
    func add(proposedInterlocutors: [ProposedInterlocutor]) {
        queue.sync { [weak self] in
            self?.elements.append(contentsOf: proposedInterlocutors)
        
            self?.reloadData()
        }
    }
    
    func remove(proposedInterlocutor: ProposedInterlocutor) {
        queue.sync { [weak self] in
            guard let index = self?.elements.firstIndex(where: { $0.id == proposedInterlocutor.id }) else {
                return
            }
            
            self?.elements.remove(at: index)
            
            self?.deleteItems(at: [IndexPath(row: index, section: 0)])
        }
    }
}

// MARK: UICollectionViewDataSource

extension ProposedInterlocutorsCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        elements.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = dequeueReusableCell(withReuseIdentifier: String(describing: ProposedInterlocutorCollectionCell.self), for: indexPath) as! ProposedInterlocutorCollectionCell
        cell.delegate = proposedInterlocutorsDelegate
        cell.setup(proposedInterlocutor: elements[indexPath.row])
        return cell
    }
}

// MARK: UICollectionViewDelegateFlowLayout

extension ProposedInterlocutorsCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 375.scale, height: ScreenSize.isIphoneXFamily ? 590.scale : 490.scale)
    }
}
