//
//  PokemonTableViewCell.swift
//  Pokedex
//
//  Created by Pasquale Vitulli on 01/05/21.
//

import UIKit

class PokemonTableViewCell: UITableViewCell {
    
    // ˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜
    //    MARK: - View
    // \_____________________________________________________________________/
    lazy var pokemonImageView : UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFit
        img.translatesAutoresizingMaskIntoConstraints = false
        img.clipsToBounds = true
        return img
    }()
    
    lazy var nameLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.layer.cornerRadius = 20
        return view
    }()
    
    // ˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜
    //    MARK: - Life cycle
    // \_____________________________________________________________________/
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // ˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜
    //    MARK: - Public var
    // \_____________________________________________________________________/
    var pokemon: PokemonViewModel? {
        didSet {
            guard let pokemonItem = pokemon else {return}
            nameLabel.text = pokemonItem.name.capitalizingFirstLetter()
            pokemonImageView.image = pokemonItem.image
            containerView.backgroundColor = self.pokemon?.color
            
            pokemon?.bindImageToView = { [weak self] in
                DispatchQueue.main.async {
                    self?.tableView?.reloadData()
                }
            }
            
            pokemon?.bindColorToView = { [weak self] in
                // BINDED WITH IMAGE
            }
        }
    }
    
    // ˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜
    //    MARK: - Private Methods
    // \_____________________________________________________________________/
    private func setupView() {
        self.selectionStyle = .none
        self.contentView.backgroundColor = .white
        
        self.contentView.addSubview(containerView)
        
        containerView.centerXAnchor.constraint(equalTo:self.contentView.centerXAnchor).isActive = true
        containerView.leadingAnchor.constraint(equalTo:self.contentView.leadingAnchor, constant:15).isActive = true
        containerView.bottomAnchor.constraint(equalTo:self.contentView.bottomAnchor, constant:-15).isActive = true
        containerView.topAnchor.constraint(equalTo:self.contentView.topAnchor, constant:15).isActive = true
        containerView.trailingAnchor.constraint(equalTo:self.contentView.trailingAnchor, constant:-15).isActive = true
        
        self.containerView.addSubview(pokemonImageView)
        self.containerView.addSubview(nameLabel)
        
        nameLabel.leadingAnchor.constraint(equalTo:self.containerView.leadingAnchor, constant:15).isActive = true
        nameLabel.bottomAnchor.constraint(equalTo:self.containerView.bottomAnchor, constant:15).isActive = true
        nameLabel.centerYAnchor.constraint(equalTo:self.pokemonImageView.centerYAnchor).isActive = true
        
        pokemonImageView.centerYAnchor.constraint(equalTo:self.containerView.centerYAnchor).isActive = true
        pokemonImageView.topAnchor.constraint(equalTo:self.containerView.topAnchor, constant:0).isActive = true
        pokemonImageView.trailingAnchor.constraint(equalTo:self.containerView.trailingAnchor, constant:-20).isActive = true
        pokemonImageView.bottomAnchor.constraint(equalTo:self.containerView.bottomAnchor, constant:0).isActive = true
        pokemonImageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
    }

}
