//
//  SearchSettingsViewController.swift
//  Surf
//
//  Created by Andrey Chernyshev on 27.07.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import UIKit
import RxSwift
import RangeSeekSlider

final class SearchSettingsViewController: UIViewController {
    var searchSettingsView = SearchSettingsView()
    
    private let viewModel = SearchSettingsViewModel()
    
    private let disposeBag = DisposeBag()
    
    override func loadView() {
        super.loadView()
        
        view = searchSettingsView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addHideAction()
        
        searchSettingsView.ageRangeSlider.delegate = self
        
        searchSettingsView
            .lookingForChoiceView.on = { [weak self] lookingFor in 
                self?.updateSettings()
            }
        
        viewModel
            .profile()
            .drive(onNext: { [weak self] profile in
                guard let profile = profile else {
                    return
                }
                
                self?.update(lookingFor: profile.lookingFor)
                self?.update(minAge: profile.minAge ?? 0, maxAge: profile.maxAge ?? 0)
            })
            .disposed(by: disposeBag)
        
        viewModel
            .updatedLookingFor()
            .drive()
            .disposed(by: disposeBag)
    }
}

// MARK: Make

extension SearchSettingsViewController {
    static func make() -> SearchSettingsViewController {
        let vc = SearchSettingsViewController()
        vc.modalPresentationStyle = .overCurrentContext
        return vc
    }
}

// MARK: RangeSeekSliderDelegate

extension SearchSettingsViewController: RangeSeekSliderDelegate {
    func rangeSeekSlider(_ slider: RangeSeekSlider, didChange minValue: CGFloat, maxValue: CGFloat) {
        update(minAge: Int(minValue), maxAge: Int(maxValue))
        updateSettings()
    }
}

// MARK: Private

private extension SearchSettingsViewController {
    func updateSettings() {
        let settings: ([Gender], Int, Int) = (searchSettingsView.lookingForChoiceView.lookingFor,
                                              Int(searchSettingsView.ageRangeSlider.selectedMinValue),
                                              Int(searchSettingsView.ageRangeSlider.selectedMaxValue))
        
        viewModel.updateLookingFor.accept(settings)
    }
    
    func update(lookingFor: [Gender]) {
        searchSettingsView.lookingForChoiceView.lookingFor = lookingFor
    }
    
    func update(minAge: Int, maxAge: Int) {
        searchSettingsView.ageRangeLabel.text = String(format: "%i-%i", minAge, maxAge)
        searchSettingsView.ageRangeSlider.selectedMinValue = CGFloat(minAge)
        searchSettingsView.ageRangeSlider.selectedMaxValue = CGFloat(maxAge)
    }
    
    func addHideAction() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideScreen))
        searchSettingsView.backgroundView.addGestureRecognizer(tapGesture)
        searchSettingsView.backgroundView.isUserInteractionEnabled = true
    }
    
    @objc
    func hideScreen() {
        dismiss(animated: false)
    }
}
