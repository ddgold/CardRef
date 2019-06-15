//
//  CardViewController.swift
//  CardRef
//
//  Created by Doug Goldstein on 6/15/19.
//  Copyright © 2019 Doug Goldstein. All rights reserved.
//

import UIKit

class CardViewController: UITableViewController {
    
    private var strings = [String]()
    
    var card: Card? {
        didSet
        {
            navigationItem.title = card?.name
            updateStrings()
        }
    }
    
    
    init() {
        super.init(style: .plain)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.backgroundView?.backgroundColor = .white
        
        tableView.allowsSelection = false
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cardLineCell")
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        assert(section == 0)
        
        return strings.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        assert(indexPath.row < strings.count)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cardLineCell", for: indexPath)
        
        cell.textLabel?.text = strings[indexPath.row]
        
        return cell
    }
    
    //MARK: - Private Functions
    private func updateStrings() {
        strings = []
        
        guard let card = self.card else {
            return
        }
        
        strings.append(card.name)
        strings.append(card.manaCost ?? "No cost")
        strings.append(card.typeLine)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
