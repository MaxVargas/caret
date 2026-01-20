---
date: 2025 February
tags:
  - FP
---
With enough pondering, it should be reasonable to convince yourself that there's often an obvious attempt to turn a parametrized type into a functor. For example, the list functor `[]` that sends a type `a` to the set of lists `[a]` can be extended to a functor where `fmap f :: [a] -> [b]` just applies `f` to each element of a given list `[a1, ..., an]`. There's a certain naturality to figure out these evaluations.

It turns out that if this "obvious" attempt actually turns out to give a functor, it's unique! Really, what I ought to say, is that any two functors constructed from the same parametrized type must actually be equal. 

To prove this, let `T` be any parametrized type. To build a functor, we have to specify maps `T a -> T b` for any types `a` and `b`. Let `fmap1` and `fmap2` be two such functorial maps. We need to show that for any `x :: T a` and `f :: a -> b`, that `fmap1 f x = fmap2 f x`.  This is certainly true when `f = id` since the two sides will evaluate identically to `x`. 

Note: The uniqueness discussed here is not a general property. If you have two categories $\mathcal{C}$ and $\mathcal{D}$, and a map between their object sets, then it's possible to extend this map to two different functors. For example, consider a category with two objects, $A$ and $B$, and only two nontrivial morphisms $A\to B$. Then the identity map on the set of objects ($A\mapsto A$, $B\mapsto B$) can be extended to four different functors given by the set of maps $\textnormal{Hom}(A, B) \to \textnormal{Hom}(A,B)$.

Now, the computer scientist won't really care about the above category (or else the claim about uniqueness of parametrized types is false), so it's really something special about parametrized types and how they're handled in Haskell... in particular, Hom-sets are objects in this category so we can make use of $\mathcal{F}(\textnormal{Hom}(A,B))$ (or `f (a->b)`, whichever notation you prefer).