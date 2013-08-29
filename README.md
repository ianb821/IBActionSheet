#IBActionSheet

Fully customizable iOS 7 style UIActionSheet replacement.  Compatible with iOS 5, 6, and 7.


##Features

By default, IBActionSheet mimics the iOS 7 UIActionSheet exactly:

 

![Standard](https://raw.github.com/ianb821/IBActionSheet/master/Pictures/Standard.png)


You then have the option to change:

 - The button text color
 - The button background color
 - The button text highlight color
 - The button backround highlight color
 - The button and title font
 - The effect when a button is pressed
 
####A simple example is shown here:
 
![Colored](https://raw.github.com/ianb821/IBActionSheet/master/Pictures/Colored.png)
 
####An extreme example with every element of the action sheet customized is show here (landscape):
 
![Funky](https://raw.github.com/ianb821/IBActionSheet/master/Pictures/Funky_Landscape.png)
 
All but the 'button press' effects can be customized for the whole action sheet, or for individual buttons and title.  The 'button press' effects current include:

 - Fade
 - Highlight (With designated background and text highlight colors)
 - Shrink Effect
 - Reverse Colors (Same as highlight, but it reverses background and text colors)
 
 
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

- (BOOL)visible;

```

To receive notifications from the IBActionSheet, just add 
```<IBActionSheetDelegate>``` to your view controller's header file, and implement the following method:


```
-(void)actionSheet:(IBActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;

```

It behaves just like the UIActionSheet method, and in fact, it will receive notifications from a UIActionSheet as well.

Then you get to the good stuff, to customize the action sheet, you can choose from the following:

```
// rotation
- (void)rotateToCurrentOrientation;

// effects
- (void)setButtonResponse:(IBActionSheetButtonResponse)response;

// fonts
- (void)setFont:(UIFont *)font;
- (void)setTitleFont:(UIFont *)font;
- (void)setFont:(UIFont *)font forButtonAtIndex:(NSInteger)index;


// standard colors
- (void)setTitleTextColor:(UIColor *)color;
- (void)setButtonTextColor:(UIColor *)color;
- (void)setTitleBackgroundColor:(UIColor *)color;
- (void)setButtonBackgroundColor:(UIColor *)color;
- (UIColor *)buttonTextColorAtIndex:(NSInteger)index;
- (UIColor *)buttonBackgroundColorAtIndex:(NSInteger)index;
- (void)setButtonTextColor:(UIColor *)color forButtonAtIndex:(NSInteger)index;
- (void)setButtonBackgroundColor:(UIColor *)color forButtonAtIndex:(NSInteger)index;


// highlight colors
- (void)setButtonHighlightBackgroundColor:(UIColor *)color;
- (void)setButtonHighlightTextColor:(UIColor *)color;
- (void)setButtonHighlightTextColor:(UIColor *)color forButtonAtIndex:(NSInteger)index;
- (void)setButtonHighlightBackgroundColor:(UIColor *)color forButtonAtIndex:(NSInteger)index;

```

##Included
I have included a super simple sample project that will show you how it works.  Please let me know if you have any questions or suggestions!

***Note: If you are running this app on iOS 7, make sure that you change the deployment target to 7.0 before installing it on a device running 7.0.  If not, the animation will be slightly off
 

##Known Issues

 - On iPad, it follows the iPhone style UIActionSheet instead of the iPad one.  I personally prefer this behavior, but if there is a demand, I'm happy to make it follow the UIActionSheet behavior for iPad, just let me know!
 
 - IBActionSheet doesn't lock orientation as UIActionSheet does.  I haven't found an elegant solution to this just yet.  You can use the actionSheet.visible property to lock it yourself, or you call:
 
```
  [actionSheet rotateToCurrentOrientation];
```
 from whatever method you are using to detect rotation and it will resize accordingly. 
 
 - When adding IBActionSheet to a UIView contained in a UINavigation Controller, use:

```
  [actionSheet showInView:self.navigationController.view];
```
instead of:

```
  [actionSheet showInView:self.view];
```
hopefully I can eliminate the need to do this in the future.

