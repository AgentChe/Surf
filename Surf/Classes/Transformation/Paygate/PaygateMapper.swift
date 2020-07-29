//
//  PaygateMapper.swift
//  SleepWell
//
//  Created by Andrey Chernyshev on 12/06/2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import Foundation.NSAttributedString
import UIKit.UIColor

final class PaygateMapper {
    typealias PaygateResponse = (json: [String: Any], paygate: Paygate, productsIds: [String])
    
    static func parse(response: Any, productsPrices: [ProductPrice]?) -> PaygateResponse? {
        guard
            let json = response as? [String: Any],
            let data = json["_data"] as? [String: Any]
        else {
            return nil
        }
        
        let mainJSON = data["main"] as? [String: Any]
        let main = map(main: mainJSON, productsPrices: productsPrices)
        
        let specialOfferJSON = data["special_offer"] as? [String: Any]
        let specialOffer = map(specialOffer: specialOfferJSON, productsPrices: productsPrices)
        
        let paygate = Paygate(main: main, specialOffer: specialOffer)
        
        let productIds = getProductIds(mainJSON: mainJSON, specialOfferJSON: specialOfferJSON)
        
        return PaygateResponse(json, paygate, productIds)
    }
}

// MARK: Private

private extension PaygateMapper {
    static func map(main: [String: Any]?, productsPrices: [ProductPrice]?) -> PaygateMain? {
        guard let main = main else {
            return nil
        }
        
        let greeting = (main["header"] as? String ?? "")
            .attributed(with: TextAttributes()
                .font(Font.OpenSans.bold(size: 34.scale))
                .textColor(UIColor.black)
                .lineHeight(38.scale))
        
        let features = main["features"] as? [String] ?? []
        let featuresAttributionString = features.map {
            $0.attributed(with: TextAttributes()
            .font(Font.OpenSans.regular(size: 14.scale))
            .textColor(.black)
            .lineHeight(16.scale)
            .textAlignment(.left))
        }
        
        let button = (main["button"] as? String ?? "")
            .uppercased()
            .attributed(with: TextAttributes()
                .font(Font.Poppins.semibold(size: 17.scale))
                .textColor(UIColor.black)
                .textAlignment(.center)
                .letterSpacing(0.02.scale)
                .lineHeight(19.scale))
        
        let subButton = (main["subbutton"] as? String ?? "")
            .attributed(with: TextAttributes()
                .font(Font.OpenSans.semibold(size: 13.scale))
                .textColor(UIColor.white)
                .letterSpacing(-0.06.scale))
        
        let restore = (main["restore"] as? String ?? "")
            .attributed(with: TextAttributes()
                .font(Font.OpenSans.semibold(size: 17.scale))
                .lineHeight(27.scale)
                .textColor(UIColor.black.withAlphaComponent(0.3)))
        
        return PaygateMain(greeting: greeting,
                           features: featuresAttributionString,
                           options: (main["options"] as? [[String: Any]])?.compactMap { map(option: $0, productsPrices: productsPrices) },
                           button: button,
                           subButton: subButton,
                           restore: restore)
    }
    
    static func map(option: [String: Any], productsPrices: [ProductPrice]?) -> PaygateOption? {
        guard
            let productId = option["product_id"] as? String
        else {
            return nil
        }
        
        let title = (option["title"] as? String)?
            .attributed(with: TextAttributes()
                .font(Font.Montserrat.bold(size: 20.scale))
                .lineHeight(25.scale)
                .letterSpacing(0.06)
                .textColor(UIColor(red: 17 / 255, green: 17 / 255, blue: 17 / 255, alpha: 1)))
        
        let subCaption = (option["subcaption"] as? String)?
            .attributed(with: TextAttributes()
                .font(Font.Montserrat.semibold(size: 10.scale))
                .letterSpacing(0.06)
                .lineHeight(13.scale)
                .textColor(UIColor(red: 17 / 255, green: 17 / 255, blue: 17 / 255, alpha: 1)))
        
        let save = (option["save"] as? String)?
            .attributed(with: TextAttributes()
                .font(Font.Montserrat.semibold(size: 13.scale))
                .letterSpacing(-0.08)
                .textColor(UIColor.white)
                .lineHeight(18.scale))
        
        guard let productPrice = productsPrices?.first(where: { $0.id == productId }) else {
            return PaygateOption(productId: productId,
                                 title: title,
                                 caption: nil,
                                 subCaption: subCaption,
                                 save: save,
                                 bottomLine: nil)
        }
        
        let div = option["div"] as? Int ?? 1
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = productPrice.priceLocale
        
        let priceDiv: Double = productPrice.priceValue / Double(div)
        let priceDivLocalized: String
        if priceDiv < 100 {
            formatter.maximumFractionDigits = 1
            priceDivLocalized = formatter.string(from: NSNumber(value: (priceDiv * 10).rounded() / 10)) ?? ""
        } else {
            formatter.maximumFractionDigits = 0
            priceDivLocalized = formatter.string(from: NSNumber(value: round(priceDiv))) ?? ""
        }
        
        formatter.maximumFractionDigits = productPrice.priceValue.truncatingRemainder(dividingBy: 1) > 0 ? 2 : 0
        let priceLocalized = formatter.string(from: NSNumber(value: productPrice.priceValue)) ?? ""
        
        let caption = (option["caption"] as? String)?
            .replacingOccurrences(of: "@price_div", with: priceDivLocalized)
            .replacingOccurrences(of: "@price", with: priceLocalized)
        let captionAttrs = NSMutableAttributedString(string: caption ?? "",
                                                     attributes: TextAttributes()
                                                        .font(Font.Montserrat.semibold(size: 15.scale))
                                                        .lineHeight(25.scale)
                                                        .letterSpacing(0.06)
                                                        .dictionary)
        let captionPriceLocalizedRange = NSString(string: caption ?? "").range(of: priceLocalized)
        captionAttrs.addAttributes(TextAttributes().font(Font.Montserrat.bold(size: 20.scale)).letterSpacing(0.06).dictionary,
                                   range: captionPriceLocalizedRange)
        let captionPriceDivLocalizedRange = NSString(string: caption ?? "").range(of: priceDivLocalized)
        captionAttrs.addAttributes(TextAttributes().font(Font.Montserrat.bold(size: 20.scale)).letterSpacing(0.06).dictionary,
                                   range: captionPriceDivLocalizedRange)
        
        let bottomLine = (option["bottom_line"] as? String)?
            .replacingOccurrences(of: "@price_div", with: priceDivLocalized)
            .replacingOccurrences(of: "@price", with: priceLocalized)
        let bottomLineAttrs = NSMutableAttributedString(string: bottomLine ?? "",
                                                        attributes: TextAttributes()
                                                            .font(Font.Montserrat.semibold(size: 15.scale))
                                                            .lineHeight(25.scale)
                                                            .dictionary)
        let bottomLinePriceLocalizedRange = NSString(string: bottomLine ?? "").range(of: priceLocalized)
        bottomLineAttrs.addAttributes(TextAttributes().font(Font.Montserrat.bold(size: 20.scale)).letterSpacing(-0.08).dictionary,
                                   range: bottomLinePriceLocalizedRange)
        let bottomLinePriceDivLocalizedRange = NSString(string: bottomLine ?? "").range(of: priceDivLocalized)
        bottomLineAttrs.addAttributes(TextAttributes().font(Font.Montserrat.bold(size: 20.scale)).letterSpacing(-0.08).dictionary,
                                   range: bottomLinePriceDivLocalizedRange)
        
        return PaygateOption(productId: productId,
                             title: title,
                             caption: captionAttrs,
                             subCaption: subCaption,
                             save: save,
                             bottomLine: bottomLineAttrs)
    }
    
    static func map(specialOffer: [String: Any]?, productsPrices: [ProductPrice]?) -> PaygateSpecialOffer? {
        guard
            let specialOffer = specialOffer,
            let productId = specialOffer["product_id"] as? String,
            let productPrice = productsPrices?.first(where: { $0.id == productId })
        else {
            return nil
        }
        
        let title = (specialOffer["subtitle"] as? String)?
            .uppercased()
            .replacingOccurrences(of: "@price", with: productPrice.priceLocalized)
            .attributed(with: TextAttributes()
                .font(Font.Poppins.semibold(size: 15.scale))
                .textColor(UIColor.black)
                .lineHeight(17.scale)
                .textAlignment(.center))
        
        let subTitle = (specialOffer["title"] as? String)?
            .replacingOccurrences(of: "@price", with: productPrice.priceLocalized)
            .uppercased()
            .attributed(with: TextAttributes()
                .font(Font.Poppins.bold(size: 52.scale))
                .textColor(UIColor.black)
                .lineHeight(54.scale)
                .textAlignment(.center))
        
        let text1 = (specialOffer["text_1"] as? String ?? "")
            .replacingOccurrences(of: "@price", with: productPrice.priceLocalized)
            .attributed(with: TextAttributes()
                .font(Font.OpenSans.bold(size: 22.scale))
                .textColor(UIColor.white)
                .lineHeight(26.scale)
                .textAlignment(.center))
        
        let text2 = (specialOffer["text_2"] as? String ?? "")
            .replacingOccurrences(of: "@price", with: productPrice.priceLocalized)
            .attributed(with: TextAttributes()
                .font(Font.OpenSans.bold(size: 22.scale))
                .textColor(UIColor.black)
                .lineHeight(26.scale)
                .textAlignment(.center))
        
        let text = NSMutableAttributedString()
        text.append(text1)
        text.append(text2)
        
        let button = (specialOffer["button"] as? String)?
            .replacingOccurrences(of: "@price", with: productPrice.priceLocalized)
            .uppercased()
            .attributed(with: TextAttributes()
                .font(Font.Poppins.semibold(size: 17.scale))
                .letterSpacing(0.2.scale)
                .textColor(UIColor.black))
        
        let subButton = (specialOffer["subbutton"] as? String)?
            .replacingOccurrences(of: "@price", with: productPrice.priceLocalized)
            .attributed(with: TextAttributes()
                    .font(Font.OpenSans.semibold(size: 13.scale))
                .textColor(UIColor.black.withAlphaComponent(0.5))
                    .letterSpacing(-0.06.scale)
                    .lineHeight(15.scale))
        
        let restore = (specialOffer["restore"] as? String ?? "")
            .attributed(with: TextAttributes()
                .font(Font.OpenSans.semibold(size: 17.scale))
                .lineHeight(27.scale)
                .textColor(UIColor.black.withAlphaComponent(0.3)))
        
        let multiplicator = specialOffer["special_offer_multiplicator"] as? Int ?? 1
        let oldPrice = productPrice.priceValue * Double(multiplicator)
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = productPrice.priceLocale
        formatter.string(from: NSNumber(value: oldPrice))
        
        let oldPriceLocalized = formatter
            .string(from: NSNumber(value: oldPrice)) ?? String(format: "%.1f", oldPrice)
        let oldPriceLocalizedAttrs = oldPriceLocalized
            .attributed(with: TextAttributes()
                .font(Font.Poppins.regular(size: 17.scale))
                .lineHeight(19.scale)
                .textColor(.black)
                .strikethroughStyle(.single))
        
        let currentPrice = (specialOffer["price_tag"] as? String)?
            .replacingOccurrences(of: "@price", with: productPrice.priceLocalized)
        let currentPriceLocalized = currentPrice?
            .attributed(with: TextAttributes()
                .font(Font.Poppins.bold(size: 17.scale))
                .lineHeight(19.scale)
                .textColor(.black))
        
        return PaygateSpecialOffer(productId: productId,
                                   title: title,
                                   subTitle: subTitle,
                                   text: text,
                                   time: specialOffer["time_left"] as? String ?? "",
                                   oldPrice: oldPriceLocalizedAttrs,
                                   price: currentPriceLocalized,
                                   button: button,
                                   subButton: subButton,
                                   restore: restore)
    }
    
    static func getProductIds(mainJSON: [String: Any]?, specialOfferJSON: [String: Any]?) -> [String] {
        var ids = [String]()
        
        let optionsJSON = mainJSON?["options"] as? [[String: Any]] ?? []
        for optionJSON in optionsJSON {
            if let id = optionJSON["product_id"] as? String {
                ids.append(id)
            }
        }
        
        if let specialOfferProductId = specialOfferJSON?["product_id"] as? String {
            ids.append(specialOfferProductId)
        }
        
        return ids
    }
}
