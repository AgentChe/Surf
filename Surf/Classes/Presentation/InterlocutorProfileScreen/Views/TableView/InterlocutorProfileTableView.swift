//
//  InterlocutorProfileTableView.swift
//  Surf
//
//  Created by Andrey Chernyshev on 30.07.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import UIKit

final class InterlocutorProfileTableView: UITableView {
    weak var actionDelegate: InterlocutorProfileTableActionDelegate?
    
    private var sections = [InterlocutorProfileTableSection]()
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        register(InterlocutorProfilePersonalTableCell.self, forCellReuseIdentifier: String(describing: InterlocutorProfilePersonalTableCell.self))
        register(InterlocutorProfileTableDirectionCell.self, forCellReuseIdentifier: String(describing: InterlocutorProfileTableDirectionCell.self))
        register(InterlocutorProfileTablePhotosCell.self, forCellReuseIdentifier: String(describing: InterlocutorProfileTablePhotosCell.self))
        
        dataSource = self
        delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(sections: [InterlocutorProfileTableSection]) {
        self.sections = sections
        
        reloadData()
    }
}

// MARK: UITableViewDataSource

extension InterlocutorProfileTableView: UITableViewDataSource {
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
            let cell = dequeueReusableCell(withIdentifier: String(describing: InterlocutorProfilePersonalTableCell.self), for: indexPath) as! InterlocutorProfilePersonalTableCell
            cell.setup(name: name, birthdate: birthdate, emoji: emoji)
            return cell
        case .direction(let direction, let title, let withIcon, let maskedCorners):
            let cell = dequeueReusableCell(withIdentifier: String(describing: InterlocutorProfileTableDirectionCell.self), for: indexPath) as! InterlocutorProfileTableDirectionCell
            cell.actionDelegate = actionDelegate
            cell.setup(direction: direction, title: title, withIcon: withIcon, maskedCorners: maskedCorners)
            return cell
        case .photos(let photos):
            let cell = dequeueReusableCell(withIdentifier: String(describing: InterlocutorProfileTablePhotosCell.self), for: indexPath) as! InterlocutorProfileTablePhotosCell
            cell.setup(photos: photos)
            return cell
        }
    }
}

// MARK: UITableViewDelegate

extension InterlocutorProfileTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let item = sections[indexPath.section].items[indexPath.row]
        
        switch item {
        case .direction:
            return 48.scale
        case .photos:
            return 337.scale
        default:
            return UITableView.automaticDimension
        }
    }
    
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
        case 1:
            return 38.scale
        default:
            return 52.scale
        }
    }
}
