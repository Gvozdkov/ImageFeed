//
//  ViewController.swift
//  ImageFeed
//
//  Created by Алексей Гвоздков on 30.04.2023.
//

import UIKit

// MARK: - class ImagesListViewController
final class ImagesListViewController: UIViewController {
    @IBOutlet private var tableView: UITableView!
    
    private let photosNames: [String] = Array(0..<20).map{ "\($0)" }
    private let showSingleImageSegueIdentifier = "ShowSingleImage"
    
    private lazy var dateFormatter: DateFormatter = {
//        let formatter = DateFormatter()
//        formatter.dateStyle = .long
//        formatter.timeStyle = .none
//        return formatter
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    //MARK: - viewDidLoad
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
//
//    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == showSingleImageSegueIdentifier {
//            guard let viewController = segue.destination as? SingleImageViewController else { return }
//            guard let indexPath = sender as? IndexPath else { return }
//            let imageName = photosNames[indexPath.row]
//            let image = UIImage(named: "\(imageName)_full_size") ?? UIImage(named: imageName)
//            viewController.image = image
//        } else {
//            super.prepare(for: segue, sender: sender)
//        }
//    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showSingleImageSegueIdentifier {
            let viewController = segue.destination as! SingleImageViewController
            let indexPath = sender as! IndexPath
            let image = UIImage(named: photosNames[indexPath.row])
            viewController.image = image
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
}

//MARK: - extension
extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photosNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        
        guard let imageListCell = cell as? ImagesListCell else { return UITableViewCell() }
        
        configCell(for: imageListCell, with: indexPath)
        return imageListCell
    }
}

extension ImagesListViewController {
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        guard let image = UIImage(named: photosNames[indexPath.row]) else { return }
        cell.cellImage.image = image
        cell.dateLabel.text = dateFormatter.string(from: Date())
        
        let isLiked = indexPath.row % 2 == 0
        let likeImage = isLiked ? UIImage(named: "likeButtonOn") : UIImage(named: "likeButtonOff")
        cell.likeButton.setImage(likeImage, for: .normal)
    }
}

extension ImagesListViewController: UITableViewDelegate {
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        performSegue(withIdentifier: "ShowSingleImage", sender: indexPath)
//    }
//    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        guard let image = UIImage(named: photosNames[indexPath.row]) else { return 0 }
//        let imageInserts = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
//        let imageViewWidth = tableView.bounds.width - imageInserts.left - imageInserts.right
//        let imageWidth = image.size.width
//        let scale = imageViewWidth / imageWidth
//        let cellHeight = image.size.height * scale + imageInserts.top + imageInserts.bottom
//        return cellHeight
//    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: showSingleImageSegueIdentifier, sender: indexPath)
    }
}

