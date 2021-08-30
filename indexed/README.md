# Indexed

its a widget allow you to order the items inside stack, sothing like z-index.

<center><video src='doc/assets/demo.mp4'  width=400 autoplay=true/></center>

## Getting Started 🚀

you can use it in 2 ways:

## use `Indexed` widget

```dart
Indexer(
    children: [
        Indexed(IndexedInterface
          // prefer add key when use AnimatedPositioned
          key: UniqueKey(),
          child: Positioned(
            //...
          )
        ),
    ],
);
```

### implements `IndexedInterface`

```dart
Indexer(
    children: [
        MyExtendsIndexed(),
        MyImplementsIndexed(),
    ],
);
// extends
class IndexedExtendsDemo extends IndexedInterface {
    int index = 5;
}
// implements
class IndexedExtendsDemo extends AnimatedWidget implements IndexedInterface {
    int index = 1000;
    //...

    //...
}
```

## Next?

* [X] Indexer
* [ ] Indexer.shadow(shadow:[1,1,100],children:[...]) // coming soon
* [X] Indexed (the item in stack)

## Support ☺️

you can buy me a coffee.

<a href="https://www.buymeacoffee.com/mohamadlounnas"><img src="https://img.buymeacoffee.com/button-api/?text=Buy me a coffee&emoji=&slug=mohamadlounnas&button_colour=FFDD00&font_colour=000000&font_family=Cookie&outline_colour=000000&coffee_colour=ffffff"></a>

engoj :)

more packeges: [Kplayer](https://pub.dev/packages/kplayer)
