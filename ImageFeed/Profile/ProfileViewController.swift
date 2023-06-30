import UIKit
import Kingfisher

// MARK: - class ProfileViewController
final class ProfileViewController: UIViewController {
    
    private var profileImageServiceObserver: NSObjectProtocol?
    private let storageToken = OAuth2TokenStorage()
    private let profileService = ProfileService.shared
    
    private let oAuth2TokenStorage = OAuth2TokenStorage.shared
    private (set) var avatarURL: String?
    
    private let animationGradient = AnimationGradientFactory.shared
    private var gradientProfileImage: CAGradientLayer!
    private var gradientNameProfile: CAGradientLayer!
    private var gradientNameLabel: CAGradientLayer!
    private var gradientDescriptionLabel: CAGradientLayer!
    let gradient = CAGradientLayer()
    
    private lazy var uIView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "ypBlack")
        return view
    }()
    
    private lazy var viewProfileImage: UIImageView = {
        let imageProfile = UIImage(named: "Profile")
        let image = UIImageView(image: imageProfile)
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    private lazy var labelNameProfile: UILabel = {
        let label = UILabel()
        label.text = "Екатерина Новикова"
        label.font = UIFont.systemFont(ofSize: 23)
        label.textColor = UIColor(named: "ypWhite")
        return label
    }()
    
    private lazy var labelNameLogin: UILabel = {
        let label = UILabel()
        label.text = "@ekaterina_nov"
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = UIColor(named: "ypGray")
        return label
    }()
    
    private lazy var labelDescription: UILabel = {
        let label = UILabel()
        label.text = "Hello, world!"
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = UIColor(named: "ypWhite")
        return label
    }()
    
    private lazy var buttonLogout : UIButton = {
        let imageButton = UIImage(named: "logoutButton")
        var button = UIButton()
        button = UIButton.systemButton(with: imageButton!,
                                       target: self,
                                       action: #selector(didTapLogoutButton))
        button.tintColor = UIColor(named: "ypRed")
        return button
    }()
    
    // MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        settingsViewController()
        updateGradient()
        guard let profile = profileService.profile else { return }
        updateAvatar()
        updateProfileDetails(profile: profile)
        observeAvatarChanges()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
}

// MARK: - extension
extension ProfileViewController {
   private func settingsViewController() {
        view.addSubview(viewProfileImage)
        view.addSubview(labelNameProfile)
        view.addSubview(labelNameLogin)
        view.addSubview(labelDescription)
        view.addSubview(buttonLogout)
        
        viewProfileImage.translatesAutoresizingMaskIntoConstraints = false
        labelNameProfile.translatesAutoresizingMaskIntoConstraints = false
        labelNameLogin.translatesAutoresizingMaskIntoConstraints = false
        labelDescription.translatesAutoresizingMaskIntoConstraints = false
        buttonLogout.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            viewProfileImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            viewProfileImage.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            viewProfileImage.heightAnchor.constraint(equalToConstant: 70),
            viewProfileImage.widthAnchor.constraint(equalToConstant: 70),
            
            labelNameProfile.topAnchor.constraint(equalTo: viewProfileImage.bottomAnchor, constant: 8),
            labelNameProfile.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            
            labelNameLogin.topAnchor.constraint(equalTo: labelNameProfile.bottomAnchor, constant: 8),
            labelNameLogin.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            
            labelDescription.topAnchor.constraint(equalTo: labelNameLogin.bottomAnchor, constant: 8),
            labelDescription.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            
            buttonLogout.centerYAnchor.constraint(equalTo: viewProfileImage.centerYAnchor),
            buttonLogout.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -26)
        ])
    }
    
    
    @objc private func didTapLogoutButton() {
        onLogout()
    }
}

extension ProfileViewController {
    private func updateGradient() {
        gradientNameProfile = animationGradient.createGradient(width: 223, height: 23, cornerRadius: 11.5)
        self.labelNameProfile.layer.addSublayer(gradientNameProfile)
        
        gradientNameLabel = animationGradient.createGradient(width: 89, height: 18, cornerRadius: 9)
        self.labelNameLogin.layer.addSublayer(gradientNameLabel)
        
        gradientDescriptionLabel = animationGradient.createGradient(width: 67, height: 18, cornerRadius: 9)
        self.labelDescription.layer.addSublayer(gradientDescriptionLabel)
        
        gradientProfileImage = animationGradient.createGradient(width: 70, height: 70, cornerRadius: 35)
//        self.viewProfileImage.layer.addSublayer(gradientProfileImage)
    }
    
    private func updateProfileDetails(profile: Profile?) {
        guard let profile = profileService.profile else { return }
        labelNameProfile.text = profile.name
        labelNameLogin.text = profile.loginName
        labelDescription.text = profile.bio
        
        gradientNameLabel?.removeFromSuperlayer()
        gradientNameProfile?.removeFromSuperlayer()
        gradientDescriptionLabel?.removeFromSuperlayer()
    }
    
    private func updateAvatar() {
        guard
            let profileImageURL = ProfileImageService.shared.avatarURL,
            let url = URL(string: profileImageURL)
        else { return self.viewProfileImage.layer.addSublayer(gradientProfileImage) }
        let processor = RoundCornerImageProcessor(cornerRadius: viewProfileImage.frame.width)
        viewProfileImage.kf.indicatorType = .activity
        viewProfileImage.kf.setImage(with: url,
                              placeholder: UIImage(named: "person.crop.circle.fill.png"),
                              options: [.processor(processor),.cacheSerializer(FormatIndicatedCacheSerializer.png)])
        let cache = ImageCache.default
        cache.clearDiskCache()
        cache.clearMemoryCache()
    }
    
    private func observeAvatarChanges() {
        profileImageServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ProfileImageService.didChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard let self = self else { return }
                self.updateAvatar()
            }
    }
}

extension ProfileViewController {
    private func onLogout() {
        let alert = UIAlertController(
            title: "Пока, пока!",
            message: "Уверены что хотите выйти?",
            preferredStyle: .alert
        )
        
        let agreeAction = UIAlertAction(
            title: "Да",
            style: .default
        ) { [weak self] _ in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.onLogout()
            }
        }
        
        let dismissAction = UIAlertAction(
            title: "Нет",
            style: .default
        )
        
        alert.addAction(agreeAction)
        alert.addAction(dismissAction)
        
        present(alert, animated: true)

    }
}

