############################
## The original author is probably Phil Ewels
## Code taken from https://github.com/nf-core/cookiecutter
############################

# Command line argument processing
args = commandArgs(trailingOnly=TRUE)
if (length(args) < 2) {
  stop("Usage: markdown_to_html.r <input.md> <output.html>", call.=FALSE)
}
markdown_fn <- args[1]
output_fn <- args[2]

# CSS
base_css_fn <- getOption("markdown.HTML.stylesheet")
base_css <- readChar(base_css_fn, file.info(base_css_fn)$size)
custom_css <-  paste(base_css, "
body {
  padding: 3em;
  margin-right: 350px;
  max-width: 100%;
}
#toc {
  position: fixed;
  right: 20px;
  width: 300px;
  padding-top: 20px;
  overflow: scroll;
  height: calc(100% - 3em - 20px);
}
#toc_header {
  font-size: 1.8em;
  font-weight: bold;
}
#toc > ul {
  padding-left: 0;
  list-style-type: none;
}
#toc > ul ul { padding-left: 20px; }
#toc > ul > li > a { display: none; }
img { max-width: 800px; }
")

# convert
markdown::markdownToHTML(
  file = markdown_fn,
  output = output_fn,
  stylesheet = custom_css,
  options = c('toc', 'base64_images', 'highlight_code')
)

