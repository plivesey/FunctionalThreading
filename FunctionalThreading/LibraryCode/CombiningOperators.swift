//
//  CombiningOperators.swift
//  FunctionalThreading
//
//  Created by Peter Livesey on 9/9/14.
//  Copyright (c) 2014 Peter Livesey. All rights reserved.
//

import Foundation


/*
  The combines two functions on the left and the right into one function.
*/
infix operator ||| { associativity left }

// Combines two functions that each take one argument

func ||| <A, B, C, D>(f1: A -> B, f2: C -> D) -> (A, C) -> TwoResults<B, D> {
  return { a, c in
    return TwoResults<B, D>(first: f1(a), second: f2(c))
  }
}

// Combines a previously combined function with a function that takes one argument

func ||| <A, B, C, D, E, F>(f1: (A, E) -> TwoResults<B, F>, f2: C -> D) -> (A, E, C) -> ThreeResults<B, F, D> {
  return { a, e, c in
    let first = f1(a, e)
    return ThreeResults<B, F, D>(first: first.first, second: first.second, third: f2(c))
  }
}

// Structs for holding parameters
// I originally used tuples instead of structs, but then this would interfere with tuples that people used in their own code

struct TwoResults<A, B> {
  var first: A
  var second: B
}

struct ThreeResults<A, B, C> {
  var first: A
  var second: B
  var third: C
}
