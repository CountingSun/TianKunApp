//
//  SalaryCalculationViewController.m
//  TianKunApp
//
//  Created by 天堃 on 2018/5/28.
//  Copyright © 2018年 天堃. All rights reserved.
//

#import "SalaryCalculationViewController.h"
#import "JTCalendar.h"
#import "NSDate+ChineseDate.h"
#import "TallyBookInfo.h"

@interface SalaryCalculationViewController ()<JTCalendarDelegate,QMUITextFieldDelegate>

@property (nonatomic ,strong) NSMutableArray *arrData;
@property (nonatomic ,strong) NSMutableDictionary *eventsByDate;
@property (nonatomic ,strong) NSDate *todayDate;
@property (nonatomic ,strong) NSDate *dateSelected;
@property (nonatomic ,strong) NSDate *currectMonthDate;

@property (strong, nonatomic) JTCalendarManager *calendarManager;
@property (weak, nonatomic) IBOutlet JTHorizontalCalendarView *calendarContentView;

@property (weak, nonatomic) IBOutlet UILabel *chineseCelndarLabel;

@property (weak, nonatomic) IBOutlet QMUIButton *typeButton;
@property (weak, nonatomic) IBOutlet QMUITextField *moneyTextField;
@property (weak, nonatomic) IBOutlet QMUITextField *countTextField;

@property (weak, nonatomic) IBOutlet UILabel *dayMoneyLabel;

@property (weak, nonatomic) IBOutlet QMUITextView *memoTextView;

@property (weak, nonatomic) IBOutlet UILabel *totalTimeLabel;

@property (weak, nonatomic) IBOutlet UILabel *toMoneyLabel;
@property (weak, nonatomic) IBOutlet UIView *totalView;
@property (nonatomic ,assign) BOOL isHaveDian;

@property (nonatomic ,strong) NSDateFormatter *monthDateFormatter;
@property (nonatomic ,strong) NSDateFormatter *yearDateFormatter;
@property (nonatomic ,strong) NSDateFormatter *dayDateFormatter;

@property (nonatomic ,strong) NetWorkEngine *netWorkEngine;
@property (nonatomic ,assign) CGFloat totalCount;
@property (nonatomic ,assign) CGFloat totalMoney;
@property (nonatomic ,strong) TallyBookInfo *currectTallyBookInfo;

@property (nonatomic ,assign) BOOL isFirst;
@property (weak, nonatomic) IBOutlet UIView *scrollerBaseView;
@property (nonatomic ,strong) QMUIPopupMenuView *menuView;
@property (nonatomic ,assign) NSInteger currecttype;




@end

@implementation SalaryCalculationViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _isFirst = YES;
    _currectMonthDate = [NSDate date];
    
    [self getData];
    [self setupUI];
    

    
}
- (void)loginSucceed{
    [self getData];
}

- (void)getData{
    
    if (![UserInfoEngine getUserInfo].userID) {
        return;
    }
    [self showWithStatus:NET_WAIT_TOST];

    NSString *year = [self.yearDateFormatter stringFromDate:_currectMonthDate];
    NSString *month = [self.monthDateFormatter stringFromDate:_currectMonthDate];

    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:[UserInfoEngine getUserInfo].userID forKey:@"user_id"];
    [dict setObject:year forKey:@"year"];
    [dict setObject:month forKey:@"month"];

    [self.netWorkEngine postWithDict:dict url:BaseUrl(@"TallyBookController/selectTallyBook.action") succed:^(id responseObject) {
        NSInteger code = [[responseObject objectForKey:@"code" ] integerValue];
        if (code == 1) {
            [self dismiss];

            if (!_arrData) {
                _arrData = [NSMutableArray array];
            }
            [_arrData removeAllObjects];
            _totalCount = [[[responseObject objectForKey:@"value"] objectForKey:@"totaltime"] floatValue];
            _totalMoney = [[[responseObject objectForKey:@"value"] objectForKey:@"totalmoney"] floatValue];

            _totalTimeLabel.text = [NSString stringWithFormat:@"%@",@(_totalCount)];
            _toMoneyLabel.text = [NSString stringWithFormat:@"%@",@(_totalMoney)];

            NSMutableArray *arr = [[responseObject objectForKey:@"value"] objectForKey:@"list"];
            if (arr.count) {
                for (NSDictionary *dict in arr) {
                    TallyBookInfo *info = [TallyBookInfo mj_objectWithKeyValues:dict];
                    if (info.month.length&&info.month.length ==1) {
                        info.month = [NSString stringWithFormat:@"0%@",info.month];
                    }

                    [_arrData addObject:info];
                    
                }
                [self createEvents];
                
                if (_isFirst) {
                    _isFirst = NO;
                    NSString *key = [[self dateFormatter] stringFromDate:_todayDate];
                    NSArray *arr = _eventsByDate[key];
                    if(arr && [arr count] > 0){
                        TallyBookInfo *info = arr[0];
                        _currectTallyBookInfo = info;
                        [self reloadBottomWithTallyBookInfo:info];
                    }else{
                        _currectTallyBookInfo = nil;
                        [self reloadBottomWithTallyBookInfo:nil];
                    }

                }

            }else{
                
            }
        }else{
            [self showErrorWithStatus:[responseObject objectForKey:@"msg"]];
            
        }
    } errorBlock:^(NSError *error) {

        [self showErrorWithStatus:NET_ERROR_TOST];
        
    }];
    
}
- (void)setupUI{
    _todayDate = [NSDate date];

    _dateSelected = _todayDate;
    
    _calendarManager = [[JTCalendarManager alloc] initWithLocale:[NSLocale localeWithLocaleIdentifier:@"zh-Hans"] andTimeZone:[NSTimeZone localTimeZone]];
    _calendarManager.delegate = self;
    [_calendarManager setContentView:_calendarContentView];
    [_calendarManager setDate:_todayDate];
    
    _calendarManager.settings.weekDayFormat = JTCalendarWeekDayFormatSingle;

    NSString *dateStr = [[self showDateFormatter] stringFromDate:_todayDate];
    [self.titleView setTitle:dateStr];
    _chineseCelndarLabel.text = [NSString stringWithFormat:@"阴历        %@",[_todayDate getChineseCalendar]];
    
//    _totalView.layer.masksToBounds = YES;
    _totalView.layer.cornerRadius = _totalView.qmui_height/2;
    _totalView.layer.shadowOffset = CGSizeMake(0, 1);
    _totalView.layer.shadowColor = [UIColor grayColor].CGColor;
    _totalView.layer.shadowRadius = 1;
    _totalView.layer.shadowOpacity = .5f;

    _countTextField.delegate = self;
    _countTextField.keyboardType = UIKeyboardTypeDecimalPad;
    
    _moneyTextField.delegate = self;
    _moneyTextField.keyboardType = UIKeyboardTypeDecimalPad;
    [_moneyTextField addTarget:self action:@selector(textFieldDidChage:) forControlEvents:UIControlEventEditingChanged];
    [_countTextField addTarget:self action:@selector(textFieldDidChage:) forControlEvents:UIControlEventEditingChanged];

    [_typeButton setImage:[UIImage imageNamed:@"三角下"] forState:UIControlStateNormal];
    [_typeButton setImage:[UIImage imageNamed:@"三角上"] forState:UIControlStateSelected];
    [_typeButton setImagePosition:QMUIButtonImagePositionRight];
    [_typeButton setSpacingBetweenImageAndTitle:5];
    
    _menuView = [[QMUIPopupMenuView alloc] init];
    _menuView.maximumWidth = 80;
    _menuView.preferLayoutDirection = QMUIPopupContainerViewLayoutDirectionBelow;
    _menuView.automaticallyHidesWhenUserTap = YES;
    QMUIPopupMenuItem *item1 = [QMUIPopupMenuItem itemWithImage:nil title:@"工时" handler:^{
        [_typeButton setTitle:@"工时" forState:0];
        _typeButton.selected = NO;
        [_menuView hideWithAnimated:YES];
        _currecttype = 1;
        
        
        
    }];
    QMUIPopupMenuItem *item2 = [QMUIPopupMenuItem itemWithImage:nil title:@"面积" handler:^{
        [_typeButton setTitle:@"面积" forState:0];
        _typeButton.selected = NO;
        [_menuView hideWithAnimated:YES];
        _currecttype = 2;

    }];
    QMUIPopupMenuItem *item3 = [QMUIPopupMenuItem itemWithImage:nil title:@"重量" handler:^{
        [_typeButton setTitle:@"重量" forState:0];
        _typeButton.selected = NO;
        [_menuView hideWithAnimated:YES];
        _currecttype = 3;

    }];
    NSMutableArray *arr = [NSMutableArray arrayWithObjects:item1,item2,item3, nil];

    _menuView.items = arr;
    
    

    
}
- (void)awakeFromNib{
    [super awakeFromNib];
    
}
- (void)reloadBottomWithTallyBookInfo:(TallyBookInfo *)tallyBookInfo{
    if (tallyBookInfo) {
        _countTextField.text = [NSString stringWithFormat:@"%@",@(tallyBookInfo.number)];
        _moneyTextField.text = [NSString stringWithFormat:@"%@",@(tallyBookInfo.price)];
        _dayMoneyLabel.text = [NSString stringWithFormat:@"%@",@(tallyBookInfo.number*tallyBookInfo.price)];
        _memoTextView.text = tallyBookInfo.comment;
        
        if (tallyBookInfo.type == 3) {
            [_typeButton setTitle:@"重量" forState:0];

        }else if (tallyBookInfo.type == 2){
            [_typeButton setTitle:@"面积" forState:0];

        }else{
            [_typeButton setTitle:@"工时" forState:0];

        }

    }else{
        _countTextField.text = @"";
        _moneyTextField.text = @"";
        _dayMoneyLabel.text = @"";
        _memoTextView.text = @"";
    }
}
- (void)createEvents
{
    if (!_eventsByDate) {
        _eventsByDate = [NSMutableDictionary new];
    }
    [_eventsByDate removeAllObjects];
    
    [_arrData enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        TallyBookInfo *info = obj;
        NSString *key = [NSString stringWithFormat:@"%@-%@-%@",info.day,info.month,info.year];
        
        NSDate *date = [[self dateFormatter] dateFromString:key];
        
        info.nowDate = date;
        
        
        if(!_eventsByDate[key]){
            _eventsByDate[key] = [NSMutableArray new];
        }
        [_eventsByDate[key] addObject:info];


    }];
    dispatch_async(dispatch_get_main_queue(), ^{
        [_calendarManager reload];

    });
    
    
    
}

- (NSDateFormatter *)showDateFormatter
{
    static NSDateFormatter *showDateFormatter;
    if(!showDateFormatter){
        showDateFormatter = [NSDateFormatter new];
        showDateFormatter.dateFormat = @"yyyy年MM月";
    }
    
    return showDateFormatter;
}

// Used only to have a key for _eventsByDate
- (NSDateFormatter *)dateFormatter
{
    static NSDateFormatter *dateFormatter;
    if(!dateFormatter){
        dateFormatter = [NSDateFormatter new];
        dateFormatter.dateFormat = @"d-MM-yyyy";
    }
    
    return dateFormatter;
}
- (NSDateFormatter *)yearDateFormatter
{
    if(!_yearDateFormatter){
        _yearDateFormatter = [NSDateFormatter new];
        _yearDateFormatter.dateFormat = @"yyyy";
    }
    
    return _yearDateFormatter;
}
- (NSDateFormatter *)monthDateFormatter
{
    if(!_monthDateFormatter){
        _monthDateFormatter = [NSDateFormatter new];
        _monthDateFormatter.dateFormat = @"MM";
    }
    
    return _monthDateFormatter;
}
- (NSDateFormatter *)dayDateFormatter
{
    if(!_dayDateFormatter){
        _dayDateFormatter = [NSDateFormatter new];
        _dayDateFormatter.dateFormat = @"d";
    }
    
    return _dayDateFormatter;
}

- (BOOL)haveEventForDay:(NSDate *)date
{
    NSString *key = [[self dateFormatter] stringFromDate:date];
    
    if(_eventsByDate[key] && [_eventsByDate[key] count] > 0){
        return YES;
    }
    
    return NO;
    
}

#pragma mark - CalendarManager delegate

// Exemple of implementation of prepareDayView method
// Used to customize the appearance of dayView
- (void)calendar:(JTCalendarManager *)calendar prepareDayView:(JTCalendarDayView *)dayView
{
    dayView.hidden = NO;
    
    // Other month
    if([dayView isFromAnotherMonth]){
        dayView.hidden = YES;
    }

    // Selected date
     if(_dateSelected && [_calendarManager.dateHelper date:_dateSelected isTheSameDayThan:dayView.date]){
        dayView.circleView.hidden = NO;
        dayView.circleView.backgroundColor = COLOR_VIEW_BACK;
        dayView.circleView.layer.borderWidth = 1;
        dayView.circleView.layer.borderColor = COLOR_THEME.CGColor;
        //        dayView.dotView.backgroundColor = [UIColor whiteColor];
        dayView.textLabel.textColor = COLOR_THEME;
         _chineseCelndarLabel.text = [NSString stringWithFormat:@"阴历        %@",[dayView.date getChineseCalendar]];
        
    }
    // Today
    else if([_calendarManager.dateHelper date:[NSDate date] isTheSameDayThan:dayView.date]){
        dayView.circleView.hidden = NO;
        dayView.circleView.backgroundColor = RGB(201, 227, 253, 1);
        dayView.circleView.layer.borderWidth = 1;
        dayView.circleView.layer.borderColor = RGB(201, 227, 253, 1).CGColor;

        dayView.dotView.backgroundColor = [UIColor whiteColor];
        
        dayView.textLabel.textColor = [UIColor whiteColor];
    }
    
    // Other month
    else if(![_calendarManager.dateHelper date:_calendarContentView.date isTheSameMonthThan:dayView.date]){
        dayView.circleView.hidden = YES;
        dayView.dotView.backgroundColor = [UIColor redColor];
        dayView.textLabel.textColor = [UIColor lightGrayColor];
    }
    // Another day of the current month
    else{
        dayView.circleView.hidden = YES;
        dayView.dotView.backgroundColor = [UIColor redColor];
        dayView.textLabel.textColor = [UIColor blackColor];
    }
    
    if([self haveEventForDay:dayView.date]){
        dayView.dotView.hidden = NO;
    }
    else{
        dayView.dotView.hidden = YES;
        
    }
    
}

- (void)calendar:(JTCalendarManager *)calendar didTouchDayView:(JTCalendarDayView *)dayView
{
    _dateSelected = dayView.date;
    
    // Animation for the circleView
    dayView.circleView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.1, 0.1);
    [UIView transitionWithView:dayView
                      duration:.3
                       options:0
                    animations:^{
                        dayView.circleView.transform = CGAffineTransformIdentity;
                        [_calendarManager reload];
                    } completion:nil];
    
    _currecttype = 0;
    
    NSString *key = [[self dateFormatter] stringFromDate:dayView.date];
    NSArray *arr = _eventsByDate[key];
    if(arr && [arr count] > 0){
        TallyBookInfo *info = arr[0];
        _currectTallyBookInfo = info;
        

        [self reloadBottomWithTallyBookInfo:info];
        
    }else{
        _currectTallyBookInfo = nil;

        [self reloadBottomWithTallyBookInfo:nil];
        
    }
    if(_calendarManager.settings.weekModeEnabled){
        return;
    }
    
    // Load the previous or next page if touch a day from another month
    
    if(![_calendarManager.dateHelper date:_calendarContentView.date isTheSameMonthThan:dayView.date]){
        if([_calendarContentView.date compare:dayView.date] == NSOrderedAscending){
            [_calendarContentView loadNextPageWithAnimation];
        }
        else{
            [_calendarContentView loadPreviousPageWithAnimation];
        }
    }
}

#pragma mark - CalendarManager delegate - Page mangement

// Used to limit the date for the calendar, optional
//- (BOOL)calendar:(JTCalendarManager *)calendar canDisplayPageWithDate:(NSDate *)date
//{
//    return [_calendarManager.dateHelper date:date isEqualOrAfter:_minDate andEqualOrBefore:_maxDate];
//}

- (void)calendarDidLoadNextPage:(JTCalendarManager *)calendar
{
    NSString *dateStr = [[self showDateFormatter] stringFromDate:calendar.date];
    [self.titleView setTitle:dateStr];
}

- (void)calendarDidLoadPreviousPage:(JTCalendarManager *)calendar
{
    NSString *dateStr = [[self showDateFormatter] stringFromDate:calendar.date];
    [self.titleView setTitle:dateStr];

}
- (void)calendarDidEndAnimaton:(JTCalendarManager *)calendar{
    
    _currectMonthDate = calendar.date;
    [self getData];

}
- (IBAction)typeButtonClick:(QMUIButton *)sender {
    sender.selected = YES;

    [_menuView showWithAnimated:YES];
    [_menuView layoutWithTargetView:_typeButton];

    
}

- (IBAction)saceButtonClick:(UIButton *)sender {
    
    if (![UserInfoEngine isLogin]) {
        return;
    }
    if (!_countTextField.text.length) {
        
        NSInteger type;
        
        if (_currecttype) {
            type = _currecttype;
            
        }else{
            type = _currectTallyBookInfo.type;
            
        }
        if (type == 1) {
            [self showErrorWithStatus:@"请输入工时"];

        }else if (type == 2){
            [self showErrorWithStatus:@"请输入面积"];

        }else{
            [self showErrorWithStatus:@"请输入重量"];

        }

        return;
    }
    if (!_moneyTextField.text.length) {
        [self showErrorWithStatus:@"请输入单价"];
        return;
    }

    NSString *year = [[self yearDateFormatter] stringFromDate:_dateSelected];
    NSString *month = [[self monthDateFormatter] stringFromDate:_dateSelected];
    NSString *day = [[self dayDateFormatter] stringFromDate:_dateSelected];

    
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:[UserInfoEngine getUserInfo].userID forKey:@"user_id"];

    [dict setObject:year forKey:@"year"];
    [dict setObject:month forKey:@"month"];
    [dict setObject:day forKey:@"day"];
    if (_currecttype) {
        [dict setObject:@(_currecttype) forKey:@"type"];

    }else{
        [dict setObject:@(_currectTallyBookInfo.type) forKey:@"type"];

    }
    [dict setObject:_moneyTextField.text forKey:@"price"];
    [dict setObject:_countTextField.text forKey:@"number"];
    if (!_memoTextView.text.length) {
        [dict setObject:@"" forKey:@"comment"];
    }else{
        [dict setObject:_memoTextView.text forKey:@"comment"];
    }
    if (_currectTallyBookInfo) {
        [dict setObject:@(_currectTallyBookInfo.bookID) forKey:@"id"];
    }
    [self showWithStatus:NET_WAIT_TOST];

    [self.netWorkEngine postWithDict:dict url:BaseUrl(@"TallyBookController/insteroruodateTallyBook.action") succed:^(id responseObject) {
        
        NSInteger code = [[responseObject objectForKey:@"code"]  integerValue];
        if (code == 1) {
            _currecttype = 0;
            
            [self showSuccessWithStatus:@"保存成功"];
            [self getData];
            [self.view endEditing:YES];
        }else{
            [self showErrorWithStatus:[responseObject objectForKey:@"msg"]];

        }
    } errorBlock:^(NSError *error) {
        [self showErrorWithStatus:NET_ERROR_TOST];
    }];
    
    
}
/**
 *  textField的代理方法，监听textField的文字改变
 *  textField.text是当前输入字符之前的textField中的text
 *
 *  @param textField textField
 *  @param range     当前光标的位置
 *  @param string    当前输入的字符
 *
 *  @return 是否允许改变
 */
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    /*
     * 不能输入.0-9以外的字符。
     * 设置输入框输入的内容格式
     * 只能有一个小数点
     * 小数点后最多能输入两位
     * 如果第一位是.则前面加上0.
     * 如果第一位是0则后面必须输入点，否则不能输入。
     */
    
    // 判断是否有小数点
    if ([textField.text containsString:@"."]) {
        self.isHaveDian = YES;
    }else{
        self.isHaveDian = NO;
    }
    
    if (string.length > 0) {
        
        //当前输入的字符
        unichar single = [string characterAtIndex:0];
        
        // 不能输入.0-9以外的字符
        if (!((single >= '0' && single <= '9') || single == '.'))
        {
            [self showErrorWithStatus:@"您的输入格式不正确"];
            
            return NO;
        }
        
        // 只能有一个小数点
        if (self.isHaveDian && single == '.') {
//            [MBProgressHUD bwm_showTitle:@"最多只能输入一个小数点" toView:self hideAfter:1.0];
            return NO;
        }
        
        // 如果第一位是.则前面加上0.
        if ((textField.text.length == 0) && (single == '.')) {
            textField.text = @"0";
        }
        
        // 如果第一位是0则后面必须输入点，否则不能输入。
        if ([textField.text hasPrefix:@"0"]) {
            if (textField.text.length > 1) {
                NSString *secondStr = [textField.text substringWithRange:NSMakeRange(1, 1)];
                if (![secondStr isEqualToString:@"."]) {
//                    [MBProgressHUD bwm_showTitle:@"第二个字符需要是小数点" toView:self hideAfter:1.0];
                    return NO;
                }
            }else{
                if (![string isEqualToString:@"."]) {
//                    [MBProgressHUD bwm_showTitle:@"第二个字符需要是小数点" toView:self hideAfter:1.0];
                    return NO;
                }
            }
        }
        
        // 小数点后最多能输入两位
        if (self.isHaveDian) {
            NSRange ran = [textField.text rangeOfString:@"."];
            // 由于range.location是NSUInteger类型的，所以这里不能通过(range.location - ran.location)>2来判断
            if (range.location > ran.location) {
                if ([textField.text pathExtension].length > 1) {
//                    [MBProgressHUD bwm_showTitle:@"小数点后最多有两位小数" toView:self hideAfter:1.0];
                    return NO;
                }
            }
        }
        
    }
    
    return YES;
}
- (void)textFieldDidChage:(UITextField *)textField{
    if (_moneyTextField.text.length&&_countTextField.text.length) {
        
        CGFloat monty =  [_moneyTextField.text floatValue];
        CGFloat count =  [_countTextField.text floatValue];

        
        _dayMoneyLabel.text = [NSString stringWithFormat:@"%@",@(monty*count)];
    }
    
}
- (NetWorkEngine *)netWorkEngine{
    if (!_netWorkEngine) {
        _netWorkEngine = [[NetWorkEngine alloc] init];
    }
    return _netWorkEngine;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
