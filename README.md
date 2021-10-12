# Set Data Structure Code Along

## Learning Goals

- Identify the use cases for a `Set`
- Implement common methods for a `Set`

## Introduction

In this lesson, we'll build the definition for a `Set` class along with some of
its common methods to get an understanding of the general approach to building
data structures.

## Building Data Structures From Scratch

When you're making a data structure to solve a particular algorithm problem, you
won't need to implement **every** common method of that data structure: you only
need to implement the ones that are required to solve your particular problem.

You may be wondering why you need to make a `Set` yourself, since many
languages, including Ruby and JavaScript, already have a built-in `Set` class.
It's common in interview settings that you'll be allowed to use built-in
classes, so you won't necessarily need to be able to build a `Set` from scratch.
However, building a data structure from scratch is a useful exercise for a few
reasons:

- It gives you a better understanding of the Big O of common methods in built-in
  classes, which you'll need to know in order to determine your algorithm's
  efficiency.
- Many other common data structures, like Linked Lists, Stacks, and Queues,
  **aren't** included in some languages, so it's important to know a general
  process to building data structures.
- Not all languages implement data structures in the same way. For example, the
  [`Set` in JavaScript][js set] preserves the order that elements were inserted
  into the `Set`, where as the [`Set` in Ruby][ruby set] does not.

When building data structures from scratch, you'll often use other built-in data
structures to support your data structure and hold data. A key consideration
when building on top of built-in data structures is understanding the Big O
runtime of built-in methods, so make sure to keep this in mind.

## When To Use a Set

A `Set` is a data structure that is used for storing a collection of **unique**
values. They are useful for problems that involve finding repeated values, or
removing duplicate values.

For example, here's an algorithm for finding the first repeated value in an
array. Without using a `Set`, we might end up with a solution like this that has
a O(n²) runtime, since we need to check every element in the array against all
the remaining elements:

```rb
def first_repeated_value(array)
  for i in 0..array.length
    for j in i + 1..array.length
      return array[i] if array[i] == array[j]
    end
  end
  nil
end

first_repeated_value([1,2,3,3,4,4])
# => 3
```

With a `Set`, we can keep track of the values we've already seen and end up with
a more efficient O(n) runtime solution, provided that the `Set#include?` and
`Set#add` methods have O(1) runtimes:

```rb
def first_repeated_value(array)
  # create a Set to keep track of values we've seen
  set = Set.new
  # iterate over each element from the array
  for i in 0..array.length
    # if we've already seen a value, we've found the duplicate!
    return array[i] if set.include?(array[i])
    # otherwise, add the value to our set
    set.add(array[i])
  end
  # return nil if we reach the end and haven't found our value
  nil
end

first_repeated_value([1,2,3,3,4,4])
# => 3
```

## Defining a Set Class

Let's make our own version of Ruby's `Set` class to understand how these methods
might work under the hood. We'll build a `MySet` class using Ruby that has the
following methods:

- `.new(enumerable)`: Initializes a new `MySet` and adds any values from the
  enumerable.
- `#include?(value)`: Checks if the value is already included in the `MySet`. Must
  have a O(1) runtime.
- `#add(value)`: Adds the value to the `MySet` if it isn't already present. Must
  have a O(1) runtime.
- `#delete(value)`: Removes the value from the `MySet`. Must have a O(1) runtime.
- `#size`: Returns the number of elements in the `MySet`.

Let's get started! We'll be coding in the `lib/my_set.rb` file. You can run the
tests at any point using `learn test` to check your work.

### `MySet.new`

To start, we'll need to define a class and set up an initialize method:

```rb
class MySet
  def initialize
  end
end
```

Let's think about how we might want to use this class. We may want to initialize
a new, empty set:

```rb
set = MySet.new
# => #<MySet: {}>"
```

We might also want to pass in an existing collection of values, such as an
array, and create a new set with just the unique values:

```rb
set = MySet.new([1, 2, 3, 3])
# => #<MySet: {1, 2, 3}>"
```

Let's update our `#initialize` method to account for these two cases:

```rb
class MySet
  def initialize(enumerable = [])
  end
end
```

Now, we need a way to keep track of all the values that were passed in. Think
about this: we want to keep track of a collection of data, and we want to be
able to **access** and **add** elements to that collection with O(1) runtime.

In order to do both of these operations, we'll need to use **another** data
structure to keep track of the elements in our set: a `Hash`! As you may recall
from earlier lessons, we discussed that a `Hash` data structure has (roughly)
the following runtimes:

| Method                                           | Big O |
| ------------------------------------------------ | ----- |
| Access (looking for a value with a known key)    | O(1)  |
| Search (looking for a value without a known key) | O(n)  |
| Insertion (adding a value at a known key)        | O(1)  |
| Deletion (removing a value at a known key)       | O(1)  |

With that in mind, we can complete our `#initialize` method by creating a `Hash`
and storing the values passed in as **keys** on the `Hash`:

```rb
class MySet
  def initialize(enumerable = [])
    @hash = {}
    enumerable.each do |value|
      @hash[value] = true
    end
  end
end
```

Run the tests now: the `MySet.new` tests should be passing. We can create new
instances of our data structure. Fantastic!

### `MySet#include?`

Next up: the `#include?` method. This method checks if the value is already
included in the set, and returns `true` if so, and `false` if not. It also must
have a O(1) runtime.

Since we're using a `Hash` as the underlying data structure for our set, what
are some ways we can check if the value is present as a key in the `Hash`?

We could either use bracket notation, and check if the key is present and the
value is truthy:

```rb
def include?(value)
  @hash[value]
end
```

That approach won't work as well if the key _isn't_ present, since it will
return `nil` instead of `false` when the value isn't in our set.

Let's use the [`Hash#has_key?`][has_key] method instead, which will always
return either true or false:

```rb
def include?(value)
  @hash.has_key?(value)
end
```

[has_key]: https://ruby-doc.org/core-2.7.4/Hash.html#method-i-has_key-3F

Run the tests now again to pass the `MySet#include?` tests. Fantastic!

### `MySet#add`

This method needs to add a value to the set if it isn't already present, and
return the updated set. It also must have a O(1) runtime.

Like the `#include?` method, we'll be working with our underlying `Hash` data
structure once more. Since adding a key to a hash is an O(1) runtime operation,
here's what our `#add` method should look like:

```rb
def add(value)
  @hash[value] = true # add a value as a key on the hash
  self                # return the updated set
end
```

Run the tests again to make sure your `#add` method works. Only two more left!

### `MySet#delete`

The `#delete` method removes a value from the set, and returns the updated set.
It also must have a O(1) runtime.

Once again, we're operating on the underlying `Hash` data structure and can take
advantage of a built-in method here:

```rb
def delete(value)
  @hash.delete(value)
  self
end
```

### `MySet#size`

Last one! The `#size` method simply needs to return the number of elements in
the set. Again, we can use a built-in `Hash` method here:

```rb
def size
  @hash.size
end
```

### Bonus

If you'd like to stretch yourself, consider refactoring our code. What parts of
our class could we DRY up? Where might we be able to use an `attr_` method
instead of referencing an instance variable directly?

For an extra bonus, here are some additional methods to try implementing. There
are tests for these in the `spec/my_set_spec.rb` file; uncomment the **bonus
methods** section in the test file to try these out.

- `MySet.[]`: Initialize a new `MySet` using bracket notation.
- `MySet#clear`: Removes **all** the items from the set, and returns the updated
  set.
- `MySet#each`: Iterates over each item in the set, and returns the set. Hint:
  you can use the build-in `#each` enumerable method. Read up on
  [Ruby blocks](https://mixandgo.com/learn/ruby-blocks) for help with syntax.
- `MySet#inspect`: Prints the set in a readable format.

Examples:

```rb
set = MySet[1,2,3]
puts set.inspect
# => #<MySet {1, 2, 3}>

set.each do |el|
  puts el
end
# => 1
# => 2
# => 3

set.clear
puts set.inspect
# => #<MySet {}>
```

## Conclusion

In this lesson, we learned about some general approaches to building a data
structure from scratch by implementing a `MySet` class. In doing so, we were
able to better understand the use cases for this data structure, as well as the
runtime of common methods. Keep in mind that the runtime of our data structure
will depend on what data structure(s) it uses under the hood.

## Resources

- [Ruby Set Class][ruby set]
- [JavaScript Set Class][js set]

[ruby set]: https://ruby-doc.org/stdlib-2.7.1/libdoc/set/rdoc/Set.html
[js set]: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Set
