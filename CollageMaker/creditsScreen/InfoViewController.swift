//
//  InfoViewController.swift
//  iPhotos
//
//  Created by Joao Flores on 21/04/21.
//  Copyright © 2021 WhatsApp. All rights reserved.
//

import UIKit

class InfoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {


    @IBAction func backButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    private let myArray: NSArray = ["All icons from flaticon", "images from freepik", "https://br.freepik.com/fotos-gratis/animada-e-curiosa-linda-loira-em-um-vestido-branco-fofo-boca-aberta-de-empolgacao-observar-coisa-legal-novo-produto-incrivel-apontando-dedos-e-olhando-para-baixo_12601347.htm", "https://br.freepik.com/fotos-gratis/animada-e-curiosa-linda-loira-em-um-vestido-branco-fofo-boca-aberta-de-empolgacao-observar-coisa-legal-novo-produto-incrivel-apontando-dedos-e-olhando-para-baixo_12601347.htm"]

    private var myTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        let barHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height
        let displayWidth: CGFloat = self.view.frame.width
        let displayHeight: CGFloat = self.view.frame.height

        myTableView = UITableView(frame: CGRect(x: 0, y: barHeight, width: displayWidth, height: displayHeight - barHeight))
        myTableView.register(UITableViewCell.self, forCellReuseIdentifier: "MyCell")
        myTableView.dataSource = self
        myTableView.delegate = self
        myTableView.separatorStyle = .none
        myTableView.isUserInteractionEnabled = false
        self.view.addSubview(myTableView)
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Num: \(indexPath.row)")
        print("Value: \(myArray[indexPath.row])")
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath as IndexPath)
        cell.textLabel!.text = "\(myArray[indexPath.row])"
        cell.textLabel?.numberOfLines = 0
        return cell
    }
}
