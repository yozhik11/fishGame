import UIKit

class ViewController: UIViewController {
    
    var countFishCatched = 0
    var countAllFishCatched = 0

    lazy var fishBlue: UIImageView = {
        let image = UIImage(named: "fishBlue")
        let view = UIImageView(image: image)
        view.frame = CGRect( x: 50, y: 50, width: 100, height: 100)
        view.contentMode = .scaleAspectFit
        return view
    }()
    lazy var fishGreen: UIImageView = {
        let image = UIImage(named: "fishGreen")
        let view = UIImageView(image: image)
        view.frame = CGRect( x: 250, y: 50, width: 100, height: 100)
        view.contentMode = .scaleAspectFit
        return view
    }()
    lazy var fishRed: UIImageView = {
        let image = UIImage(named: "fishRed")
        let view = UIImageView(image: image)
        view.frame = CGRect( x: 50, y: 450, width: 100, height: 100)
        view.contentMode = .scaleAspectFit
        return view
    }()
    lazy var fishPink: UIImageView = {
        let image = UIImage(named: "fishPink")
        let view = UIImageView(image: image)
        view.frame = CGRect( x: 250, y: 450, width: 100, height: 100)
        view.contentMode = .scaleAspectFit
        return view
    }()
    lazy var fishYellow: UIImageView = {
        let image = UIImage(named: "fishYellow")
        let view = UIImageView(image: image)
        view.frame = CGRect( x: 150, y: 150, width: 100, height: 100)
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    lazy var fishes: [UIImageView] = {
        var fishes = [UIImageView()]
        fishes = [fishBlue, fishGreen, fishPink, fishRed, fishYellow]
        return fishes
    }()
    
    private lazy var button: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Охота началась", for: .normal)
        button.isHidden = false
        return button
    }()
    
    lazy var labelCount: UILabel = {
        let label = UILabel()
        label.text = "Все рыбы на свободе"
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTap))
        view.addGestureRecognizer(tap)
        
        let backImage = UIImage(named: "ocean") ?? UIImage()
        view.backgroundColor = UIColor(patternImage: backImage)
        fishes.forEach({view.addSubview($0)})
        view.addSubview(labelCount)
        view.addSubview(button)
        buttonActive()
        labelConstraint()
        fishes.forEach({moveTo($0)})
    }
    
    func buttonActive() {
        button.topAnchor.constraint(equalTo: view.topAnchor, constant: 40).isActive = true
        button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        
        button.addAction(UIAction(handler: { [weak self] _ in
            guard let self = self else {return}
                self.fishes.forEach({$0.transform = .identity})
                self.countFishCatched = 0
                self.fishes.forEach({$0.alpha = 1})
                self.fishes.forEach({self.moveTo($0)})
                self.fishes.forEach({$0.isUserInteractionEnabled = false})
                self.button.setTitle("Готово, все на месте", for: .normal)
                self.labelCount.text = "Поймано сейчас: \(self.countFishCatched), Всего: \(self.countAllFishCatched)"
        }), for: .touchUpInside)
    }
    
    func labelConstraint() {
        labelCount.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50).isActive = true
        labelCount.rightAnchor.constraint(equalTo: view.leftAnchor, constant: 350).isActive = true
    }
    
    func moveFish(_ fish: UIImageView, _ xAndY: (Int, Int), _ moveTo: @escaping (_ fish: UIImageView) -> Void) {
        UIView.animate(withDuration: Double.random(in: 0.5...2),
                       delay: Double.random(in: 0...1),
                       options: [.curveEaseInOut , .allowUserInteraction],
                       animations: {
            fish.center = CGPoint(x: xAndY.0, y: xAndY.1)
        },
                       completion: { finished in
                moveTo(fish)
        })
    }
    
    func moveTo(_ fish: UIImageView) -> Void {
        switch Int.random(in: 0...3) {
        case 0: self.moveR(fish)
        case 1: self.moveL(fish)
        case 2: self.moveB(fish)
        default: self.moveT(fish)
        }
    }
    
    func moveR(_ fish: UIImageView) -> Void {
        moveFish(fish, (Int.random(in: Int(fish.center.x)...Int(view.frame.maxX)), Int(fish.center.y)), moveTo)
    }
    
    func moveL(_ fish: UIImageView) -> Void {
        moveFish(fish, (Int.random(in: 0...Int(fish.center.x)), Int(fish.center.y)), moveTo)
    }
    
    func moveT(_ fish: UIImageView) -> Void {
        moveFish(fish, (Int(fish.center.x), Int.random(in: 100...Int(fish.center.y))), moveTo)
    }
    
    func moveB(_ fish: UIImageView) -> Void {
        moveFish(fish, (Int(fish.center.x), Int.random(in: Int(fish.center.y)...Int(view.frame.maxY))), moveTo)
    }
    
    @objc func didTap(_ gesture: UITapGestureRecognizer) {
        let tapLocation = gesture.location(in: view)
        guard let tappedFish = fishes.first(where: {!$0.isUserInteractionEnabled && ($0.layer.presentation()?.frame.contains(tapLocation))!}) else {return}
        fishCatchedAnimation(tappedFish)
        tappedFish.isUserInteractionEnabled = true
    }
    
    func fishCatchedAnimation(_ tappedFish: UIImageView) {
        UIView.animate(withDuration: 1) { [weak self] in
            guard let self = self else {return}
                tappedFish.alpha = 0
                tappedFish.transform = CGAffineTransform(translationX: 0, y: -700)
                self.countFishCatched += 1
                self.countAllFishCatched += 1
                self.labelCount.text = "Поймано сейчас: \(self.countFishCatched); Всего: \(self.countAllFishCatched)"
                self.button.setTitle("\(5 - self.countFishCatched > 0 ? "Поймать еще \(5 - self.countFishCatched)" : "Вернуть рыбонек!")", for: .normal)
        }
    }
}

