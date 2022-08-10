//
//  DetailViewController.swift
//  ProjetoMarvel
//
//  Created by c94289a on 17/01/22.
//

import UIKit
import SafariServices

class DetailViewController: UIViewController {
    
//    var touchedHero: Results = Results()
    var reuseIdentifier = "cell"
    lazy var viewModelDetail: DetailViewModel = {
        return DetailViewModel(view: self)
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.isUserInteractionEnabled = false
        return stackView
    }()
    
    private lazy var imageDetail: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        return image
    }()
    
    private lazy var labelHeroName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 23.0)
        label.isAccessibilityElement = true
        return label
    }()
    
    private lazy var labelTitleBiography: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 15.0)
        label.text = "BIOGRAPHY"
        label.isAccessibilityElement = false
        return label
    }()
    
    lazy var labelBiography: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 14.0)
        label.numberOfLines = 0
        label.isAccessibilityElement = true
        return label
    }()
    
    private lazy var labelTitleComics: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 15.0)
        label.text = "COMICS"
        label.isAccessibilityElement = false
        return label
    }()
    
    private lazy var labelComics: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 14.0)
        label.numberOfLines = 0
        label.isAccessibilityElement = true
        return label
    }()
    
    private lazy var labelTitleSeries: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 15.0)
        label.text = "SERIES"
        label.isAccessibilityElement = false
        return label
    }()
    
    private lazy var labelSeries: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 14.0)
        label.numberOfLines = 0
        label.isAccessibilityElement = true
        return label
    }()
    
    private lazy var clickableDetailsView: UIControl = {
        let view = UIControl()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(red: 217/255.0, green: 56/255.0, blue: 50/255.0, alpha: 1.0)
        view.addTarget(self, action: #selector(setButtonAction), for: .touchUpInside)
        view.layer.cornerRadius = 10
        view.isUserInteractionEnabled = true
        return view
    }()
    
    private lazy var moreDetailsStackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.distribution = .fill
        stack.alignment = .center
        stack.spacing = 8
        stack.isUserInteractionEnabled = false
        return stack
    }()
    
    private lazy var linkIcon: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(systemName: "link")
        image.contentMode = .scaleAspectFill
        image.tintColor = .darkGray
        return image
    }()
    
    private lazy var moreDetailsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "MORE ABOUT THE CHARACTER"
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 14.0)
        label.isUserInteractionEnabled = false
        return label
    }()
    
    //MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
    
        setupNavigation()
        setupView()
        updateView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        checkingVoiceOver()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        applyAccessibility()
        voiceOverStatusDidChange()
        AnalyticsServices().selectedScreenView(screenName: "details_screen_view", screenClass: "DetailViewController")
    }
    
    //MARK: Methods
    
    @objc func setButtonAction() {
        viewModelDetail.setUrlButtonAction()
        print("cliquei")
    }
    
    
    private func updateView() {
        labelHeroName.text = viewModelDetail.setupLabelNameText()
        let url = viewModelDetail.setupImageUrlString()
        guard let imageURL = URL(string: url) else { return }
        if let data = try? Data(contentsOf: imageURL) {
        let image = UIImage(data: data)
            imageDetail.image = image
        }
        labelComics.text = viewModelDetail.setupLabelComicsText()
        labelSeries.text = viewModelDetail.setupLabelSeriesText()
    }
    
    private func applyAccessibility() {
        guard let name = labelHeroName.text,
              let biographyTitle = labelTitleBiography.text,
              let biography = labelBiography.text,
              let comicsTitle = labelTitleComics.text,
              let comics = labelComics.text,
              let seriesTitle = labelTitleSeries.text,
              let series = labelSeries.text else { return }
        
        labelHeroName.accessibilityLabel = name
        labelHeroName.accessibilityTraits = .header
        labelBiography.accessibilityLabel = "\(biographyTitle) \(biography)"
        labelComics.accessibilityLabel = "\(comicsTitle) \(comics)"
        labelSeries.accessibilityLabel = "\(seriesTitle) \(series)"
        clickableDetailsView.isAccessibilityElement = true
        clickableDetailsView.accessibilityLabel = "More about the character"
        clickableDetailsView.accessibilityTraits = .link
        clickableDetailsView.accessibilityHint = "Double click for more information about the character"
    }
    
    func checkingVoiceOver() {
        if UIAccessibility.isVoiceOverRunning {
            imageDetail.isHidden = true
        } else {
            imageDetail.isHidden = false
        }
    }
    
    func voiceOverStatusDidChange() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(changedVoiceOverStatus),
                                               name: UIAccessibility.voiceOverStatusDidChangeNotification,
                                               object: nil)
    }
    
    @objc private func changedVoiceOverStatus() {
        checkingVoiceOver()
        self.view.layoutIfNeeded()
    }
    
    private func setupGradient(_ image: UIImageView) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor(red: 32/255.0, green: 32/255.0, blue: 32/255.0, alpha: 1.0).withAlphaComponent(1.0).cgColor,UIColor.black.withAlphaComponent(0.0).cgColor]
        let tamanho = CGRect(x: 0, y: 0, width: 500, height: 375)
        gradientLayer.frame = tamanho
        gradientLayer.startPoint = CGPoint(x: 0.97, y: 0.97)
        gradientLayer.endPoint = CGPoint(x: 0.97, y: 0.0)
        image.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    private func setupView() {
        view.backgroundColor = UIColor(red: 32/255.0, green: 32/255.0, blue: 32/255.0, alpha: 1.0)
        
        view.addSubview(scrollView)
        scrollView.addSubview(imageDetail)
        scrollView.addSubview(stackView)
        stackView.addArrangedSubview(labelHeroName)
        stackView.addArrangedSubview(labelTitleBiography)
        stackView.addArrangedSubview(labelBiography)
        stackView.addArrangedSubview(labelTitleComics)
        stackView.addArrangedSubview(labelComics)
        stackView.addArrangedSubview(labelTitleSeries)
        stackView.addArrangedSubview(labelSeries)
        stackView.addArrangedSubview(clickableDetailsView)
        clickableDetailsView.addSubview(moreDetailsStackView)
        moreDetailsStackView.addArrangedSubview(linkIcon)
        moreDetailsStackView.addArrangedSubview(moreDetailsLabel)
        stackView.setCustomSpacing(32, after: clickableDetailsView)
        setupGradient(imageDetail)
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            imageDetail.topAnchor.constraint(equalTo: scrollView.topAnchor),
            imageDetail.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 0),
            imageDetail.rightAnchor.constraint(equalTo: scrollView.rightAnchor, constant: 0),
            imageDetail.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            imageDetail.heightAnchor.constraint(equalToConstant: 375.0),
            
            stackView.topAnchor.constraint(equalTo: imageDetail.bottomAnchor),
            stackView.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 24),
            stackView.rightAnchor.constraint(equalTo: scrollView.rightAnchor, constant: -24),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            
            labelHeroName.heightAnchor.constraint(equalToConstant: 49.0),
            labelTitleBiography.heightAnchor.constraint(equalToConstant: 36.0),
            labelTitleComics.heightAnchor.constraint(equalToConstant: 36.0),
            labelTitleSeries.heightAnchor.constraint(equalToConstant: 36.0),
            
            moreDetailsStackView.topAnchor.constraint(equalTo: clickableDetailsView.topAnchor, constant: 8),
            moreDetailsStackView.leftAnchor.constraint(equalTo: clickableDetailsView.leftAnchor, constant: 8),
            moreDetailsStackView.rightAnchor.constraint(equalTo: clickableDetailsView.rightAnchor, constant: -8),
            moreDetailsStackView.bottomAnchor.constraint(equalTo: clickableDetailsView.bottomAnchor, constant: -8),
            
            linkIcon.heightAnchor.constraint(equalToConstant: 24),
            linkIcon.widthAnchor.constraint(equalToConstant: 24)
        ])
    }
}

