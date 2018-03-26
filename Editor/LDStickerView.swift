//
//  LDStickerView.swift
//  LDStickerView
//
//  Created by Vũ Trung Thành on 1/18/15.
//  Copyright (c) 2015 V2T Multimedia. All rights reserved.
//

import UIKit

@objc protocol LDStickerViewDelegate{
    @objc optional func stickerViewDidBeginEditing(_ sticker:LDStickerView)
    @objc optional func stickerViewDidChangeEditing(_ sticker:LDStickerView)
    @objc optional func stickerViewDidEndEditing(_ sticker:LDStickerView)
    @objc optional func stickerViewDidClose(_ sticker:LDStickerView)
    @objc optional func stickerViewDidShowEditingHandles(_ sticker:LDStickerView)
    @objc optional func stickerViewDidHideEditingHandles(_ sticker:LDStickerView)
}
class LDStickerView: UIView, UIGestureRecognizerDelegate, LDStickerViewDelegate {
    fileprivate var _globalInset: CGFloat!
    
    fileprivate var _initialBounds: CGRect!
    fileprivate var _initialDistance: CGFloat!
    
    fileprivate var _beginningPoint: CGPoint!
    fileprivate var _beginningCenter: CGPoint!
    
    fileprivate var _prevPoint: CGPoint!
    fileprivate var _touchLocation: CGPoint!
    
    fileprivate var _deltaAngle: CGFloat!
    
    fileprivate var _startTransform: CGAffineTransform!
    fileprivate var _beginBounds: CGRect!
    
    fileprivate var _resizeView: UIImageView!
    fileprivate var _rotateView: UIImageView!
    fileprivate var _closeView: UIImageView!
    fileprivate var _isShowingEditingHandles: Bool!
    fileprivate var _contentView: UIView!
    fileprivate var _delegate: LDStickerViewDelegate?
    fileprivate var _showContentShadow: Bool! //Default is YES.
    fileprivate var _showCloseView: Bool! //Default is YES. If set to NO, user can't delete the view
    fileprivate var _showResizeView: Bool! //Default is YES. If set to NO, user can't resize the view
    fileprivate var _showRotateView: Bool! //Default is YES. If set to NO, user can't rotate the view
    var initialFontSize : CGFloat = CGFloat(0)
    var lastTouchedView: LDStickerView!
    
    func refresh(){
        if (superview != nil)
        {
            let scale: CGSize  = CGAffineTransformGetScale(transform)
            let t: CGAffineTransform = CGAffineTransform(scaleX: scale.width, y: scale.height)
            _closeView.transform = t.inverted()
            _resizeView.transform = t.inverted()
            _rotateView.transform = t.inverted()
            
//            if ((_isShowingEditingHandles) != false){
//                _contentView.layer.borderWidth = 1/scale.width
//            } else {
//                _contentView.layer.borderWidth = 0.0
//            }
            
            if((self.superview?.subviews.count)! > 0){
                for view in (self.superview?.subviews)!{
                    if(view.accessibilityIdentifier == "drag"){
                        if(view != lastTouchedView){
                            if(view.subviews.count == 3){
                                view.subviews[1].isHidden = true
                                view.subviews[2].isHidden = true
                                view.subviews[0].layer.borderWidth = 0.0
                            }
                        }else if(view == lastTouchedView){
                            if(view.subviews.count == 3){
                                view.subviews[1].isHidden = false
                                view.subviews[2].isHidden = false
                                view.subviews[0].layer.borderColor = UIColor.gray.cgColor
                                view.subviews[0].layer.borderWidth = 1.0
                            }
                        }
                    }
                }
            }
        }
    }
    
    override func didMoveToSuperview(){
        super.didMoveToSuperview()
        refresh()
    }
    
    override init(frame: CGRect) {
        if (frame.size.width < (1+12*2)) {
     
        }
        if (frame.size.height < (1+12*2)){
            
        }
        
        super.init(frame: frame)
        
        _globalInset = 12;
        
        backgroundColor = UIColor.clear
        
        //Close button view which is in top left corner
        _closeView = UIImageView(frame: CGRect(x: bounds.size.width - _globalInset*2, y: 0, width: _globalInset*2, height: _globalInset*2))
          _closeView.autoresizingMask = [.flexibleLeftMargin, .flexibleBottomMargin]
        
        _closeView.backgroundColor = UIColor.clear
        _closeView.image = UIImage(named: "cancel_icon")
        _closeView.isUserInteractionEnabled = true
        addSubview(_closeView)
        
        //Rotating view which is in bottom left corner
        _rotateView = UIImageView(frame: CGRect(x: bounds.size.width - _globalInset*2, y: bounds.size.height - _globalInset*2, width: _globalInset*2, height: _globalInset*2))
        _rotateView.autoresizingMask = [.flexibleLeftMargin, .flexibleTopMargin]
        _rotateView.backgroundColor = UIColor.clear
        _rotateView.image = UIImage(named: "expand")
        _rotateView.isUserInteractionEnabled = true
        addSubview(_rotateView)
        
        //Resizing view which is in bottom right corner
        _resizeView = UIImageView(frame: CGRect(x: 0, y: bounds.size.height - _globalInset*2, width: _globalInset*2, height: _globalInset*2))
        _resizeView.autoresizingMask = [.flexibleRightMargin,.flexibleTopMargin]
        _resizeView.backgroundColor = UIColor.clear
        _resizeView.isUserInteractionEnabled = true
        _resizeView.image = UIImage(named: "expand")
        //addSubview(_resizeView)

        let moveGesture: UIPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(LDStickerView.moveGesture(_:)))
        addGestureRecognizer(moveGesture)
        
        let singleTapShowHide:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LDStickerView.contentTapped(_:)))
        addGestureRecognizer(singleTapShowHide)
        
        let singleTap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LDStickerView.singleTap(_:)))
        _closeView.addGestureRecognizer(singleTap)
        
  
        let panRotateGesture:UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(LDStickerView.rotateViewPanGesture(_:)))
        
        panRotateGesture.minimumPressDuration = 0
        _rotateView.addGestureRecognizer(panRotateGesture)
        
        moveGesture.require(toFail: singleTap)
        
        setEnableClose(true)
        setEnableResize(true)
        setEnableRotate(true)
        setShowContentShadow(false)
        
        hideEditingHandles()
        
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)!
    }
    
    @objc func contentTapped(_ tapGesture:UITapGestureRecognizer){
//        self.superview?.endEditing(true)
//        hideOtherViewSelection()
//        showEditingHandles()
//        superview?.bringSubview(toFront: self)
       
        self.superview?.endEditing(true)
        superview?.bringSubview(toFront: self)
        refresh()
//        if ((_isShowingEditingHandles) != false){
//            hideEditingHandles()
//            self.superview?.endEditing(true)
//            superview?.bringSubview(toFront: self)
//            let scrollView = self.superview as! UIScrollView
//            scrollView.isScrollEnabled = false
//        } else {
//            showEditingHandles()
//        }
    }
    
    func hideOtherViewSelection()
    {
        if((self.superview?.subviews.count)! > 0){
            for view in (self.superview?.subviews)!
            {
                if(view.accessibilityIdentifier == "drag"){
                    if(view.subviews.count == 3){
                        view.subviews[1].isHidden = true
                        view.subviews[2].isHidden = true
                    }
                }
            }
        }
    }
    
    func setEnableClose(_ enableClose:Bool){
        _showCloseView = enableClose;
        _closeView.isHidden = !_showCloseView
        _closeView.isUserInteractionEnabled = _showCloseView
    }
    
    func setEnableResize(_ enableResize:Bool){
        _showResizeView = enableResize;
        _resizeView.isHidden = !_showResizeView
        _resizeView.isUserInteractionEnabled = _showResizeView
    }
    
    func setEnableRotate(_ enableRotate:Bool){
        _showRotateView = enableRotate;
        _rotateView.isHidden = !_showRotateView
        _rotateView.isUserInteractionEnabled = _showRotateView
    }
    
    func setShowContentShadow(_ enableContentShadow:Bool){
        _showContentShadow = enableContentShadow;
        
        if ((_showContentShadow) != false){
            layer.shadowColor = UIColor.black.cgColor
            layer.shadowOffset = CGSize(width: 0, height: 5)
            layer.shadowOpacity = 1.0
            layer.shadowRadius = 4.0
        } else {
            layer.shadowColor = UIColor.clear.cgColor
            layer.shadowOffset = CGSize.zero
            layer.shadowOpacity = 0.0
            layer.shadowRadius = 0.0
        }
    }
    
    func hideEditingHandles(){
        lastTouchedView = nil;
        
        _isShowingEditingHandles = false;
        if(_showCloseView != false){
            _closeView.isHidden = true
        }
        if(_showResizeView != false){
            _resizeView.isHidden = true
        }
        if(_showRotateView != false){
            _rotateView.isHidden = true
        }
        
        refresh()
        
        _delegate?.stickerViewDidHideEditingHandles!(self)
        
    }
    
    func showEditingHandles(){
        if (lastTouchedView != nil){
            lastTouchedView.hideEditingHandles()
        }
        _isShowingEditingHandles = true;
        
        lastTouchedView = self;
        if(_showCloseView != false){
            _closeView.isHidden = false
        }
        if(_showResizeView != false){
            _resizeView.isHidden = false
        }
        if(_showRotateView != false){
            _rotateView.isHidden = false
        }
        refresh()
        
        _delegate?.stickerViewDidShowEditingHandles!(self)
    }
    
   @objc func setContentView(_ contentView: UIView){
        if _contentView != nil {
            _contentView.removeFromSuperview()
        }
        lastTouchedView = self;
        _contentView = contentView
        _contentView.frame = self.bounds.insetBy(dx: _globalInset, dy: _globalInset);
        _contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        _contentView.layer.borderColor = UIColor.gray.cgColor
        _contentView.layer.borderWidth = 1.0;
        insertSubview(_contentView, at: 0)
    }
    
    @objc func singleTap(_ recognizer: UITapGestureRecognizer){
       
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "dismissKeybordOnDeleteTextBoxNotification"), object: nil)
        _touchLocation = recognizer.location(in: superview)
        print(_touchLocation.y)
        print("TOuch Location")
        getTheLastViewPosition(selectedYposition: _touchLocation.y)

        if(self.accessibilityIdentifier == "drag")
        {
            let imageName = self.subviews[0].accessibilityIdentifier
            //deleteFileWithImageName(imageName: (imageName)!, isDiary: false)
        }
        removeFromSuperview()

        if responds(to: #selector(LDStickerViewDelegate.stickerViewDidClose(_:))){
            _delegate?.stickerViewDidClose!(self)
        }
    }
    @objc func moveGesture(_ recognizer: UIPanGestureRecognizer){
        _touchLocation = recognizer.location(in: superview)

        let scrollView = self.superview as! UIScrollView
        //if lastTouchedView != nil{
        //if(scrollView.isScrollEnabled == false){
        if(recognizer.state == UIGestureRecognizerState.began){
           
            _beginningPoint = _touchLocation
            _beginningCenter = center
            center = CGPoint(x: _beginningCenter.x + (_touchLocation.x - _beginningPoint.x), y: _beginningCenter.y + (_touchLocation.y - _beginningPoint.y))
            
            _beginBounds = self.bounds
           
            // Show editing handles and bring the current view to front
            showEditingHandles()
            superview?.bringSubview(toFront: self)
            
            if responds(to: #selector(LDStickerViewDelegate.stickerViewDidBeginEditing(_:))){
                _delegate?.stickerViewDidBeginEditing!(self)
            }
        } else if (recognizer.state == UIGestureRecognizerState.changed){
            center = CGPoint(x: _beginningCenter.x+(_touchLocation.x-_beginningPoint.x), y: _beginningCenter.y+(_touchLocation.y-_beginningPoint.y))
            
            //let dictionary = ["TouchlocationY":_touchLocation.y]
            let dictionary:[String: CGFloat] = ["Key": _touchLocation.y]
          NotificationCenter.default.post(name: NSNotification.Name(rawValue: "StickerImageMoveNotification"), object: dictionary)
            if responds(to: #selector(LDStickerViewDelegate.stickerViewDidChangeEditing(_:))){
                _delegate?.stickerViewDidChangeEditing!(self)
            }
        } else if (recognizer.state == UIGestureRecognizerState.ended){
            center = CGPoint(x: _beginningCenter.x+(_touchLocation.x-_beginningPoint.x), y: _beginningCenter.y+(_touchLocation.y-_beginningPoint.y))
            if responds(to: #selector(LDStickerViewDelegate.stickerViewDidEndEditing(_:))){
                _prevPoint = _touchLocation
            }
            _touchLocation = recognizer.location(in: superview)
            print(_touchLocation.y)
            getTheLastViewPosition(selectedYposition: _touchLocation.y)

        }
        
        _prevPoint = _touchLocation;
        //}
    }
    
    @objc func resizeTranslate(_ recognizer: UIPanGestureRecognizer){
        _touchLocation = recognizer.location(in: superview)
        //Reforming touch location to it's Identity transform.
        _touchLocation = CGPointRorate(_touchLocation, basePoint: CGRectGetCenter(frame),angle: -CGAffineTransformGetAngle(transform))
        if (recognizer.state == UIGestureRecognizerState.began){
            if responds(to: #selector(LDStickerViewDelegate.stickerViewDidBeginEditing(_:))){
                _delegate?.stickerViewDidBeginEditing!(self)
            }
        } else if (recognizer.state == UIGestureRecognizerState.changed){
            let wChange: CGFloat = (_prevPoint.x - _touchLocation.x); //Slow down increment
            let hChange: CGFloat = (_touchLocation.y - _prevPoint.y); //Slow down increment
            let t: CGAffineTransform = transform
            transform = CGAffineTransform.identity
            var scaleRect:CGRect = CGRect(x: frame.origin.x, y: frame.origin.y, width: max(frame.size.width + (wChange*2), 1 + _globalInset*2), height: max(frame.size.height + (hChange*2), 1 + _globalInset*2))
           
            /*var scaleRect:CGRect
            if (frame.size.width >= frame.size.height){
            scaleRect = CGRectMake(frame.origin.x, frame.origin.y, max(frame.size.width + (hChange*2), 1 + _globalInset*2), max(frame.size.height + (hChange*2), 1 + _globalInset*2))
            } else {
            scaleRect = CGRectMake(frame.origin.x, frame.origin.y, max(frame.size.width + (wChange*2), 1 + _globalInset*2), max(frame.size.height + (wChange*2), 1 + _globalInset*2))
            }*/
            scaleRect = CGRectSetCenter(scaleRect, center: center)
            frame = scaleRect
            transform = t
          
            if responds(to: #selector(LDStickerViewDelegate.stickerViewDidChangeEditing(_:))) {
                _delegate?.stickerViewDidChangeEditing!(self)
            }
        }else if (recognizer.state == UIGestureRecognizerState.ended){
            if responds(to: #selector(LDStickerViewDelegate.stickerViewDidEndEditing(_:))){
                _delegate?.stickerViewDidEndEditing!(self)
            }
        }
        _prevPoint = _touchLocation;
    
    }

    @objc func rotateViewPanGesture(_ recognizer: UIPanGestureRecognizer){
        _touchLocation =  recognizer.location(in: superview)
        let btnPlainTextBox = self._contentView as? UIButton
        let label = btnPlainTextBox?.titleLabel
        
        let c: CGPoint = CGRectGetCenter(frame);
        if (recognizer.state == UIGestureRecognizerState.began){
            _deltaAngle = atan2(_touchLocation.y - c.y, _touchLocation.x - c.x) - CGAffineTransformGetAngle(transform)
            if(self._contentView as? UIButton != nil){
                initialFontSize = (label?.font.pointSize)!
            }
            _initialBounds = bounds;
            _initialDistance = CGPointGetDistance(c, point2: _touchLocation);
            
            if (responds(to: #selector(LDStickerViewDelegate.stickerViewDidBeginEditing(_:)))){
                _delegate?.stickerViewDidBeginEditing!(self)
            }
        } else if (recognizer.state == UIGestureRecognizerState.changed){
            let ang:CGFloat = atan2(_touchLocation.y - c.y, _touchLocation.x - c.x)
            let angleDiff:CGFloat = _deltaAngle - ang
            transform = CGAffineTransform(rotationAngle: -angleDiff)
            setNeedsDisplay()
            let scale: CGFloat = sqrt(CGPointGetDistance(c, point2: _touchLocation) / _initialDistance)
            let scaleRect: CGRect = CGRectScale(_initialBounds, wScale: scale, hScale: scale);
            if (scaleRect.size.width >= (1 + _globalInset*2) && scaleRect.size.height >= (1 + _globalInset*2)){
                bounds = scaleRect
            }
           
            if(self._contentView as? UIButton != nil){           
                let scaleVal = Float((scaleRect.size.width+scaleRect.size.height)/2) - Float((_initialBounds.size.height+_initialBounds.size.width)/2)
                label?.font = UIFont.systemFont(ofSize:CGFloat(initialFontSize))
                
//                let myAttribute = [ NSAttributedStringKey.font: UIFont.systemFont(ofSize:CGFloat(initialFontSize)+(CGFloat(scaleVal)/3)) ]
                let myAttribute = [ NSAttributedStringKey.font: UIFont.systemFont(ofSize:CGFloat(initialFontSize)) ]
                let myString = NSMutableAttributedString(string:(label?.text)!, attributes: myAttribute )
                label?.lineBreakMode = .byWordWrapping
                btnPlainTextBox?.setAttributedTitle(myString, for: .normal)
                
            }
            
            if responds(to: #selector(LDStickerViewDelegate.stickerViewDidChangeEditing(_:))) {
                _delegate?.stickerViewDidChangeEditing!(self)
            }
        } else if (recognizer.state == UIGestureRecognizerState.ended){
            if responds(to: #selector(LDStickerViewDelegate.stickerViewDidEndEditing(_:))){
                _delegate?.stickerViewDidEndEditing!(self)
            }
        }
       
    }
    
    
    fileprivate func CGRectGetCenter(_ rect:CGRect) -> CGPoint{
        return CGPoint(x: rect.midX, y: rect.midY)
    }
    fileprivate func CGPointRorate(_ point: CGPoint, basePoint: CGPoint, angle: CGFloat) -> CGPoint{
        let x: CGFloat = cos(angle) * (point.x-basePoint.x) - sin(angle) * (point.y-basePoint.y) + basePoint.x;
        let y: CGFloat = sin(angle) * (point.x-basePoint.x) + cos(angle) * (point.y-basePoint.y) + basePoint.y;
        
        return CGPoint(x: x,y: y);
    }
    
    fileprivate func CGRectSetCenter(_ rect: CGRect, center: CGPoint) -> CGRect{
        return CGRect(x: center.x-rect.width/2, y: center.y-rect.height/2, width: rect.width, height: rect.height);
    }
    
    fileprivate func CGRectScale(_ rect: CGRect, wScale: CGFloat, hScale: CGFloat) -> CGRect{
        return CGRect(x: rect.origin.x * wScale, y: rect.origin.y * hScale, width: rect.size.width * wScale, height: rect.size.height * hScale);
    }
    
    fileprivate func CGPointGetDistance(_ point1: CGPoint, point2: CGPoint) -> CGFloat{
        let fx: CGFloat = (point2.x - point1.x);
        let fy: CGFloat = (point2.y - point1.y);
        
        return sqrt((fx*fx + fy*fy));
    }
    
    fileprivate func CGAffineTransformGetAngle(_ t:CGAffineTransform) -> CGFloat{
        return atan2(t.b, t.a);
    }
    
    
    fileprivate func CGAffineTransformGetScale(_ t:CGAffineTransform) -> CGSize{
        return CGSize(width: sqrt(t.a * t.a + t.c * t.c), height: sqrt(t.b * t.b + t.d * t.d)) ;
    }
    func getTheLastViewPosition(selectedYposition: CGFloat)
    {
        let array = NSMutableArray()
        if((self.superview?.subviews.count)! > 0){
            for view in (self.superview?.subviews)!
            {
                if(view.accessibilityIdentifier == "drag"){
                    let dict = ["tag" : view.tag, "viewSize" :  Int(view.frame.origin.y),"viewHeight" :  Int(view.frame.size.height),"LastYposition" :  Int(selectedYposition)]
                    array.add(dict)
                }
            }
            let sizeDescriptor = NSSortDescriptor(key: "viewSize", ascending: false)
            let sortedArray = array.sortedArray(using: [sizeDescriptor])
            print("sorted array:\(sortedArray)")
            print("bottom viewSize: ",sortedArray[0])
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reduceScrollviewHeightNotification"), object: sortedArray[0])
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "StickerImageMoveNotification"), object: sortedArray[0])
        }
    }
//    func getTheLastViewPosition(selectedYposition: CGFloat)
//    {
//        let array = NSMutableArray()
//        if((self.superview?.subviews.count)! > 0){
//            for view in (self.superview?.subviews)!
//            {
//                if(view.accessibilityIdentifier == "drag"){
//                    let dict = ["tag" : view.tag, "viewSize" :  Int(view.frame.origin.y),"viewHeight" :  Int(view.frame.size.height),"LastYposition" :  Int(selectedYposition)]
//                    array.add(dict)
//                }
//            }
//            let sizeDescriptor = NSSortDescriptor(key: "viewSize", ascending: false)
//            let sortedArray = array.sortedArray(using: [sizeDescriptor])
//            
//          //  NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reduceScrollviewHeightNotification"), object: sortedArray[0])
//         //   NotificationCenter.default.post(name: NSNotification.Name(rawValue: "StickerImageMoveNotification"), object: sortedArray[0])
//        }
//    }
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
    // Drawing code
    }
    */
    
}
