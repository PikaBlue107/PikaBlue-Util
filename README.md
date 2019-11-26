# PikaBlue-Util
A suite of custom scripts for ComputerCraft computers in Minecraft.

Usage: These files should be placed in a new folder in the root directory of a computer, called `lib/`. They can be called from anywhere on the Computer or Turtle by `/lib/[name] <parameters>`. Alternatively, you can create aliases (`alias travel lib/travel`) for programs with command-line functionality.


## properties.lua
Loads a file with key-value pairs on each line.
A key and value are separated by one equal sign '='.
No command-line functionality.

#### Functions
`readFile(filename)`: Reads the provided file for all key-value pairs it can find.
* Parameters
  * filename: a path to the properties file to be read
* Returns:
  * a table of keys and values from the file


## update.lua
Updates a lua file on this Computer from the text at a Pastebin URL.
The ComputerCraft Lua API provides a custom program called `pastebin`, which is itself built on top of the `http` API. This `update` program handles the manual process of deleting an old local file, copying in the pastebin URL, and running the pastebin program.
It loads the pastebin url from a properties file specified below.
If loading the file from Pastebin fails, update will not replace the old program file with empty text.
`update.lua` can update itself.
* preconditions: `/lib/config/urls.prop` with one key-value pair giving the name of the program being updated and the Pastebin URL it is linked with
* dependencies: `properties.lua`
#### Functions
`update(update_path)`: Updates the local program specified from the Pastebin URL saved in the file system.
* Parameters
  * update_path: a path to the program to be updated
  
#### Command line usage
`update [program]`: Calls the update function on the specified program.
* If the program path given does not contain the string `lib/`, it will be prepended to the program path before calling the `update` function. This allows the user to skip the `lib/` when typing `update lib/[program]`.


## travel.lua [WIP]
Implements movement commands for Turtles that remember initial facing direction and displacement from starting position.
Very similar to the idea of moveNorth(), moveSouth(), etc, but instead of using cardinal directions, this program uses the initial direction its host Turtle is facing as its "North".
`travel` also keeps track of the number of blocks this Turtle has moved since initialization with a `Vector`. Movement forward() and backward() is saved on the *Z axis (+/- respectively)*, while right() and left() are on the *X axis (+/-)*, and up() and down() are on the *Y axis (+/-)*
For example, when a turtle is initially facing West, and the following calls are made, it will move in the following directions:
```
forward(): West
right(): North
left(2): South, South
forward(): West
back(): East
up(): 
```
After these calls, the turtle will remember the following displacement:
* X axis: -1
* Y axis: 1
* Z axis: 1

This program uses the following convention to internally store directions as integers:
* 1 = Right
* 2 = Forward
* 3 = Left
* 4 = Back

#### Functions
`forward(num)`: Moves the Turtle in the forward direction it was first facing.
* Parameters
  * num: Number of blocks to attempt to move
* Returns
  * number of blocks successfully traveled
`back(num)`: Moves the Turtle in the backward direction from the one it was first facing.
* Parameters
  * num: Number of blocks to attempt to move
* Returns
  * number of blocks successfully traveled
`right(num)`: Moves the Turtle in the rightward direction from the one it was first facing.
* Parameters
  * num: Number of blocks to attempt to move
* Returns
  * number of blocks successfully traveled
`left(num)`: Moves the Turtle in the leftward direction from the one it was first facing.
* Parameters
  * num: Number of blocks to attempt to move
* Returns
  * number of blocks successfully traveled
`up(num)`: Moves the Turtle in the upward direction.
* Parameters
  * num: Number of blocks to attempt to move
* Returns
  * number of blocks successfully traveled
`down(num)`: Moves the Turtle in the downward direction.
* Parameters
  * num: Number of blocks to attempt to move
* Returns
  * number of blocks successfully traveled
`turnRight(num)`: Rotates the Turtle to the right.
* Parameters
  * num: Number of rotations to perform
`turnLeft(num)`: Rotates the Turtle to the left.
* Parameters
  * num: Number of rotations to perform
`getDir()`: Retrieves the raw integer direction this turtle is currently facing
* Returns
  * The raw integer direction stored by this program
`getDirStr()`: Retrieves the display string that this Turtle is currently facing ("Right", "Forward", "Left", "Back")
* Returns
  * The display-friendly string for the direction this Turtle is currently facing
` printDir()`: Prints the result of getDirStr()
`getDisp()`: Gets the Displacement Vector.
* Returns
  * a Vector describing the number of blocks this Turtle has been displaced by moves from this program since initialization.
` printDisp()`: Prints the data of the Displacement Vector in the format "[axis]: [displacement]"

#### Internal Functions
`bound(arg)`: Bounds the provided number by a modulus of 4 between 1 and 4. If a decimal number is provided, may run with an infinite loop.
* Parameters
  * arg: Any number to bound, usually an integer
* Returns
  * A new number n that satisfies `n = arg + 4 * [some integer]` and `1 <= n <= 4`
`matchDir(desired, strict)`: Rotates the turtle to match the desired direction. If strict is true, then it must rotate to match exactly the direction desired; otherwise, it must only point on the *same axis* as the desired direction. This allows a call to back() while the turtle is facing forward to skip the 180 degree rotation, and instead use the `turtle.back()` function.
* Parameters
  * desired: The integer direction to be traveled in.
  * strict: true = the turtle must face exactly the direction desired, false = the turtle must face on the axis of the direction desired.
* Returns
  * False if the Turtle ends up facing the same axis, opposite direction as desired, otherwise true.
`move(num)`: Moves the turtle in the direction it is currently facing. If num is negative, will move it in the opposite direction.
* Parameters
  * num: The number of blocks to attempt to move
* Returns
  * the number of blocks successfully moved
`vert(direction, num)`: Moves the turtle vertically with the direction and number of blocks specified. Does NOT allow negative num values. Similar to `move()`, but for vertical movement.
* Parameters
  * direction: integer direction to be traveled in (Up or Down)
  * num: The number of blocks to attempt to move
* Returns
  * the number of blocks successfullly moved
`travel(direction, num)`: Ensures that a turtle is pointing in the desired direction, then passes the movement command to `move()`. Acts as a mediary between horizontal movement API functions and the internal `matchDir()` and `move()` functions to reduce reduncancy.
* Parameters
  * direction: The integer direction to be moved in
  * num: The number of blocks to attempt to move
* Returns
  * The number of blocks successfully moved

#### Command line usage
Any of the API functions may be called from the commandline, with their arguments as commandline arguments after the function name. Additionally, the following command is implemented as a wrapper for the useful internal function matchDir():
`face [direction]`: Calls the internal `matchDir()` function, pointing the turtle toward the desired direction.
* This call is made with `strict = true`, so the turtle will always face exactly the direction specified.
