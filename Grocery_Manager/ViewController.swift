//
//  homeViewController.swift
//  Grocery_Manager
//
//  Created by matheusvb on 19/05/22.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @objc func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = models[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
    
        var qtd: Int32
        
        qtd = model.qtdReq - model.qtdHome
        if qtd < 0 {
            qtd = 0
        }
        
        cell.textLabel?.text = model.name
        cell.textLabel?.font = .boldSystemFont(ofSize: 15)
        cell.detailTextLabel?.text = ("\(qtd)")
        cell.detailTextLabel?.font = .systemFont(ofSize: 14)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print ("aa")
    }
    

    @IBOutlet var tableView: UITableView!
    
    private var models = [ProductList]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        getAllProducts()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getAllProducts()
    }
    
    
    //------------CORE DATA---------------

    func getAllProducts() {
        do {
            models = try context.fetch(ProductList.fetchRequest())
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        catch {
            //error
        }
    }

    func addProduct(name: String, qtd: Int32) {
        let newProduct = ProductList(context: context)
        newProduct.name = name
        newProduct.qtdReq = qtd
        newProduct.qtdHome = 0
        
        do {
            try context.save()
            getAllProducts()
        }
        catch {
            //error
        }
    }

    func removeProduct(product: ProductList) {
        context.delete(product)
        
        do {
            try context.save()
            getAllProducts()
        }
        catch {
            //error
        }
    }

    func changeQtd(product: ProductList, qtd: Int32) {
        product.qtdReq = qtd
        
        do {
            try context.save()
            getAllProducts()
        }
        catch {
            //error
        }
    }
    
    func getList() {
    
        for model in models {
            model.qtdList = model.qtdReq - model.qtdHome
            
            if model.qtdList < 0 {
                model.qtdList = 0
            }
        }
        
        do {
            try context.save()
            getAllProducts()
        }
        catch {
            //error
        }
    }
    
}
