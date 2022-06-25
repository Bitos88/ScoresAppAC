//
//  ScoresTableViewController.swift
//  ScoresAPP
//
//  Created by Alberto Alegre Bravo on 31/5/22.
//

import UIKit


//MARK: FORMA CLÁSICA
final class ScoresTableViewController: UITableViewController {
    
    let modelLogic = ModelLogic.shared
    
    var myView: UIView!
    var showView = false

    @IBOutlet weak var sortButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureSortButton()

        // Uncomment the following line to preserve selection between presentations
         self.clearsSelectionOnViewWillAppear = false
        //MARK: PERMITE AÑADIR BOTÓN DE EDICIÓN
         self.navigationItem.leftBarButtonItem = self.editButtonItem
        
        NotificationCenter.default.addObserver(forName: .reloadNewData, object: nil, queue: .main) { [self] _ in
            tableView.reloadData()
            tableView.scrollToRow(at: IndexPath(row: modelLogic.scores.count - 1, section: 0), at: .bottom, animated: false)
            
        }
    }

    // MARK: - Table view data source
    @IBAction func push(_ sender: UIBarButtonItem) {
//        let storyboard = UIStoryboard(name: "Main", bundle: .main)
//        let window = storyboard.instantiateViewController(withIdentifier: "emergente")

//        present(window, animated: true, completion: nil)
        
        if !showView {
            showView.toggle()
            
            guard let xib = Bundle.main.loadNibNamed("MyView", owner: self, options: nil),
                  let miXib = xib.first as? UIView,
                  let navigationC = navigationController else { return }
            
            myView = miXib
            myView.backgroundColor = .gray
            myView.layer.cornerRadius = 10
            myView.translatesAutoresizingMaskIntoConstraints = false
            myView.layer.opacity = 0.0
            
            //To center the element on screen
//            myView.frame.origin = CGPoint(x: (UIScreen.main.bounds.width / 2) - (myView.frame.width / 2), y: (UIScreen.main.bounds.height / 2) - (myView.frame.height / 2))
            navigationC.view.addSubview(myView)
            
            
            NSLayoutConstraint.activate([
                myView.centerXAnchor.constraint(equalTo: navigationC.view.centerXAnchor),
                myView.centerYAnchor.constraint(equalTo: navigationC.view.centerYAnchor),
                myView.widthAnchor.constraint(equalToConstant: 250),
                myView.heightAnchor.constraint(equalToConstant: 250)
                
            ])
            
            let offset = myView.layer.frame.origin.y
            myView.layer.frame.origin = CGPoint(x: self.myView.layer.frame.origin.x, y: offset + 400)
            
            UIView.animate(withDuration: 1) {
                self.myView.layer.opacity = 1.0
                self.myView.layer.frame.origin = CGPoint(x: self.myView.layer.frame.origin.x, y: offset)
            }
            
        } else {
            showView.toggle()
            let offset = myView.layer.frame.origin.y

            
            UIView.animate(withDuration: 1) {
                self.myView.layer.opacity = 0.0
                self.myView.layer.frame.origin = CGPoint(x: self.myView.layer.frame.origin.x, y: offset - 400)
                
            } completion: { state in
                self.myView.removeFromSuperview()
            }
        }
        
        
        
        
    }
    
    func configureSortButton() {
        let actionOne = UIAction(title: "Ascendent", image: UIImage(systemName: "arrow.up")) {_ in
            self.modelLogic.sortType = .ascendent
            self.tableView.reloadData()
        }
        
        let actionTwo = UIAction(title: "Descendent", image: UIImage(systemName: "arrow.down")) {_ in
            self.modelLogic.sortType = .descendent
            self.tableView.reloadData()
        }
        
        let actionThree = UIAction(title: "None", image: UIImage(systemName: "arrow.right")) {_ in
            self.modelLogic.sortType = .none
            self.tableView.reloadData()
        }
        
        sortButton.menu = UIMenu(title: "Sort Options", children: [actionOne, actionTwo, actionThree])
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return modelLogic.scores.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "zelda", for: indexPath)

        let score = modelLogic.sortScores[indexPath.row]
        
        //MARK: Forma antigua deprecada
//        cell.textLabel?.text = "\(score.title)"
//        cell.detailTextLabel?.text = "\(score.composer)"
//        cell.imageView?.image = UIImage(named: "\(score.cover)")
        
        //MARK: FORMA CORRECTA Y ACTUALIZADA
        var content = UIListContentConfiguration.cell()
        
        //MARK: Se interpola el dato por SEGURIDAD, por si alguien cambia el tipo en el JSON, que no pete la app.
        content.text = "\(score.title)"
        content.secondaryText = "\(score.composer)"
        content.image = UIImage(named: "\(score.cover)")

        cell.contentConfiguration = content
        return cell
    }

    
    // Override to support conditional editing of the table view.
    
    //MARK: INDICA QUE CELDAS SERÁN EDITABLES Y CUALES NO
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            modelLogic.deleteRow(indexPath: indexPath)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } 
    }


    
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        modelLogic.moveRow(from: fromIndexPath, to: to)

    }
    

    
    // Override to support conditional rearranging of the table view.
    //MARK: PERMITE MOVER CELDAS 
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    
    
    //MARK: FORMA CLASICA INYECCION DEPENDENCIAS
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "edit",
           let destination = segue.destination as? DetailViewController,
           let cell = sender as? UITableViewCell,
           let indexPath = tableView.indexPath(for: cell) {
            destination.score = modelLogic.sortScores[indexPath.row]
        }
    }
    
    @IBAction func backScores(segue: UIStoryboardSegue) {
        if segue.identifier == "back",
           let source = segue.source as? DetailViewController,
           let score = source.score,
            let indexPath = modelLogic.updateScore(score: score) {
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
    @IBAction func sortButtonTapped(_ sender: UIBarButtonItem) {
        
        //MARK: OLD SCHOOL PATH (APPLE DON'T WANT THIS METHOD)
        let alert = UIAlertController(title: "Choose an option", message: "Choos how to sort Scores", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Ascendent", style: .default) {_ in
            self.modelLogic.sortType = .ascendent
            self.tableView.reloadData()
        })
        alert.addAction(UIAlertAction(title: "Descendent", style: .default) {_ in
            self.modelLogic.sortType = .descendent
            self.tableView.reloadData()

        })
        alert.addAction(UIAlertAction(title: "Nothing", style: .cancel) {_ in
            self.modelLogic.sortType = .none
            self.tableView.reloadData()

        })
        
        present(alert, animated: true)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .reloadNewData, object: nil)
    }
}

