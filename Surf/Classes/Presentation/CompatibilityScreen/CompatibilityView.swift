//
//  CompatibilityView.swift
//  Surf
//
//  Created by Andrey Chernyshev on 04.09.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import UIKit

final class CompatibilityView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .red
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Make constraints

private extension CompatibilityView {
    
}

// MARK: Lazy initialization

private extension CompatibilityView {
    
}
