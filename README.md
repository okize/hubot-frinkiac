[![NPM version](http://img.shields.io/npm/v/hubot-frinkiac.svg?style=flat)](https://www.npmjs.org/package/hubot-frinkiac)
[![Build Status](http://img.shields.io/travis/okize/hubot-frinkiac.svg?style=flat)](https://travis-ci.org/okize/hubot-frinkiac)
[![Dependency Status](http://img.shields.io/david/okize/hubot-frinkiac.svg?style=flat)](https://david-dm.org/okize/hubot-frinkiac)
[![Downloads](http://img.shields.io/npm/dm/hubot-frinkiac.svg?style=flat)](https://www.npmjs.org/package/hubot-frinkiac)

# hubot-frinkiac

Hubot plugin for searching for Simpsons screencaps on [Frinkiac](https://frinkiac.com/)

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
user1>> hubot simpsons search Me fail English? That's unpossible.
hubot>> returns captioned Simpsons image
```

There is a also an alias for `simpsons search` called `frinkiac`:

```
user1>> hubot frinkiac You don't win friends with salad.
hubot>> also returns captioned Simpsons image
```

Additionally, a second argument can be supplied (delineated by a pipe character) to override the image caption.

```
user1>> hubot simpsons search Mmmm, sacrilicious. | Mmmm, cromulent.
hubot>> returns Simpsons image with a caption of the second argument
```
