//
//  EditorVC.m
//  Editor
//
//  Created by Mohammed Aslam on 27/02/18.
//  Copyright © 2018 Oottru. All rights reserved.
//

#import "EditorVC.h"
#import <QuartzCore/QuartzCore.h>
#import "UIFont+MemobirdEditor.h"
#import "NSAttributedString+MemobirdEditor.h"
#import "FontCollectionViewCell.h"
#import "Editor-Swift.h"

@interface EditorVC ()<UITextViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,NSLayoutManagerDelegate,UIGestureRecognizerDelegate>
{
  //  LDStickerView * sticker;

//    UIScrollView *scrollView;
    
    ///////Navigation Bar
    UIView *navigatonBarview;
    UILabel *titlelabel;
    CGFloat keyboardHeight;
    
    //CustomView
    UIButton *selectedTextBoxButton;
   
    UILabel *placeholderLabel;
    
    //Font slider
    UISlider *fontSlider;
    UILabel *fontsizeLabel;
    UILabel *fontmaxsizeLabel;
    UILabel *fontLabel;
    NSArray *fontArray;
    
    ////Collectionview
    UICollectionView *fontCollectionView;
    UICollectionView *textBoxCollectionView;
    NSArray *textBoxImagesArray;
    
    BOOL boldflag;
    BOOL italicflag;
    BOOL undelineflag;
    BOOL leftalignflag;
    BOOL centeralignflag;
    BOOL rightalignflag;
    NSIndexPath *selectedFontCollectionIndexPath;
    
    
    ////////TEXTBOXDOUBLECLICK
    UIImageView *picimageView;
//    UIButton *btnImageWithText;
    UIButton *btnPlainTextBox;
    UIButton *doubleclickdonebtn;
//    var stickerView = LDStickerView()

}
@property (nonatomic, strong) LDStickerView *selectedView;
@property (nonatomic,strong)  UIScrollView *scrollView;
@property (nonatomic,strong) UIButton *btnImageWithText;;
//@property (nonatomic, strong) LDStickerView *getSelectedViwe;
//CustomVIews
@property (strong, nonatomic) UITextView *backgroundTextView;
@property (strong,nonatomic) UITextView *textViewEditTextBox;
@property (strong, nonatomic) UIView *vwTextOptions;
@property (strong, nonatomic) UIView *vwTextFont;
@property (strong, nonatomic) UIView *vwTextFormat;
@property (strong, nonatomic) UIView *vwTextBoxOption;
@property (strong,nonatomic) UIView *customTabBarView;
@property (strong,nonatomic) UIView *vwEditTextBox;
///Font,Format,DONE Button
@property (strong, nonatomic) UIButton *btnFormat;
@property (strong, nonatomic) UIButton *btnFont;
@property (strong, nonatomic) UIButton *btnComplete;
@property (strong, nonatomic) UIButton *btnCompleteDone;

///Editor Buttons
@property (strong, nonatomic) UIButton *btnBold;
@property (strong, nonatomic) UIButton *btnUnderline;
@property (strong, nonatomic) UIButton *btnItalics;
@property (strong, nonatomic) UIButton *btnLeftAlign;
@property (strong, nonatomic) UIButton *btnCenterAlign;
@property (strong, nonatomic) UIButton *btnRightAlign;

@property (nonatomic, assign) BOOL typingAttributesInProgress;

@property (assign) UITapGestureRecognizer *tapRecognizer;
@property(nonatomic) NSRange selectedRange;
@end

@implementation EditorVC


#pragma mark - ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    fontArray = [[NSArray alloc] initWithArray:[UIFont familyNames]];
    textBoxImagesArray = [NSArray arrayWithObjects:@"text_01.png", @"text_02.png", @"text_03.png",@"text_04.png",@"text_05.png",@"text_06.png", nil];
    [self navigationCustomBG];
    [self menubuttonsBG];
    [self customAlignButtonsBG];
    [self sliderBG];
    
    [self scrollviewBG];
    [self textviewBG];
    [self completebtnBG];
    [self collectionviewBG];
    [self collectionviewTextBoxBG];
    //[self showEditTextBox];
    _vwTextOptions.hidden = YES;
    UITapGestureRecognizer *tapDescription = [[UITapGestureRecognizer alloc]
                      initWithTarget:self action:@selector(tapDescription:)];
    [self.backgroundTextView addGestureRecognizer:tapDescription];
    self.backgroundTextView.editable = NO;

}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reduceScrollviewHeight:) name:@"reduceScrollviewHeightNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(StickerImageMoveNotification:) name:@"StickerImageMoveNotification" object:nil];
  
}
- (void)StickerImageMoveNotification:(NSNotification *)notification
{
    NSLog(@"%@ fdghdfghdfghdfghdfgupdated",notification.object[@"viewSize"]); // gives your dictionary
    int Lastimageyposition = [notification.object[@"viewSize"]intValue];
    int LastimageHeight = [notification.object[@"viewHeight"]intValue];
    int sumLastypositionandHeight = Lastimageyposition + LastimageHeight;
    NSLog(@"%@ viewHeightviewHeight",notification.object[@"viewHeight"]);
    if(sumLastypositionandHeight + 120 > self.scrollView.contentSize.height)
    {
        self.scrollView.contentSize = CGSizeMake(self.scrollView.contentSize.width, self.scrollView.contentSize.height + 200);
        NSLog(@"Increased Heoight");
    }
}

- (void)reduceScrollviewHeight:(NSNotification *)notification
{
    int Lastimageyposition = [notification.object[@"viewSize"]intValue];
    int LastimageHeight = [notification.object[@"viewHeight"]intValue];
    int sumLastypositionandHeight = Lastimageyposition + LastimageHeight;
    NSLog(@"%@ viewHeightviewHeight",notification.object[@"viewHeight"]);
    int scrollviewcontentIntvalue = self.scrollView.contentSize.height;
    int getcontentsizevalue = scrollviewcontentIntvalue;
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    CGFloat floatReducedifferencescrolllastimage = 0.0 ;

    int differencescrolllastimage = scrollviewcontentIntvalue - sumLastypositionandHeight;
    if(differencescrolllastimage > 60)
    {
        int Reducedifferencescrolllastimage = differencescrolllastimage - 10;
         floatReducedifferencescrolllastimage = (CGFloat)Reducedifferencescrolllastimage;
        self.scrollView.contentSize = CGSizeMake(self.scrollView.contentSize.width, self.scrollView.contentSize.height - floatReducedifferencescrolllastimage);
        // getting an NSString
        NSString *myString = [prefs stringForKey:@"SavescrollcontentHeightt"];
        if([myString length] == 0)
        {
            
        }else
        {
            NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
//            // saving an NSString
//            [prefs setObject:@"TextToSave" forKey:@"keyToLookupString"];
//            // saving an NSInteger
//            [prefs setInteger:42 forKey:@"integerKey"];
//            // saving a Double
//            [prefs setDouble:3.1415 forKey:@"doubleKey"];
            // saving a Float
            [prefs setFloat:floatReducedifferencescrolllastimage forKey:@"SavescrollcontentHeightt"];
            // This is suggested to synch prefs, but is not needed (I didn't put it in my tut)
            [prefs synchronize];

        }
    }else
    {
        NSString *myString = [prefs stringForKey:@"SavescrollcontentHeightt"];
        if([myString length] == 0)
        {
            CGFloat myFloat = [prefs floatForKey:@"SavescrollcontentHeightt"];
            CGFloat NEWscrollviewcontentIntvalue = myFloat;
            if(NEWscrollviewcontentIntvalue == floatReducedifferencescrolllastimage)
            {
                
            }else{
                [prefs setFloat:floatReducedifferencescrolllastimage forKey:@"SavescrollcontentHeightt"];
                CGPoint bottomOffset = CGPointMake(0, self.scrollView.contentSize.height - self.scrollView.bounds.size.height + self.scrollView.contentInset.bottom + 120);
                [self.scrollView setContentOffset:bottomOffset animated:YES];
            }
        }
    }
   
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}
#pragma mark - UI BackGroundViews

-(void)scrollviewBG{
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(10, 84, self.view.frame.size.width-20, self.view.frame.size.height-_customTabBarView.frame.size.height-navigatonBarview.frame.size.height-32)];
    [self.scrollView setBackgroundColor:[UIColor whiteColor]];
    [self.scrollView setContentSize:CGSizeMake(self.view.frame.size.width-30, self.view.frame.size.height-_customTabBarView.frame.size.height-navigatonBarview.frame.size.height-32)];
    [self.view addSubview:self.scrollView];
}
-(void)textviewBG{
    
    ///TextViewBG
    self.backgroundTextView = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width-20,self.scrollView.contentSize.height)];
    [self.backgroundTextView setDelegate:self];
    [self.backgroundTextView.layoutManager setDelegate:self];
    [self.backgroundTextView setReturnKeyType:UIReturnKeyDone];
    self.backgroundTextView.allowsEditingTextAttributes = true;
    self.backgroundTextView.backgroundColor = [UIColor whiteColor];
    self.backgroundTextView.font = [UIFont systemFontOfSize:24];
    [self.scrollView addSubview:self.backgroundTextView];
    
   ///TextView Placeholder
    placeholderLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 4, self.backgroundTextView.frame.size.width, self.backgroundTextView.font.pointSize)];
    placeholderLabel.text = @"Enter some text...";
    placeholderLabel.font = [UIFont systemFontOfSize:self.backgroundTextView.font.pointSize];
    placeholderLabel.textColor = [UIColor lightGrayColor];
    [self.backgroundTextView addSubview:placeholderLabel];
}

-(void)navigationCustomBG
{
    ///////////Navigation Bar
    navigatonBarview=[[UIView alloc]initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, 60)];
    [navigatonBarview setBackgroundColor:[UIColor colorWithRed:66/255.0
                                                         green:244/255.0
                                                          blue:220/255.0
                                                         alpha:1]];
    
    [self.view addSubview:navigatonBarview];
    
    /////////////TITLE Label
    titlelabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 60)];
    titlelabel.text = @"EDITOR";
    titlelabel.font = [UIFont systemFontOfSize:24];
    titlelabel.textColor = [UIColor whiteColor];
    titlelabel.textAlignment = NSTextAlignmentCenter;
    [navigatonBarview addSubview:titlelabel];
    
    //////// ToolBar Background main view
    _customTabBarView=[[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-60, self.view.frame.size.width, 60)];
    [_customTabBarView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:_customTabBarView];
    
    //TOOLBAR BOARDER LINE
    UIView *toolbarborderline=[[UIView alloc]initWithFrame:CGRectMake(0, 0, _customTabBarView.frame.size.width, 1)];
    [toolbarborderline setBackgroundColor:[UIColor lightGrayColor]];
    [_customTabBarView addSubview:toolbarborderline];
    
    //////// TEXTOption Background main view
    _vwTextOptions=[[UIView alloc]initWithFrame:CGRectMake(10, self.view.frame.size.height-200, self.view.frame.size.width-20, 200)];
    [_vwTextOptions setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:_vwTextOptions];
    
    //TOOLBAR BOARDER LINE
    UIView * texttoolbarborderline=[[UIView alloc]initWithFrame:CGRectMake(-10, 0, _vwTextOptions.frame.size.width+20, 1)];
    [texttoolbarborderline setBackgroundColor:[UIColor lightGrayColor]];
    [_vwTextOptions addSubview:texttoolbarborderline];
    
    /////////TextFont sub view
    _vwTextFont=[[UIView alloc]initWithFrame:CGRectMake(10, 50, _vwTextOptions.frame.size.width-20, 150)];
    [_vwTextFont setBackgroundColor:[UIColor whiteColor]];
    [_vwTextOptions addSubview:_vwTextFont];
    
    ////////TextFormat sub view
    _vwTextFormat=[[UIView alloc]initWithFrame:CGRectMake(10, 50, _vwTextOptions.frame.size.width-20, 150)];
    [_vwTextFormat setBackgroundColor:[UIColor whiteColor]];
    [_vwTextOptions addSubview:_vwTextFormat];
    
    ////////TextBOXOption sub view
    _vwTextBoxOption=[[UIView alloc]initWithFrame:CGRectMake(10, 50, _vwTextOptions.frame.size.width-20, 150)];
    [_vwTextBoxOption setBackgroundColor:[UIColor whiteColor]];
    [_vwTextOptions addSubview:_vwTextBoxOption];
    
    //
    _vwEditTextBox = [[UIView alloc]initWithFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.size.height+60,self.view.frame.size.width, 150)];

}
- (void) menubuttonsBG {
     ////////Text Button
    UIButton *TextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [TextButton addTarget:self action:@selector(ExpandbuttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [TextButton.heightAnchor constraintEqualToConstant:40].active = true;
    [TextButton.widthAnchor constraintEqualToConstant:40].active = true;
    UIImage *textImage = [UIImage imageNamed:@"iconFont.png"];
    [TextButton setImage:textImage forState:UIControlStateNormal];
    
     ////////Camera Button
    UIButton *CameraButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [CameraButton addTarget:self action:@selector(camerabuttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [CameraButton.heightAnchor constraintEqualToConstant:40].active = true;
    [CameraButton.widthAnchor constraintEqualToConstant:40].active = true;
    UIImage *camImage = [UIImage imageNamed:@"iconPreview.png"];
    [CameraButton setImage:camImage forState:UIControlStateNormal];
   
    ////////Material Button
    UIButton *Materialbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    [Materialbutton addTarget:self action:@selector(materialbuttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [Materialbutton.heightAnchor constraintEqualToConstant:40].active = true;
    [Materialbutton.widthAnchor constraintEqualToConstant:40].active = true;
    UIImage *materialImage = [UIImage imageNamed:@"iconText.png"];
    [Materialbutton setImage:materialImage forState:UIControlStateNormal];
    
    ////////Exapnd Button
    UIButton *Expandbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    [Expandbutton addTarget:self action:@selector(ExpandbuttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [Expandbutton.heightAnchor constraintEqualToConstant:40].active = true;
    [Expandbutton.widthAnchor constraintEqualToConstant:40].active = true;
    UIImage *expandImage = [UIImage imageNamed:@"iconMore.png"];
    [Expandbutton setImage:expandImage forState:UIControlStateNormal];
    
    //Stack View
    UIStackView *stackView = [[UIStackView alloc] init];
    stackView.frame = CGRectMake(_customTabBarView.frame.origin.x, _customTabBarView.frame.origin.y, _customTabBarView.frame.size.width, _customTabBarView.frame.size.height);
    stackView.axis = UILayoutConstraintAxisHorizontal;
    stackView.distribution = UIStackViewDistributionEqualSpacing;
    stackView.alignment = UIStackViewAlignmentCenter;
    stackView.spacing = 50;
    stackView.backgroundColor = [UIColor blueColor];
    [stackView addArrangedSubview:TextButton];
    [stackView addArrangedSubview:CameraButton];
    [stackView addArrangedSubview:Materialbutton];
    [stackView addArrangedSubview:Expandbutton];
    stackView.translatesAutoresizingMaskIntoConstraints = false;
    [_customTabBarView addSubview:stackView];
    [stackView.centerXAnchor constraintEqualToAnchor:_customTabBarView.centerXAnchor].active = true;
    [stackView.centerYAnchor constraintEqualToAnchor:_customTabBarView.centerYAnchor].active = true;
}
-(void)customAlignButtonsBG{
    
    ///Bold
    self.btnBold = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btnBold.frame = CGRectMake(20, 20, 40, 40);
    [self.btnBold setTitleColor:[UIColor  whiteColor] forState: UIControlStateNormal];
    UIImage *image = [UIImage imageNamed:@"ico_bold_unchecked.png"];
    [self.btnBold setImage:image forState:UIControlStateNormal];
    self.btnBold.backgroundColor = [UIColor clearColor];
    boldflag = NO;
    [self.btnBold addTarget:self action:@selector(boldbuttonClicked:)forControlEvents:UIControlEventTouchUpInside];
    [_vwTextFormat addSubview:self.btnBold];
    
    //Underline
    self.btnUnderline = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btnUnderline.frame = CGRectMake(70, 20, 40, 40);
    UIImage *underimage = [UIImage imageNamed:@"ico_underline_unchecked.png"];
    [self.btnUnderline setImage:underimage forState:UIControlStateNormal];
    self.btnUnderline.backgroundColor = [UIColor clearColor];
    undelineflag = NO;
    [self.btnUnderline addTarget:self action:@selector(underlinebuttonClicked:)forControlEvents:UIControlEventTouchUpInside];
    [_vwTextFormat addSubview:self.btnUnderline];
    
    //Italic
    self.btnItalics = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btnItalics.frame = CGRectMake(120, 20, 40, 40);
    [self.btnItalics setTitleColor:[UIColor  whiteColor] forState: UIControlStateNormal];
    UIImage *italicimage = [UIImage imageNamed:@"ico_italic_unchecked.png"];
    italicflag = NO;
    [self.btnItalics setImage:italicimage forState:UIControlStateNormal];
    [self.btnItalics addTarget:self action:@selector(italicbuttonClicked:)forControlEvents:UIControlEventTouchUpInside];
    [_vwTextFormat addSubview:self.btnItalics];
    
    //LeftAlign
    self.btnLeftAlign = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btnLeftAlign.frame = CGRectMake(170, 20, 40, 40);
    [self.btnLeftAlign setTitleColor:[UIColor  whiteColor] forState: UIControlStateNormal];
    UIImage *leftimage = [UIImage imageNamed:@"ico_left_unchecked.png"];
    [self.btnLeftAlign setImage:leftimage forState:UIControlStateNormal];
    leftalignflag = NO;
    [self.btnLeftAlign addTarget:self action:@selector(leftalignbuttonClicked:)forControlEvents:UIControlEventTouchUpInside];
    [_vwTextFormat addSubview:self.btnLeftAlign];
    
    //CenterAlign
    self.btnCenterAlign = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btnCenterAlign.frame = CGRectMake(220, 20, 40, 40);
    [self.btnCenterAlign setTitleColor:[UIColor  whiteColor] forState: UIControlStateNormal];
    UIImage *centerimage = [UIImage imageNamed:@"ico_center_unchecked.png"];
    centeralignflag = NO;
    [self.btnCenterAlign setImage:centerimage forState:UIControlStateNormal];
    [self.btnCenterAlign addTarget:self action:@selector(centeralignbuttonClicked:)forControlEvents:UIControlEventTouchUpInside];
    [_vwTextFormat addSubview:self.btnCenterAlign];
    
    //RightAlign
    self.btnRightAlign = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btnRightAlign.frame = CGRectMake(270, 20, 40, 40);
    [self.btnRightAlign setTitleColor:[UIColor  whiteColor] forState: UIControlStateNormal];
    UIImage *rightimage = [UIImage imageNamed:@"ico_right_unchecked.png"];
    [self.btnRightAlign setImage:rightimage forState:UIControlStateNormal];
    rightalignflag = NO;
    [self.btnRightAlign addTarget:self action:@selector(rightalignbuttonClicked:)forControlEvents:UIControlEventTouchUpInside];
    [_vwTextFormat addSubview:self.btnRightAlign];
    
}
-(void)collectionviewBG
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setItemSize:CGSizeMake(50, 50)];
    [flowLayout setMinimumLineSpacing:1];
    [flowLayout setMinimumInteritemSpacing:1];
    [flowLayout setSectionInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    fontCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0.0, 8, _vwTextFont.frame.size.width, _vwTextFont.frame.size.height-24) collectionViewLayout:flowLayout];
    fontCollectionView.backgroundColor = [UIColor whiteColor];
    fontCollectionView.dataSource = self;
    fontCollectionView.delegate = self;
    [_vwTextFont addSubview:fontCollectionView];
    [fontCollectionView registerClass:[FontCollectionViewCell class] forCellWithReuseIdentifier:@"FontCell"];
}
-(void)collectionviewTextBoxBG
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setItemSize:CGSizeMake(80, 80)];
//    [flowLayout setMinimumLineSpacing:1];
//    [flowLayout setMinimumInteritemSpacing:1];
    [flowLayout setSectionInset:UIEdgeInsetsMake(5, 5, 5, 5)];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    textBoxCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0.0, 8, _vwTextBoxOption.frame.size.width, _vwTextBoxOption.frame.size.height-24) collectionViewLayout:flowLayout];
    textBoxCollectionView.backgroundColor = [UIColor whiteColor];
    textBoxCollectionView.dataSource = self;
    textBoxCollectionView.delegate = self;
    [_vwTextBoxOption addSubview:textBoxCollectionView];
    _vwTextBoxOption.hidden = YES;

    [textBoxCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellTextBox"];
}
-(void)Textboxview{
    
    _vwEditTextBox.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:_vwEditTextBox];
    self.textViewEditTextBox = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width-50,self.scrollView.contentSize.height)];
//    [textViewEditTextBox setDelegate:self];
//    self.textViewEditTextBox.delegate = self;
    [self.textViewEditTextBox setDelegate:self];
    [self.textViewEditTextBox.layoutManager setDelegate:self];
    [self.textViewEditTextBox setReturnKeyType:UIReturnKeyDone];
    self.textViewEditTextBox.allowsEditingTextAttributes = true;
    self.textViewEditTextBox.backgroundColor = [UIColor lightGrayColor];
    self.textViewEditTextBox.font = [UIFont systemFontOfSize:18];
    [_vwEditTextBox addSubview:self.textViewEditTextBox];
    [self.view bringSubviewToFront:_vwEditTextBox];
   
    ///Complete
    _btnCompleteDone = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnCompleteDone.frame = CGRectMake(self.textViewEditTextBox.frame.size.width+10, 10, 40, 40);
    UIImage *doneimage = [UIImage imageNamed:@"ico_complete_unchecked"];
    [_btnCompleteDone setImage:doneimage forState:UIControlStateNormal];
    [_btnCompleteDone addTarget:self action:@selector(DoneCompletebuttonClicked:)forControlEvents:UIControlEventTouchUpInside];
    [_vwEditTextBox addSubview:_btnCompleteDone];
   // _vwEditTextBox.hidden = YES;
//    vwEditTextBox.backgroundColor = UIColor.lightGray     //give color to the view
//    self.view.addSubview(vwEditTextBox)
//    self.textViewEditTextBox = UITextView()
//    self.textViewEditTextBox.delegate = self
//    self.textViewEditTextBox.allowsEditingTextAttributes = true
//    self.textViewEditTextBox.backgroundColor = UIColor.gray
//    self.textViewEditTextBox.font = .systemFont(ofSize: 18)
//    self.textViewEditTextBox.frame = CGRect(x:0,y:0,width:self.view.frame.size.width-50, height:self.scrollView.contentSize.height)
//    self.textViewEditTextBox.font = UIFont(name : selectedFontName, size:17)
//    self.vwEditTextBox.addSubview(textViewEditTextBox)
//    self.view.bringSubview(toFront: self.vwEditTextBox)
//    btnComplete = UIButton(frame: CGRect(x: textViewEditTextBox.frame.size.width+10, y: 10, width: 40, height: 40))
//    let doneimage = UIImage(named: "ico_complete_unchecked") as UIImage?
//    btnComplete.setImage(doneimage, for: .normal)
//    btnComplete.addTarget(self, action:#selector(self.Donecompleteboxbtn), for: .touchUpInside)
//    vwEditTextBox.addSubview(btnComplete)
//    vwEditTextBox.isHidden = true
}
#pragma mark - collection view delegate methods

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if(collectionView == fontCollectionView){
        return fontArray.count;
    }
    if(collectionView == textBoxCollectionView){
        return textBoxImagesArray.count;
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    id cell = nil;
    if(collectionView == fontCollectionView){
    NSString *cellIdentifier = @"FontCell";
    FontCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.contentView.layer.cornerRadius = 14;
    cell.contentView.layer.masksToBounds = true;
    [cell.contentView.layer setBorderColor:[UIColor grayColor].CGColor];
    [cell.contentView.layer setBorderWidth:2.0f];
    cell.label.tag = indexPath.row;
    cell.contentView.backgroundColor = [UIColor whiteColor];
    cell.label.textColor = [UIColor blackColor];
    cell.label.font = [UIFont fontWithName:fontArray[indexPath.row] size:25.0];;

    if(selectedFontCollectionIndexPath != nil && indexPath == selectedFontCollectionIndexPath)
    {
        cell.backgroundColor = [UIColor darkGrayColor];
    }else{
        cell.backgroundColor = [UIColor whiteColor];
    }
    return cell;
    }
    if(collectionView == textBoxCollectionView)
    {
        NSString *cellIdentifier = @"cellTextBox";
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdtextBox, for: indexPath)
        // Checking for plain textbox
        if(indexPath.row == 0){
            if(cell.contentView.subviews.count==0){
                UILabel *plainText = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 80)];
                plainText.text =@"TEXTT";
                // plainText.text = textBoxImagesArray[indexPath.row]
                [cell.contentView addSubview:plainText];
               
            }
        }else{ // If it is not plain textbox adding image to the cell
            
            if(cell.contentView.subviews.count==0){
                UIImageView *imgTextBoxItem = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 80, 80)];
                imgTextBoxItem.contentMode = UIViewContentModeScaleAspectFit;
                [cell.contentView addSubview:imgTextBoxItem];
                imgTextBoxItem.image = [UIImage imageNamed:[textBoxImagesArray objectAtIndex:indexPath.row]];

               // imgTextBoxItem.image = UIImage(named: textBoxImagesArray[indexPath.row])
               
            }
        }
        return cell;
    }
 return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
     if(collectionView == fontCollectionView){
    UICollectionViewCell *datasetCell =[collectionView cellForItemAtIndexPath:indexPath];
    datasetCell.backgroundColor = [UIColor blueColor];
    selectedFontCollectionIndexPath = indexPath;
    for (UICollectionViewCell *cell in [fontCollectionView visibleCells]) {
               NSIndexPath *indexPath = [fontCollectionView indexPathForCell:cell];
        if(indexPath == selectedFontCollectionIndexPath)
        {
            cell.backgroundColor = [UIColor darkGrayColor];
        }else{
            cell.backgroundColor = [UIColor whiteColor];
        }
    }
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    [self applyFontAttributesToSelectedRangeWithBoldTrait:nil italicTrait:nil fontName:[fontArray objectAtIndex:indexPath.row] fontSize:nil];
     }
    if(collectionView == textBoxCollectionView)
    {
         NSMutableAttributedString *titleString = [[NSMutableAttributedString alloc] initWithString:@"Double Tap to edit"];
       // [UIImage imageWithContentsOfFile:textBoxImagesArray[indexPath.row]]
        UIImage *myImage = [UIImage imageNamed: textBoxImagesArray[indexPath.row]];;

        [self stickerviewBG:(UIImage *)textBoxImagesArray[indexPath.row] : (NSAttributedString*)titleString];
    }
}


-(void)dragzoomroatateview:(UIImage *)img : (NSString*)imageName : (int)type : (NSAttributedString*)attributedString
{
    
    self.scrollView.contentSize = CGSizeMake(self.scrollView.contentSize.width, self.scrollView.contentSize.height);
    self.backgroundTextView.contentSize = CGSizeMake(self.backgroundTextView.frame.size.width, self.scrollView.contentSize.height);
    UIImage *image = [UIImage imageNamed:@"iconMemobird.png"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
//    sticker = [[LDStickerView alloc]initWithFrame:CGRectMake(10, 120, 300, 300)];
//    [sticker addSubview:imageView];
//    [self.view addSubview:sticker];
//    
//    stickerView = LDStickerView(frame: CGRect(x: (self.scrollView.contentSize.width-calcWidth)/2, y: self.scrollView.contentOffset.y+200, width: calcWidth, height: calcHeight))
//    
//    stickerView.accessibilityIdentifier = "drag"
//    let doubleTap = UITapGestureRecognizer(target: self, action: #selector(textBoxDoubleTapped))
//    doubleTap.numberOfTapsRequired = 2
}

#pragma mark - Gesture -

- (void) tapDescription:(UIGestureRecognizer *)gr {
    self.backgroundTextView.editable = YES;
    [self.backgroundTextView becomeFirstResponder];
}
#pragma mark - TextViewDelegate Method

- (void)selectParagraph:(id)sender
{
    if (![self.backgroundTextView hasText])
        return;
    NSRange range = [self.backgroundTextView.attributedText firstParagraphRangeFromTextRange:self.selectedRange];
    [self.backgroundTextView setSelectedRange:range];
    [[UIMenuController sharedMenuController] setTargetRect:[self frameOfTextAtRange:self.backgroundTextView.selectedRange] inView:self.backgroundTextView];
    [[UIMenuController sharedMenuController] setMenuVisible:YES animated:YES];
}

- (void) textViewDidEndEditing:(UITextView *)textView {
    //whatever else you need to do
    textView.editable = NO;
    if (![textView hasText]) {
        placeholderLabel.hidden = NO;
    }
}
- (void) textViewDidChange:(UITextView *)textView
{
    if(![textView hasText]) {
        placeholderLabel.hidden = NO;
        [self applyFontAttributesToSelectedRangeWithBoldTrait:nil italicTrait:nil fontName:@"ArialMT" fontSize:[NSNumber numberWithFloat: 24]];
        [self enumarateThroughParagraphsInRange:self.backgroundTextView.selectedRange withBlock:^(NSRange paragraphRange){
            NSDictionary *dictionary = [self dictionaryAtIndex:paragraphRange.location];
            NSMutableParagraphStyle *paragraphStyle = [[dictionary objectForKey:NSParagraphStyleAttributeName] mutableCopy];
            if (!paragraphStyle)
                paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            paragraphStyle.alignment = NSTextAlignmentLeft;
            [self applyAttributes:paragraphStyle forKey:NSParagraphStyleAttributeName atRange:paragraphRange];
        }];
        fontsizeLabel.text = [NSNumber numberWithFloat:1].stringValue;
        fontSlider.value = 1;
        if(boldflag == YES){
            [self.btnBold setSelected:NO];
            UIImage *image = [UIImage imageNamed:@"ico_bold_unchecked.png"];
            [self.btnBold setImage:image forState:UIControlStateNormal];
        }
        if(undelineflag == YES){
            [self.btnUnderline setSelected:NO];
            UIImage *underimage = [UIImage imageNamed:@"ico_underline_unchecked.png"];
            [self.btnUnderline setImage:underimage forState:UIControlStateNormal];
        }
        if(italicflag == YES){
            [self.btnItalics setSelected:NO];
            UIImage *italicimage = [UIImage imageNamed:@"ico_italic_unchecked.png"];
            [self.btnItalics setImage:italicimage forState:UIControlStateNormal];
        }
        if(leftalignflag == YES){
            [self.btnLeftAlign setSelected:NO];
            UIImage *leftimage = [UIImage imageNamed:@"ico_left_unchecked.png"];
            [self.btnLeftAlign setImage:leftimage forState:UIControlStateNormal];
        }
        if(centeralignflag == YES){
            [self.btnCenterAlign setSelected:NO];
            UIImage *centerimage = [UIImage imageNamed:@"ico_center_unchecked.png"];
            [self.btnCenterAlign setImage:centerimage forState:UIControlStateNormal];
        }
        if(rightalignflag == YES){
            [self.btnRightAlign setSelected:NO];
            UIImage *rightimage = [UIImage imageNamed:@"ico_right_unchecked.png"];
            [self.btnRightAlign setImage:rightimage forState:UIControlStateNormal];
        }
    }
    else{
        placeholderLabel.hidden = YES;
    }
    if(textView == _textViewEditTextBox){
        
        //selectedFont = selectedTextBoxButton.titleLabel?.font
      //  [UIFont fontWithName:fontArray[indexPath.row] size:25.0]
      
        NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
        paragraph.lineBreakMode = NSLineBreakByWordWrapping;
        NSDictionary *attributes = @{NSFontAttributeName : self.btnImageWithText.titleLabel.font,
                                     NSParagraphStyleAttributeName : paragraph};
        CGSize constrainedSize = CGSizeMake(self.btnImageWithText.bounds.size.width, NSIntegerMax);
        CGRect rect = [self.btnImageWithText.titleLabel.text boundingRectWithSize:constrainedSize
                                                 options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                              attributes:attributes context:nil];
        NSLog(@"i%",rect);
        NSLog(@"i%",self.btnImageWithText.bounds.size.height);
        NSLog(@"RECTTT  TOO MUCH");

        
        if (rect.size.height + 100> self.btnImageWithText.bounds.size.height) {
            NSLog(@"TOO MUCH");
            self.vwEditTextBox.hidden = YES;
            _btnFormat.hidden = NO;
            _btnFont.hidden = NO;
            
            
            NSMutableAttributedString *titleString = [[NSMutableAttributedString alloc] initWithString:_textViewEditTextBox.text];
            [selectedTextBoxButton setAttributedTitle:titleString forState:UIControlStateNormal];
            //    let myAttribute = [ NSAttributedStringKey.font: selectedFont ]
            //    let myString = NSMutableAttributedString(string:textViewEditTextBox.text, attributes: myAttribute )
            //    selectedTextBoxButton.setAttributedTitle(myString, for: .normal)
            self.scrollView.contentSize = CGSizeMake(self.scrollView.contentSize.width, self.scrollView.contentSize.height);
            CGRect customTabBarframe = self.customTabBarView.frame;
            customTabBarframe.origin.y = self.view.frame.size.height-60;
            self.customTabBarView.frame = customTabBarframe;
            CGRect _vwEditTextBoxrame = self.vwEditTextBox.frame;
            _vwEditTextBoxrame.origin.y = self.view.frame.size.height+60;
            self.vwEditTextBox.frame = _vwEditTextBoxrame;
            [_textViewEditTextBox resignFirstResponder];
            UIAlertController * alert=   [UIAlertController
                                          alertControllerWithTitle:@"Exceeded Limit"
                                          message:nil
                                          preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                
                //do something when click button
            }];
            [alert addAction:okAction];
            [self presentViewController:alert animated:YES completion:nil];

        }else{
            NSMutableAttributedString *titleString = [[NSMutableAttributedString alloc] initWithString:_textViewEditTextBox.text];
            [selectedTextBoxButton setAttributedTitle:titleString forState:UIControlStateNormal];
        }
//        [btnImageWithText setAttributedTitle:titleString forState:UIControlStateNormal];
//        NSAttributedString *attribute = [NSAttributedString]
//        let myAttribute = [ NSAttributedStringKey.font: selectedFont ]
//        let myString = NSMutableAttributedString(string:textViewEditTextBox.text, attributes: myAttribute )
//        selectedTextBoxButton.setAttributedTitle(myString, for: .normal)
    }
}
- (CGFloat)layoutManager:(NSLayoutManager *)layoutManager lineSpacingAfterGlyphAtIndex:(NSUInteger)glyphIndex withProposedLineFragmentRect:(CGRect)rect
{
    return 10;
}

#pragma mark - Editor Methods -
-(void) boldbuttonClicked:(UIButton*)sender
{
    sender.selected  = ! sender.selected;
    if (sender.selected){
        UIImage *image = [UIImage imageNamed:@"ico_bold_checked.png"];
        [self.btnBold setImage:image forState:UIControlStateNormal];
        boldflag = YES;
    }
    else{
        UIImage *image = [UIImage imageNamed:@"ico_bold_unchecked.png"];
        [self.btnBold setImage:image forState:UIControlStateNormal];
        boldflag = NO;
    }
    UIFont *font = [self fontAtIndex:self.backgroundTextView.selectedRange.location];
    [self applyFontAttributesToSelectedRangeWithBoldTrait:[NSNumber numberWithBool:![font isBold]] italicTrait:nil fontName:nil fontSize:nil];
}

-(void) underlinebuttonClicked:(UIButton*)sender
{
    sender.selected  = ! sender.selected;
    if (sender.selected){
        UIImage *underimage = [UIImage imageNamed:@"ico_underline_checked.png"];
        [self.btnUnderline setImage:underimage forState:UIControlStateNormal];
        undelineflag = YES;
    }
    else{
        UIImage *underimage = [UIImage imageNamed:@"ico_underline_unchecked.png"];
        [self.btnUnderline setImage:underimage forState:UIControlStateNormal];
        undelineflag = NO;
    }
    NSDictionary *dictionary = [self dictionaryAtIndex:self.backgroundTextView.selectedRange.location];
    NSNumber *existingUnderlineStyle = [dictionary objectForKey:NSUnderlineStyleAttributeName];
    if (!existingUnderlineStyle || existingUnderlineStyle.intValue == NSUnderlineStyleNone)
        existingUnderlineStyle = [NSNumber numberWithInteger:NSUnderlineStyleSingle];
    else
        existingUnderlineStyle = [NSNumber numberWithInteger:NSUnderlineStyleNone];
    [self applyAttrubutesToSelectedRange:existingUnderlineStyle forKey:NSUnderlineStyleAttributeName];
}
-(void) italicbuttonClicked:(UIButton*)sender
{
    sender.selected  = ! sender.selected;
    if (sender.selected){
        UIImage *italicimage = [UIImage imageNamed:@"ico_italic_checked.png"];
        [self.btnItalics setImage:italicimage forState:UIControlStateNormal];
        italicflag = YES;
         [self applyFontAttributesToSelectedRangeWithBoldTrait:nil italicTrait:[NSNumber numberWithBool:1] fontName:nil fontSize:nil];
    }
    else{
        UIImage *italicimage = [UIImage imageNamed:@"ico_italic_unchecked.png"];
        [self.btnItalics setImage:italicimage forState:UIControlStateNormal];
        italicflag = NO;
         [self applyFontAttributesToSelectedRangeWithBoldTrait:nil italicTrait:[NSNumber numberWithBool:0] fontName:nil fontSize:nil];
    }
   
   

}
-(void) leftalignbuttonClicked:(UIButton*)sender
{
    sender.selected  = ! sender.selected;
    if (sender.selected){
        rightalignflag = NO;
        leftalignflag = YES;
        centeralignflag = NO;
        
    }
    UIImage *leftimage = [UIImage imageNamed:@"ico_left_checked.png"];
    [self.btnLeftAlign setImage:leftimage forState:UIControlStateNormal];
    UIImage *centerimage = [UIImage imageNamed:@"ico_center_unchecked.png"];
    [self.btnCenterAlign setImage:centerimage forState:UIControlStateNormal];
    UIImage *rightimage = [UIImage imageNamed:@"ico_right_unchecked.png"];
    [self.btnRightAlign setImage:rightimage forState:UIControlStateNormal];
    [self enumarateThroughParagraphsInRange:self.backgroundTextView.selectedRange withBlock:^(NSRange paragraphRange){
        NSDictionary *dictionary = [self dictionaryAtIndex:paragraphRange.location];
        NSMutableParagraphStyle *paragraphStyle = [[dictionary objectForKey:NSParagraphStyleAttributeName] mutableCopy];
        if (!paragraphStyle)
            paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.alignment = NSTextAlignmentLeft;
        [self applyAttributes:paragraphStyle forKey:NSParagraphStyleAttributeName atRange:paragraphRange];
    }];
    
}
-(void) centeralignbuttonClicked:(UIButton*)sender
{
    sender.selected  = ! sender.selected;
    if (sender.selected){
        rightalignflag = NO;
        leftalignflag = NO;
        centeralignflag = YES;
    }
    UIImage *leftimage = [UIImage imageNamed:@"ico_left_unchecked.png"];
    [self.btnLeftAlign setImage:leftimage forState:UIControlStateNormal];
    UIImage *centerimage = [UIImage imageNamed:@"ico_center_checked.png"];
    [self.btnCenterAlign setImage:centerimage forState:UIControlStateNormal];
    UIImage *rightimage = [UIImage imageNamed:@"ico_right_unchecked.png"];
    [self.btnRightAlign setImage:rightimage forState:UIControlStateNormal];
    [self enumarateThroughParagraphsInRange:self.backgroundTextView.selectedRange withBlock:^(NSRange paragraphRange){
        NSDictionary *dictionary = [self dictionaryAtIndex:paragraphRange.location];
        NSMutableParagraphStyle *paragraphStyle = [[dictionary objectForKey:NSParagraphStyleAttributeName] mutableCopy];
        if (!paragraphStyle)
            paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.alignment = NSTextAlignmentCenter;
        [self applyAttributes:paragraphStyle forKey:NSParagraphStyleAttributeName atRange:paragraphRange];
    }];
    
}
-(void) rightalignbuttonClicked:(UIButton*)sender
{
    sender.selected  = ! sender.selected;
    if (sender.selected){
        rightalignflag = YES;
        leftalignflag = NO;
        centeralignflag = NO;
    }
    UIImage *leftimage = [UIImage imageNamed:@"ico_left_unchecked.png"];
    [self.btnLeftAlign setImage:leftimage forState:UIControlStateNormal];
    UIImage *centerimage = [UIImage imageNamed:@"ico_center_unchecked.png"];
    [self.btnCenterAlign setImage:centerimage forState:UIControlStateNormal];
    UIImage *rightimage = [UIImage imageNamed:@"ico_right_checked.png"];
    [self.btnRightAlign setImage:rightimage forState:UIControlStateNormal];
    [self enumarateThroughParagraphsInRange:self.backgroundTextView.selectedRange withBlock:^(NSRange paragraphRange){
        NSDictionary *dictionary = [self dictionaryAtIndex:paragraphRange.location];
        NSMutableParagraphStyle *paragraphStyle = [[dictionary objectForKey:NSParagraphStyleAttributeName] mutableCopy];
        if (!paragraphStyle)
            paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.alignment = NSTextAlignmentRight;
        [self applyAttributes:paragraphStyle forKey:NSParagraphStyleAttributeName atRange:paragraphRange];
    }];
    
}
#pragma mark - MenuButtons -
-(void) TextBoxExpandbuttonClicked:(UIButton*)sender
{
}
-(void) camerabuttonClicked:(UIButton*)sender{
    _vwTextOptions.hidden = NO;
    
    _vwTextBoxOption.hidden = NO;
    _btnFormat.hidden = YES;
    _btnFont.hidden = YES;
    [self.backgroundTextView resignFirstResponder];
    
    CGRect scrollframe = self.scrollView.frame;
    scrollframe.size.height = self.view.frame.size.height-navigatonBarview.frame.size.height-32-_vwTextOptions.frame.size.height;
    self.scrollView.frame = scrollframe;
}
-(void) materialbuttonClicked:(UIButton*)sender{
}
-(void) ExpandbuttonClicked:(UIButton*)sender{
    _vwTextOptions.hidden = NO;
    _vwTextBoxOption.hidden = YES;
    [self.backgroundTextView resignFirstResponder];
    CGRect scrollframe = self.scrollView.frame;
    scrollframe.size.height = self.view.frame.size.height-navigatonBarview.frame.size.height-32-_vwTextOptions.frame.size.height;
    self.scrollView.frame = scrollframe;
}
#pragma mark - Slider

-(void)sliderBG{
     //Slider value  Label
    fontLabel = [[UILabel alloc]initWithFrame:CGRectMake(4, 80, 40, 40)];
    fontLabel.text = @"Size";
    fontLabel.font = [UIFont systemFontOfSize:20];
    fontLabel.textColor = [UIColor grayColor];
    fontLabel.textAlignment = NSTextAlignmentLeft;
    [_vwTextFormat addSubview:fontLabel];
    
     //Slider Current value Label
    fontsizeLabel = [[UILabel alloc]initWithFrame:CGRectMake(46, 80, 30, 40)];
    fontsizeLabel.font = [UIFont systemFontOfSize:20];
    fontsizeLabel.textColor = [UIColor grayColor];
    fontsizeLabel.textAlignment = NSTextAlignmentCenter;
    [_vwTextFormat addSubview:fontsizeLabel];
    
     //Slider MAximum value Label
    fontmaxsizeLabel = [[UILabel alloc]initWithFrame:CGRectMake(_vwTextFormat.frame.size.width-60, 80, 30, 40)];
    fontmaxsizeLabel.text = @"20";
    fontmaxsizeLabel.font = [UIFont systemFontOfSize:20];
    fontmaxsizeLabel.textColor = [UIColor grayColor];
    fontmaxsizeLabel.textAlignment = NSTextAlignmentRight;
    [_vwTextFormat addSubview:fontmaxsizeLabel];
   
    //Slider
    CGRect frame = CGRectMake(90, 80,_vwTextOptions.frame.size.width-180, 40);
    fontSlider = [[UISlider alloc] initWithFrame:frame];
    [fontSlider addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
    fontSlider.tintColor = [UIColor greenColor];
    fontSlider.minimumValue = 1;
    fontSlider.maximumValue = 20;
    fontSlider.continuous = YES;
    fontSlider.value = 1;
    fontsizeLabel.text = [NSNumber numberWithFloat:fontSlider.value].stringValue;
    [_vwTextFormat addSubview:fontSlider];
}
-(void)valueChanged:(id)sender{
    UISlider *slider = (UISlider*)sender;
    float value = slider.value;
    fontsizeLabel.text = [NSNumber numberWithFloat:(int)value].stringValue;
    [self applyFontAttributesToSelectedRangeWithBoldTrait:nil italicTrait:nil fontName:nil fontSize:[NSNumber numberWithFloat:(int)value + 24]];
}
#pragma mark - TextFont/Format/Done button BG

-(void)completebtnBG{
    ///Textbutton
    _btnFormat = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnFormat.frame = CGRectMake(30, 10, 40, 40);
    UIImage *leftimage = [UIImage imageNamed:@"ico_format.png"];
    [_btnFormat setImage:leftimage forState:UIControlStateNormal];
    [_btnFormat addTarget:self action:@selector(textformatbuttonClicked:)forControlEvents:UIControlEventTouchUpInside];
    [_vwTextOptions addSubview:_btnFormat];
   
   
    /////Font
    _btnFont = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnFont.frame = CGRectMake(100, 10, 40, 40);
    UIImage *fontimage = [UIImage imageNamed:@"ico_font.png"];
    [_btnFont setImage:fontimage forState:UIControlStateNormal];
    [_btnFont addTarget:self action:@selector(textfontbuttonClicked:)forControlEvents:UIControlEventTouchUpInside];
    [_vwTextOptions addSubview:_btnFont];

    ///Complete
    _btnComplete = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnComplete.frame = CGRectMake(_vwTextOptions.frame.size.width-60, 10, 40, 40);
    UIImage *doneimage = [UIImage imageNamed:@"ico_complete_unchecked"];
    [_btnComplete setImage:doneimage forState:UIControlStateNormal];
    [_btnComplete addTarget:self action:@selector(DonebuttonClicked:)forControlEvents:UIControlEventTouchUpInside];
    [_vwTextOptions addSubview:_btnComplete];
}
#pragma mark - TextFont/Format/Done button Action
-(void)DoneCompletebuttonClicked:(UIButton *)sender
{
    self.vwEditTextBox.hidden = YES;
    _btnFormat.hidden = NO;
    _btnFont.hidden = NO;
    

    NSMutableAttributedString *titleString = [[NSMutableAttributedString alloc] initWithString:_textViewEditTextBox.text];
    [selectedTextBoxButton setAttributedTitle:titleString forState:UIControlStateNormal];
//    let myAttribute = [ NSAttributedStringKey.font: selectedFont ]
//    let myString = NSMutableAttributedString(string:textViewEditTextBox.text, attributes: myAttribute )
//    selectedTextBoxButton.setAttributedTitle(myString, for: .normal)
    self.scrollView.contentSize = CGSizeMake(self.scrollView.contentSize.width, self.scrollView.contentSize.height);
    CGRect customTabBarframe = self.customTabBarView.frame;
    customTabBarframe.origin.y = self.view.frame.size.height-60;
    self.customTabBarView.frame = customTabBarframe;
    CGRect _vwEditTextBoxrame = self.vwEditTextBox.frame;
    _vwEditTextBoxrame.origin.y = self.view.frame.size.height+60;
    self.vwEditTextBox.frame = _vwEditTextBoxrame;
    [_textViewEditTextBox resignFirstResponder];
}
-(void) DonebuttonClicked:(UIButton*)sender{
    _vwTextOptions.hidden = YES;
    _customTabBarView.hidden = NO;
    _btnFont.hidden = NO;
    _btnFormat.hidden = NO;
    CGRect scrollframe = self.scrollView.frame;
    scrollframe.size.height = self.view.frame.size.height-navigatonBarview.frame.size.height-32-_customTabBarView.frame.size.height;
    self.scrollView.frame = scrollframe;
}
-(void) textformatbuttonClicked:(UIButton*)sender
{
    _vwTextFormat.hidden = NO;
    _vwTextFont.hidden = YES;
}
-(void) textfontbuttonClicked:(UIButton*)sender
{
    _vwTextFormat.hidden = YES;
    _vwTextFont.hidden = NO;
}
#pragma mark - Keyboard Actions

- (void)keyboardWillShow:(NSNotification *)notification {
//    self.customTabBarView.frame.origin.y = self.view.frame.size.height-60 - keyboardSize.height
//    self.customTabBarView.isHidden = false
//
//    if(self.textViewEditTextBox.isFirstResponder == true){
//
//        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
//            keyboardHeight = keyboardSize.height
//
//            showEditTextBox()
//        }
//
//    }else{
//        self.vwEditTextBox.isHidden = true
//    }
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    keyboardHeight = keyboardSize.height;
    CGRect f = _customTabBarView.frame;
    f.origin.y = self.view.frame.size.height-60-keyboardSize.height;
    _customTabBarView.frame = f;
    if(_textViewEditTextBox.isFirstResponder == true)
    {
        keyboardHeight = keyboardSize.height;
        [self showEditTextBox];
    }
    CGRect scrollframe = self.scrollView.frame;
    scrollframe.size.height = self.view.frame.size.height-_customTabBarView.frame.size.height-navigatonBarview.frame.size.height-32-keyboardSize.height;
    self.scrollView.frame = scrollframe;
    _customTabBarView.hidden = NO;
    self.backgroundTextView.selectedRange = NSMakeRange(self.backgroundTextView.attributedText.length, 0);
    [UIView commitAnimations];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    CGRect scrollframe = self.scrollView.frame;
    scrollframe.size.height = self.view.frame.size.height-navigatonBarview.frame.size.height-32-_vwTextOptions.frame.size.height;
    self.scrollView.frame = scrollframe;
    CGRect f = _customTabBarView.frame;
    f.origin.y = self.view.frame.size.height-60;
    _customTabBarView.frame = f;
  
    _customTabBarView.hidden = YES;
    _vwTextOptions.hidden = NO;
    [UIView commitAnimations];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - TextEditor Private Methods

- (UIFont *)fontAtIndex:(NSInteger)index
{
    // If index at end of string, get attributes starting from previous character
    if (index == self.backgroundTextView.attributedText.string.length && [self.backgroundTextView hasText])
        --index;
    
    // If no text exists get font from typing attributes
    NSDictionary *dictionary = ([self.backgroundTextView hasText])
    ? [self.backgroundTextView.attributedText attributesAtIndex:index effectiveRange:nil]
    : self.backgroundTextView.typingAttributes;
    
    return [dictionary objectForKey:NSFontAttributeName];
}

- (NSDictionary *)dictionaryAtIndex:(NSInteger)index
{
    // If index at end of string, get attributes starting from previous character
    if (index == self.backgroundTextView.attributedText.string.length && [self.backgroundTextView hasText])
        --index;
    
    // If no text exists get font from typing attributes
    return  ([self.backgroundTextView hasText])
    ? [self.backgroundTextView.attributedText attributesAtIndex:index effectiveRange:nil]
    : self.backgroundTextView.typingAttributes;
}

- (void)applyAttributeToTypingAttribute:(id)attribute forKey:(NSString *)key
{
    NSMutableDictionary *dictionary = [self.backgroundTextView.typingAttributes mutableCopy];
    [dictionary setObject:attribute forKey:key];
    [self.backgroundTextView setTypingAttributes:dictionary];
}

- (void)applyAttributes:(id)attribute forKey:(NSString *)key atRange:(NSRange)range
{
    // If any text selected apply attributes to text
    if (range.length > 0)
    {
        NSMutableAttributedString *attributedString = [self.backgroundTextView.attributedText mutableCopy];
        
        // Workaround for when there is only one paragraph,
        // sometimes the attributedString is actually longer by one then the displayed text,
        // and this results in not being able to set to lef align anymore.
        if (range.length == attributedString.length-1 && range.length == self.backgroundTextView.text.length)
            ++range.length;
        
        [attributedString addAttributes:[NSDictionary dictionaryWithObject:attribute forKey:key] range:range];
        
        [self.backgroundTextView setAttributedText:attributedString];
        [self.backgroundTextView setSelectedRange:range];
    }
    // If no text is selected apply attributes to typingAttribute
    else
    {
        self.typingAttributesInProgress = YES;
        [self applyAttributeToTypingAttribute:attribute forKey:key];
    }
}

- (void)applyAttrubutesToSelectedRange:(id)attribute forKey:(NSString *)key
{
    [self applyAttributes:attribute forKey:key atRange:self.backgroundTextView.selectedRange];
}

- (void)applyFontAttributesToSelectedRangeWithBoldTrait:(NSNumber *)isBold italicTrait:(NSNumber *)isItalic fontName:(NSString *)fontName fontSize:(NSNumber *)fontSize
{
    [self applyFontAttributesWithBoldTrait:isBold italicTrait:isItalic fontName:fontName fontSize:fontSize toTextAtRange:self.backgroundTextView.selectedRange];
}

- (void)applyFontAttributesWithBoldTrait:(NSNumber *)isBold italicTrait:(NSNumber *)isItalic fontName:(NSString *)fontName fontSize:(NSNumber *)fontSize toTextAtRange:(NSRange)range
{
    // If any text selected apply attributes to text
    if (range.length > 0)
    {
        
        /////////////////
        NSMutableAttributedString *attributedString = [self.backgroundTextView.attributedText mutableCopy];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
        
        [paragraphStyle setLineSpacing:24];
        paragraphStyle.lineHeightMultiple = 50.0f;
        paragraphStyle.maximumLineHeight = 50.0f;
        paragraphStyle.minimumLineHeight = 50.0f;
        if(leftalignflag == YES){
            paragraphStyle.alignment = NSTextAlignmentLeft;
        }
        if(centeralignflag == YES){
            paragraphStyle.alignment = NSTextAlignmentCenter;
        }
        if(rightalignflag == YES){
            paragraphStyle.alignment = NSTextAlignmentRight;
        }
        [attributedString beginEditing];
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, self.backgroundTextView.attributedText.length)];
        [attributedString enumerateAttributesInRange:range
                                             options:NSAttributedStringEnumerationLongestEffectiveRangeNotRequired
                                          usingBlock:^(NSDictionary *dictionary, NSRange range, BOOL *stop){

UIFont *newFont = [self fontwithBoldTrait:isBold
                              italicTrait:isItalic
                                 fontName:fontName
                                 fontSize:fontSize
                           fromDictionary:dictionary];
      if (newFont)
          [attributedString addAttributes:[NSDictionary dictionaryWithObject:newFont forKey:NSFontAttributeName] range:range];
                                          }];
          [attributedString endEditing];
        self.backgroundTextView.attributedText = attributedString;
      [self.backgroundTextView setSelectedRange:range];
    }
    // If no text is selected apply attributes to typingAttribute
    else
    {
        self.typingAttributesInProgress = YES;
        UIFont *newFont = [self fontwithBoldTrait:isBold
                                      italicTrait:isItalic
                                         fontName:fontName
                                         fontSize:fontSize
                                   fromDictionary:self.backgroundTextView.typingAttributes];
        if (newFont)
            [self applyAttributeToTypingAttribute:newFont forKey:NSFontAttributeName];
    }
   
}
// Returns a font with given attributes. For any missing parameter takes the attribute from a given dictionary
- (UIFont *)fontwithBoldTrait:(NSNumber *)isBold italicTrait:(NSNumber *)isItalic fontName:(NSString *)fontName fontSize:(NSNumber *)fontSize fromDictionary:(NSDictionary *)dictionary
{
   

    UIFont *newFont = nil;
    UIFont *font = [dictionary objectForKey:NSFontAttributeName];
    BOOL newBold = (isBold) ? isBold.intValue : [font isBold];
    BOOL newItalic = (isItalic) ? isItalic.intValue : [font isItalic];
    CGFloat newFontSize = (fontSize) ? fontSize.floatValue : font.pointSize;

    if (fontName)
    {
        newFont = [UIFont fontWithName:fontName size:newFontSize boldTrait:newBold italicTrait:newItalic];
    }
    else
    {
        newFont = [font fontWithBoldTrait:newBold italicTrait:newItalic andSize:newFontSize];
    }
    
    return newFont;
}
- (CGRect)frameOfTextAtRange:(NSRange)range
{
    UITextRange *selectionRange = [self.backgroundTextView selectedTextRange];
    NSArray *selectionRects = [self.backgroundTextView selectionRectsForRange:selectionRange];
    CGRect completeRect = CGRectNull;
    
    for (UITextSelectionRect *selectionRect in selectionRects)
    {
        completeRect = (CGRectIsNull(completeRect))
        ? selectionRect.rect
        : CGRectUnion(completeRect,selectionRect.rect);
    }
    
    return completeRect;
}

- (void)enumarateThroughParagraphsInRange:(NSRange)range withBlock:(void (^)(NSRange paragraphRange))block
{
    if (![self.backgroundTextView hasText])
        return;
    
    NSArray *rangeOfParagraphsInSelectedText = [self.backgroundTextView.attributedText rangeOfParagraphsFromTextRange:self.backgroundTextView.selectedRange];
    
    for (int i=0 ; i<rangeOfParagraphsInSelectedText.count ; i++)
    {
        NSValue *value = [rangeOfParagraphsInSelectedText objectAtIndex:i];
        NSRange paragraphRange = [value rangeValue];
        block(paragraphRange);
    }
    
    NSRange fullRange = [self fullRangeFromArrayOfParagraphRanges:rangeOfParagraphsInSelectedText];
    [self.backgroundTextView setSelectedRange:fullRange];
}

- (NSRange)fullRangeFromArrayOfParagraphRanges:(NSArray *)paragraphRanges
{
    if (!paragraphRanges.count)
        return NSMakeRange(0, 0);
    
    NSRange firstRange = [[paragraphRanges objectAtIndex:0] rangeValue];
    NSRange lastRange = [[paragraphRanges lastObject] rangeValue];
    return NSMakeRange(firstRange.location, lastRange.location + lastRange.length - firstRange.location);
}
-(void)stickerviewBG:(UIImage *)img : (NSAttributedString *)attributedString
{
//    CGFloat calcWidth = 0.0;
//    CGFloat calcHeight = 0.0;
//    //calcWidth = CGFloat(200)
//    //calcHeight = CGFloat(200)
//    if(img.size.width > self.view.frame.size.width){
//        calcWidth = img.size.width/4;
//        calcHeight = img.size.height/4;
//    }
//    else{
//        calcWidth = img.size.width;
//        calcHeight = img.size.height;
//    }
    self.scrollView.contentSize = CGSizeMake(self.scrollView.contentSize.width, self.scrollView.contentSize.height);
    self.backgroundTextView.contentSize = CGSizeMake(self.backgroundTextView.frame.size.width, self.scrollView.contentSize.height);

    _selectedView = [[LDStickerView alloc]initWithFrame:CGRectMake(self.scrollView.frame.origin.x+20, self.scrollView.frame.origin.y , 300, 300)];
    _selectedView.accessibilityIdentifier = @"drag";

//
    self.btnImageWithText = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btnImageWithText.frame = CGRectMake(20, 20, _selectedView.frame.size.width-80, _selectedView.frame.size.height-40);
    [self.btnImageWithText setTitleColor:[UIColor  blackColor] forState: UIControlStateNormal];
    self.btnImageWithText.titleLabel.numberOfLines = 0;
    self.btnImageWithText.backgroundColor = [UIColor clearColor];
    self.btnImageWithText.clipsToBounds = true;
    self.btnImageWithText.titleLabel.minimumScaleFactor = 0.5;
   self.btnImageWithText.titleLabel.adjustsFontSizeToFitWidth = true;
    self.btnImageWithText.titleEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 20);
    [self.btnImageWithText setUserInteractionEnabled:NO];
    UIImage *image = [UIImage imageNamed:img];
    [self.btnImageWithText setBackgroundImage:image forState:UIControlStateNormal];
    NSMutableAttributedString *titleString = [[NSMutableAttributedString alloc] initWithString:@"Double Tap to edit"];
    [self.btnImageWithText setAttributedTitle:titleString forState:UIControlStateNormal];

   // [btnImageWithText addTarget:self action:@selector(boldbuttonClicked:)forControlEvents:UIControlEventTouchUpInside];
   // [_vwTextFormat addSubview:btnImageWithText];
    UITapGestureRecognizer *gesRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)]; // Declare the Gesture.
    gesRecognizer.numberOfTapsRequired = 2;
    gesRecognizer.delegate = self;
    [_selectedView addGestureRecognizer:gesRecognizer];
//    [_selectedView addSubview:btnImageWithText];
    [_selectedView setContentView:self.btnImageWithText];
    [self.scrollView addSubview:_selectedView];

//    [scrollView addSubview:_selectedView];

   
    
   // self.selectedView = stickerView;
}
- (void)handleTap:(UIGestureRecognizer *)gestureRecognizer{
    NSLog(@"Tapped");
    [self showEditTextBox];
    [self Textboxview];

    _vwEditTextBox.hidden = NO;
    selectedTextBoxButton = gestureRecognizer.view.subviews[0];
    self.textViewEditTextBox.layer.borderWidth = 1.0;
    self.textViewEditTextBox.layer.borderColor = (__bridge CGColorRef _Nullable)([UIColor grayColor]);
    if([selectedTextBoxButton.titleLabel.text  isEqual: @"Double Tap to edit"])
    {
        self.textViewEditTextBox.text = @"";
        selectedTextBoxButton.titleLabel.text = @"";
        NSMutableAttributedString *titleString = [[NSMutableAttributedString alloc] initWithString:@""];
       [self.btnImageWithText setAttributedTitle:titleString forState:UIControlStateNormal];
//[selectedTextBoxButton setAttributedTitle:(NSAttributedString) forState:UIControlStateNormal];
        
    }
    self.textViewEditTextBox.text = selectedTextBoxButton.titleLabel.text;
    self.textViewEditTextBox.layer.borderWidth = 1.0;
    self.textViewEditTextBox.text = selectedTextBoxButton.titleLabel.text;
    self.textViewEditTextBox.editable = YES;
    [self.textViewEditTextBox becomeFirstResponder];

}

-(void)showEditTextBox
{
    CGRect _vwEditTextBoxframe = _vwEditTextBox.frame;
    _vwEditTextBoxframe.origin.y = self.view.frame.size.height-60-keyboardHeight;
    _vwEditTextBox.frame = _vwEditTextBoxframe;
    _vwEditTextBox.backgroundColor = [UIColor lightGrayColor];
    self.scrollView.contentSize = CGSizeMake(self.scrollView.contentSize.width, self.scrollView.contentSize.height + 100);
    [self.scrollView bringSubviewToFront:_vwEditTextBox];
    _vwEditTextBox.hidden = NO;
}

@end
