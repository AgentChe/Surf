//
//  ProfileCollectionView.swift
//  Surf
//
//  Created by Andrey Chernyshev on 19.07.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import UIKit

final class ProfileTableView: UITableView {
    weak var actionDelegate: ProfileTableActionDelegate?
    
    private var sections = [ProfileTableSection]()
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        register(ProfilePersonalTableCell.self, forCellReuseIdentifier: String(describing: ProfilePersonalTableCell.self))
        register(ProfileTableDirectionCell.self, forCellReuseIdentifier: String(describing: ProfileTableDirectionCell.self))
        
        dataSource = self
        delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(sections: [ProfileTableSection]) {
        self.sections = sections
        
        reloadData()
    }
}

// MARK: UITableViewDataSource

extension ProfileTableView: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sections[section].items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = sections[indexPath.section]
        let item = section.items[indexPath.row]
        
        switch item {
        case .personal(let name, let birthdate, let emoji):
            let cell = dequeueReusableCell(withIdentifier: String(describing: ProfilePersonalTableCell.self), for: indexPath) as! ProfilePersonalTableCell
            cell.setup(name: name, birthdate: birthdate, emoji: emoji)
            return cell
        case .direction(let direction, let title, let withIcon, let maskedCorners):
            let cell = dequeueReusableCell(withIdentifier: String(describing: ProfileTableDirectionCell.self), for: indexPath) as! ProfileTableDirectionCell
            cell.actionDelegate = actionDelegate
            cell.setup(direction: direction, title: title, withIcon: withIcon, maskedCorners: maskedCorners)
            return cell
        }
    }
}

// MARK: UITableViewDelegate

extension ProfileTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 0:
            return nil
        default:
            let view = UIView()
            view.backgroundColor = .clear
            return view
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 0
        default:
            return 52.scale
        }
    }
}
