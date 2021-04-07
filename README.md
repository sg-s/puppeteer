# puppeteer

[![GitHub last commit](https://img.shields.io/github/last-commit/sg-s/puppeteer.svg)]()

A MATLAB class that can control **anything**. 

![](https://user-images.githubusercontent.com/6005346/57262966-9b751100-703c-11e9-890f-3808062e60d9.gif)

## The Problem:

* You have a simulation or a function with some parameters. It's complicated
* You want to get a feel for it by twiddling the parameters and seeing how it changes
* It's a pain to write bespoke wrappers for your code and worry about UI generation

## The solution 

`puppeteer` does all the hard work of generating UI elements for you. Here's how it works. 

Generate a new `puppeteer` instance and tell it the parameters you want to manipulate:

```matlab

p = puppeteer();

p.add('Name',Name,'Value',Value,'Group',categorical({'Wow'}),'Upper',1e-3,'Units','M');
% and so on...
```



Then wire up a callback function that gets called every time the sliders move:

```matlab
p.valueChangingFcn = @self.manipulateEvaluate; 
```

Finally, ask it to draw the UI

```matlab
p.makeUI;
```

That's it. Enjoy.


## License

GPL 3. `puppeteer` is free software. 


## puppeteer in use

1. [black-box-neuron](https://github.com/sg-s/black-box-neuron-public)
2. [xolotl](https://github.com/sg-s/xolotl)
