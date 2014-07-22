//
//  ViewController.h
//  ePaisaDemo
//
//  Created by Ashish Pisey on 7/21/14.
//  Copyright (c) 2014 com.lionkingmedia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UIPickerViewDataSource,UIPickerViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *emailIDTxtField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIPickerView *picker;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
- (IBAction)LoginBtnAction:(UIButton *)sender;
- (IBAction)changeThemeAction:(UIButton *)sender;
- (IBAction)changeLanguageAction:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *changeThemeBtn;
@property (weak, nonatomic) IBOutlet UIButton *changeLanguageBtn;
@property (weak, nonatomic) IBOutlet UIView *pickerView;
@property (weak, nonatomic) IBOutlet UIButton *setTheme;
- (IBAction)exitKeyBoard:(UITextField *)sender;
- (IBAction)setBtnAction:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *setBtn;
@end
