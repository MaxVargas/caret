---
date: 2025 February
---
To be terse, a monoid is an object $M$, equipped with maps $m: M\otimes M\to M$ and $u:1\to M$ making the following diagrams commute (I'm choosing not to be precise about $1$ or $\otimes$, or the canonical arrows $\textnormal{can} : 1\otimes M \to M$ and $M\otimes 1\to M$):

![TikZ SVG](attachments/functional/monoid/01.svg), ![TikZ SVG](attachments/functional/monoid/02.svg)

If $M$ is a set (i.e., we are working in the category of (small) sets), then this boils down to the usual definition of a(n associative unital) monoid that one might run into in an undergrad math curriculum: 
- (Closure) For any $a,b\in M$, we have $ab\in M$.
- (Associativity) For any $a,b,c\in M$, we have $(ab)c = a(bc)$.
- (Unit) There exists an element $1\in M$ so that for any $a\in M$, we have $1a = a = a1$.
If you've never seen the above diagrams before, it might be worthwhile to chase out how these equations match up with the above diagrams, noting that $\otimes$ in this case is just the usual cartesian product on sets. 


Suppose that $\mathcal{C}=\textbf{Vec}$, the category of vector spaces. As above, the commutativity diagram for $m$ states that $m$ is associative: $(ab)c = a(bc)$, while the unit map $u$ states that there exists some $1\in\mathbb{F}$ satisfying the usual properties $(1a = a = a1)$. Unlike the previous case, however, we have extra structure coming from the fact that all arrows need to be linear maps! You can use this information to derive some familiar properties about $m$ (I'm not going to prove them...):
- (Distributivity) For all $a,b,c\in M$, we have $a (b + c) = ab + ac$ and $(a + b) c = ac + bc$.
- (Compatibility with scalars) For $a,b\in M$ and $\alpha,\beta\in\mathbb{F}$, we have $(\alpha a)(\beta b) = (\alpha\beta)(ab)$.
These rules --- unitality and associativity of multiplication, distributivity over addition, and compatibility with scalars --- just say that a monoid in $\textbf{Vec}$ is just an algebra over the base field $\mathbb{F}$!