## Why calling C from R
R was designed with arrays in mind and sucks at looping through data structures in iterative algorithms. Getting all the speed advantages from C with the convenience of R's environment for scientific and statistical programming, is possible if compiling C functions in shared libraries and embedding its calls in R code.

## Considerations

Two major considerations have to be taken into account:

* Function arguments are always passed from R as references, with a pointer.

* Function has no return value. Instead, it modifies it's input arguments passed by reference.

## A toy function

This function squares the ''n'' elements of the ''x'' vector:

```C
void f(int *_x, double *x)
{
	int n = _x[0];

	int i;

	for (i=0; i<n; i++)
		x[i] = x[i] * x[i];
}
```

**BE EXTREMELY CAREFUL NOT GOING BEYOND THE BOUNDARIES OF THE VECTOR.**

## Compiling and calling the C code

The C source file has to be compiled as a shared object from the UNIX prompt with:

```sh
$ R CMD SHLIB f.c
```

Then loading the shared library within R and calling a function:

```R
R> dyn.load("f.so")
R> .C("f", _x=as.integer(5), x=as.double(rnorm(5)))
```

## Wrapper to the C function

Creating a wrapper function in R to call the original C function has some benefits, apart from being user-frendly:

* It allows some error checking in R, where it is easier than in C.
* It allows some arguments (like n here) to be calculated so they don't have to be supplied by the user.
* It allows you to return only what the user needs.

```R
foo <- function(x) {
	if (!is.numeric(x))
		stop("argument x must be numeric")
	out <- .C("foo",
		n=as.integer(length(x)),
		x=as.double(x))
	return(out$x)
}
```

## Error handling

Use the R ''error'' or ''warning'' functions:

```C
#include <R.h>

void f(int *_x, double *x)
{
	int n = _x[0];

	int i;

	if (n < 1)
		error("arg _x was %d, must be positive\n", n);

	for (i=0; i<n; i++)
		x[i] = x[i] * x[i];
}
```

