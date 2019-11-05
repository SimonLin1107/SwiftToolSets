import Foundation
import UIKit

open class ImageTools {
    
    public static func rotateImage(original: UIImage, radians: CGFloat) -> UIImage? {
        
        let rotatedSize = CGRect(origin: .zero, size: original.size)
            .applying(CGAffineTransform(rotationAngle: CGFloat(radians)))
            .integral.size
        UIGraphicsBeginImageContext(rotatedSize)
        if let context = UIGraphicsGetCurrentContext() {
            let origin = CGPoint(x: rotatedSize.width / 2.0,
                                 y: rotatedSize.height / 2.0)
            context.translateBy(x: origin.x, y: origin.y)
            context.rotate(by: radians)
            original.draw(in: CGRect(x: -origin.y, y: -origin.x,
                                     width: original.size.width, height: original.size.height))
            let rotatedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            return rotatedImage
        }
        
        return nil
        
    }
    
    public static func imageToBase64(image:UIImage) -> String? {
        
        if let imageData = image.pngData() {
            return imageData.base64EncodedString()
        } else {
            if let imageData = image.jpegData(compressionQuality: 0.75) {
                return imageData.base64EncodedString()
            }
        }
        return nil
        
    }
    
    public static func base64ToImage(base64:String) -> UIImage? {
        
        if let dataDecoded = Data(base64Encoded: base64, options: Data.Base64DecodingOptions.init()) {
            if let decodedimage = UIImage(data: dataDecoded) {
                return decodedimage
            }
        }
        
        return nil
    }
    
    public static func resizeImageLimited(image: UIImage, limitedSize: CGFloat) -> UIImage {
        
        let size = image.size
        if (size.width < limitedSize && size.height < limitedSize) {
            return image
        } else {
            var targetWidth:CGFloat = 0
            var targetHeight:CGFloat = 0
            if (size.width > size.height) {
                targetWidth = limitedSize
                targetHeight = limitedSize * size.height / size.width
            } else {
                targetHeight = limitedSize
                targetWidth = limitedSize * size.width / size.height
            }
            
            let newSize = CGSize(width: targetWidth, height: targetHeight)
            let rect = CGRect(x: 0, y: 0, width: targetWidth, height: targetHeight)
            
            UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
            image.draw(in: rect)
            var newImage = UIImage()
            if let newImageTemp = UIGraphicsGetImageFromCurrentImageContext() {
                newImage = newImageTemp
            }
            UIGraphicsEndImageContext()
            
            return newImage
        }
        
    }
    
    public static func getDownArrowImage(imageSize:CGFloat, color:UIColor) -> UIImage? {
        
        UIGraphicsBeginImageContextWithOptions(CGSize(width: imageSize, height: imageSize), false, 0)
        if let ctx = UIGraphicsGetCurrentContext() {
            ctx.beginPath()
            ctx.move(to: CGPoint(x: 0.0, y: 0.0))
            ctx.addLine(to: CGPoint(x: imageSize, y: 0.0))
            ctx.addLine(to: CGPoint(x: imageSize / 2, y: imageSize))
            ctx.closePath()
            ctx.setFillColor(color.cgColor)
            ctx.fillPath()
        }
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return img
        
    }
    
    public static func getUpArrowImage(imageSize:CGFloat, color:UIColor) -> UIImage? {
        
        UIGraphicsBeginImageContextWithOptions(CGSize(width: imageSize, height: imageSize), false, 0)
        if let ctx = UIGraphicsGetCurrentContext() {
            ctx.beginPath()
            ctx.move(to: CGPoint(x: 0.0, y: imageSize))
            ctx.addLine(to: CGPoint(x: imageSize, y: imageSize))
            ctx.addLine(to: CGPoint(x: imageSize / 2, y: 0.0))
            ctx.closePath()
            ctx.setFillColor(color.cgColor)
            ctx.fillPath()
        }
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return img
        
    }
    
    public static func getColorImage(size: CGFloat?, color: UIColor?) -> UIImage? {
        
        var contextSize:CGFloat = 100
        if (size != nil) {
            contextSize = size!
        }
        
        UIGraphicsBeginImageContextWithOptions(CGSize(width: contextSize, height: contextSize), false, 0.0)
        
        if let context = UIGraphicsGetCurrentContext() {
            
            context.beginPath()
            context.move(to: CGPoint(x: 0, y: 0))
            context.addLine(to: CGPoint(x: contextSize, y: 0))
            context.addLine(to: CGPoint(x: contextSize, y: contextSize))
            context.addLine(to: CGPoint(x: 0, y: contextSize))
            context.closePath()
            if let color = color {
                context.setFillColor(color.cgColor)
            } else {
                context.setFillColor(UIColor.clear.cgColor)
            }
            context.fillPath()
            
        }
        
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return img
    }
    
    public static func getPieImage(outRadius:CGFloat, proportions:[CGFloat], colors:[UIColor]?, inRadius:CGFloat?, inColor: UIColor?, backgroundColor:UIColor?) -> UIImage? {
        
        if (outRadius > 0 && proportions.count > 0) {
            
            var inRadiusFinal:CGFloat = 0
            if inRadius != nil {
                if (inRadius! > 0 && inRadius! < outRadius) {
                    inRadiusFinal = inRadius!
                }
            }
            
            UIGraphicsBeginImageContextWithOptions(CGSize(width: outRadius * 2, height: outRadius * 2), false, 0.0)
            
            if let context = UIGraphicsGetCurrentContext() {
                
                context.beginPath()
                context.move(to: CGPoint(x: 0, y: 0))
                context.addLine(to: CGPoint(x: outRadius * 2, y: 0))
                context.addLine(to: CGPoint(x: outRadius * 2, y: outRadius * 2))
                context.addLine(to: CGPoint(x: 0, y: outRadius * 2))
                context.closePath()
                if let backgroundColor = backgroundColor {
                    context.setFillColor(backgroundColor.cgColor)
                } else {
                    context.setFillColor(UIColor.clear.cgColor)
                }
                context.fillPath()
            }
            
            
            var totalValue:CGFloat = 0
            for i in 0..<proportions.count {
                totalValue = totalValue + proportions[i]
            }
            var startAngle:CGFloat = 270
            for i in 0..<proportions.count {
                let endAngle:CGFloat = startAngle + 360 * proportions[i] / totalValue
                if let context = UIGraphicsGetCurrentContext() {
                    context.beginPath()
                    
                    var xPosition = outRadius + (inRadiusFinal * cos(startAngle * CGFloat.pi / 180))
                    var yPosition = outRadius + (inRadiusFinal * sin(startAngle * CGFloat.pi / 180))
                    context.move(to: CGPoint(x: xPosition, y: yPosition))
                    
                    xPosition = outRadius + (outRadius * cos(startAngle * CGFloat.pi / 180))
                    yPosition = outRadius + (outRadius * sin(startAngle * CGFloat.pi / 180))
                    context.addLine(to: CGPoint(x: xPosition, y: yPosition))
                    
                    context.addArc(center: CGPoint(x: outRadius, y: outRadius), radius: outRadius, startAngle: startAngle * CGFloat.pi / 180 , endAngle: endAngle * CGFloat.pi / 180, clockwise: false)
                    xPosition = outRadius + (outRadius * cos(endAngle * CGFloat.pi / 180))
                    yPosition = outRadius + (outRadius * sin(endAngle * CGFloat.pi / 180))
                    context.move(to: CGPoint(x: xPosition, y: yPosition))
                    
                    xPosition = outRadius + (inRadiusFinal * cos(endAngle * CGFloat.pi / 180))
                    yPosition = outRadius + (inRadiusFinal * sin(endAngle * CGFloat.pi / 180))
                    context.addLine(to: CGPoint(x: xPosition, y: yPosition))
                    
                    context.addArc(center: CGPoint(x: outRadius, y: outRadius), radius: inRadiusFinal, startAngle: endAngle * CGFloat.pi / 180 , endAngle: startAngle * CGFloat.pi / 180, clockwise: true)
                    xPosition = outRadius + (inRadiusFinal * cos(startAngle * CGFloat.pi / 180))
                    yPosition = outRadius + (inRadiusFinal * sin(startAngle * CGFloat.pi / 180))
                    context.move(to: CGPoint(x: xPosition, y: yPosition))
                    
                    context.closePath()
                    
                    if let colors = colors {
                        if (colors.count > i) {
                            context.setFillColor(colors[i].cgColor)
                        } else {
                            context.setFillColor(UIColor.init(red: CGFloat(arc4random_uniform(256)) / 255.0, green: CGFloat(arc4random_uniform(256)) / 255.0, blue: CGFloat(arc4random_uniform(256)) / 255.0, alpha: 1.0).cgColor)
                        }
                    } else {
                        context.setFillColor(UIColor.init(red: CGFloat(arc4random_uniform(256)) / 255.0, green: CGFloat(arc4random_uniform(256)) / 255.0, blue: CGFloat(arc4random_uniform(256)) / 255.0, alpha: 1.0).cgColor)
                    }
                    context.fillPath()
                    
                }
                
                startAngle = endAngle
            }
            
            if let inRoundColor = inColor {
                if let context = UIGraphicsGetCurrentContext() {
                    context.beginPath()
                    context.move(to: CGPoint(x: outRadius * 2, y: outRadius))
                    context.addArc(center: CGPoint(x: outRadius, y: outRadius), radius: inRadiusFinal, startAngle: 0 , endAngle: 360 * CGFloat.pi / 180, clockwise: false)
                    context.closePath()
                    context.setFillColor(inRoundColor.cgColor)
                    context.fillPath()
                }
            }
            
            let img = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            return img
            
        }
        
        return nil
        
    }
    
}
