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
        img.layer.cornerRadius = 100
        img.clipsToBounds = true
        img.backgroundColor = .white
        return img
    }()
    
    lazy var statsTitleLabel: UILabel = {
        let statsTitleLabel = UILabel()
        statsTitleLabel.text = "STATS"
        statsTitleLabel.font = UIFont.boldSystemFont(ofSize: 23)
        statsTitleLabel.textColor = .black
        statsTitleLabel.textAlignment = .center
        return statsTitleLabel
    }()
    
    lazy var statsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: getStatsLabels())
        stackView.distribution = .fillProportionally
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.backgroundColor = .white
        stackView.layer.cornerRadius = 20
        stackView.layer.masksToBounds = true
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
            label.backgroundColor = .white
            label.layer.cornerRadius = 10
            label.layer.masksToBounds = true
            
            labels.append(label)
        })
        
        let stackView = UIStackView(arrangedSubviews: labels)
        stackView.distribution = .fillProportionally
        stackView.spacing = 10
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    // ˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜
    //    MARK: - Private Var
    // \___________________________________________/
    private(set) var pokemonVM: PokemonViewModel?
    
    // ˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜
    //    MARK: - Life cycle
    // \_____________________________________________________________________/
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
    }
    
    init(pokemon: PokemonViewModel) {
        self.pokemonVM = pokemon
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigation()
        setupView()
    }
    
    private func setUpNavigation() {
        navigationItem.title = "Pokemon"
    }
    
    private func setupView() {
        self.view.backgroundColor = pokemonVM?.color
        
        self.view.addSubview(nameLabel)
        
        nameLabel.text = pokemonVM?.name.capitalizingFirstLetter()
        
        nameLabel.topAnchor.constraint(equalTo:view.safeAreaLayoutGuide.topAnchor, constant:35).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo:view.leadingAnchor, constant:20).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo:view.trailingAnchor, constant:-20).isActive = true
        
        self.view.addSubview(pokemonImageView)
        
        pokemonImageView.image = pokemonVM?.image
        
        NSLayoutConstraint.activate([
            pokemonImageView.topAnchor.constraint(equalTo:nameLabel.topAnchor, constant:30),
            pokemonImageView.trailingAnchor.constraint(equalTo:view.trailingAnchor, constant:-20),
            pokemonImageView.widthAnchor.constraint(equalToConstant:200),
            pokemonImageView.heightAnchor.constraint(equalToConstant:200),
        ])
        
        self.view.addSubview(typesStackView)
        
        NSLayoutConstraint.activate([
            typesStackView.topAnchor.constraint(equalTo:pokemonImageView.topAnchor, constant:20),
            typesStackView.leadingAnchor.constraint(equalTo:view.leadingAnchor, constant:20),
            typesStackView.widthAnchor.constraint(equalToConstant:80),
            typesStackView.heightAnchor.constraint(equalToConstant:65),
        ])
        
        self.view.addSubview(statsStackView)
        
        NSLayoutConstraint.activate([
            statsStackView.topAnchor.constraint(equalTo:pokemonImageView.bottomAnchor, constant:20),
            statsStackView.leadingAnchor.constraint(equalTo:view.leadingAnchor, constant:10),
            statsStackView.trailingAnchor.constraint(equalTo:view.trailingAnchor, constant:-10),
            statsStackView.bottomAnchor.constraint(equalTo:view.safeAreaLayoutGuide.bottomAnchor, constant:-40),
        ])
    }
    
    func getStatsLabels() -> [UILabel] {
        var labels: [UILabel] = [statsTitleLabel]
        
        pokemonVM?.stats.forEach({ stat in
            let label = UILabel()
            label.text = stat.name + ":  \(stat.baseStat)"
            label.font = UIFont.italicSystemFont(ofSize: 20)
            label.textColor = .black
            label.textAlignment = .center
            labels.append(label)
        })
        
        return labels
    }
    
}
