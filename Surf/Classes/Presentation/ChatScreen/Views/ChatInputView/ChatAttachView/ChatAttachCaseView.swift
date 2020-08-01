//
//  ChatAttachCaseView.swift
//  FAWN
//
//  Created by Andrey Chernyshev on 08/06/2020.
//  Copyright © 2020 Алексей Петров. All rights reserved.
//

import UIKit

final class ChatAttachCaseView: UIView {
    lazy var imageView = makeImageView()
    lazy var label = makeLabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        _ = imageView
        _ = label
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Lazy initialization

private extension ChatAttachCaseView {
    func makeImageView() -> UIImageView {
        let view = UIImageView(frame: CGRect(x: 14.scale, y: 15.scale, width: 32.scale, height: 32.scale))
        view.contentMode = .scaleAspectFit
        addSubview(view)
        return view
    }
    
    func makeLabel() -> UILabel {
        let x: CGFloat = 14.scale + 32.scale + 15.scale
        let view = UILabel(frame: CGRect(x: x,
                                         y: 19.scale,
                                         width: self.bounds.width - x - 16.scale,
                                         height: 23.scale))
        view.font = Font.SFProText.regular(size: 19.scale)
        view.textColor = .black
        addSubview(view)
        return view
    }
}
