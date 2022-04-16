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
    
    
    var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fill
        return stackView
    }()
    
    var viewImage: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var viewHeroName: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var viewBiographyTitle: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var viewBiography: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var viewComicsTitle: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var viewComicsList: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var viewSeriesTitle: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    var viewSeriesList: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var viewMoreInfosTitle: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var viewButton: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var imageDetail: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        let url = viewModelDetail.setupImageUrlString()
        let heroUrlImage = URL(string: url)
                image.kf.setImage(with: heroUrlImage,
                                               placeholder: UIImage(named: "placeholder"),
                                               options: [
                                                .cacheOriginalImage
                                               ],
                                               progressBlock: nil,
                                               completionHandler: nil)
        self.setupGradient(image)
        
        return image
    }()
    
    lazy var labelHeroName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 23.0)
        label.isAccessibilityElement = true
        
        var labelText = viewModelDetail.setupLabelNameText()
        label.text = labelText
        
        return label
    }()
    
    lazy var labelTitleBiography: UILabel = {
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
        
        var labelText = viewModelDetail.setupLabelDescriptionText()
        label.text = labelText
        
        return label
    }()
    
    lazy var labelTitleComics: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 15.0)
        label.text = "COMICS"
        label.isAccessibilityElement = false
        return label
    }()
    
    lazy var labelComics: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 14.0)
        label.numberOfLines = 0
        label.isAccessibilityElement = true
        
        var labelText = viewModelDetail.setupLabelComicsText()
        label.text = labelText
        
        return label
    }()
    
    lazy var labelTitleSeries: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 15.0)
        label.text = "SERIES"
        label.isAccessibilityElement = false
        return label
    }()
    
    lazy var labelSeries: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 14.0)
        label.numberOfLines = 0
        label.isAccessibilityElement = true
        
        var labelText = viewModelDetail.setupLabelSeriesText()
        label.text = labelText
        
        return label
    }()
    
    lazy var labelDetails: UILabel = {
        let image1Attachment = NSTextAttachment()
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.cornerRadius = 10
        label.addLeading(image: UIImage(systemName: "link") ?? UIImage(), text: "  MORE ABOUT THE CHARACTER")
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 14.0)
        label.layer.backgroundColor = UIColor(red: 217/255.0, green: 56/255.0, blue: 50/255.0, alpha: 1.0).cgColor
        label.textAlignment = .center
        
        label.isAccessibilityElement = true
        
        return label
    }()
    
    //MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
    
        setupNavigation()
        setupView()
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
        self.viewModelDetail.setUrlButtonAction()
    }
    
    func applyAccessibility() {
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
        labelDetails.accessibilityLabel = "More about the character"
        labelDetails.accessibilityTraits = .link
        labelDetails.accessibilityHint = "Double click for more information about the character"
    }
    
    func checkingVoiceOver() {
        if UIAccessibility.isVoiceOverRunning {
            imageDetail.isHidden = true
            viewImage.isHidden = true
        } else {
            imageDetail.isHidden = false
            viewImage.isHidden = false
        }
    }
    
    func voiceOverStatusDidChange() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(changedVoiceOverStatus),
                                               name: UIAccessibility.voiceOverStatusDidChangeNotification,
                                               object: nil)
    }
    
    @objc func changedVoiceOverStatus() {
        checkingVoiceOver()
        self.view.layoutIfNeeded()
    }
    
    func setupGradient(_ image: UIImageView) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor(red: 32/255.0, green: 32/255.0, blue: 32/255.0, alpha: 1.0).withAlphaComponent(1.0).cgColor,UIColor.black.withAlphaComponent(0.0).cgColor]
        let tamanho = CGRect(x: 0, y: 0, width: 500, height: 375)
        gradientLayer.frame = tamanho
        gradientLayer.startPoint = CGPoint(x: 0.97, y: 0.97)
        gradientLayer.endPoint = CGPoint(x: 0.97, y: 0.0)
        image.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func setupView() {
        view.backgroundColor = UIColor(red: 32/255.0, green: 32/255.0, blue: 32/255.0, alpha: 1.0)
        
        self.view.addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    
        scrollView.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        
        stackView.addArrangedSubview(viewImage)
        NSLayoutConstraint.activate([
            self.viewImage.heightAnchor.constraint(equalToConstant: 375.0)
        ])
       
        viewImage.addSubview(imageDetail)
        NSLayoutConstraint.activate([
            self.imageDetail.topAnchor.constraint(equalTo: viewImage.topAnchor),
            self.imageDetail.leftAnchor.constraint(equalTo: viewImage.leftAnchor),
            self.imageDetail.rightAnchor.constraint(equalTo: viewImage.rightAnchor),
            self.imageDetail.bottomAnchor.constraint(equalTo: viewImage.bottomAnchor),
            self.imageDetail.heightAnchor.constraint(equalToConstant: 375.0)
        ])
        
        stackView.addArrangedSubview(viewHeroName)
        NSLayoutConstraint.activate([
            self.viewHeroName.heightAnchor.constraint(equalToConstant: 49.0)
        ])
        
        viewHeroName.addSubview(labelHeroName)
        NSLayoutConstraint.activate([
            self.labelHeroName.topAnchor.constraint(equalTo: viewHeroName.topAnchor, constant: 8.0),
            self.labelHeroName.leftAnchor.constraint(equalTo: viewHeroName.leftAnchor, constant: 28.0),
            self.labelHeroName.rightAnchor.constraint(equalTo: viewHeroName.rightAnchor, constant: -28.0),
            self.labelHeroName.bottomAnchor.constraint(equalTo: viewHeroName.bottomAnchor)
        ])
        
        stackView.addArrangedSubview(viewBiographyTitle)
        NSLayoutConstraint.activate([
            self.viewBiographyTitle.heightAnchor.constraint(equalToConstant: 36.0)
        ])
        
        viewBiographyTitle.addSubview(labelTitleBiography)
        NSLayoutConstraint.activate([
            self.labelTitleBiography.topAnchor.constraint(equalTo: viewBiographyTitle.topAnchor, constant: 16),
            self.labelTitleBiography.leftAnchor.constraint(equalTo: viewBiographyTitle.leftAnchor, constant: 24.0),
            self.labelTitleBiography.rightAnchor.constraint(equalTo: viewBiographyTitle.rightAnchor, constant: -24.0),
            self.labelTitleBiography.bottomAnchor.constraint(equalTo: viewBiographyTitle.bottomAnchor)
        ])
        
        stackView.addArrangedSubview(viewBiography)
        
        viewBiography.addSubview(labelBiography)
        NSLayoutConstraint.activate([
            self.labelBiography.topAnchor.constraint(equalTo: viewBiography.topAnchor, constant: 8.0),
            self.labelBiography.leftAnchor.constraint(equalTo: viewBiography.leftAnchor, constant: 24.0),
            self.labelBiography.rightAnchor.constraint(equalTo: viewBiography.rightAnchor, constant: -24.0),
            self.labelBiography.bottomAnchor.constraint(equalTo: viewBiography.bottomAnchor)
        ])
        
        stackView.addArrangedSubview(viewComicsTitle)
        NSLayoutConstraint.activate([
            self.viewComicsTitle.heightAnchor.constraint(equalToConstant: 36.0)
        ])
        
        viewBiographyTitle.addSubview(labelTitleComics)
        NSLayoutConstraint.activate([
            self.labelTitleComics.topAnchor.constraint(equalTo: viewComicsTitle.topAnchor, constant: 16),
            self.labelTitleComics.leftAnchor.constraint(equalTo: viewComicsTitle.leftAnchor, constant: 24.0),
            self.labelTitleComics.rightAnchor.constraint(equalTo: viewComicsTitle.rightAnchor, constant: -24.0),
            self.labelTitleComics.bottomAnchor.constraint(equalTo: viewComicsTitle.bottomAnchor)
        ])
        
        stackView.addArrangedSubview(viewComicsList)
        
        viewBiography.addSubview(labelComics)
        NSLayoutConstraint.activate([
            self.labelComics.topAnchor.constraint(equalTo: viewComicsList.topAnchor, constant: 8.0),
            self.labelComics.leftAnchor.constraint(equalTo: viewComicsList.leftAnchor, constant: 24.0),
            self.labelComics.rightAnchor.constraint(equalTo: viewComicsList.rightAnchor, constant: -24.0),
            self.labelComics.bottomAnchor.constraint(equalTo: viewComicsList.bottomAnchor)
        ])
        
        stackView.addArrangedSubview(viewSeriesTitle)
        NSLayoutConstraint.activate([
            self.viewSeriesTitle.heightAnchor.constraint(equalToConstant: 36.0)
        ])
        
        viewBiographyTitle.addSubview(labelTitleSeries)
        NSLayoutConstraint.activate([
            self.labelTitleSeries.topAnchor.constraint(equalTo: viewSeriesTitle.topAnchor, constant: 16.0),
            self.labelTitleSeries.leftAnchor.constraint(equalTo: viewSeriesTitle.leftAnchor, constant: 24.0),
            self.labelTitleSeries.rightAnchor.constraint(equalTo: viewSeriesTitle.rightAnchor, constant: -24.0),
            self.labelTitleSeries.bottomAnchor.constraint(equalTo: viewSeriesTitle.bottomAnchor)
        ])
        
        stackView.addArrangedSubview(viewSeriesList)
        
        viewBiography.addSubview(labelSeries)
        NSLayoutConstraint.activate([
            self.labelSeries.topAnchor.constraint(equalTo: viewSeriesList.topAnchor, constant: 8.0),
            self.labelSeries.leftAnchor.constraint(equalTo: viewSeriesList.leftAnchor, constant: 24.0),
            self.labelSeries.rightAnchor.constraint(equalTo: viewSeriesList.rightAnchor, constant: -24.0),
            self.labelSeries.bottomAnchor.constraint(equalTo: viewSeriesList.bottomAnchor)
        ])
        
        stackView.addArrangedSubview(viewButton)

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(setButtonAction))
        viewButton.addGestureRecognizer(tapGesture)

        viewBiographyTitle.addSubview(labelDetails)
        NSLayoutConstraint.activate([
            self.labelDetails.topAnchor.constraint(equalTo: viewButton.topAnchor, constant: 8.0),
            self.labelDetails.bottomAnchor.constraint(equalTo: viewButton.bottomAnchor),
            self.labelDetails.leftAnchor.constraint(equalTo: viewButton.leftAnchor, constant: 24.0),
            self.labelDetails.rightAnchor.constraint(equalTo: viewButton.rightAnchor, constant: -24.0),
            self.labelDetails.heightAnchor.constraint(equalToConstant: 40.0)
        ])
    }
}

