
Before getting to monads, we ought to start with monoids (it's the first piece of abstract nonsense in the definition that a monad is "a monoid in the category of endofunctors"). I'll mention that a lot of the definitions here are what you'd find through other online resources. I'm just aggregating it here and including some examples. I'd imagine this mostly serves as a refresher to people who have seen the theory before. I'll also try to keep examples approachable if you've only run into linear algebra, set theory, and other basics. But it's worth noting that there's a slew of interesting examples if you're familiar with more.

---------------
[[Monoids]]

The presentation in the header link isn't the traditional one, but it's a 'categorical' abstraction that recovers the traditional viewpoint when thinking about sets and functions.

----------------------
[[Categories]]

It'll turn out that there are some 'familiar' objects which are actually monads in some category, we still have a bit more vocab to get through. Next word! 

-------------------
(Endo) [[Functors (Mathematics)]]

Just a little more until we get to start putting pieces together.

-----------------
Building Up!
The Category of Endofunctors (of $\mathcal{C}$)

At this point, we can convince ourselves that we know what an endofunctor is haha. Now we need to understand how they form a category. We've already got the objects (endofunctors, duh), so we just need the morphisms. Such 'arrows' between functors are called *natural transformations* and, in the same sense as how functors are structure-preserving maps between categories, these natural transformations are structure-preserving maps between functors.
I guess we now have 'arrows between arrows,' so it might be useful to specify our notation to not get confused. A functor is still an arrow between categories: $\mathcal{F}:\mathcal{C}\to\mathcal{D}$ . Given another functor $\mathcal{G}:\mathcal{C}\to\mathcal{D}$ (note that these two functors have the same source and targets), a natural transformation $\alpha: \mathcal{F} \implies \mathcal{G}$ is the data of
- a morphism $\alpha_X : \mathcal{F}X\to \mathcal{G}X$ for each $X\in\mathbb{O}(\mathcal{C})$.
This data has to satisfy the rule that for any arrow $f: X\to Y$ between objects of $\mathcal{C}$, we have an equality of morphisms $\alpha_Y \circ \mathcal{F}(f) = \mathcal{G}(f) \circ \alpha_X$. This is often depicted diagrammatically as saying that the following diagram commutes (traversing the arrows through the top right corner gives the same result as the traversal through the bottom left).

![[monad1.png | 180]]

Examples of natural transformations:
- Letting $X$ be a set, consider the functor $X\times?$ from the previous section. If we let $f:X\to X$ be any function on $X$, then the family of maps $$\alpha_Y : X\times Y\to X\times Y, \hspace{20pt} (x,y) \mapsto (f(x), f(y))$$ is a natural transformation $\alpha: X\times? \implies X\times?$.
- **Nonexample** If $f_1, f_2 :  G\to H$ are graph homomorphisms, then consider the functors $\mathcal{F}_1, \mathcal{F}_2: \mathcal{C}(G)\to\mathcal{C}(H)$ from as defined in the section on functors. Suppose we can find paths $p_v : f_1(v)\rightsquigarrow f_2(v)$ for all $v\in V$. Then for each path (i.e., morphism) $q: v\rightsquigarrow w$ in $\mathcal{C}(G)$, we can build a diagram as below. However, this diagram *does not* commute since, in general, the two paths are not equal. So the family of paths $(p_v)_{v\in V}$  does not form a natural transformation. 

![[monad2.png | 400]]

- Currying; I won't go into much precise detail on this example since, technically speaking, one wants to work with the notion of "contravariant" functors which I haven't talked about at all. But some programmers (blah blah functional programming) often treat a function on two variables as "a function of one variable which outputs another function of one variable". That is, given some function $f: X\times Y\to Z$ whose inputs are pairs $(x,y)$, we can define a function $\bar{f}: X\to (Y\to Z)$ by the following definition: $$x\mapsto (y\mapsto f(x,y))$$ in other words, $\bar{f}(x)$ is a function $Y\to Z$, and $\bar{f}(x)(y) := f(x,y)$. This gives a map $\bar{?} : \textnormal{Hom}_{\textbf{Set}}(X\times Y, Z) \to \textnormal{Hom}_{\textbf{Set}}(X, \textnormal{Hom}_{\textbf{Set}}(Y, Z))$ defined by $f\mapsto \bar{f}$. It turns out this map is a bijection, and actually defines a natural transformation between two appropriately defined functors. This turns out to be an isomorphism, which I won't go into here, but this word 'isomorphism' tells us that $f$ and $\bar{f}$ are equivalent though the given bijection. Again, intuitively this means that your functions on two variables can be thought of as a cascade of functions of a single variable where you're just plugging in one variable at a time.[^1] 
I consider the last example a special case of the *tensor-Hom* adjunction.
[^1]:So any time you see people perform currying and treating two- (or more-)variable functions as these cascaded functions on one variable, they're really using the natural transformation to convert their function!

With a couple examples in hand, now we can define the category of endofunctors (of a given category $\mathcal{C}$). We'll denote this category $\mathcal{E}nd(\mathcal{C})$. The objects here are just functors $\mathcal{F}:\mathcal{C}\to\mathcal{C}$ and morphisms are natural transformations $\alpha: \mathcal{F}\implies \mathcal{G}$, where $\mathcal{F}$ and $\mathcal{G}$ are endofunctors of $\mathcal{C}$. The first example above was a morphism in $\mathcal{E}nd(\textbf{Set})$. 

---------------------
Monads:
Monoids in the Category of Endofunctors

Finally, we get to define the concept of a monad...! First, a clarification. When talking about monoids, I chose to be imprecise about the 'monoidal product' $\otimes$ and the 'unit object' $1$. In general, being able to talk about such things presumes that you have some *monoidal* category floating around. I'm not going to get into the precise detail here, but luckily the category of endofunctors (on a given category) turns out to be one! All that's important for now is that there  is a monoidal product (i.e., a way to compose functors to satisfy a certain set of conditions) and this monoidal product is just functor composition. Further, the monoidal unit is the identity functor. That is,
$$
\mathcal{F}\otimes \mathcal{G} := \mathcal{F}\circ\mathcal{G}, \hspace{30pt} 1X = X \ \text{ for all } X\in\mathbb{O}(\mathcal{C}) 
$$
In fact, $\mathcal{E}nd(\mathcal{C})$ turns out to be a *strict* monoidal category, meaning that given three endofunctors $\mathcal{F}, \mathcal{G}$ and $\mathcal{H}$, we have that $(\mathcal{H}\circ \mathcal{G})\circ \mathcal{F} = \mathcal{H}\circ(\mathcal{G}\circ\mathcal{F})$.

Now we can write what it means for a functor $\mathcal{M}$ to be a monoid in this category. Going back to the phrase "a monoid in the category of endofunctors", we just need $\mathcal{M}$ to satisfy the monoid axioms. For now, let's let $\textnormal{Id}$ denote the identity endofunctor: $\textnormal{Id} X = X$ for all $X\in\mathbb{O}(\mathcal{C})$ and you can guess what it does on morphisms. All we'll need for $\mathcal{M}$ to have the structurer of a monad is  *just* some morphisms (i.e. natural transformation) $m: \mathcal{M}\circ\mathcal{M} \to \mathcal{M}$ and $u:\textnormal{Id}\to\mathcal{M}$ that make those diagrams from [[Monoids]] commute, which I'll copy for this context below. Note that these natural transformations entail a collection of maps $m_X : \mathcal{M}\circ \mathcal{M}\ X \to \mathcal{M}\ X$ and $u_X : X\to \mathcal{M} X$ (satisfying the naturality condition, of course). Then the monoid diagrams entail that for each $X$, there is a commuting diagram:

![[monad3.png]]

Now, there's a bit of notation here which I've not explained. First, it's worth commenting on $\textnormal{Id}$. Since it acts trivially on all objects, there's a natural identification
$$
\textnormal{Id}\circ \mathcal{M}\ X = \textnormal{Id}\ (\mathcal{M\ X}) = \mathcal{M}\ X = \mathcal{M}\ (\textnormal{Id}\ X) = \mathcal{M}\circ \textnormal{Id}\ X
$$
This identification can be used to define the canonical map, $\textnormal{can}$. I also need to specify what the maps like $m\cdot 1$ mean. Similar to the section on monoids, it's suggestive to mean "do nothing on the rightmost apply on the leftmost". For $m\cdot 1$, this specifically means that we want to perform a contraction $(\mathcal{M}\circ \mathcal{M}) (\mathcal{M}\ X)\to \mathcal{M} (\mathcal{M}\ X)$. Going back to the definition of the maps $m_X$, inspection suggests that $(m\cdot 1)_X = m_{\mathcal{M}X}$. Doing the same exercise for the other maps gives the following prescriptions of these "dotted" compositions for all $X$.
$$
(m\cdot 1)_X = m_{\mathcal{M}X}, \hspace{20pt} (1\cdot m)_X = \mathcal{M}({m_X}), \hspace{20pt}
(u\cdot 1)_X = u_{\mathcal{M}X}, \hspace{20pt} (1\cdot u)_X = \mathcal{M}({u_X})
$$
As a final note before some examples, these "dotted" maps are a special case of something known as the horizontal composition of natural transformations. Turns out there's quite a few ways to put together two natural transformations to create a new one, but that's for another time.

**Example 1** This is enough to get us to our first monad --- the identity functor! It's not a very interesting one, but go chase around the definition to verify that it is, indeed, a monoid in the category of endofunctors. In particular, since we have $1\circ 1 = 1$, we can take $m$ to be the identity natural transformation: $m_X = 1_X: (1\circ 1) (X) \to 1 (X)$. The unit morphism is just the identity on $1$.

**Example 2**: recall the functors $\text{Free}: \text{Set}\to \text{Vec}$ and $\text{Forget}: \text{Vec}\to \text{Set}$ between the categories of sets and vectorspaces. The functor $\mathcal{F} := \text{Forget}\circ \text{Free} : \text{Set} \to \text{Set}$ turns out to have the structure of a monad! To define the multiplication natural transformation, $m: \mathcal{F}\circ\mathcal{F}\to \mathcal{F}$, we need to define maps
$$
\mathcal{F}(\mathcal{F} X) \to \mathcal{F}X
$$
for all sets $X$. Recall that elements of $\mathcal{F}X$ are linear combinations $\sum_{x\in X} a_x x$ of elements of $X$. In turn, elements of $\mathcal{F}(\mathcal{F} X)$ are linear combinations $\sum_{\underline{a}\in \mathcal{F} X} b_{\underline{a}} \underline{a}$, where each $\underline{a}$ appearing in the sum can itself be written as a linear combination $\underline{a} = \sum_{x\in X} a_x x$. Now, trying to keeping things simple (not doing any functional analysis stuff), these sums are finite so we can always write 
$$
\sum_{\underline{a}\in \mathcal{F}X} b_{\underline{a}} \underline{a} = \sum_{\sum a_x x \in \mathcal{F} X} b_{\sum a_x x} \left(\sum_{x\in X} a_x x\right) = \sum_{x\in X} \sum_{a: X\to \mathbb{F}} b_a a_x x,
$$
where we define $b_a := b_{\underline{a}}$ . In the last equality, note that we can associate any $\underline{a} = \sum_{x\in X} a_x x$ with a uniquely defined function $a:X\to \mathbb{F}$ by examining the collection of coefficients. This gives a natural way to 'simplify' elements of $\mathcal{F}(\mathcal{F}X)$ into elements of $\mathcal{F}X$. That is, it gives us a function $m : (\mathcal{F}\circ \mathcal{F})X\to \mathcal{F}X$ for all sets $X$. This turns out to be a natural transformation. We can define the unit by specifying a map $u_X: X\to \mathcal{F}X$ for each $X$. The map is simple in this case, with $u_X(x) = x$.

**Example 3** The power set monad. This one is similar to the last one, but a bit easier. There's a functor $\mathcal{P}:\text{Set}\to\text{Set}$ which takes a set $X$ to its power set $\mathcal{P}X$, which is just the set of subsets of $X$. This functor sends a function $f:X\to Y$ to the function $\mathcal{P}f : \mathcal{P}X\to \mathcal{P}Y$ which sends a subset $U$ of $X$ to the subset $f(U)$ of $Y$. The monad structure on $\mathcal{P}$ can be described by defining maps $m_X : \mathcal{P}(\mathcal{P}X) \to \mathcal{P}X$ for each set $X$. Note that elements of $\mathcal{P}(\mathcal{P} X)$ are sets of subsets of $X$, so we can simply define
$$
m_x : \mathcal{P}(\mathcal{P}X) \to \mathcal{P}X,\hspace{30pt} \{U\subset X\} \mapsto \bigcup U
$$
The unit morphism $u: 1\to \mathcal{P}$ once again can be defined by specifying maps $u_X: X\to \mathcal{P}X$ that are natural in $X$. Here, $u_X(x) = \{x\}$.

**Example 4** Consider the category of finite-dimensional vector spaces over a field $\mathbb{F}$, $\textbf{Vec}_{\text{fd}}$. Let $A$ be a finite-dimensional $\mathbb{F}$-algebra. Using the tensor product over $\mathbb{F}$, we can construct a monad $A\otimes? : \textbf{Vec}_{\text{fd}}\to \textbf{Vec}_{\text{fd}}$. The multiplication map $m: A\otimes(A\otimes ?) \to A\otimes?$ can be defined using the usual multiplication on $A$. That is, for each vector space $V$, we have a map 
$$m: A\otimes A\otimes V\to A\otimes V, \hspace{30pt} a\otimes a'\otimes v \mapsto a\cdot a' \otimes v$$
The unit map $1\to A\otimes ?$ can be constructed through observing that there is a natural isomorphism[^2] between the identity functor and the functor given by tensoring with the base field; $1 \simeq \mathbb{F}\otimes?$. Using this identification, the unit map is defined through the unit map $\mathbb{F}\to A, s\mapsto s\cdot 1$ for $A$.
[^2]: A natural transformation $\alpha$ between two functors $\mathcal{F}$ and $\mathcal{G}$ which is an isomorphism for each object $X$. 

**Example 5** This one will be similar to above, but needs some basic knowledge of representation theoretic vocabulary. Let $\text{Rep}(S_n)$ be the category of finite-dimensional representations of the symmetric group, $S_n$, again assuming some base field $\mathbb{F}$. Let $V = \mathbb{F}^n$ be the natural representation of $S_n$. Then, as above, $V\otimes?$ turns out to have the structure of a monoid. To define the multiplication and unit maps, it's useful to enumerate bases. Let $x_1, \ldots, x_n$ be the standard basis for $V$. Then the multiplication $V\otimes V\to V, x_i\otimes x_j\mapsto \delta_{ij} x_i$ induces the multiplication map $V\otimes V\otimes ?\to V\otimes ?$, where $\delta_{ij}$ is the Kronecker delta. Similarly, the map $\mathbb{F} \to V, 1 \mapsto \sum x_i$ induces the unit map on functors $1\simeq \mathbb{F}\otimes ? \to V\otimes?$.