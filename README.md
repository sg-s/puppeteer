# puppeteer

[![GitHub last commit](https://img.shields.io/github/last-commit/sg-s/puppeteer.svg)]()

A MATLAB class that can control **anything**. 

![](https://user-images.githubusercontent.com/6005346/57262966-9b751100-703c-11e9-890f-3808062e60d9.gif)

## The Problem:

* You have a simulation or a function with some parameters. It's complicated
* You want to get a feel for it by twiddling the parameters and seeing how it changes
* It's a pain to write bespoke wrappers for your code and worry about UI generation

## The solution 

`puppeteer` does all the hard work of generating UI elements for you. 

Generate a new `puppeteer` instance and tell it the parameters you want to manipulate:

```matlab
% your parameters are in a structure
params.A = 1;
params.B = 2;

% with a corresponding lower 
% bound and upper bound structure
lb.A = 0;
lb.B = 0;

ub.A = 2;
ub.B = 3;

p = puppeteer(params,lb,ub);

```

`puppeteer` then generates a figure with sliders that allows you to control these parameters. The nice thing now is that any changes you make in the sliders are reflected in the `puppeteer` object:

```
p.parameters % stores the updated value, always
``` 

Now, there are two ways to hook up `puppeteer` to your simulation so that changes in `puppeteer` affect your simulation. 

The first is simple: your simulation simply polls `p.parameters`, and changes its parameters based on that. 

The second allows you to configure a callback function so that `puppeteer` will call this every time you change a parameter. 

```
p.callback_function = my_function_handle;
% puppeteer will call this function with the parameters argument

```



## License

GPL 3. `puppeteer` is free software. 