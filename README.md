Functional Threading
====================

An experiment with functional programming in Swift

Basic Idea
----------

The basic idea was to create a declarative way of expressing threading and function piping in Swift. In it's current form, this is more of a thought experiment than a library that is ready to use. Let me know what you think.

Effectively, this may be a very simple implementation of promises, but I don't think that's exactly true. Up to you to decide...

Basic Example
-------------

Let's say I've written a bunch of functions like below. Note: I don't need to do any threading in these functions. I implement the functions like they are synchronous.

`func addOne(x: Int) -> Int`
`func printNumber(x: Int)`

Now, let's also pretend this function is slow, so I want to put it on a background thread. I simply do something like this:

`6 ^-> addOne |-> printNumber`

The means:

- Take 6
- Run it as a parameter for addOne on a background thread
- Take the result, and pass it to printNumber on the main thread

The Operators
-------------

Currently available are:

`-->` This means pass the result from the left function into the right function. Do no change threads. This can also be used to chain input parameters.

`|->` This means pass the result from the left function into the right function, but switch to the main thread to run the right function.

`^->` This means pass the result from the left function into the right function, but switch to a background thread to run the right function.

`|||` This means run the left and the right in parallel, and combine the results. When passed to the next function, the next function should expect the return value of the first function as it's first argument, then the return value of the second function.

All of the operands also double as running the function when proceeded by an operator. So, in the example above, the code is actually run.

A Complex Example
-----------------

`1 --> "2" --> 3 ^-> ( addOne ||| toInt ||| minusOne ) --> addAll |-> printNumber`

- Take three parameters
- Pass each one to three different functions that all run on a background thread
- Take the result of each function and pass it to addAll
- Run addAll on the same thread (background thread)
- Jump back to the main thread and run printNumber

The code
--------

Currently, all the code is in an app. This is because it doesn't look like swift libraries are supported yet (let me know if you know a good way to do this).

Take a look at the unit tests for some more examples.

Known Issues
------------

There are a bunch since this project is just a thought experiment but here are a few:

- You can only use a max of three parameters for anything
- You can't specify which thread to use. Only main or background.
- Running stuff in parallel doesn't really run it in parallel. It just runs them in sequence. This should be relatively easily fixed. You need to pass a structure with all of the functions in (not the results of the functions). Then the next step should do the fan out, then call the completion block on the correct thread.

Ideas
-----

- What if you had a function with a completion block built in? Should you be able to chain this too?
- The syntax is ugly...a better way?
