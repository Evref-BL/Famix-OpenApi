"
A diagnostic that is not the one of the importer: the existence check only asks any diagnostic for #code, #pointer and #severity, and the tests prove it with this one.
"
Class {
	#name : 'FamixOpenApiStubDiagnostic',
	#superclass : 'Object',
	#instVars : [
		'code',
		'pointer',
		'severity'
	],
	#category : 'Famix-OpenApi-Validation-Test',
	#package : 'Famix-OpenApi-Validation-Test'
}

{ #category : 'instance creation' }
FamixOpenApiStubDiagnostic class >> code: aSymbol pointer: aPointer [

	^ self new
		  code: aSymbol;
		  pointer: aPointer;
		  severity: #warning;
		  yourself
]

{ #category : 'accessing' }
FamixOpenApiStubDiagnostic >> code [

	^ code
]

{ #category : 'accessing' }
FamixOpenApiStubDiagnostic >> code: aSymbol [

	code := aSymbol
]

{ #category : 'accessing' }
FamixOpenApiStubDiagnostic >> pointer [

	^ pointer
]

{ #category : 'accessing' }
FamixOpenApiStubDiagnostic >> pointer: aPointer [

	pointer := aPointer
]

{ #category : 'accessing' }
FamixOpenApiStubDiagnostic >> severity [

	^ severity
]

{ #category : 'accessing' }
FamixOpenApiStubDiagnostic >> severity: aSymbol [

	severity := aSymbol
]
