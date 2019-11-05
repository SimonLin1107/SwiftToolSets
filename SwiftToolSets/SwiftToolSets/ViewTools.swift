//
//  ViewTools.swift
//  TaiwanLottery
//
//  Created by Apple on 2019/11/5.
//  Copyright © 2019 LotteryAnalysis. All rights reserved.
//

import Foundation
import UIKit

open class ViewTools {
    
    public static func getViewOfAbsoluteFame(view:UIView) -> CGRect {
        
        var originX:CGFloat = 0
        var originY:CGFloat = 0
        originX = originX + view.frame.origin.x
        originY = originY + view.frame.origin.y
        var superView = view.superview
        while (superView != nil) {
            if superView is UIScrollView {
                originY = originY - (superView as! UIScrollView).contentOffset.y
            }
            originX = originX + superView!.frame.origin.x
            originY = originY + superView!.frame.origin.y
            superView = superView!.superview
        }
        return CGRect(x: originX, y: originY, width: view.frame.size.width, height: view.frame.size.height)
        
    }
    
    public static func getOutermostView(view:UIView) -> UIView {
        var superView:UIView? = view
        while (superView!.superview != nil) {
            superView = superView!.superview
        }
        return superView!
    }
    
}
