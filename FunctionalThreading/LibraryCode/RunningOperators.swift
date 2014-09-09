//
//  RunningOperators.swift
//  FunctionalThreading
//
//  Created by Peter Livesey on 9/9/14.
//  Copyright (c) 2014 Peter Livesey. All rights reserved.
//

import Foundation


/*
  These operators take a parameter and a function and apply the parameter to the function. It also runs the function if it's the last parameter. This allows us to 'pipe' parameters into functions.
*/

////////////////////////////////////
//   One Parameter
////////////////////////////////////

func --> <A>(input: A, completion: A -> ()) {
  completion(input)
}

func |-> <A>(input: A, completion: A -> ()) {
  dispatch_async(dispatch_get_main_queue()) {
    completion(input)
  }
}

func ^-> <A>(input: A, completion: A -> ()) {
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)) {
    completion(input)
  }
}

////////////////////////////////////
//   Two Parameters
////////////////////////////////////

func --> <A, B>(input: B, completion: (A, B) -> ()) -> A -> () {
  return { a in
    completion(a, input)
  }
}

func |-> <A, B>(input: B, completion: (A, B) -> ()) -> A -> () {
  return { a in
    dispatch_async(dispatch_get_main_queue()) {
      completion(a, input)
    }
  }
}

func ^-> <A, B>(input: B, completion: (A, B) -> ()) -> A -> () {
  return { a in
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)) {
      completion(a, input)
    }
  }
}

////////////////////////////////////
//   Three Parameters
////////////////////////////////////

func --> <A, B, C>(input: C, completion: (A, B, C) -> ()) -> (A, B) -> () {
  return { a, b in
    completion(a, b, input)
  }
}

func |-> <A, B, C>(input: C, completion: (A, B, C) -> ()) -> (A, B) -> () {
  return { a, b in
    dispatch_async(dispatch_get_main_queue()) {
      completion(a, b, input)
    }
  }
}

func ^-> <A, B, C>(input: C, completion: (A, B, C) -> ()) -> (A, B) -> () {
  return { a, b in
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)) {
      completion(a, b, input)
    }
  }
}
