//
//  HoroscopesTableView.swift
//  Surf
//
//  Created by Andrey Chernyshev on 04.09.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import UIKit

final class HoroscopesTableView: UITableView {
    weak var actionsDelegate: HoroscopesTableViewDelegate?
    
    private var sections = [HoroscopeTableSection]()
    
    private var heightAtIndexPath = NSMutableDictionary()
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        register(HoroscopeOnTableCell.self, forCellReuseIdentifier: String(describing: HoroscopeOnTableCell.self))
        register(HoroscopeArticleTableCell.self, forCellReuseIdentifier: String(describing: HoroscopeArticleTableCell.self))
        
        dataSource = self
        delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(sections: [HoroscopeTableSection]) {
        self.sections = sections
        
        reloadData()
    }
}

// MARK: UITableViewDataSource

extension HoroscopesTableView: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sections[section].elements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = sections[indexPath.section]
        let element = section.elements[indexPath.row]
        
        switch element {
        case .horoscopeOn(let horoscopeOn):
            let cell = dequeueReusableCell(withIdentifier: String(describing: HoroscopeOnTableCell.self), for: indexPath) as! HoroscopeOnTableCell
            cell.delegate = actionsDelegate
            cell.setup(horoscopeOn: horoscopeOn)
            return cell
        case .article(let article):
            let cell = dequeueReusableCell(withIdentifier: String(describing: HoroscopeArticleTableCell.self), for: indexPath) as! HoroscopeArticleTableCell
            cell.delegate = actionsDelegate
            cell.setup(article: article)
            return cell
        }
    }
}

// MARK: UITableViewDelegate

extension HoroscopesTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if let height = heightAtIndexPath.object(forKey: indexPath) as? NSNumber {
            return CGFloat(height.floatValue)
        } else {
            return UITableView.automaticDimension
        }
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let height = NSNumber(value: Float(cell.frame.size.height))
        heightAtIndexPath.setObject(height, forKey: indexPath as NSCopying)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        40.scale
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        return view 
    }
}
