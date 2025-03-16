---
date: 2025 February
---
The notion of applicative is meant to encapsulate functions that can have many inputs. To put shortly, an applicative is the data of a functor `f` with the following extra data:
```
pure  :: a -> f a
(<*>) :: f (a -> b) -> f a -> f b 
```
This data has to satisfy the following conditions:
```
pure id <*> x   = x
pure (g x)      = pure g <*> pure x
x <*> pure y    = pure (\g -> g y) <*> x
x <*> (y <*> z) = (pure (.) <*> x <*> y) <*> z
```

There's a few things to comment on, the first of which is that we care about `pure` applied to functions. One thing these conditions are telling us is how to think about the image of functions (from the original category) to the image: what is `pure g` as a function? Turns out `pure g` behaves in ways we'd expect.

The other thing to comment on is that the above notation is terrible, so we're going to spend some time unwrapping them. First of all the binary operator `<*>` tells us, for any `lambda :: a -> b`, how to interpret `pure lambda` as a function `f a -> f b`.^[2] In terms of commutative diagrams,

![[applicative1.png | center | 300]]

In this notation it might look a bit silly but $\mathcal{F}(\lambda)\langle*\rangle ?$ is just a function that you can apply on elements of $\mathcal{F}A$. I guess `pure` is easier to think about... it sends types through to their image via the functor.

Notationally, it's annoying to write down `pure` so many times, so I'm going to write $\iota = \tt{pure}$ whenever convenient. It's also annoying to constantly write `(\g -> g y)`, so I'm going to call it 'evaluation at `y`' whenever convenient and write $\textnormal{ev}_y := (\\g \mapsto g y)$.

Now to begin on the four conditions.
- `pure id <*> x = x`
	In short, this says that the applicative respects identities. Note that `pure id` has type `f (a -> a)`, and using `<*>`, we can evaluate on any element `f a` as the identity. That is to say, `f <*> ?` is the identity on `f a`. 
- `pure (g x) = pure g <*> pure x`
	This says that the applicative preserves function application in the category. We can either apply `pure` after evaluating a function, or we can apply `pure` to each of the function and input, and then evaluate.

![[applicatives2.png | 150]]

- `x <*> pure y = pure (\g -> g y) <*> x`
	The moral here is that $\textnormal{ev}_{\iota y} = \iota \textnormal{ev}_y$ where the left hand side needs $\langle*\rangle$ to make sense. So, an applicative must 'behave expectedly' with respect to function evaluation.
	
![[applicatives3.png| 300]]

- `x <*> (y <*> z) = (pure (.) <*> x <*> y) <*> z`
	Applicatives respect function application. This one is tedious to write out in full, but note that `y <*> ? :: f Z -> f Y` and `x <*> ? :: f Y -> f X` can be composed together, and can be done by using the reflection of the composition operator.

[2]: Due to the cavalier nature, we can suppose that the set (type) of functions `a->b` is again a set (type) that makes sense for us to apply the functor `f`. This is typically the case as when the ambient category is the category of (small) sets (types).

Some closing remark: there's two maps $\textnormal{Hom}(A,B) \to \textnormal{Hom}(\mathcal{F}A, \mathcal{F}B)$, namely the functorial one given by $\mathcal{F}$ itself, and also $\iota g \langle \ast \rangle$ . It turns out that these maps actually agree with each other! This is due to the fact that there is, at most, one unique way to turn a ***parametrized type*** into a functor (see [[functors from parametrized types]] ). In particular, this entails that `pure` (or $\iota$) is actually a natural transformation between the identity functor and $\mathcal{F}$. 