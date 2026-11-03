"
A context for the unit tests of the comparators that only need the version of the document (FamixOpenApiValueCheck is the real one).
"
Class {
	#name : 'FamixOpenApiValueContextStub',
	#superclass : 'Object',
	#instVars : [
		'version'
	],
	#category : 'Famix-OpenApi-Validation-Test',
	#package : 'Famix-OpenApi-Validation-Test'
}

{ #category : 'accessing' }
FamixOpenApiValueContextStub >> version [

	^ version
]

{ #category : 'accessing' }
FamixOpenApiValueContextStub >> version: aSymbol [

	version := aSymbol
]
