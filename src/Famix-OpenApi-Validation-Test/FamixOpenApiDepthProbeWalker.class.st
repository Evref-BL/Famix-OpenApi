"
I am a FamixOpenApiSourceWalker that records the largest call stack seen while visiting a node, to prove that the walk does not recurse along the depth of the document.
"
Class {
	#name : 'FamixOpenApiDepthProbeWalker',
	#superclass : 'FamixOpenApiSourceWalker',
	#instVars : [
		'maxStackSize',
		'firstStackSize'
	],
	#category : 'Famix-OpenApi-Validation-Test',
	#package : 'Famix-OpenApi-Validation-Test'
}

{ #category : 'accessing' }
FamixOpenApiDepthProbeWalker >> maxStackSize [
	"The largest stack size (number of contexts) seen at a visit; 0 before any walk"

	^ maxStackSize ifNil: [ 0 ]
]

{ #category : 'accessing' }
FamixOpenApiDepthProbeWalker >> stackGrowth [
	"How much deeper the stack got, at its deepest visit, than at the first visit"

	^ self maxStackSize - (firstStackSize ifNil: [ 0 ])
]

{ #category : 'private - visiting' }
FamixOpenApiDepthProbeWalker >> visit: aNode [

	| size |
	size := thisContext stack size.
	firstStackSize ifNil: [ firstStackSize := size ].
	maxStackSize := self maxStackSize max: size.
	^ super visit: aNode
]
