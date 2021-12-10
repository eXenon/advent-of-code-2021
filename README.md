# Advent of Code 2021 in APL

This is my first attempt at making anything in APL, so it
might not be very good. However, it was a lot of fun to make!

## APL dialect

There are many ways to execute APL, each of which works a little
differently. Here is what I used.

### tryapl.com

[TryAPL.com](tryapl.com) was my first choice. It is easy and requires
no login. The IDE is pretty good and allows you to easily tinker with
the code. It uses a subset of Dyalog APL. Up to Day 8, all the examples
were written in this dialect.

However, it has very limited execution space, so variables often won't
fit into memory and commands time out.

### Dyalog APL

[Dyalog APL](dyalog.com) is free for non commercial uses, so you will
be able to find an install for your OS. It is the same dialect as above,
but with more primitives. You are only limited by the power of your
machine for space and time!

However, I found the IDE very finicky and uncomfortable. Some lines are
not _perfectly_ compatible with TryAPL for reasons I don't understand and
which seem very obscure to debug. I would definitely not recommend it
for beginners.

### Dyalog APL RIDE

The Dyalog APL Remote IDE is another project that is open source, which
gives you basically a web IDE (packaged in an electron app) for a Dyalog
APL session. The IDE is much more comfortable to use than the default one!

However, it still has these slight incompatibilities with TryAPL, so your
mileage may vary.

### Replit APL

[Replit](replit.com) offers free APL workspaces, using GNU APL. This
dialect of APL is mostly compatible with TryAPL, but all the functions
that are outside of the core of APL (IO, settings ... ) are different.

However, there is basically no IDE, just a text editor. So, you might
want to edit your code in a more friendly environment, then copy
paste it into replit to benefit from the increased memory and execution
time.