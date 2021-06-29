//
//  ViewController.swift
//  15Puzzle
//
//  Created by Vamsi Krishna on 12/03/21.
//

import UIKit

class ViewController: UIViewController {
    var move = 0{
        didSet{
            moves.text = "Moves:\(move)"
        }
    }
    @IBOutlet weak var newgameButton: UIButton!
    @IBOutlet weak var moves: UILabel!
    @IBOutlet var cardArray: [UIButton]!
    lazy var newgame = game()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        while newgame.isSolvable()[0]==0 {
        move = 0
        newgame = game()
        }
        updateView()
        for i in 0...15{
            cardArray[i].setTitle("\(newgame.cards[i].value)", for: .normal)
        }
        // Do any additional setup after loading the view.
    }
    
    @IBAction func newGame(_ sender: UIButton) {
        newgameButton.setTitleColor(#colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1), for: .normal)
        move = 0
        newgame = game()
        while newgame.isSolvable()[0]==0 {
        newgame = game()
        }
        updateView()
//        if let vc = UIStoryboard(name: "main2", bundle: nil).instantiateInitialViewController(){
//        present(vc, animated: true, completion: nil)
//        }
    }
    
    @IBAction func cardPressed(_ sender: UIButton) {
        if newgame.findEmptyCell(index: cardArray.firstIndex(of: sender)!) {
            move += 1
        }
        updateView()
    }
    
    func updateView(){
        if newgame.isSolvable()[1] == 0 && newgame.isSolvable()[2] == 0{
            moves.text = "You Win with \(move) moves."
            newgameButton.setTitleColor(#colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1), for: .normal)
        }
        for i in 0...15{
            if cardArray[i].currentTitle == "0"{
                cardArray[i].titleLabel?.isHidden = true
            }
            cardArray[i].setTitle("\(newgame.cards[i].value)", for: .normal)
            cardArray[i].backgroundColor = newgame.cards[i].color
        }
    }
}

