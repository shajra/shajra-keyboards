The files in this directory support the maintenance of the project. You can safely ignore this directory if you only want to use the project.

There are two scripts in this directory.

-   `dependencies-upgrade`
-   `docs-generate`

They are designed to be called with no arguments, and can be called from any working directory, though they both modify the source code in place.

`dependencies-upgrade` updates the dependencies in [../nix/sources.json](../nix/sources.json) with a tool called [Niv](https://github.com/nmattia/niv).

`docs-generate` will execute any `SRC` blocks in Org-mode files, modifying them in place. And then it generate GitHub Flavored Markdown files from them.
