# Pokedex App
This app displays a list of Pokèmon with image and name.<br>
When the user selects a pokèmon, the app shows the detail with the Pokèmon name, images, stats and type.

### API
APIs available at: https://pokeapi.co

## Details
- Swift Version: 5
- iOS Deployment Target: 11
- Programmatically UI with UIKit
- No external libraries
- MVVM Pattern + State
- Loading of the pokemon list with automatic pagination on scrolling
- App work even offline
- Unit Test

## Implementation

### No External Libraries
I use external libraries only in case of real need. In this case I felt that writing totally native code was the best choice.

### MVVM Pattern + State
The MVVM pattern fits perfectly in apps of this type.<br>
The VM takes care of retrieving data (M) from the services and binds to the view (V).

The VM also has a State in order to quickly update the view in case of changes.

I created 2 view models:

1. **PokemonViewModel**
2. **PokemonListViewModel**

The first contains all the information to represent a pokemon while the second contains all the information to represent <br>the list of pokemon, therefore also an array of **PokemonViewModels**.

Specifically, **PokemonViewModel** binds to **PokemonTableViewCell**, which is the view that represents the pokemon in the<br> list.

While, **PokemonListViewModel** binds to the **PokemonListViewController** which contains the<br> list of pokemon.

Even in the event that an error or a change of state occurs such as the end of loading of other pokemon, the<br> **PokemonListViewModel** always binds on the view to update.

### Services
The **PokemonService** class takes care of making backend calls and getting data (M).

After analyzing the APIs, I have implemented 3 main backend calls.

1. *fetchPokemons* -> (Pokemon number, next page url and pokemon list)
2. *fetchPokemonDetails* -> (pokemon type and stats)
3. *fetchPokemonImageData* -> (Pokemon image data)<br>


1. I defined a baseUrl [https://pokeapi.co/api/v2/pokemon], which I invoked to get the total number of Pokemon, <br>the first Pokemon contained in the pokedex and the url to call to get the next pokemon.<br><br>
 This last data allowed me to implement **the loading of the pokemon list with automatic pagination on scroll**.<br> i.e. when the user scrolls the list to the last pokemon just loaded, a subsequent call to the backend will be invoked <br>to recover the following pokemon. The VM will take care of binding it to the view.
 <br><br> **Note:** Since it is possible to define the number of Pokemon to receive using an offset (default: 20) which can be <br>defined as query params, this can also be used to anticipate the recovery of subsequent pokemon.
<br><br>
2. I have got the pokemon details (type and stats) by invoking baseUrl + a path param like this:<br> [baseUrl + /{pokemon name}].
<br><br>
3. From the details it is possible to obtain the sprites objects containing the images of the pokemon. But since the URLs of the <br>main images are unique, just add a param path containing the pokemon's id to retrieve the image more quickly.<br> [https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon] + /{id.png}

Once the image has been retrieved, the binding of the VM to the view is done according to the logic described above.

### Offline Use 
To make the app work even offline, I chose to use *Core Data*, recommended by Apple for saving data locally.

I created 2 Entities in order to map the data contained in the **PokemonViewModel**:

1. *PokemonEntity* (types, imageData, name, id)
2. *PokemonStatEntity* (name, baseStat)

The relationship between entities *PokemonEntity* and *PokemonStatEntity* is one to many, because each pokemon has <br>multiple stats.

Each time a *fetchPokemons* is invoked, the pokemons are saved in the *Core Data* as a result.

So if the app is offline, the saved pokemon can be loaded.

In this way, even if the app is online, there is an increase in performance because the pokemon saved on *Core Data* <br>are loaded first and then, when the user scrolls, the others are loaded. Always if the total number of pokemon <br>hasn't been reached.

Finally, the only data that I have saved in the *UserDefaults* is the total number of pokemon in the pokedex, useful to <br>understand when the pokemon to load in the pokedex are finished and not attempt a new call to the backend.

### Online Use
When the app comes back online, to load the next pokemon, I reconstruct the url by setting the offset equal to the<br> number of pokemon currently loaded.


### Unit Test
I have implemented some unit tests to test the services, parts of the view and the business logic.<br> The tests certainly remain extensible.
<br><br>
### Search Pokemon
For searching already loaded pokemon, i have added a search bar at the top of the main view.

