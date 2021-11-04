## gnuplot

From the gnuplot project:

Gnuplot is a portable command-line driven graphing utility for Linux, OS/2, MS Windows, OSX, VMS, and many other platforms. It was originally created to allow scientists and students to visualize mathematical functions and data interactively, but has grown to support many non-interactive uses such as web scripting. It is also used as a plotting engine by third-party applications like Octave.

We suggest here to use it as extension of the basic R graphic capabilities.

## Requirements

The gnuplot packages:

```sh
$ sudo apt-get install gnuplot
$ sudo apt-get install gnuplot-x11
```

And the R package:

```R
R> install.packages("Rgnuplot")
```

## Opening a gnuplot session

This very basic command plots 3 trigonometric functions in gnuplot:

```gnuplot
> set terminal pngcairo  transparent enhanced font 'arial,10' fontscale 1.0 size 500, 350
> set output 'out.png'
> set key left box
> plot [-10:10] sin(x),atan(x) with points,cos(atan(x)) with impulses
```

From R, one can pipe commands into gnuplot after opening a new session:

```R
R> library(Rgnuplot)
R> h1<-gp.init()
R> gp.cmd(h1,"set terminal pngcairo  transparent enhanced font 'arial,10' fontscale 1.0 size 500, 350")
R> gp.cmd(h1,"set output 'out.png'")	# set output file
R> gp.cmd(h1,"set key left box")		# include a boxed legend
R> gp.cmd(h1,"plot [-10:10] sin(x),atan(x) with points,cos(atan(x)) with impulses")
R> gp.close(h1)
```

## Further reading

[http://gnuplot.sourceforge.net/demo/ The gnuplot project page] and [http://cran.r-project.org/web/packages/Rgnuplot/index.html the Rgnuplot package repo]

