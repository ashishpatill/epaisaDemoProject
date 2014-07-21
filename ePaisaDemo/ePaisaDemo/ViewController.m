//
//  ViewController.m
//  ePaisaDemo
//
//  Created by Ashish Pisey on 7/21/14.
//  Copyright (c) 2014 com.lionkingmedia. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
{
    NSArray *themeArray;
    NSArray *languageArray;
    NSArray *pickerArray;
    BOOL isThemeBtnSelected;
}
@end

@implementation ViewController
@synthesize emailIDTxtField,passwordTextField,picker,loginBtn;

-(void)viewWillAppear:(BOOL)animated
{
    [self.pickerView setHidden:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    languageArray = [[NSArray alloc]initWithObjects:@"Marathi",@"Hindi",@"English", nil];
    
    themeArray = [[NSArray alloc]initWithObjects:@"Red",@"Green",@"yellow",@"Blue", nil];
    
    //pickerArray = [[NSArray alloc]init];
    
}

// toDetailPage

//admin@epaisa.com
//123123

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)LoginBtnAction:(UIButton *)sender
{
    if (![emailIDTxtField.text isEqualToString:@"admin@epaisa.com"]&&[passwordTextField.text isEqualToString:@"123123"])
    {
        [self showAlert:@"Invalid Email" :@"Please Verify your email and try again"];
    }
    else if ([emailIDTxtField.text isEqualToString:@"admin@epaisa.com"]&& ![passwordTextField.text isEqualToString:@"123123"])
    {
        [self showAlert:@"Invalid Password" :@"Please Verify your Password and try again"];
    }
    else if ([emailIDTxtField.text isEqualToString:@"admin@epaisa.com"]&& [passwordTextField.text isEqualToString:@"123123"])
    {
        if ([self.changeThemeBtn.titleLabel.text isEqualToString:@"Change Theme"] && ![self.changeLanguageBtn.titleLabel.text isEqualToString:@"Change Language"])
        {
            [self showAlert:@"Invalid Theme" :@"Select a theme and try again"];
        }
        else if ([self.changeLanguageBtn.titleLabel.text isEqualToString:@"Change Language"] && ![self.changeThemeBtn.titleLabel.text isEqualToString:@"Change Theme"])
        {
            [self showAlert:@"Invalid Language" :@"Select a Language and try again"];
        }
        else if ([self.changeLanguageBtn.titleLabel.text isEqualToString:@"Change Language"] && [self.changeThemeBtn.titleLabel.text isEqualToString:@"Change Theme"])
        {
            [self showAlert:@"Invalid Theme and Language" :@"Select a theme and Language and try again"];
        }
        else
        {
            [self performSegueWithIdentifier:@"toDetailPage" sender:self];
            
            [self showAlert :@"Login Successful" :@"You can now access the app" ];
        }
    }
    else
    {
        UIAlertView *invalidEmailAndPasswdAlert = [[UIAlertView alloc]initWithTitle:@"Invalid Email and Password" message:@"Please Verify your email and Password and try again" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [invalidEmailAndPasswdAlert show];
    }

}

-(void)showAlert :(NSString *)titleString :(NSString *)messageText
{
    UIAlertView *alert= [[UIAlertView alloc]initWithTitle:titleString message:messageText delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

- (NSInteger)numberOfComponentsInPickerView:
(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component
{
    return pickerArray.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component
{
    return pickerArray[row];
}

- (IBAction)changeThemeAction:(UIButton *)sender
{
    pickerArray = [NSArray arrayWithArray:themeArray];
    
    [self.picker reloadComponent:0];
    
    [self.pickerView setHidden:NO];
    
    isThemeBtnSelected = YES;
}

- (IBAction)changeLanguageAction:(UIButton *)sender
{
    pickerArray = [NSArray arrayWithArray:languageArray];
    
    [self.picker reloadComponent:0];
    
    [self.pickerView setHidden:NO];
    
    isThemeBtnSelected = NO;
    
}


- (IBAction)setBtnAction:(UIButton *)sender
{
    NSInteger row = [self.picker selectedRowInComponent:0];
    //Choose it for other components
    NSString *selectedPickerString  = [pickerArray objectAtIndex:row];
    
    if (isThemeBtnSelected == YES)
    {
        self.changeThemeBtn.titleLabel.text = selectedPickerString;
        [self.changeThemeBtn setTitle:selectedPickerString forState:UIControlStateNormal];
        switch (row) {
            case 0:
                [self.view setBackgroundColor:[UIColor redColor]];
                break;
            case 1:
                [self.view setBackgroundColor:[UIColor greenColor]];
                break;
            case 2:
                [self.view setBackgroundColor:[UIColor yellowColor]];
                break;
            case 3:
                [self.view setBackgroundColor:[UIColor blueColor]];
                break;
            default:
                [self.view setBackgroundColor:[UIColor whiteColor]];
                break;
        }
    }
    else
    {
        self.changeLanguageBtn.titleLabel.text = selectedPickerString;
        [self.changeLanguageBtn setTitle:selectedPickerString forState:UIControlStateNormal];
        
       /* switch (row) {
            case 0:
                [self.view setBackgroundColor:[UIColor redColor]];
                break;
            case 1:
                [self.view setBackgroundColor:[UIColor greenColor]];
                break;
            case 2:
                [self.view setBackgroundColor:[UIColor yellowColor]];
                break;
            default:
                [self.view setBackgroundColor:[UIColor whiteColor]];
                break;
        }
        */

    }
    [self.pickerView setHidden:YES];
}

- (IBAction)exitKeyBoard:(UITextField *)sender
{
    [sender resignFirstResponder];
}

@end
