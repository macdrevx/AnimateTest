# AnimateTest

Cocoa Brains @ Two Toasters, 14 March 2013, Andrew Hershberger

## Motivation

What are the differences between

	- (void)doSomethingAnimated:(BOOL)animated
	{
		void(^animationBlock)(void) = ^{ …animations… };

		if (animated) {
			[UIView animateWithDuration:1.0
							 animations:animationBlock];
		} else {
			animationBlock();
		}
	}

and

	- (void)doSomethingAnimated:(BOOL)animated
	{
		[UIView animateWithDuration:animated ? 1.0 : 0.0
						 animations:^{ …animations… }];
	}

## Using the Demo App

Click the black dots to make the red view move to that position. Adjust the animation and logging options to explore different scenarios.

## Exercise 1

Demonstrate that using a 0.0s animation still adds an animation to the view's layer.

## Exercise 2

Demonstrate that interrupting an in-progress animation with a second animation causes the first animation to end.

## Exercise 3

Demonstrate that updating the view's model while the animation is is-progress does not cause the first animation to end. However the observed behavior is that the view is now
animating to the new model state, from the original model state.

This happens because of the way the first animation is configured:

	position animation: <CABasicAnimation: 0x946f730>
		   - fromValue: NSPoint: {160, 20}
		   -   toValue: (null)
		   -   byValue: (null)

The [CABasicAnimation docs](https://developer.apple.com/library/ios/#documentation/GraphicsImaging/Reference/CABasicAnimation_class/Introduction/Introduction.html) state:

> [If the] fromValue is non-nil. Interpolates between fromValue and the current presentation value of the property.

Since simply updating the model does not remove the in-progress animation from the view's layer, it continues to animate, but instead of interpolating to the original destination, it now interpolates to a new destination as specified by the model.
