
I've no idea how to do this in a good way haha

The original plan was to use a package like `node-tikzjax` to automate the process of taking TikZ code to generate SVG images, but I wasn't able to find a package that actually worked.

So now I'm taking a much simpler approach, albeit a little more manual:
1. Generate a PDF containing the image I want to render using LaTeX.
2. Convert the pdf to svg with the `pdf2svg` utility.
3. Place the svg in a location appropriate for this website.
4. Insert the image using the markdown format `![TAG](path/to/image.svg)`, where `TAG=TikZ SVG`.
5. Use a custom `Transformer` to find and replace the above markdown with a CSS item of the form `<img src="path/to/image.svg" alt="TikZ SVG" class="tikz-color">`. The class `tikz-color` just renders the image with appropriate colors for light/dark theme.
I suppose I could combine 4 and 5 into a single step, just to work with CSS but... eh..

![TikZ SVG](attachments/functional/categories/1.svg)

Here's the code to generate the sample image. Taken from the [obsidian-tikzjax](https://github.com/artisticat1/obsidian-tikzjax) project.

```tikz
\usepackage{tikz-cd}

\begin{document}
\begin{tikzcd}

    T
    \arrow[drr, bend left, "x"]
    \arrow[ddr, bend right, "y"]
    \arrow[dr, dotted, "{(x,y)}" description] & & \\
    K & X \times_Z Y \arrow[r, "p"] \arrow[d, "q"]
    & X \arrow[d, "f"] \\
    & Y \arrow[r, "g"]
    & Z

\end{tikzcd}
\end{document}
```

