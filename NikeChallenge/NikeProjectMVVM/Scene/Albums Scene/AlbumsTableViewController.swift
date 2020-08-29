//
//  AlbumsTableViewController.swift
//  NikeProjectMVVM
//
//  Created by Riccardo Washington on 8/6/20.
//  Copyright © 2020 Riccardo Washington. All rights reserved.
//

import UIKit

class AlbumsTableViewController: UITableViewController {
    
    // MARK: - Properties
    
    var albumsViewModel: AlbumsViewModelProtocol?
    private var loadingSpinner: UIActivityIndicatorView?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        displayLoadingSpinner()
        setupViewModel()
        getAlbums(with: albumsViewModel)
    }
    
    // MARK: - Methods
    
    private func setupNavBar() {
        navigationItem.title = "Top Albums"
    }
    
    private func setupViewModel() {
        albumsViewModel = AlbumsViewModel(worker: AlbumWorker(service: DataFetcher.shared))
    }
    
    private func displayLoadingSpinner() {
        loadingSpinner = UIActivityIndicatorView(style: .large)
        loadingSpinner?.color = .darkGray
        loadingSpinner?.startAnimating()
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.view.addSubview(self.loadingSpinner ?? UIActivityIndicatorView())
            
            self.loadingSpinner?.translatesAutoresizingMaskIntoConstraints = false
            self.loadingSpinner?.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
            self.loadingSpinner?.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        }
        
    }
    
    private func removeLoadingSpinner() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.loadingSpinner?.stopAnimating()
            self.loadingSpinner?.removeFromSuperview()
            self.loadingSpinner = nil
            self.view.setNeedsDisplay()
        }
    }
    
    func getAlbums(with viewModel: AlbumsViewModelProtocol?) {
        albumsViewModel?.getAlbums() { [weak self] success, error in
            self?.removeLoadingSpinner()
            if success {
                self?.tableView.reloadData()
                return
            }
            if let error = error {
                let ac = UIAlertController.alert("Error", message: error.localizedDescription)
                self?.present(ac, animated: true)
            }
        }
    }
    
    private func setupViews() {
        setupNavBar()
        tableView.register(AlbumTableViewCell.self, forCellReuseIdentifier: AlbumTableViewCell.id)
    }
    
    private func navigateToDetail(with index: Int) {
        guard let album = albumsViewModel?.albums[index] else { return }
        let viewModel = AlbumDetailViewModel(album: album)
        let albumDetailVC = AlbumDetailViewController()
        albumDetailVC.albumDetailViewModel = viewModel
        navigationController?.pushViewController(albumDetailVC, animated: true)
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albumsViewModel?.albumsCount ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AlbumTableViewCell.id, for: indexPath) as? AlbumTableViewCell, let viewModel = albumsViewModel else { return UITableViewCell() }
        let album = viewModel.albums[indexPath.row]
        cell.configure(viewModel: album)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        navigateToDetail(with: indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
