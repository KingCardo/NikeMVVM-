//
//  AlbumDetailViewController.swift
//  NikeProjectMVVM
//
//  Created by Riccardo Washington on 8/6/20.
//  Copyright © 2020 Riccardo Washington. All rights reserved.
//

import UIKit


class AlbumDetailViewController: UIViewController {
    
    // MARK: - Properties
    
    var albumDetailViewModel: AlbumDetailViewModelProtocol?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        displayAlbumDetails(viewModel: albumDetailViewModel)
    }
    
    // MARK: Views
    
    private let albumImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    private let albumNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .title2)
        return label
    }()
    
    let artistNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        label.textColor = .lightGray
        return label
    }()
    
    private let genreLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .body)
        return label
    }()
    
    private let releaseDateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .body)
        return label
    }()
    
    private let copyrightLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .caption1)
        label.textColor = .darkGray
        return label
    }()
    
    private lazy var labelStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [albumNameLabel, artistNameLabel, genreLabel, releaseDateLabel, copyrightLabel])
        sv.axis = .vertical
        sv.spacing = AlbumDetailViewController.stackViewSpacing
        sv.alignment = .center
        sv.distribution = .fillProportionally
        return sv
    }()
    
    private lazy var displayAlbumPageButton: UIButton = {
        let button = UIButton()
        button.setTitle("Go to Album Page", for: .normal)
        button.backgroundColor = .blue
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(goToAlbumPage), for: .touchDown)
        return button
    }()
    
    
    // MARK: - Methods
    
    @objc private func goToAlbumPage() {
        guard let urlString = albumDetailViewModel?.album.url else { return }
        let webVC = WebViewController()
        webVC.url = URL(string: urlString)
        navigationController?.pushViewController(webVC, animated: true)
    }
    
    func displayAlbumDetails(viewModel: AlbumDetailViewModelProtocol?) {
        guard let albumDetail = albumDetailViewModel else { return }
        albumNameLabel.text = albumDetail.album.albumName
        artistNameLabel.text = albumDetail.album.artistname
        genreLabel.text = "\(albumDetail.album.genre)"
        releaseDateLabel.text = albumDetail.album.releasedate
        copyrightLabel.text = albumDetail.album.copyright
        
        view.setNeedsDisplay()
        
        if let image = ImageCache.storage[albumDetail.album.albumImage] {
            albumImageView.image = image
        } else {
            guard let url = URL(string: albumDetail.album.albumImage) else {
                albumImageView.image = #imageLiteral(resourceName: "icons8-full-image-100")
                return }
            albumImageView.setImage(with: url) { image, errorString in
                if let image = image {
                    ImageCache.storage[albumDetail.album.albumImage] = image
                    return
                }
                guard let errorString = errorString else { return }
                let ac = UIAlertController.alert("Error", message: errorString)
                self.present(ac, animated: true, completion: nil)
            }
        }
    }
    
    private func setupViewsForRegularHeight() {
        addViews()
        
        albumImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: AlbumDetailViewController.imageViewInsets.top).isActive = true
        albumImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: AlbumDetailViewController.imageViewInsets.left).isActive = true
        albumImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: AlbumDetailViewController.imageViewInsets.right).isActive = true
        albumImageView.heightAnchor.constraint(equalToConstant: view.frame.height * AlbumDetailViewController.imageViewInsets.bottom).isActive = true
        
        displayAlbumPageButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: AlbumDetailViewController.displayButtonInsets.left).isActive = true
        displayAlbumPageButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: AlbumDetailViewController.displayButtonInsets.bottom).isActive = true
        displayAlbumPageButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: AlbumDetailViewController.displayButtonInsets.right).isActive = true
        displayAlbumPageButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        displayAlbumPageButton.heightAnchor.constraint(equalToConstant: AlbumDetailViewController.displayButtonInsets.top).isActive = true
        
        
        labelStackView.topAnchor.constraint(equalTo: albumImageView.bottomAnchor, constant: AlbumDetailViewController.stackViewInsets.top).isActive = true
        labelStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: AlbumDetailViewController.stackViewInsets.left).isActive = true
        labelStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: AlbumDetailViewController.stackViewInsets.right).isActive = true
        labelStackView.bottomAnchor.constraint(equalTo: displayAlbumPageButton.topAnchor, constant: AlbumDetailViewController.stackViewInsets.bottom).isActive = true
        
        view.setNeedsLayout()
        view.setNeedsDisplay()
        
    }
    
    private func setupViewsForCompactHeight() {
        addViews()
        
        albumImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: AlbumDetailViewController.imageViewInsets.top).isActive = true
        albumImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: AlbumDetailViewController.imageViewInsets.left).isActive = true
        albumImageView.heightAnchor.constraint(equalToConstant: view.frame.height * 0.6).isActive = true
        albumImageView.widthAnchor.constraint(equalToConstant: view.frame.width * AlbumDetailViewController.imageViewInsets.bottom).isActive = true
        
        displayAlbumPageButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: AlbumDetailViewController.displayButtonInsets.left).isActive = true
        displayAlbumPageButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: AlbumDetailViewController.displayButtonInsets.bottom).isActive = true
        displayAlbumPageButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: AlbumDetailViewController.displayButtonInsets.right).isActive = true
        displayAlbumPageButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        displayAlbumPageButton.heightAnchor.constraint(equalToConstant: AlbumDetailViewController.displayButtonInsets.top).isActive = true
        
        
        labelStackView.topAnchor.constraint(equalTo: albumImageView.topAnchor, constant: AlbumDetailViewController.stackViewInsets.top).isActive = true
        labelStackView.leadingAnchor.constraint(equalTo: albumImageView.trailingAnchor, constant: AlbumDetailViewController.stackViewInsets.left).isActive = true
        labelStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: AlbumDetailViewController.stackViewInsets.right).isActive = true
        labelStackView.bottomAnchor.constraint(equalTo: displayAlbumPageButton.topAnchor, constant: AlbumDetailViewController.stackViewInsets.bottom).isActive = true
        
        view.setNeedsLayout()
        view.setNeedsDisplay()
        
    }
    
    private func removeViews() {
        albumImageView.removeFromSuperview()
        displayAlbumPageButton.removeFromSuperview()
        labelStackView.removeFromSuperview()
        view.setNeedsLayout()
    }
    
    private func addViews() {
        view.addSubview(albumImageView)
        albumImageView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(displayAlbumPageButton)
        displayAlbumPageButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(labelStackView)
        labelStackView.translatesAutoresizingMaskIntoConstraints = false
        
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if traitCollection.horizontalSizeClass != previousTraitCollection?.horizontalSizeClass {
            enableConstraintsForHeight(traitCollection.horizontalSizeClass)
        }
    }
    
    private func enableConstraintsForHeight(_ verticalSizeClass: UIUserInterfaceSizeClass) {
        if verticalSizeClass == .regular {
            removeViews()
            setupViewsForCompactHeight()
            
        } else {
            removeViews()
            setupViewsForRegularHeight()
        }
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        addViews()
        enableConstraintsForHeight(traitCollection.horizontalSizeClass)
        
    }
}

extension AlbumDetailViewController {
    static let imageViewInsets = UIEdgeInsets(top: 16, left: 16, bottom: 0.4, right: -16)
    static let displayButtonInsets = UIEdgeInsets(top: 50, left: 20, bottom: -20, right: -20)
    static let stackViewInsets = UIEdgeInsets(top: 8, left: 16, bottom: -16, right: -8)
    static let stackViewSpacing: CGFloat = 4
}
