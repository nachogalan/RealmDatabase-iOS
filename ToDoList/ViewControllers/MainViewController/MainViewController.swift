//
//  MainViewController.swift
//  ToDoList
//
//  Created by IGNACIO GALAN DE PINA on 19/12/18.
//  Copyright © 2018 IGNACIO GALAN DE PINA. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    internal var tasks: [Task] = []
    internal var repository = LocalTaskRepository()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCells()
        tasks = repository.getAll()
        title = "Mis Tareas"
        
        let addBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addPressed))
        navigationItem.setRightBarButton(addBarButtonItem, animated: false)
    }

    @objc internal func addPressed() {
        let addVC = AddViewController(task: nil)
        addVC.delegate = self
        addVC.modalTransitionStyle = .coverVertical
        addVC.modalPresentationStyle = .overCurrentContext
        present(addVC, animated: true, completion: nil)
    }
    
    internal func registerCells(){
        let nib = UINib(nibName: "TaskCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "TaskCell")
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}

extension MainViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: TaskCell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as! TaskCell
        let task = tasks[indexPath.row]
                
        cell.nameLabel.text = task.name
        cell.imgView.isHidden = !task.isDone
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let task = tasks[indexPath.row]
        task.isDone = !task.isDone
        if repository.update(a: task) {
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let task = tasks[indexPath.row]
            if repository.delete(a: task){
                tasks.remove(at: indexPath.row)
                tableView.beginUpdates()
                tableView.deleteRows(at: [indexPath], with: .automatic)
                tableView.endUpdates()
                
            }
        }
    }
    
    
}

extension MainViewController: AddViewControllerDelegate {
    func addViewController(_ vc: AddViewController, didEditTask task: Task) {
        vc.dismiss(animated: true, completion: nil)
        if repository.create(a: task) {
            tasks = repository.getAll()
            tableView.reloadData()
        }
    }
}
