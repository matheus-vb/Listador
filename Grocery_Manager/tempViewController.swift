//
//  ViewController.swift
//  Grocery_Manager
//
//  Created by matheusvb on 19/05/22.
//

import UIKit

class tempViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @objc func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
    
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
        // Do any additional setup after loading the view.
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(didTapRef))
        navigationItem.rightBarButtonItem?.tintColor = .red
        getAllProducts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getAllProducts()
    }

    @objc private func didTapRef() {
        return
    }

    //-----------CORE DATA -------------
    
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

