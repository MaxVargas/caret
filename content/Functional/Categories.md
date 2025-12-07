---
date: 2025 February
---
A *category* $\mathcal{C}$ is the data of 
- a collection[^1] of 'objects' $\mathbb{O}(\mathcal{C})$,
- a collection of 'morphisms' (or arrows) $\textnormal{Hom}_{\mathcal{C}}(X,Y) = \{f: X\to Y\}$[^2] for each $X,Y\in\mathbb{O}(\mathcal{C})$, 
- a rule to compose arrows; given $f: X\to Y$ and $g: Y\to Z$, then there is an arrow $g\circ f : X\to Z$[^3], 
- for each $X\in\mathbb{O}(\mathcal{C})$, a distinguished identity morphism $1_X : X\to X$.
Further, this data has to satisfy the following criteria:
- (Associativity) We have for any $f: W\to X, g: X\to Y, h: Y\to Z$, that $h\circ (g\circ f) = (h\circ g) \circ f)$ as arrows $W\to Z$.
- (Unital) For all $X,Y\in \mathbb{O}(\mathcal{C})$ and $f:X\to Y$, we have $f\circ 1_X = f$. Similarly, for any $g: Y\to X$, we have $1_X \circ g = g$.
[^1]: Sometimes you see talk about classes vs. sets... this isn't an important detail... but if you use the formalism of Grothendieck Universes then you can run with everything being a set (within your universe) and not have to worry about classes...
[^2]: Given $f\in \textnormal{Hom}_{\mathcal{C}}(X,Y)$, sometimes I'll write $f:X\to Y$ instead. This makes it clearer (to me) which way the direction is going, and notationally this always makes composition easier in my head.
[^3]: The composition is just amounts to 'stacking the arrows': $g\circ f = X \xrightarrow{f} Y \xrightarrow{g} Z$. 

There's plenty of examples of categories. These two, we've already seen:
- The category, **Set**, whose objects are (small) sets and morphisms are your typical functions.
- The category, $\textbf{Vec}_{\mathbb{F}}$, whose objects are vector spaces over a given field $\mathbb{F}$ and morphisms are linear maps.
Here's a few other examples:
- Given a (directed) graph $G$ with vertices $V$ and edges $E$, we can build a category $\mathcal{C}(G)$ whose objects are precisely the vertex set $V$. The morphism set $\textnormal{Hom}_{\mathcal{C}{G}}(v, w)$ is precisely the set of paths $v\rightsquigarrow w$, (including the empty path in the case $v=w$).
- Again consider a graph $G$. We can build a different category $\mathcal{E}(G)$ whose objects are the set of all paths in $G$, including empty paths (of which there is one for each $v\in V$). Morphisms between two paths $p: v\rightsquigarrow w$ and $p': v'\rightsquigarrow w'$ will consist of pairs $(\psi, \varphi)$ where $\psi$ is a path $v'\rightsquigarrow v$ and $\varphi$ is a path $w\rightsquigarrow w'$. In the diagram below, the arrow (which goes to the right) from $v\rightsquigarrow w$ to $v'\rightsquigarrow w'$ consists of *both* horizontal arrows. The composition is a bit interesting here: given paths $p:v\rightsquigarrow w$, $p:v'\rightsquigarrow w'$, $p:v''\rightsquigarrow w''$ and morphisms $(\psi, \varphi) : p\to p'$ and $(\psi', \varphi'): p'\to p''$ , we have $(\psi', \varphi')\circ(\psi, \varphi) := (\psi\cdot\psi', \varphi'\cdot \varphi)$, using $\cdot$ to denote path concatenation.

![TikZ SVG](attachments/functional/categories/01.svg)