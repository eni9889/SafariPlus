// Copyright (c) 2017-2019 Lars Fröder

// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:

// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.

// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

#import "../SafariPlus.h"
#import "Extensions.h"

#import "../Util.h"
#import "../Classes/SPPreferenceManager.h"
#import "../Classes/SPLocalizationManager.h"

%hook BrowserRootViewController

- (void)presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion
{
	if(preferenceManager.forceHTTPSEnabled)
	{
		//Apple made it really hard to get a reference to the reload options alertcontroller ;)
		if([viewControllerToPresent.view.accessibilityIdentifier isEqualToString:@"ReloadOptionsAlert"])
		{
			UIAlertController* reloadOptionsAlertController = (UIAlertController*)viewControllerToPresent;

			TabDocument* activeDocument;

			if([self respondsToSelector:@selector(browserController)])
			{
				activeDocument = self.browserController.tabController.activeTabDocument;
			}
			else
			{
				activeDocument = browserControllers().firstObject.tabController.activeTabDocument;
			}

			NSURL* activeURL = [activeDocument URL];

			if([preferenceManager isURLOnHTTPSExceptionsList:activeURL])
			{
				UIAlertAction* removeFromExceptionsAction = [UIAlertAction actionWithTitle:[localizationManager localizedSPStringForKey:@"REMOVE_FROM_FORCE_HTTPS_EXCEPTIONS"]
									     style:UIAlertActionStyleDefault handler:^(UIAlertAction* action)
				{
					[preferenceManager removeURLFromHTTPSExceptionsList:activeURL];
					[activeDocument reload];
				}];

				[reloadOptionsAlertController addAction:removeFromExceptionsAction];
			}
			else
			{
				UIAlertAction* addToExceptionsAction = [UIAlertAction actionWithTitle:[localizationManager localizedSPStringForKey:@"ADD_TO_FORCE_HTTPS_EXCEPTIONS"]
									style:UIAlertActionStyleDefault handler:^(UIAlertAction* action)
				{
					[preferenceManager addURLToHTTPSExceptionsList:activeURL];
					[activeDocument loadURL:[activeURL httpURL] userDriven:NO];
				}];

				[reloadOptionsAlertController addAction:addToExceptionsAction];
			}
		}
	}

	%orig;
}

%end

void initBrowserRootViewController()
{
	%init();
}
