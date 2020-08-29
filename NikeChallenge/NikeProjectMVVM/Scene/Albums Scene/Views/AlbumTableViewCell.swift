//
//  AlbumsTableViewController.swift
//  NikeProjectMVVM
//
//  Created by Riccardo Washington on 8/6/20.
//  Copyright © 2020 Riccardo Washington. All rights reserved.
//

import UIKit

class AlbumTableViewCell: UITableViewCell {
    
    static let id = "AlbumTableViewCell"
    
    // MARK: - Views
    
    private let albumImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "icons8-full-image-100")
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        return iv
    }()
    
    private let albumNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .title2)
        return label
    }()
    
    private let artistNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        label.textColor = .lightGray
        return label
    }()
    
    private lazy var labelStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [albumNameLabel, artistNameLabel])
        sv.axis = .vertical
        sv.spacing = AlbumTableViewCell.stackViewSpacing
        sv.distribution = .fillProportionally
        return sv
    }()
    
    // MARK: - Inits
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Failed to init from coder")
    }
    
    // MARK: - Methods
    
    func configure(viewModel: Album) {
        albumNameLabel.text = viewModel.albumName
        artistNameLabel.text = viewModel.artistName
        if let image = ImageCache.storage[viewModel.artworkUrl100] {
            albumImageView.image = image
        } else {
            guard let url = URL(string: viewModel.artworkUrl100) else {
                albumImageView.image = #imageLiteral(resourceName: "icons8-full-image-100")
                return
            }
            albumImageView.setImage(with: url) { image, errorString in
                if let image = image {
                    ImageCache.storage[viewModel.artworkUrl100] = image
                }
            }
        }
    }
    
    private func setupViews() {
        contentView.addSubview(albumImageView)
        albumImageView.translatesAutoresizingMaskIntoConstraints = false
        albumImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: AlbumTableViewCell.imageViewInsets.left).isActive = true
        albumImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        albumImageView.widthAnchor.constraint(equalToConstant: AlbumTableViewCell.imageViewInsets.right).isActive = true
        albumImageView.heightAnchor.constraint(equalToConstant: AlbumTableViewCell.imageViewInsets.right).isActive = true
        
        contentView.addSubview(labelStackView)
        labelStackView.translatesAutoresizingMaskIntoConstraints = false
        labelStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: AlbumTableViewCell.labelInsets.top).isActive = true
        labelStackView.leadingAnchor.constraint(equalTo: albumImageView.trailingAnchor, constant: AlbumTableViewCell.labelInsets.left).isActive = true
        labelStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: AlbumTableViewCell.labelInsets.bottom).isActive = true
        labelStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: AlbumTableViewCell.labelInsets.right).isActive = true
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        albumImageView.image = #imageLiteral(resourceName: "icons8-full-image-100")
        albumNameLabel.text = ""
        artistNameLabel.text = ""
    }

}

extension AlbumTableViewCell {
    static let labelInsets = UIEdgeInsets(top: 16, left: 16, bottom: -16, right: -16)
    static let imageViewInsets = UIEdgeInsets(top: 16, left: 16, bottom: -16, right: 80)
    static let stackViewSpacing: CGFloat = 4
}
