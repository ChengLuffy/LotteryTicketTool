//
//  ListCell.swift
//  LotteryTicketTool
//
//  Created by 成殿 on 14/11/2018.
//  Copyright © 2018 chengluffy. All rights reserved.
//

import UIKit
import SnapKit

class ListCell: UITableViewCell {

    lazy var firstLabel1: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        label.backgroundColor = #colorLiteral(red: 0.262745098, green: 0.4862745098, blue: 0.8784313725, alpha: 1)
        label.layer.cornerRadius = 15
        label.clipsToBounds = true
        label.textAlignment = .center
        return label
    }()
    
    lazy var firstLabel2: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        label.backgroundColor = #colorLiteral(red: 0.262745098, green: 0.4862745098, blue: 0.8784313725, alpha: 1)
        label.layer.cornerRadius = 15
        label.clipsToBounds = true
        label.textAlignment = .center
        return label
    }()
    
    lazy var firstLabel3: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        label.backgroundColor = #colorLiteral(red: 0.262745098, green: 0.4862745098, blue: 0.8784313725, alpha: 1)
        label.layer.cornerRadius = 15
        label.clipsToBounds = true
        label.textAlignment = .center
        return label
    }()
    
    lazy var firstLabel4: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        label.backgroundColor = #colorLiteral(red: 0.262745098, green: 0.4862745098, blue: 0.8784313725, alpha: 1)
        label.layer.cornerRadius = 15
        label.clipsToBounds = true
        label.textAlignment = .center
        return label
    }()
    
    lazy var firstLabel5: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        label.backgroundColor = #colorLiteral(red: 0.262745098, green: 0.4862745098, blue: 0.8784313725, alpha: 1)
        label.layer.cornerRadius = 15
        label.clipsToBounds = true
        label.textAlignment = .center
        return label
    }()
    
    lazy var firstLabel6: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        label.backgroundColor = #colorLiteral(red: 0.262745098, green: 0.4862745098, blue: 0.8784313725, alpha: 1)
        label.layer.cornerRadius = 15
        label.clipsToBounds = true
        label.textAlignment = .center
        return label
    }()
    
    lazy var secondLabel1: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        label.backgroundColor = #colorLiteral(red: 0.9490196078, green: 0.3137254902, blue: 0.3882352941, alpha: 1)
        label.layer.cornerRadius = 15
        label.clipsToBounds = true
        label.textAlignment = .center
        return label
    }()
    
    lazy var secondLabel2: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        label.backgroundColor = #colorLiteral(red: 0.9490196078, green: 0.3137254902, blue: 0.3882352941, alpha: 1)
        label.layer.cornerRadius = 15
        label.clipsToBounds = true
        label.textAlignment = .center
        return label
    }()
    
    lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.lightGray
        label.textAlignment = .right
        return label
    }()
    
    lazy var purchasedLabel: UILabel = {
        let label = UILabel()
        label.text = "已购"
        label.textColor = UIColor.systemBlue
        label.font = UIFont.systemFont(ofSize: 12)
        label.isHidden = true
        return label
    }()
    
    lazy var expectLabel: UILabel = {
        let label = UILabel()
        label.text = "期"
        label.textColor = UIColor.lightGray
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = .right
        return label
    }()
    
    lazy var degreeLabel: UILabel = {
        let label = UILabel()
        label.text = "1等奖"
        label.textColor = UIColor.systemRed
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = .left
        return label
    }()
    
    var ticket: Ticket? {
        didSet {
            if ticket == nil {
                return
            }
            if ticket?.cate == 0 || ticket?.cate == 2 {
                secondLabel1.isHidden = false
                
                let firstZoon = ticket?.opencode.components(separatedBy: "+").first?.components(separatedBy: ",")
                let secondZoon = ticket?.opencode.components(separatedBy: "+").last?.components(separatedBy: ",")
                
                
                secondLabel1.text = secondZoon![0]
                secondLabel2.text = secondZoon![1]
                
                firstLabel1.text = firstZoon![0]
                firstLabel2.text = firstZoon![1]
                firstLabel3.text = firstZoon![2]
                firstLabel4.text = firstZoon![3]
                firstLabel5.text = firstZoon![4]
                firstLabel6.isHidden = true
            } else {
                
                let firstZoon = ticket?.opencode.components(separatedBy: "+").first?.components(separatedBy: ",")
                let secondZoon = ticket?.opencode.components(separatedBy: "+").last?.components(separatedBy: ",")
                
                secondLabel1.isHidden = true
                secondLabel2.text = secondZoon![0]
                
                firstLabel1.text = firstZoon![0]
                firstLabel2.text = firstZoon![1]
                firstLabel3.text = firstZoon![2]
                firstLabel4.text = firstZoon![3]
                firstLabel5.text = firstZoon![4]
                firstLabel6.text = firstZoon![5]
                firstLabel6.isHidden = false
            }
            
            let date = Date(timeIntervalSince1970: TimeInterval(ticket!.opentimestamp))
            let df = DateFormatter()
            df.dateFormat = "yyyy-MM-dd HH:mm:SS"
            let str = df.string(from: date)
            dateLabel.text = str
            
            if ticket?.degree == 0 {
                degreeLabel.isHidden = true
            } else if ticket?.degree == -1 {
                degreeLabel.text = "未中奖"
                degreeLabel.isHidden = !(ticket!.ticketPurchased!)
            } else {
                var temp = ""
                switch ticket!.degree! {
                case 1:
                    temp = "发财了"
                case 2:
                    temp = ticket?.cate == 0 ? "发小财了" : "发小财了"
                case 3:
                    temp = ticket?.cate == 0 ? "10000元" : "3000元"
                case 4:
                    temp = ticket?.cate == 0 ? "3000元" : "200元"
                case 5:
                    temp = ticket?.cate == 0 ? "300元" : "10元"
                case 6:
                    temp = ticket?.cate == 0 ? "200元" : "5元"
                case 7:
                    temp = "100元"
                case 8:
                    temp = "15元"
                case 9:
                    temp = "5元"
                default:
                    temp = "好可惜"
                }
                degreeLabel.text = "\(ticket!.degree!)等奖" + temp
                degreeLabel.isHidden = !(ticket!.ticketPurchased!)
            }
            
            if ticket?.ticketPurchased == nil {
                purchasedLabel.isHidden = true
            } else {
                purchasedLabel.isHidden = !(ticket!.ticketPurchased!)
            }
            
            expectLabel.text = "\(ticket!.expect)期"
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configSubviews()
    }
    
    private func configSubviews() {
        contentView.addSubview(firstLabel1)
        contentView.addSubview(firstLabel2)
        contentView.addSubview(firstLabel3)
        contentView.addSubview(firstLabel4)
        contentView.addSubview(firstLabel5)
        contentView.addSubview(firstLabel6)
        
        contentView.addSubview(secondLabel1)
        contentView.addSubview(secondLabel2)
        
        contentView.addSubview(purchasedLabel)
        contentView.addSubview(expectLabel)
        contentView.addSubview(degreeLabel)
        contentView.addSubview(dateLabel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        firstLabel1.snp.makeConstraints { (maker) in
            maker.centerY.equalTo(contentView).offset(-8)
            maker.left.equalTo(contentView.snp_leftMargin)
            maker.width.height.equalTo(30)
        }
        
        firstLabel2.snp.makeConstraints { (maker) in
            maker.centerY.equalTo(contentView).offset(-8)
            maker.left.equalTo(firstLabel1.snp_rightMargin).offset(15)
            maker.width.height.equalTo(30)
        }
        
        firstLabel3.snp.makeConstraints { (maker) in
            maker.centerY.equalTo(contentView).offset(-8)
            maker.left.equalTo(firstLabel2.snp_rightMargin).offset(15)
            maker.width.height.equalTo(30)
        }
        
        firstLabel4.snp.makeConstraints { (maker) in
            maker.centerY.equalTo(contentView).offset(-8)
            maker.left.equalTo(firstLabel3.snp_rightMargin).offset(15)
            maker.width.height.equalTo(30)
        }
        
        firstLabel5.snp.makeConstraints { (maker) in
            maker.centerY.equalTo(contentView).offset(-8)
            maker.left.equalTo(firstLabel4.snp_rightMargin).offset(15)
            maker.width.height.equalTo(30)
        }
        
        firstLabel6.snp.makeConstraints { (maker) in
            maker.centerY.equalTo(contentView).offset(-8)
            maker.left.equalTo(firstLabel5.snp_rightMargin).offset(15)
            maker.width.height.equalTo(30)
        }
        
        secondLabel2.snp.makeConstraints { (maker) in
            maker.centerY.equalTo(contentView).offset(-8)
            maker.right.equalTo(contentView.snp_rightMargin)
            maker.width.height.equalTo(30)
        }
        
        secondLabel1.snp.makeConstraints { (maker) in
            maker.centerY.equalTo(contentView).offset(-8)
            maker.right.equalTo(secondLabel2.snp_leftMargin).offset(-15)
            maker.width.height.equalTo(30)
        }
        
        purchasedLabel.snp.makeConstraints { (maker) in
            maker.bottom.equalTo(contentView).offset(-8).offset(-8)
            maker.left.equalTo(contentView.snp_leftMargin)
        }
        
        degreeLabel.snp.makeConstraints { (maker) in
            maker.bottom.equalTo(contentView).offset(-8)
            maker.left.equalTo(purchasedLabel.snp.right).offset(8)
        }
        
        expectLabel.snp.makeConstraints { (maker) in
            maker.bottom.equalTo(contentView).offset(-8)
            maker.right.equalTo(dateLabel.snp.left).offset(-8)
        }
        
        dateLabel.snp.makeConstraints { (maker) in
            maker.bottom.equalTo(contentView).offset(-8)
            maker.right.equalTo(contentView.snp_rightMargin)
        }
    }
    
}
