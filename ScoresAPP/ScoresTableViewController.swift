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

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
         self.clearsSelectionOnViewWillAppear = false
        //MARK: PERMITE AÑADIR BOTÓN DE EDICIÓN
         self.navigationItem.leftBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

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

        let score = modelLogic.scores[indexPath.row]
        
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
            destination.score = modelLogic.scores[indexPath.row]
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
}
