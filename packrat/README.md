# Packrat deployment

To avoid the package "hell" effect, we're using packrat in order to keep track
of the package versions and deploy in production a consistent version with what
was tested. The production versions of R and especially the packages may vary
between those used in RStudio Server and the Shiny Server.

### Enable a project and deploy it

In Rstudio, enable the project to use packrat (only the first time). This step
should probably be done only once.

```
packrat::init()
```

Prepare a bundle with the app + all the packages, ready to be deployed somewhere
else, all together.

```
packrat::snapshot()
packrat::bundle()
```

Last command will generate a tar.gz file, which is to be deployed in the final
destination.

In the next steps we'll take the bundle and deploy it in the *user* apps dir of
the Shiny server, to copy it later to the system's dir:

```
packrat::unbundle("/home/sayolspu/src/myapp/packrat/bundles/myapp-2017-11-15.tar.gz", "/home/sayolspu/ShinyApps")
```

And copy the app from the user's to the system's folder:

```
cp -r /home/sayolspu/ShinyApps/myapp /home/sayolspu/ShinyApps/systemShinyApps
```

The app can now be accessed at `http://shinyserver.mycompany.com/s/myapp/`

Don't forget to enable packrat in your global.R (or server.R + ui.R)

```
packrat::on()
```

### Notes and tips

* Init of the project to use packrat should probably be done only once
* If new packages are added to the project, do the snapshot and prepare the bundle
* If no new packages are required, simply copy the modified R files to the app dir

Also, probably, before "unbundling":

* open a new bash with "clean" module envir
* as per today, load the Bioconductor/3.5-foss-2016b module. A way to discover which modules to load is to run in the Shiny Server the command `system("module list 2>&1", intern=T)` from the [debug console](https://github.com/ssayols/R-epository/tree/master/debugConsole)
* open R and unbundle + activate packrat in the destination folder

More info at the official sources:

* [Using Packrat with RStudio](https://rstudio.github.io/packrat/rstudio.html)
* [Deploying packrat projects to Shiny Server Pro](https://support.rstudio.com/hc/en-us/articles/216528108-Deploying-packrat-projects-to-Shiny-Server-Pro)
