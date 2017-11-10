# WybroStarter
This `pod` contains a collection of Swift extensions that reduce boilerplate code in new iOS projects

Getting Started
------
Add the following line to your `Podfile`:
```
pod 'WybroStarter'
```

Swift Extensions
------
We have added new functionality to `UIView`, `NSLayoutConstraint` and `UIColor` to make it easier to build projects *without* `xib` files

### UIView

#### Constraints
Specify that a view will be using constraints. A good time to do this is while the view is being added as a subview:

```Swift
view.addSubview(yourView.usingConstraints())
```

#### Centering
Center a view horizontally or vertically within another view:
```Swift
let horizontal = yourView.center(in: view, type: .horizontal)
let vertical = yourView.center(in: view, type: .vertical)
```

### NSLayoutConstraint
Create constraints for multiple views and formats with **VFL**:
```Swift
let constraints = NSLayoutConstraint.constraints(
      formats: ["V:|[view]|",
                "H:|[view]|"],
      views: ["view": yourView]
)
```

A nice pattern to follow involves creating a function to return the constraints you want and chaining an `activate` to enable all of the constraints:
```Swift
func layoutConstraints() -> [NSLayoutConstraint] {
  // create constraints here
  return constraints
}

layoutConstraints().activate()
```

### UIColor
Create an instance of `UIColor` using a `hex` string:
```Swift
let color = UIColor(hex: "FFFFFF")
```

