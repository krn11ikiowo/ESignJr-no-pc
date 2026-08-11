import UIKit

class MainViewController: UIViewController {
    // MARK: - UI Elements
    private let appTitleLabel = UILabel()
    private let welcomeLabel = UILabel()
    private let versionLabel = UILabel()
    private let actionButton = UIButton(type: .system)
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    // MARK: - Setup Methods
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "ESignJr"
        
        // App Title Label
        appTitleLabel.text = "ESignJr"
        appTitleLabel.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        appTitleLabel.textAlignment = .center
        appTitleLabel.textColor = .label
        
        // Welcome Label
        welcomeLabel.text = "Digital Signature Management"
        welcomeLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        welcomeLabel.textAlignment = .center
        welcomeLabel.textColor = .secondaryLabel
        welcomeLabel.numberOfLines = 0
        
        // Version Label
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
        versionLabel.text = "Version \(appVersion)"
        versionLabel.font = UIFont.systemFont(ofSize: 12, weight: .light)
        versionLabel.textAlignment = .center
        versionLabel.textColor = .tertiaryLabel
        
        // Action Button
        var config = UIButton.Configuration.filled()
        config.title = "Get Started"
        config.baseBackgroundColor = .systemBlue
        config.baseForegroundColor = .white
        config.buttonSize = .large
        actionButton.configuration = config
        actionButton.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
        
        // Add to view
        view.addSubview(appTitleLabel)
        view.addSubview(welcomeLabel)
        view.addSubview(versionLabel)
        view.addSubview(actionButton)
    }
    
    private func setupConstraints() {
        appTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
        versionLabel.translatesAutoresizingMaskIntoConstraints = false
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            appTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            appTitleLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -60),
            
            welcomeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            welcomeLabel.topAnchor.constraint(equalTo: appTitleLabel.bottomAnchor, constant: 20),
            welcomeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            welcomeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            actionButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            actionButton.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 40),
            actionButton.widthAnchor.constraint(equalToConstant: 150),
            
            versionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            versionLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }
    
    // MARK: - Actions
    @objc private func actionButtonTapped() {
        let alert = UIAlertController(title: "Welcome", message: "ESignJr is ready to help you manage digital signatures.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
