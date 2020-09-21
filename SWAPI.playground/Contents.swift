import UIKit

struct Person: Decodable {
    
    let name: String
    let films: [URL]
    
}

struct Film: Decodable {
    
    let title: String
    let opening_crawl: String
    let release_date: String
    
}

class SwapiService {
    
    static private let baseURL = URL(string: "https://swapi.dev/api/")
    
    static func fetchPerson(id: Int, completion: @escaping (Person?) -> Void ) {
        
        guard let baseURL = baseURL else { return completion(nil) }
        let finalURL = baseURL.appendingPathComponent("people/\(id)")
        
        URLSession.shared.dataTask(with: finalURL) { (data, _, error) in
            if let error = error {
                print(error)
                completion(nil)
            }
            guard let data = data else { return completion(nil) }
            do {
                let person = try JSONDecoder().decode(Person.self, from: data)
                completion(person)
            } catch {
                print(error)
                print(error.localizedDescription)
            }
        }.resume()
    }
    
    static func fetchFilm(url: URL, completion: @escaping (Film?) -> Void ) {
        
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error {
                print(error)
                completion(nil)
            }
            guard let data = data else { return completion(nil) }
            do {
                let film = try JSONDecoder().decode(Film.self, from: data)
                completion(film)
            } catch {
                print(error)
                print(error.localizedDescription)
            }
        }.resume()
    }
    
}

func fetchFilm(url: URL) {
    SwapiService.fetchFilm(url: url) { (film) in
        if let film = film {
            print(film.title)
            print("-----------------------------")
            print(film.opening_crawl)
            print("\n\n\n")
        }
    }
}

SwapiService.fetchPerson(id: 1) { (person) in
    if let person = person {
        for filmURL in person.films {
            fetchFilm(url: filmURL)
        }
    }
}
