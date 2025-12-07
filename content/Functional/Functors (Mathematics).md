---
date: 2025 February
---
Normally, you learn about functions when encountering set theory. Sets don't really have structure, so a function doesn't really need to satisfy much apart from passing the vertical line test[^1]. As one learns more math, it becomes common to care about sets with some extra structure and you'll want your functions to respect this extra structure. For example, when a student learns about groups, they learn to care about group homomorphisms. Or when they learn of topological spaces, they'll care about continuous maps. There's a similar moral with category theory (although a category isn't "just" a set with extra structure like those previous examples).
[^1]:I'm being terse here again, avoiding the formal definition of a function.

Morally, a functor is a function between two categories. That is to say, a (covariant[^2]) functor $\mathcal{F} : \mathcal{C} \to \mathcal{D}$ from a category $\mathcal{C}$ to another category $\mathcal{D}$ is just a way to go from the first category to the second in such a way that the categorical structure gets preserved. Keeping in mind that some of the core data of a category is just its objects and morphisms, $\mathcal{F}$ needs a way to send objects of $\mathcal{C}$ to objects of $\mathcal{D}$, and similarly for morphisms, satisfying some structural constraints. More precisely, $\mathcal{F}$ consists of the data:
- An assignment $\mathcal{F}X\in \mathbb{O}(\mathcal{D})$ for each $X\in \mathbb{\mathcal{C}}$.
- An assignment $\mathcal{F}(g): \mathcal{F}X \to \mathcal{F}Y$ for each $g: X\to Y \in \textnormal{Hom}_{\mathcal{C}}(X,Y)$.
These assignments have to satisfy the following structural rules:
- $\mathcal{F}$ preserves composition: $\mathcal{F}(h\circ g) = \mathcal{F}(h)\circ \mathcal{F}(g)$ for each $g:X\to Y$ and $h\in Y\to Z$. That is, 
$$
\mathcal{F}(h\circ g) : \mathcal{F}X\to \mathcal{F}Z \hspace{20pt} = \hspace{20pt} \mathcal{F}X\xrightarrow{\mathcal{F}(g)} \mathcal{F}Y \xrightarrow{\mathcal{F}(h)} \mathcal{F}Z.
$$
- $\mathcal{F}$ preserves identities: $\mathcal{F}(1_X) = 1_{\mathcal{F}X}$ for all $X\in\mathbb{O}(\mathcal{C})$.
[^2]: There's also contravariant functors but I'll leave that to you. There's always too much abstraction one can spin up, likely I'm doing the same.

Now all of a sudden if I want to write down examples of morphisms then we ought to be comfortable with some categories! We can bank off the examples from above.
- Fix a field $\mathbb{F}$. there's a functor $\textnormal{Forget}: \textbf{Vec}\to \textbf{Set}$ which sends a vector space to itself, viewed just as a set. It also sends any linear map to its self-same map, viewed as a map between sets.
- Continuing with notation from the previous example, there's a functor $\textnormal{Free}: \textbf{Set}\to \textbf{Vec}$ which sends a set $X$ to the $\mathbb{F}$-vector space with basis given by elements of $X$. Elements of $\textnormal{Free}(X)$ are (formal) linear combinations of elements of $X$. A function $g:X\to Y$ between sets gets sent to the linear map defined by:
$$
\textnormal{Free}(g): \textnormal{Free}\ X \to \textnormal{Free}\ Y, \hspace{15pt} \sum_{x\in X} a_x x \mapsto \sum_{x\in X} a_x g(x)
$$
- Take a graph $G$ and consider $\mathcal{C}(G)$ as in the previous section. Given any $v\in V$, there's a functor $\textnormal{Hom}_{\mathcal{C}(G)}(v, ? )$ which sends any $w\in V$ to the set $\textnormal{Hom}_{\mathcal{C}(G)}(v,w)$, which is definitionally equal to the set of paths $v\rightsquigarrow w$. To any morphism $w\rightsquigarrow w'$, we get a function between sets $\textnormal{Hom}_{\mathcal{C}(G)}(v,w) \to \textnormal{Hom}_{\mathcal{C}(G)}(v,w')$ given by appending a path $v\rightsquigarrow w$ with the path $w\rightsquigarrow w'$. I'll note that this is a special case of the more general notion of a representable functor and is related to the Yoneda lemma.
- If we are given a graph homomorphism $f: G\to H$, then we can build a functor $\mathcal{F}: \mathcal{C}(G)\to \mathcal{C}(H)$ in an obvious way. Try to check that the 'obvious' definition is actually a functor.
An endofunctor is just a functor of the form $\mathcal{F}:\mathcal{C}\to\mathcal{C}$. Here are some examples:
- Let $X$ be a set and consider the functor $X\times ?$ which sends any other set $Y$ to the product $X\times Y$ and any morphism $f : Y\to Z$ to the map $(1_X, f) : X\times Y \to X\times Z$. This is an endofunctor on $\textbf{Set}$. 
- More generally, in any category where it makes sense to take finite products, you can mimic the above definition. 
- You can compose the functors $\textbf{Free}$ and $\textbf{Forget}$ to get endofunctors $\textbf{Free}\circ\textbf{Forget} : \textbf{Vec}\to\textbf{Vec}$ and $\textbf{Forget}\circ\textbf{Free} : \textbf{Set}\to\textbf{Set}$. For the vast majority of vector spaces, $V$, $\textbf{Free}(\textbf{Forget}\ V)$ is likely quite large!
- Let $\textbf{Vec}_f$ be the category of finite-dimensional vector spaces over $\mathbb{F}$. Fixing $k\in\mathbb{N}$, there is a functor $\textnormal{Sym}^k$ which sends a vector space $V$ to its $k$-th symmetric power, $\textnormal{Sym}^k\ V$. Similarly, there functor $\bigwedge^k$ which sends $V$ to its $k$-th exterior power, $\bigwedge^k V$. I'm not defining the assignment of this functor on morphisms, but if you're interested then you can look up the definition of the symmetric and exterior powers and then you should be able to piece it together. These functors are examples of polynomial functors. 