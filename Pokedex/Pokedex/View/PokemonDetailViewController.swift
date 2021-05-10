//
//  PokemonDetailViewController.swift
//  Pokedex
//
//  Created by Pasquale Vitulli on 01/05/21.
//

import UIKit

class PokemonDetailViewController: UIViewController {
    
    // ˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜
    //    MARK: - View
    // \___________________________________________/
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var pokemonImageView: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFit
        img.translatesAutoresizingMaskIntoConstraints = false
        img.clipsToBounds = true
        img.layer.cornerRadius = 70
        img.backgroundColor = .white
        img.layer.masksToBounds = false
        img.layer.shadowOffset = CGSize(width: 0, height: 10)
        img.layer.shadowColor = UIColor.black.cgColor
        img.layer.shadowRadius = 10
        img.layer.shadowOpacity = 0.25
        return img
    }()
    
    lazy var statsTitleLabel: UILabel = {
        let statsTitleLabel = UILabel()
        statsTitleLabel.text = "STATS"
        statsTitleLabel.font = UIFont.boldSystemFont(ofSize: 25)
        statsTitleLabel.textColor = .black
        statsTitleLabel.textAlignment = .center
        return statsTitleLabel
    }()
    
    lazy var containerStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [statsTitleLabel])
        stackView.distribution = .fillProportionally
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.layer.cornerRadius = 20
        stackView.layer.masksToBounds = false
        stackView.layoutMargins = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.backgroundColor = .white
        return stackView
    }()
    
    lazy var statsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fillEqually
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.backgroundColor = .white.withAlphaComponent(0.95)
        stackView.layer.cornerRadius = 20
        stackView.layer.masksToBounds = false
        stackView.layoutMargins = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()
    
    lazy var statsLabelStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: getStatsLabels())
        stackView.distribution = .fillProportionally
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.backgroundColor = .white.withAlphaComponent(0.95)
        stackView.layer.cornerRadius = 20
        stackView.layer.masksToBounds = false
        stackView.layoutMargins = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()
    
    lazy var statsSliderStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: getStatsSliders())
        stackView.distribution = .fillProportionally
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.backgroundColor = .white.withAlphaComponent(0.95)
        stackView.layer.cornerRadius = 20
        stackView.layer.masksToBounds = false
        stackView.layoutMargins = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()
    
    lazy var typesStackView: UIStackView = {
        var labels: [UILabel] = []
        
        pokemonVM?.types.forEach({ stat in
            let label = UILabel()
            label.text = stat.capitalizingFirstLetter()
            label.font = UIFont.systemFont(ofSize: 18)
            label.textAlignment = .center
            label.textColor = .black
            label.backgroundColor = .white.withAlphaComponent(0.8)
            label.layer.cornerRadius = 10
            label.layer.masksToBounds = true
            
            labels.append(label)
        })
        
        let stackView = UIStackView(arrangedSubviews: labels)
        stackView.distribution = .fillProportionally
        stackView.spacing = 5
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    // ˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜
    //    MARK: - Private Var
    // \___________________________________________/
    var pokemonVM: PokemonViewModel? {
        didSet {
            guard let pokemonItem = pokemonVM else {return}
            pokemonItem.bindImageToView = { [weak self] in
                DispatchQueue.main.async {
                    self?.pokemonImageView.image = self?.pokemonVM?.image
                }
            }
        }
    }
    
    // ˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜
    //    MARK: - Life cycle
    // \_____________________________________________________________________/
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigation()
        setupView()
        
        self.pokemonAppearsAnimation()
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3) {
            self.pokemonImageView.layer.removeAllAnimations()
        }
    }
    
    private func setUpNavigation() {
        navigationItem.title = "Pokemon"
    }
    
    private func setupView() {
        self.view.backgroundColor = pokemonVM?.color
        
        self.view.addSubview(nameLabel)
        
        nameLabel.text = pokemonVM?.name.capitalizingFirstLetter()
        
        nameLabel.topAnchor.constraint(equalTo:view.safeAreaLayoutGuide.topAnchor, constant:25).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo:view.leadingAnchor, constant:20).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo:view.trailingAnchor, constant:-20).isActive = true
        
        self.view.addSubview(pokemonImageView)
        
        pokemonImageView.image = pokemonVM?.image
        
        NSLayoutConstraint.activate([
            pokemonImageView.topAnchor.constraint(equalTo:nameLabel.topAnchor, constant:35),
            pokemonImageView.centerXAnchor.constraint(equalTo:view.centerXAnchor, constant: 15),
            pokemonImageView.widthAnchor.constraint(equalToConstant: 140),
            pokemonImageView.heightAnchor.constraint(equalToConstant: 140),
        ])
        
        self.view.addSubview(typesStackView)
        
        let typesStackViewHeight = pokemonVM?.types.count == 1 ? 30 : 60
        NSLayoutConstraint.activate([
            typesStackView.topAnchor.constraint(equalTo:pokemonImageView.topAnchor, constant:5),
            typesStackView.leadingAnchor.constraint(equalTo:view.leadingAnchor, constant:20),
            typesStackView.widthAnchor.constraint(equalToConstant:80),
            typesStackView.heightAnchor.constraint(equalToConstant:CGFloat(typesStackViewHeight)),
        ])
        
        self.view.addSubview(containerStackView)
        self.view.sendSubviewToBack(containerStackView)
        
        NSLayoutConstraint.activate([
            containerStackView.topAnchor.constraint(equalTo: pokemonImageView.bottomAnchor, constant:-10),
            containerStackView.topAnchor.constraint(equalTo:pokemonImageView.bottomAnchor, constant:20),
            containerStackView.leadingAnchor.constraint(equalTo:view.leadingAnchor, constant:10),
            containerStackView.trailingAnchor.constraint(equalTo:view.trailingAnchor, constant:-10),
            containerStackView.bottomAnchor.constraint(equalTo:view.safeAreaLayoutGuide.bottomAnchor, constant:-20),
        ])
        
        containerStackView.addArrangedSubview(statsTitleLabel)
        containerStackView.addArrangedSubview(statsStackView)
        
        statsStackView.addArrangedSubview(statsLabelStackView)
        statsStackView.addArrangedSubview(statsSliderStackView)
    }
    
    private func getStatsLabels() -> [UILabel] {
        var labels: [UILabel] = []
        
        pokemonVM?.stats.forEach({ stat in
            let label = UILabel()
            label.text = stat.name.uppercased()
            label.font = UIFont.italicSystemFont(ofSize: 16)
            label.textColor = .black
            labels.append(label)
        })
        
        return labels
    }
    
    private func getStatsSliders() -> [UISlider] {
        var sliders: [UISlider] = []
        
        pokemonVM?.stats.forEach({ stat in
            let slider = UISlider()
            slider.isUserInteractionEnabled = false
            slider.thumbTintColor = .clear
            slider.tintColor = .systemGreen
            slider.minimumValue = 0
            slider.maximumValue = 160
            slider.value = Float(stat.baseStat)
            sliders.append(slider)
        })
        
        return sliders
    }
    
    private func pokemonAppearsAnimation() {
        UIView.animate(withDuration: 0.5, delay: 0.2, options: [.autoreverse, .repeat, .curveEaseInOut], animations: {
            self.pokemonImageView.transform = CGAffineTransform(translationX: 0, y: -20)
        }) { _ in
            self.pokemonImageView.transform = .identity
        }
    }
}
