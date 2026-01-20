---
date: 2025 February
tags:
  - FP
---

The point here isn't to get into too much detail but you can loosely think about 'types' as sets.[^1] A parametrized type can be thought of as a construction of a new type, from a given input type. In practice, this can be thought of as a function which takes a given type of objects and produces some new output type. 
[^1]:(A computer scientist might yell at me for saying so, but realistically you'll probably never need to worry about the distinction.

- `Triple a = T a a a`. This definition states that I can construct a triple of type `a` by specifying three objects, each of which have `a` as their type. That is, something has the form of `Triple a` if it looks like `T x y z` where `type(x) = type(y) = type(z) = a`. The prefix `T` is just a label that says "hey, here's a triple!" To make a parallel, sometimes people write `(x,y,z)` for triples of numbers. In this case, the parentheses and commas aren't really necessary -- they're just to make legibility easier for us humans. `Triple Int` is just those things that look like `T x y z` where `x y` and `z` are all integers. 
- `Maybe`. Another common example of a parametrized type. Writing its definition as `Maybe a = Nothing | Just a`, this says that something has the type `Maybe a` if it is either the `Nothing` object or looks like `Just x`, where `type(x)=a`. If we think in set theoretic terms, this is essentially like adding a new distinguished element called `Nothing` to the set (or type) `a`.
- `Tree a = Leaf a | Node (Tree a) a (Tree a)`. This definition gives us a way to build trees out of a given type `a`.  That is, such a tree is either looks like `Leaf x` where `type(x)=a` or `Node l x r`, where `type(x)=a` and `l` and `r` are themselves trees (i.e., `type(l)=type(r)=Tree a`). Note that this definition is *recursive*, letting you build new trees from one you know already exist. The following are examples of trees, as one might typically imagine them.
```haskell
	        |            |        Node 5
            |   Node 1   |        /    \
	Node x  |    /  \    |     Node 2  Node 6
	        |   l    r   |     /    \
	        |            | Node 4   Node 2
```

