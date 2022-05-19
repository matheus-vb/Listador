//
//  reqViewController.swift
//  Grocery_Manager
//
//  Created by matheusvb on 19/05/22.
//

import UIKit

class reqViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
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

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAdd))
        navigationItem.rightBarButtonItem?.tintColor = .red
        
        tableView.delegate = self
        tableView.dataSource = self
        getAllProducts()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getAllProducts()
    }
    
    @objc private func didTapAdd() {
        let alert = UIAlertController(title: "Adicionar produto", message: nil, preferredStyle: .alert)
        alert.addTextField(configurationHandler: { field in
            field.placeholder = "Nome do produto"
            field.returnKeyType = .next
        })
        alert.addTextField(configurationHandler: { field in
            field.placeholder = "Quantidade do produto"
            field.keyboardType = .numberPad
        })
        alert.addAction(UIAlertAction(title: "Confirmar", style: .cancel, handler: { [weak self] _ in
            guard let field = alert.textFields?.first, let text = field.text, !text.isEmpty else {
                return
            }
            
            guard let field2 = alert.textFields?.last, let text2 = field2.text, !text2.isEmpty else {
                return
            }
                    
            let qtd = Int32(text2 ?? " ") ?? 0
            self?.addProduct(name: text, qtd: qtd)
        }))
        
        present(alert, animated: true)
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    
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
