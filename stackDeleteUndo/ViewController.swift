//
//  ViewController.swift
//  stackDeleteUndo
//
//  Created by Darko Dujmovic on 24/05/2019.
//  Copyright © 2019 Darko Dujmovic. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var products = ["Fireball","Beer","Coke","Fanta"]
    var deletedItemsStack = DeletedItemsStack()
    
    let undoBtn = UIButton()
    var undoTimer:Timer?
    
    func configureUndoButton(){
        self.tableView.addSubview(undoBtn)
        undoBtn.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            undoBtn.topAnchor.constraint(equalTo: tableView.safeAreaLayoutGuide.topAnchor, constant: 20),
            undoBtn.widthAnchor.constraint(equalToConstant: 70),
            undoBtn.heightAnchor.constraint(equalToConstant: 30),
            undoBtn.centerXAnchor.constraint(equalTo: self.tableView.centerXAnchor)
            ])
        
        undoBtn.backgroundColor = .gray
        undoBtn.setTitle("Undo", for: .normal)
        undoBtn.layer.cornerRadius = 11
        
        undoBtn.addTarget(self, action: #selector(undoAction), for: .touchUpInside)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUndoButton()
        undoBtn.isHidden = true
        
    }
    
 
    func showUndoButton(){
        if !undoBtn.isHidden { return }
        self.undoBtn.isHidden = false
        resetUndoTimer()
    }
    
    @objc
    func undoAction(){
        guard let lastDeletedItem = deletedItemsStack.pop() else { return }
        products.insert(lastDeletedItem.name, at: lastDeletedItem.index)
        tableView.reloadData()
        resetUndoTimer()
    }
    
    func resetUndoTimer(){
        undoTimer?.invalidate()
        undoTimer = Timer.scheduledTimer(withTimeInterval: 4, repeats: false, block: {_ in
            self.undoBtn.isHidden = true
        })
    }


}

extension ViewController:UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! UITableViewCell
        
        cell.textLabel?.text = products[indexPath.row]
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        deletedItemsStack.push(CustomObject(name: self.products[indexPath.row], index: indexPath.row))
        self.products.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .right)
        showUndoButton()
    }
}
