## NOTE

Some of this documentation currently is for the ActionScript 2 version of Bloxley.  It's in the process of being changed.

Classes marked with a * are significant to understanding the framework as a whole.

# bloxley.base

  A container for the root superclass, and included libraries.

### BXObject
  The superclass for all higher-functioning bloxley classes.  It contains code for reflection, method
  cascading, and to interact with the notification and semaphore systems.

### JSON
  An included library for generating and parsing JSON.

# bloxley.controller

## bloxley.controller.event

  This contains all of the main event logic code.

### BXAction
  An atomic game action, ie, game state change.  All game actions are subclasses of this class.

### BXActorColorAction
  A change in a color attribute of an actor.

### BXAddAction
  An addition of a new actor to the board.

### BXBehavior
  This is a superclass for an action which involves actors moving around the board.  This action is designed to cause other actions.

### BXBoardChangeAction
  A large-scale change of the patches on a board.

### BXCropAction
  A board change that specifically involves the board becoming smaller.  Used by a standard interface component.

### BXDestroyAction
  The removal of an actor from the board, especially in edit mode.

### BXDisableAction
  Makes an actor disabled--not able to be selected, but not destroyed.

### BXEvent
  An event is a group of actions, organized causally.  They are undone as a group.

### BXInsertRowAction
  A board change that specifically involves adding a row or column to the board.
  
### BXMoveAction
  The most common game action an actor moves some number of steps in a direction.

### BXPatchColorAction
  A change in a color attribute of a patch.

### BXPatchFillAction
  A board change that specifically involves setting all of the patches to a new type.

### BXPatchPenAction
  Changing a single patch to a new type.

### BXPlaceAction
  Placing an actor at some fixed place on the board.  Not for gameplay purposes (use BXMoveAction).
  
### BXSelectionAction
  Changes the currently selected actor.

### BXSlideAction
  A move action that repeats until it fails.

### BXUndoManager
  This is an undo queue--it keeps track of events, and undoes them in a LIFO order.

## bloxley.controller.game

  These classes are the main game controller-layer classes.

### BXActorController
  The superclass for actor behavior.  Each type of actor should have an individual BXActorController subclass.
  
### BXController
  The superclass for game behavior.  Each game should have a subclass of BXController.
  
### BXPatchController
  The superclass for patch behavior.  Each game should have at least one BXPatchController subclass.

## bloxley.controller.mailbox

  The mailbox is a universal implementation of the Observer Pattern.  Modeled after Cocoa's NSNotificationCenter, objects can be registered
  to be notified in three different circumstances
    (1) A specific object O sends a specific message M
    (2) A specific object O sends any message
    (3) Any object sends a specific message M
  Note that the sending object does not needs to know about the existence of the listening object.

### BXDelayedCall
  A request to call some method, on some object, later in the current frame.

### BXDelayedCallQueue
  Manages delayed calls, calling each in turn.

### BXMailbox
  The implementation of the Observer Pattern.  Any object can be set to be notified when a message that it cares about is generated.

### BXObserver
  An object is listening to a/any message from a/any source.
  
### BXObserverQueue
  A group of observers, all observing the same object/lack of object.

## bloxley.controller.pen

  The pen is how the user interacts with the game.  It handles mouse events, keyboard events (treating arrow keys specially), and drag-and-drop.
  
### BXAttributePen
  A pen to change some attribute of patches that are clicked on.
  
### BXColorPen
  A pen to change a color attribute (defaults to 'color') of patches or actors that are clicked on.
  
### BXDragObject
  An object representing something being dragged.

### BXGamePen
  A simple gameplay pen--pressing an arrow key moves the currently selected actor in that direction, and pressing space switches the
  selected actor.  Can be used as a subclass for more complex game pens.
  
### BXMouseEvent
  Represents what the user is doing with the mouse--pressing it, releasing it, or dragging it.

### BXObjectPen
  A pen for dragging objects around.
  
### BXPatchPen
  A pen for changing the type of patches.
  
### BXPen
  The superclass for pens.  Doesn't contain much logic itself, but includes hook methods for all of the events that it the framework handles.

### BXRectanglePen
  A pen for selecting a rectangular region of the board.

## bloxley.controller.phase

  Phases are the implementation of game flow.
  
### BXPhase
  A phase is an atomic unit of game flow.  Phases can be entered, exited, and either succeed or fail.

### BXGameLoop
  It performs the main game loop, and handles the transitions between phases.
  
## bloxley.controller.io

### BXInterfaceLoader
  Handles loading a game interface from a server.
  
### BXLevelLoader
  Handles loading a game level from a server.

### BXLoader
  A superclass for communication with a server.  Has methods to implement indicating success or failure.

### BXLoadRequest
  The actual communication request to a server.  It keeps track of the progress, and returns to the loader the data upon success or failure.

### BXTile
  A mapping between a character and a patch key.  Used in the XML representation of levels.
  
### BXTileLibrary
  A collection of tiles--handles mapping between patch keys and characters.

# bloxley.model

## bloxley.model.collection #

Defines smarter collection classes than the base ActionScript Array class.  Defines the common functional meta-methods (select, map, etc.)

### BXGroup
  A set, specifically of actors.
  
### BXPath
  An ordered sequence of patches.  Can be walked.

### BXRegion
  A set, specifically of patches.

### BXSet
  The superclass of collection objects.  Can be iterated over.

## bloxley.model.data

Small data objects.
  
### BXColor
  A color.

### BXDirection
  A direction on a board (North is up).

## bloxley.model.game

The major model objects for the bloxley framework.
  
### BXActor
  An object on the board that can move around, and be any size.

### BXBoard
  A grid of patches, which actors can sit upon.

### BXPatch
  A single "square" of a board.  It can change attributes, but it cannot move or change size.

# bloxley.view

## bloxley.view.animation

An animation is any visual change over time.

### BX2DBlend
  A change in 2 related attributes simultaneously, like x & y or width & height.

### BXAnimation
  An animation is something with a start and finish, that gets updated every frame to cause visual changes.
  
### BXBlend
  A blend is a change of some attribute over a period of time.

### BXChoreographer
  A choreographer walks an event tree, and determines from the causal relationships how each events' animations are to be sequenced in time.

### BXCircularBlend
  A change in a circular attribute, like angle of rotation.

### BXEmptyAnimation
  A no-op placeholer animation.

### BXFadeToAnimation
  A sample compound animation of a patch fading from one frame into another.

### BXFrameAnimation
  An animation that is a sequence of frame changes.

### BXPatchAnimation
  An instantaneous animation that involves all patches being visually updated at once.

### BXWrapperAnimation
  An animation that allows several animations to be treated as a single one.

## bloxley.view.clock

The game clock keeps track of the frame, and elapsed time during the game.

### BXClock
  The clock handles all time and frame related tracking.  It sends signals at the start of every frame.

### BXSignal
  A signal is a request to send a signal after some time has elapsed.

### BXSignalQueue
  Manages signals, and determines if & when a signal should be sent.

### BXTimer
  A timer sends a signal every frame, and every second, until some set time is reached.

## bloxley.view.gui

These are gui elements (buttons, labels, images, drag wells, etc.)

### BXButton
  A single button that can be clicked on, and sends a message when it gets hit.
  
### BXButtonArray
  A group of buttons, displayed visually as a unit.

### BXGeometry
  The geometry is the grid square size for a BXGrid.

### BXGrid
  The visual display of a BXBoard.

### BXGuiElement
  The superclass of all interface elements.

### BXImage
  A bitmap image.

### BXLabel
  A text label.  It can be given different display formats depending on what it displays plain text, money, score, or time.

### BXMovieClipImage
  A vector art image.  Will be folded into BXImage.

### BXSelectionRectangle
  A rectangle used to display the current selection on a board.

### BXToggle
  A two-setting toggle switch, similar to the iPhone display.

### BXWell
  A drag-and-drop well, usable as a drag source or drag target.

## bloxley.view.sprite

Sprites are the superclass of everything that gets displayed on the screen.

### BXCompositeSprite
  A sprite made up of layers of sprites.  Can be nested.  Moving, resizing, etc, the composite sprite will update all of the sprites within.
  
### BXSprite
  A visual object which can be displayed, moved, resized, etc.

### BXSpriteChange
  Keeps track of changes to a sprite, so that it only gets updated once per frame.
