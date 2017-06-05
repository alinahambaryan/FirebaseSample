//
//  ViewController.swift
//  Sample
//
//  Created by ALINA HAMBARYAN on 6/5/17.
//  Copyright © 2017 ALINA HAMBARYAN. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase

class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    fileprivate var dataSource : [Quote] = []
    
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Auth.auth().signInAnonymously() { [weak self] (user, error) in
            if !(error != nil) {
                self?.fetchQuotes()
            }
        }
    }
    
    func fetchQuotes() {
        let refArtists = Database.database().reference().child("list");
        refArtists.observe(DataEventType.value, with: { (snapshot) in
            self.dataSource.removeAll()
            
            if snapshot.childrenCount > 0 {
                for quotes in snapshot.children.allObjects as! [DataSnapshot] {
                    let quoteObject = quotes.value as? [String: AnyObject]
                    let title : String = quoteObject?["title"] as! String
                    let details : String  = (quoteObject?["details"]) as! String
                    let quote = Quote(title: title , details: details)
                    self.dataSource.append(quote)
                }
                self.tableView.reloadData()
            }
        })
    }
}
extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuoteCell", for: indexPath)
        let quote = self.dataSource[indexPath.row]
        cell.textLabel?.text = quote.title
        cell.detailTextLabel?.text = quote.details
        return cell
    }
}
