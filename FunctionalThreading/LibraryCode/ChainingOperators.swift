//
//  ChainingOperators.swift
//  FunctionalThreading
//
//  Created by Peter Livesey on 9/9/14.
//  Copyright (c) 2014 Peter Livesey. All rights reserved.
//

import Foundation


/*
  This is used to chain functions while staying on the same thread.
*/
infix operator --> { associativity right }

/*
  This is used to chain functions and move to the main thread. The function on the left is on the previous thread and the function on the right is on the new thread.
*/
infix operator |-> { associativity right }

/*
This is used to chain functions and move to a backgrounbd thread. The function on the left is on the previous thread and the function on the right is on the new thread.
*/
infix operator ^-> { associativity right }

////////////////////////////////////
//   One Parameter
////////////////////////////////////

func --> <A, B>(input: B -> A, completion: A -> ()) -> B -> () {
  return { x in
    let result = input(x)
    completion(result)
  }
}

func ^-> <A, B>(input: B -> A, completion: A -> ()) -> B -> () {
  return { x in
    let result = input(x)
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)) {
      completion(result)
    }
  }
}

func |-> <A, B>(input: B -> A, completion: A -> ()) -> B -> () {
  return { x in
    let result = input(x)
    dispatch_async(dispatch_get_main_queue()) {
      completion(result)
    }
  }
}

////////////////////////////////////
//   Two Parameters
////////////////////////////////////

func --> <A, B, C, D>(input: (A, C) -> TwoResults<B, D>, completion: (B, D) -> ()) -> (A, C) -> () {
  return { a, c in
    let result = input(a, c)
    completion(result.first, result.second)
  }
}

func |-> <A, B, C, D>(input: (A, C) -> TwoResults<B, D>, completion: (B, D) -> ()) -> (A, C) -> () {
  return { a, c in
    let result = input(a, c)
    dispatch_async(dispatch_get_main_queue()) {
      completion(result.first, result.second)
    }
  }
}

func ^-> <A, B, C, D>(input: (A, C) -> TwoResults<B, D>, completion: (B, D) -> ()) -> (A, C) -> () {
  return { a, c in
    let result = input(a, c)
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)) {
      completion(result.first, result.second)
    }
  }
}

////////////////////////////////////
//   Three Parameters
////////////////////////////////////

func --> <A, B, C, D, E, F>(input: (A, B, C) -> ThreeResults<D, E, F>, completion: (D, E, F) -> ()) -> (A, B, C) -> () {
  return { a, b, c in
    let result = input(a, b, c)
    completion(result.first, result.second, result.third)
  }
}

func |-> <A, B, C, D, E, F>(input: (A, B, C) -> ThreeResults<D, E, F>, completion: (D, E, F) -> ()) -> (A, B, C) -> () {
  return { a, b, c in
    let result = input(a, b, c)
    dispatch_async(dispatch_get_main_queue()) {
      completion(result.first, result.second, result.third)
    }
  }
}

func ^-> <A, B, C, D, E, F>(input: (A, B, C) -> ThreeResults<D, E, F>, completion: (D, E, F) -> ()) -> (A, B, C) -> () {
  return { a, b, c in
    let result = input(a, b, c)
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)) {
      completion(result.first, result.second, result.third)
    }
  }
}
