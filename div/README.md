
## Div widget

This widget is just a wrapper for the container Widget with an gesture detector and row, col (column) constructors.
it also use the first argument as a child or children

## Usage

### basic usage:
```dart
Div(
  Text('Hello div'),
),
```
it has all container widget properties
```dart
Div(
  Text('Hello div'),
  color: Colors.red,
  padding: EdgeInsets.all(12),
  // and more ...
),
```
### Row
```dart
Div.row([
    Text('Hello div'),
    Text('Hello div'),
],),
```

### Column

```dart
Div.col([
    Text('Hello div'),
    Text('Hello div'),
],),
```

### with Gesture detector

```dart
Div(
    Text('Hello div'),
    onTap: () {
      print('tap');
    },
),
```

## Why?
to me think using first argument as a child or children can minimize the code and make it more readable, because when ur tree go to be more complex, it will be hard to read.

Example:
```dart
Div.col([
    Text('Hello 0'),
    Div(
        Text('Hello 1'),
        color: Colors.teal
    ),
    Div.row([
        Text('Text'),
    ]),
    Div(
        Text('Hello with onTap'),
        onTap: () {
        print('tap');
        },
    ),
]),
```

## Next?
...