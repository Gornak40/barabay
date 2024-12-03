# barabay

*Simple template engine written in Bash.*

- **No dependencies.**
- **Dead simple.**
- **Not very fast.**

## Usage

**TODO**

## Example

### Files

`params.cfg`

*Your data lives here.*

```
title	Gorilla
link	https://algolymp.ru

@gorilla	gorilla.html
text	Gorilla is big animal
image	/static/img/west.png
@.

text	Gorilla is gorgeous
image	/static/img/east.png
@.
```

`gorilla.html`

*Element templates.*

```html
<div class="gorilla">
	<p>This is the gorilla!</p>
	<p>{{ text }}</p>
	<img src="{{ image }}">
</div>
```

`index.html`

*Main template.*

```html
<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="UTF-8">
	<title>{{ title }}</title>
</head>
<body>
	<h1>{{ title}}</h1>
	<div>
		<a href="{{ link }}">gorilla pic</a>
		{{ @gorilla }}
	</div>
</body>
```

### Usage

```bash
cat params.cfg | ./barabay.sh index.html
```

### Result

```html
<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="UTF-8">
	<title>Gorilla</title>
</head>
<body>
	<h1>Gorilla</h1>
	<div>
		<a href="https://algolymp.ru">gorilla pic</a>
		<div class="gorilla">
	<p>This is the gorilla!</p>
	<p>Gorilla is big animal</p>
	<img src="/static/img/west.png">
</div>
<div class="gorilla">
	<p>This is the gorilla!</p>
	<p>Gorilla is gorgeous</p>
	<img src="/static/img/east.png">
</div>
	</div>
</body>
```
