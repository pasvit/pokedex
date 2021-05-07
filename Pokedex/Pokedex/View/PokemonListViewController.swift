//
//  ViewController.swift
//  Pokedex
//
//  Created by Pasquale Vitulli on 01/05/21.
//

import UIKit

class PokemonListViewController: UIViewController {
    
    // ˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜
    //    MARK: - View
    // \_____________________________________________________________________/
    let pokemonsTableView = UITableView()
    var refreshControl = UIRefreshControl()
    let searchController = UISearchController(searchResultsController: nil)
    
    // ˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜
    //    MARK: - Private Var
    // \_____________________________________________________________________/
    private var pokemonListVM: PokemonListViewModel?
    private var pokemonsVM: [PokemonViewModel]? {
        pokemonListVM?.pokemons
    }
    private var pokemonsLoaded: Int? {
        return pokemonsVM?.count
    }
    
    // filter
    private var filteredPokemons: [PokemonViewModel] = []
    private var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    private var isFiltering: Bool {
        return searchController.isActive && !isSearchBarEmpty
    }
    
    // ˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜
    //    MARK: - Life cycle
    // \_____________________________________________________________________/
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setUpNavigation()
        setUpSearchController()
        
        callToViewModelForUIUpdate()
    }
    
    // ˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜
    //    MARK: - Private Methods
    // \_____________________________________________________________________/
    private func callToViewModelForUIUpdate() {
        self.pokemonListVM = PokemonListViewModel()
        self.pokemonListVM?.bindPokedexToView = { [weak self] in
            DispatchQueue.main.async {
                self?.pokemonsTableView.reloadData()
                if let pokemonsLoaded = self?.pokemonsLoaded {
                    self?.navigationItem.title = "Pokedex" + "  \(pokemonsLoaded)"
                }
            }
        }
        self.pokemonListVM?.bindStateToView = { [weak self] in
            DispatchQueue.main.async {
                if let error = self?.pokemonListVM?.state.errorDescription {
                    UIAlertController.showError(message: error)
                }
                if let isPokedexCompleted = self?.pokemonListVM?.state.isPokedexCompleted {
                    if isPokedexCompleted { self?.pokemonsTableView.tableFooterView?.isHidden = true }
                }
            }
        }
    }
    
    private func setupTableView() {
        pokemonsTableView.backgroundColor = .white
        pokemonsTableView.dataSource = self
        pokemonsTableView.delegate = self
        pokemonsTableView.estimatedRowHeight = 140
        pokemonsTableView.separatorStyle = .none
        
        refreshControl.attributedTitle = NSAttributedString(string: "")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        pokemonsTableView.addSubview(refreshControl) // not required when using UITableViewController
        
        view.addSubview(pokemonsTableView)
        pokemonsTableView.constraint(to: self.view)
        
        pokemonsTableView.register(PokemonTableViewCell.self, forCellReuseIdentifier: "pokemonCell")
    }
    
    private func setUpNavigation() {
        navigationItem.title = "Pokedex"
        self.navigationController?.navigationBar.barTintColor = .primaryColor
    }
    
    private func setUpSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Pokemon Already Loaded"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    @objc private func refresh(_ sender: AnyObject) {
        if InternetConnectionManager.isConnectedToNetwork() {
            if let isLoading = self.pokemonListVM?.state.isLoading, !isLoading {
                CoreDataController.shared.reset() { [weak self] in
                    self?.callToViewModelForUIUpdate()
                }
            }
            self.refreshControl.endRefreshing()
        } else {
            UIAlertController.showError(title: "Info", message: "Turn on connection if you want to refresh pokemon") {
                self.refreshControl.endRefreshing()
            }
        }
    }
    
}

// ˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜
//    MARK: - TableView Data Source
// \___________________________________________/
extension PokemonListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filteredPokemons.count
        }
        return pokemonsVM?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var pokemon: PokemonViewModel?
        
        if isFiltering {
            pokemon = filteredPokemons[indexPath.row]
        } else if let pokemons = self.pokemonsVM, !pokemons.isEmpty {
            if pokemons.count >= indexPath.row {
                pokemon = pokemons[indexPath.row]
            }
        }
        
        if let pokemon = pokemon {
            let cell = tableView.dequeueReusableCell(withIdentifier: "pokemonCell", for: indexPath) as! PokemonTableViewCell
            cell.pokemon = pokemon
            return cell
        }
        
        return  UITableViewCell()
    }
}

// ˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜
//    MARK: - TableView Delegate
// \___________________________________________/
extension PokemonListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var pokemon: PokemonViewModel?
        
        if isFiltering {
            pokemon = filteredPokemons[indexPath.row]
        } else {
            pokemon = self.pokemonsVM?[indexPath.row]
        }
        
        guard let navigationController = self.navigationController, let pokemonVM = pokemon, pokemonVM.arePokemonDetailsCompleted else { return }
        let detailViewController = PokemonDetailViewController()
        detailViewController.pokemonVM = pokemonVM
        navigationController.pushViewController(detailViewController, animated: true)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let isReachingEnd = scrollView.contentOffset.y >= 0
            && scrollView.contentOffset.y >= (scrollView.contentSize.height - scrollView.frame.size.height)
        if let isPokedexCompleted = self.pokemonListVM?.isPokedexCompleted, isReachingEnd && !InternetConnectionManager.isConnectedToNetwork(), !isPokedexCompleted {
            UIAlertController.showError(title: "Info", message: "Turn on connection if you want to load more pokemon") {
                self.pokemonsTableView.tableFooterView?.isHidden = true
            }
        }
        
        if let pokemon = self.pokemonsVM?.last, !self.refreshControl.isRefreshing {
            if InternetConnectionManager.isConnectedToNetwork() {
                self.pokemonListVM?.loadMorePokemonsIfNeeded(currentPokemon: pokemon)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let isPokedexCompleted = self.pokemonListVM?.isPokedexCompleted, !isFiltering && InternetConnectionManager.isConnectedToNetwork() && !isPokedexCompleted {
            let lastSectionIndex = tableView.numberOfSections - 1
            let lastRowIndex = tableView.numberOfRows(inSection: lastSectionIndex) - 1
            if indexPath.section ==  lastSectionIndex && indexPath.row == lastRowIndex {
                
                let spinner = UIActivityIndicatorView(style: .gray)
                spinner.startAnimating()
                spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.bounds.width, height: CGFloat(44))
                
                self.pokemonsTableView.tableFooterView = spinner
                self.pokemonsTableView.tableFooterView?.isHidden = false
            }
        }
    }
}

// ˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜
//    MARK: - UISearchResultsUpdating Delegate
// \___________________________________________/
extension PokemonListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        self.pokemonsTableView.tableFooterView?.isHidden = true
        let searchBar = searchController.searchBar
        filterContentForSearchText(searchBar.text!)
    }
    
    func filterContentForSearchText(_ searchText: String,
                                    pokemon: Pokemon? = nil) {
        filteredPokemons = pokemonsVM?.filter({ pokemonVM in
            return pokemonVM.name.lowercased().contains(searchText.lowercased())
        }) ?? []
        
        pokemonsTableView.reloadData()
    }
}
