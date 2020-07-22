//
//  ProfileTablePhotosCell.swift
//  Surf
//
//  Created by Andrey Chernyshev on 21.07.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import UIKit
import Kingfisher

final class ProfileTablePhotosCell: UITableViewCell {
    weak var actionDelegate: ProfileTableActionDelegate?
    
    lazy var photoView1 = makePhotoView()
    lazy var photoView2 = makePhotoView()
    lazy var photoView3 = makePhotoView()
    
    private var sortedPhotos = [Photo]()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = UIColor(red: 240 / 255, green: 240 / 255, blue: 242 / 255, alpha: 1)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(photos: [Photo]) {
        sortedPhotos = photos.sorted(by: { $0.order < $1.order })
        
        [photoView1, photoView2, photoView3].enumerated().forEach { stub in
            let (index, photoView) = stub
            
            photoView.tag = index
            
            photoView.label.text = "\(index + 1)"
            
            photoView.imageView.kf.cancelDownloadTask()
            photoView.imageView.image = nil
            
            if sortedPhotos.indices.contains(index) {
                if let url = URL(string: sortedPhotos[index].url) {
                    photoView.imageView.kf.setImage(with: url)
                }
            }
        }
    }
}

// MARK: Private

private extension ProfileTablePhotosCell {
    @objc
    func tapped(sender: Any) {
        guard
            let tapGesture = sender as? UITapGestureRecognizer,
            let photoView = tapGesture.view as? ProfileTablePhotoView
        else {
            return
        }

        var selectedPhoto: Photo? = nil

        if sortedPhotos.indices.contains(photoView.tag) {
            selectedPhoto = sortedPhotos[photoView.tag]
        }

        actionDelegate?.profileTable(selected: selectedPhoto)
    }
}

// MARK: Make constraints

private extension ProfileTablePhotosCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            photoView1.widthAnchor.constraint(equalToConstant: 239.scale),
            photoView1.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            photoView1.topAnchor.constraint(equalTo: contentView.topAnchor),
            photoView1.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            photoView2.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale),
            photoView2.topAnchor.constraint(equalTo: contentView.topAnchor),
            photoView2.heightAnchor.constraint(equalToConstant: 124.scale),
            photoView2.widthAnchor.constraint(equalToConstant: 88.scale)
        ])
        
        NSLayoutConstraint.activate([
            photoView3.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale),
            photoView3.topAnchor.constraint(equalTo: photoView2.bottomAnchor, constant: 16.scale),
            photoView3.heightAnchor.constraint(equalToConstant: 124.scale),
            photoView3.widthAnchor.constraint(equalToConstant: 88.scale)
        ])
    }
}

// MARK: Lazy initialization

private extension ProfileTablePhotosCell {
    func makePhotoView() -> ProfileTablePhotoView {
        let view = ProfileTablePhotoView()
        view.backgroundColor = .clear
        view.layer.cornerRadius = 16.scale
        view.layer.masksToBounds = true
        view.isUserInteractionEnabled = true
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapped(sender:)))
        view.addGestureRecognizer(tapGesture)
        
        return view
    }
}
