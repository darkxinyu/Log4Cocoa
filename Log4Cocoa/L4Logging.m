/**
 * For copyright & license, see LICENSE.
 */

#import <objc/message.h>
#import "L4Logging.h"
#import "L4Logger.h"
#import "NSObject+Log4Cocoa.h"

void log4Log(id object, int line, const char *file, const char *method, SEL sel, L4Level *level, BOOL isAssertion, BOOL assertion,  id exception, id message, ...)
{
	NSString *combinedMessage;
	if ( [message isKindOfClass:[NSString class]] ) {
		va_list args;
		va_start(args, message);
		combinedMessage = [[NSString alloc] initWithFormat:message arguments:args];
		va_end(args);
	} else {
		combinedMessage = [message retain];
	}
	
	L4Logger *logger = [object l4Logger];
	if ( isAssertion ) {
		//objc_msgSend([object l4Logger], sel, line, file, method, assertion, combinedMessage);
		
		// workaround for crashing in iOS8 64bit
		[logger lineNumber: line fileName: (char *)file methodName: (char *)method assert: assertion log: combinedMessage];
	} else {
		//objc_msgSend([object l4Logger], sel, line, file, method, combinedMessage, level, exception);
		
		// workaround for crashing in iOS8 64bit
		[logger lineNumber:line fileName: (char *)file methodName: (char *)method message: combinedMessage level: level exception: exception];
	}
	
	[combinedMessage release];
}

