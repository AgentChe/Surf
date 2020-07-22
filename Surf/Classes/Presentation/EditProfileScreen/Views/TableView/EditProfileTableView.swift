//
//  EditProfileTableView.swift
//  Surf
//
//  Created by Andrey Chernyshev on 22.07.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import UIKit

final class EditProfileTableView: UITableView {
    weak var actionDelegate: EditProfileTableActionDelegate?
    
    private var sections = [EditProfileTableSection]()
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        register(EditProfileTableNameCell.self, forCellReuseIdentifier: String(describing: EditProfileTableNameCell.self))
        register(EditProfileTableDeleteCell.self, forCellReuseIdentifier: String(describing: EditProfileTableDeleteCell.self))
        register(EditProfileTablePhotosCell.self, forCellReuseIdentifier: String(describing: EditProfileTablePhotosCell.self))
        
        dataSource = self
        delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(sections: [EditProfileTableSection]) {
        self.sections = sections
        
        reloadData()
    }
}

// MARK: UITableViewDataSource

extension EditProfileTableView: UITableViewDataSource {
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
        case .photos(let photos):
            let cell = dequeueReusableCell(withIdentifier: String(describing: EditProfileTablePhotosCell.self), for: indexPath) as! EditProfileTablePhotosCell
            cell.actionDelegate = actionDelegate
            cell.setup(photos: photos)
            return cell
//        case .name(let name):
//            let cell = dequeueReusableCell(withIdentifier: String(describing: EditProfileTableNameCell.self), for: indexPath) as! EditProfileTableNameCell
//            cell.setup(name: name)
//            return cell
        case .delete(let email):
            let cell = dequeueReusableCell(withIdentifier: String(describing: EditProfileTableDeleteCell.self), for: indexPath) as! EditProfileTableDeleteCell
            cell.actionDelegate = actionDelegate
            cell.setup(email: email)
            return cell
        }
    }
}

// MARK: UITableViewDelegate

extension EditProfileTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let item = sections[indexPath.section].items[indexPath.row]
        
        switch item {
        case .photos:
            return 337.scale
        default:
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        52.scale
    }
}
