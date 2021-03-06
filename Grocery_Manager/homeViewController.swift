//
//  homeViewController.swift
//  Grocery_Manager
//
//  Created by matheusvb on 19/05/22.
//

import UIKit

class homeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @objc func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = models[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = model.name
        cell.textLabel?.font = .boldSystemFont(ofSize: 15)
        cell.detailTextLabel?.text = ("\(model.qtdHome)")
        cell.detailTextLabel?.font = .systemFont(ofSize: 14)
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let product = models[indexPath.row]
        addOne(product: product)
    }
    

    @IBOutlet var tableView: UITableView!
    
    private var models = [ProductList]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        getAllProducts()
        
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(homeViewController.longPress(longPressGestureRecognizer:)))
        tableView.addGestureRecognizer(longPressRecognizer)
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getAllProducts()
    }
    
    @objc func longPress(longPressGestureRecognizer: UILongPressGestureRecognizer) {

        if longPressGestureRecognizer.state == UIGestureRecognizer.State.began {
            let touchPoint = longPressGestureRecognizer.location(in: tableView)
            if let indexPath = tableView.indexPathForRow(at: touchPoint) {
                let product = models[indexPath.row]
                removeOne(product: product)
                //print(indexPath.row)
                // add your code here
                // you can use 'indexPath' to find out which row is selected
            }
        }
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

    func addOne(product: ProductList) {
        product.qtdHome = product.qtdHome + 1
        
        do {
            try context.save()
            getAllProducts()
        }
        catch{
            //error
        }
    }
    
    func removeOne(product: ProductList) {
        product.qtdHome = product.qtdHome - 1
        
        if product.qtdHome < 0 {
            product.qtdHome = 0
        }
        
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
