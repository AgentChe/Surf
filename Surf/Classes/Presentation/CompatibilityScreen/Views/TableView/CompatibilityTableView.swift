//
//  CompatibilityTableView.swift
//  Surf
//
//  Created by Andrey Chernyshev on 05.09.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import UIKit

final class CompatibilityTableView: UITableView {
    private var sections = [CompatibilityTableSection]()
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        register(CompatibilityTableSignsCell.self, forCellReuseIdentifier: String(describing: CompatibilityTableSignsCell.self))
        register(CompatibilityTableScoresCell.self, forCellReuseIdentifier: String(describing: CompatibilityTableScoresCell.self))
        register(CompatibilityTableOverallScoreCell.self, forCellReuseIdentifier: String(describing: CompatibilityTableOverallScoreCell.self))
        register(CompatibilityTableTextCell.self, forCellReuseIdentifier: String(describing: CompatibilityTableTextCell.self))
        
        dataSource = self
        delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(sections: [CompatibilityTableSection]) {
        self.sections = sections
        
        reloadData()
    }
}

// MARK: UITableViewDataSource
 
extension CompatibilityTableView: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sections[section].items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = sections[indexPath.section]
        let element = section.items[indexPath.row]
        
        switch element {
        case .signs(let sign1, let sign2):
            let cell = dequeueReusableCell(withIdentifier: String(describing: CompatibilityTableSignsCell.self), for: indexPath) as! CompatibilityTableSignsCell
            cell.setup(sign1: sign1, sign2: sign2)
            return cell
        case .scores(let scores):
            let cell = dequeueReusableCell(withIdentifier: String(describing: CompatibilityTableScoresCell.self), for: indexPath) as! CompatibilityTableScoresCell
            cell.setup(scores: scores)
            return cell
        case .overallScore(let score):
            let cell = dequeueReusableCell(withIdentifier: String(describing: CompatibilityTableOverallScoreCell.self), for: indexPath) as! CompatibilityTableOverallScoreCell
            cell.setup(overallScore: score)
            return cell
        case .text(let text):
            let cell = dequeueReusableCell(withIdentifier: String(describing: CompatibilityTableTextCell.self), for: indexPath) as! CompatibilityTableTextCell
            cell.setup(text: text)
            return cell
        }
    }
}

// MARK: UITableViewDelegate
 
extension CompatibilityTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard let element = sections[section].items.first else {
            return 40.scale
        }
        
        switch element {
        case .signs:
            return 40.scale
        case .scores:
            return 40.scale
        case .overallScore:
            return 40.scale
        case .text:
            return 16.scale
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section = sections[indexPath.section]
        let element = section.items[indexPath.row]
        
        switch element {
        case .signs:
            return 108.scale
        case .scores:
            return 120.scale
        case .overallScore:
            return 28.scale
        case .text:
            return UITableView.automaticDimension
        }
    }
}
