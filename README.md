##IBActionSheet

Fully customizable iOS 7 UIActionSheet replacement.

![Pictures]()


##Features
By default, IBActionSheet mimics the iOS 7 UIActionSheet exactly.  You then have the option to change:

 - The button text color
 - The button background color
 - The button text highlight color
 - The button backround highlight color
 - The button and title font
 - The effect when a button is pressed
 
All but the 'button press' effects can be customized for the whole action sheet, or for individual buttons.  The 'button press' effects current include:

 - Fade
 - Highlight
 - Shrink Away effect
 - Reverse button background and text color
 
 
##Usage
 
IBActionSheet offers the same functionality as the UIActionSheet, including things like:

```
- (id)initWithTitle:(NSString *)title delegate:(id<IBActionSheetDelegate>)delegate cancelButtonTitle:(NSString *)cancelTitle destructiveButtonTitle:(NSString *)destructiveTitle otherButtonTitles:(NSString *)otherTitles, ... NS_REQUIRES_NIL_TERMINATION;

- (void)showInView:(UIView *)theView;

- (NSInteger)addButtonWithTitle:(NSString *)title;

- (void)dismissWithClickedButtonIndex:

- (NSInteger)buttonIndex animated:(BOOL)animated;

- (NSInteger)numberOfButtons;

- (NSString *)buttonTitleAtIndex:(NSInteger)index;

```

To receive notifications from the IBActionSheet, just add <IBActionSheetDelegate> to your .h file, and implement the following method:


```
-(void)actionSheet:(IBActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;

```

It behaves just like the UIActionSheet method, and in fact, it will receive notifications from a UIActionSheet as well

#Included
I have included a super simple sample project that will show you how it works.  Please let me know if you have any questions or suggestions!
 

