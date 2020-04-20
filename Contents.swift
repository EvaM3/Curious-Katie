import UIKit
import  Foundation

// Declaring a Player struct with 2 String constants, and one array(variable)
struct Player : Codable {
    let name: String
    let age: Int
    let location: String
    var interests: [Interest]
}
// Declaring an other struct Interest, with two constants.
struct Interest : Codable {
    let title: String
    let description: String
}

// Struct declared(defined) with two name constants,resulting Strings, and a constant resulting Integers, for the reason to store two different players and their matching results.
struct PlayerMatch : Codable {
    let  name1: String
    let name2: String
    let match: Int
}

var playersJsonString = String()
do {                                     // With optional error handling we try to (return) get the file URL for the resource named and file extension.
    guard let fileURL = Bundle.main.url(forResource: "players", withExtension: "json") else {
        fatalError()
    }
    try playersJsonString = String(contentsOf: fileURL)
} catch {
    print("Opening the file failed.")                        // In the case it fails, it will print the message.
}

let jsonData = playersJsonString.data(using: .utf8)!    // Force unwrapping  for getting the data from the playerJsonstring, resulting in the constant named jsonData.
var playerCandidates =  try! JSONDecoder().decode([Player].self, from: jsonData).shuffled()    //We use the decoder to decode the JSON data and then we shuffle them.

let playerCount = Int.random(in: 1...playerCandidates.count / 2) * 2         //With the constant playerCount we randomly generate 2 players from our playerCandidates.
let allPlayers = playerCandidates[..<playerCount]                        //With the allPlayers constant we get the number of players.
print("The number of players is:\(allPlayers.count)")                       //The number of players is printed.

func countMatches(player1: Player, player2: Player) -> Int {           //Declaring a function to compare 2 Players interests, returns count of matching interest.
    var match = 0   // match set to 0.
    
    for interest in player1.interests {   // Declaring a for(nested) loop matching the players interest, where with the match variable each equal interest will add one to match
        for interestPerson2 in player2.interests {
            if interest.title == interestPerson2.title {
                match = match + 1
            }
        }
    }
    
    print("Our players are: \(player1.name) and \(player2.name),their matching interest count :\(match)")           // Will print out two players  matching count.
    
    return match // returns match counting results
}
var matchResults = [PlayerMatch]()    // Created a new array to store the matching results.

for i in 0...allPlayers.count - 2  {               /* Creating indexes for all players excluding the last one */
    let player1 = allPlayers[i]
    for k in i + 1...allPlayers.count - 1 {          // Creating an index range from next to i until the last one.
        let player2 = allPlayers[k]                      // Giving back the player at k.
        let match = countMatches(player1: player1, player2: player2)   // Call the comparing method, function.
        let matchResult = PlayerMatch.init(name1:player1.name , name2: player2.name, match: match) // Creating the Players matching result.
        
        matchResults.append(matchResult)//Add matching result.
    }
}

var sortedMatches = matchResults.sorted(by: {$0.match < $1.match})       // The sortedMatches variable sorts out the matchResults array using shorthand syntax.
var selectedPlayersCounter = 0                                                           // Counter is set to zero.
var matchedNames = [String]()                                // Creating an empty array for the chosen players.
print("Starting the pairing:")
for matchedPair in sortedMatches {
    if matchedNames.contains(matchedPair.name1) || matchedNames.contains(matchedPair.name2) {      // If the names are paired, skip it.
        continue
    }
    print("The player \(matchedPair.name1) is paired with: \(matchedPair.name2)")                                 // Prints out the matches.
    selectedPlayersCounter += 2
    matchedNames.append(matchedPair.name1)                                 // The chosen players names will be added into the matchedNames array.
    matchedNames.append(matchedPair.name2)
    
    
    if allPlayers.count == selectedPlayersCounter {              // When all players have been chosen, break statement will be used to immediately end the execution of the loop.
        break
    } 
    
}















