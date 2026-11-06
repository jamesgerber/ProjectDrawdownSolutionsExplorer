# Project Drawdown Solutions Explorer

Textual repo description goes here.

some MATLAB stuff for the Solutions Explorer written by Jamie mostly.

# Matlab Environment Usage:

Jamie likes to have simlinks to all sorts of goodies on his system.
Most of us don't have the exact same setup forged in the fires of ages of data science.

Instead of this clunky path access we should use `.env` variables, these are simple files with key value pairs

Heres a classic `.env` structure, that is compatible with bash and MATLAB. 

```bash
KEY=VALUE
```

In MATLAB we can load and access .env files as such:

```MATLAB
    loadenv('.env')

    getenv('KEY') // This will be VALUE
```
In Octave:

```octave
    getenv('KEY') // will be VALUE
```


Having everyone have their own private `.env` file that is `.gitignored` then makes it so we don't have to worry about paths! This makes sharing code much easier and hastle free.

For old men who don't like change, `jamie.env` has been provided prepopulated based on files. 


Add the following to your startup.m and your env file will automatically be loaded (From the current working dir) when matlab runs.
You might also want to have your .env be in the same folder as your startup.m itself. 
```matlab
if exist .env
    loadenv(.env)
else
    warning("No .env found in current dir")
end
```

## Best Practices
Because the .env values are strings sometimes matlab/python/etc can parse ~/ as literally "~"/"etc" rather than expanding ~ as /home/etc or /Users/etc as such its best practice to have your full home path rather than the ~ in the .env.

Always end directories with / this will make it less likely to have path concatenation issues where we end up with `path/to/dirfile` which can cause errors, luckily `path/to/dir//file` generally evaluates to `path/to/dir/file` internally, so the risk of having the / is none. 