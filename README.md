[![NPM version](http://img.shields.io/npm/v/hubot-frinkiac.svg?style=flat)](https://www.npmjs.org/package/hubot-frinkiac)
[![Build Status](http://img.shields.io/travis/okize/hubot-frinkiac.svg?style=flat)](https://travis-ci.org/okize/hubot-frinkiac)
[![Dependency Status](http://img.shields.io/david/okize/hubot-frinkiac.svg?style=flat)](https://david-dm.org/okize/hubot-frinkiac)
[![Downloads](http://img.shields.io/npm/dm/hubot-frinkiac.svg?style=flat)](https://www.npmjs.org/package/hubot-frinkiac)

# hubot-frinkiac

Hubot plugin for searching for Simpsons screencaps on the amazing [Frinkiac](https://frinkiac.com/) search engine (check it out!).

See [`src/frinkiac.coffee`](src/frinkiac.coffee) for full documentation.

## Installation

In hubot project repo, run:

`npm install hubot-frinkiac --save`

Then add **hubot-frinkiac** to your `external-scripts.json`:

```json
[
  "hubot-frinkiac"
]
```

## Sample Interaction

```
user> hubot simpsons me You don't win friends with salad.
```

![Example 1](https://raw.github.com/okize/hubot-frinkiac/gh-pages/example1.jpg)

Additionally, a second argument can be supplied (delineated by a pipe character) to override the image caption.

```
user> hubot simpsons me You don't win friends with salad. | ♪ You don't win friends with salad! ♪
```

![Example 1](https://raw.github.com/okize/hubot-frinkiac/gh-pages/example2.jpg)

There are also command aliases: `frinkiac` & `simpsons search`:

```
user> hubot frinkiac Me fail English? That's unpossible.
```

![Example 1](https://raw.github.com/okize/hubot-frinkiac/gh-pages/example3.jpg)
