---
date: 2025 February
---
A functor is the data of a parametric type `f`, along with a function 
```haskell
fmap :: (a -> b) -> f a -> f b
``` 
for all types `a` and `b` for which `f a` and `f b` is defined. Further, this data has to satisfy the following conditions:
```haskell
fmap id_a = id_a
fmap (g . h) = (fmap g) . (fmap h)
```
That is, for any function `lambda :: a -> b`, we have that `fmap lambda` is a function `f a -> f b`. The criteria in the second box asserts that `fmap` must send identity maps to identity maps and also respect compositions of functions (denoted with the dot `.`). 

The above definition is essentially the same as the mathematical one [[Functors (Mathematics)]]! One interesting note, however, is that the programmer didn't need the use of categories. This is no big concern -- the category is implicitly assumed as (often) consisting of 'those types `a` where `f a` is defined'. A lot of the time, it's a lot of bookkeeping to track this implicit category and we can work as if we deal with the 'category of all types (or sets)'. The parametric types listed in the above examples are well-defined on all types. With this mindset, we can (in a somewhat cavalier mindset) regard these functors as *endofunctors* of this ambient category.

All of the examples of parametrized types can easily be extended to give examples of functors. The check of the functor axioms are straightforward.
- `Triple a`. To define the function `fmap`, note that by definition, for any `lambda :: a -> b` we have `fmap lambda :: Triple a -> Triple b`. That is `fmap lambda` is a function which takes triples of type `a` as input, and returns triples of type `b`. Taking any triple `T x y z :: Triple a`, we can just define `(fmap lambda) (T x y z) = T (lambda x) (lambda y) (lambda z)`. 
- `Maybe a`. Following as the previous example, we must have that `fmap lambda` be a function `Maybe a -> Maybe b` for any function `lambda :: a -> b`. Defining `(fmap lambda) Nothing = Nothing` and `(fmap lambda) Just x = Just (lambda x)` does the job.
- `Tree a`.  The definition of `fmap` can succinctly be defined recursively, just as `Tree a` itself was too. While this is formally convenient, the map here is again the obvious one. That is, `fmap lambda :: Tree a -> Tree b` is evaluated by just applying `lambda` to each node in a given tree. Formally, `(fmap lambda) (Node x) = Node (lambda x)` and `(fmap lambda) (l x r) = (fmap lambda l) (lambda x) (fmap lambda r)`.  As an example, for `lamdba = (\x -> x^2) :: Int -> Int`, then 
```haskell
                    Node 5                  Node 25
                    /    \                  /     \
(fmap lambda)    Node 2  Node 6   =      Node 4  Node 36
                  /    \                /      \
               Node 4  Node 2        Node 16  Node 4
```

There turns out to be a nice uniqueness property about functors and parametrized types. See [[functors from parametrized types]]