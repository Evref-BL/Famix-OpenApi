"
I am one explicit decision of FamixOpenApiFieldMapping about one spec field. I know the field name, my mode (#map: the field is carried by the slot or relation named by my selector; #implicit: the field is carried by the structure, my selector names the slot or relation that carries it; #notApplicable: the field has no meaning for the model), my selector, the name of the OP class that carries the field (nil when it is the class of the spec object) and a note.
"
Class {
	#name : 'FamixOpenApiMappingEntry',
	#superclass : 'Object',
	#instVars : [
		'fieldName',
		'mode',
		'selector',
		'note',
		'targetClassName'
	],
	#category : 'Famix-OpenApi-Validation',
	#package : 'Famix-OpenApi-Validation'
}

{ #category : 'instance creation' }
FamixOpenApiMappingEntry class >> extensions [
	"The entry of the specification extensions x-*, shared by every spec object."

	^ self fromRow:
		  #( 'x-*' implicit extensions '' 'specification extensions' )
]

{ #category : 'instance creation' }
FamixOpenApiMappingEntry class >> fromRow: aRow [
	"aRow is #(field mode selector targetClassName note); targetClassName is empty when the entry applies to the class of the spec object."

	| explicitClass |
	explicitClass := (aRow at: 4) asString.
	^ self new
		  fieldName: (aRow at: 1);
		  mode: (aRow at: 2);
		  selector: (aRow at: 3);
		  targetClassName: (explicitClass isEmpty ifFalse: [ explicitClass ]);
		  note: (aRow at: 5);
		  yourself
]

{ #category : 'accessing' }
FamixOpenApiMappingEntry >> fieldName [

	^ fieldName
]

{ #category : 'accessing' }
FamixOpenApiMappingEntry >> fieldName: aString [

	fieldName := aString
]

{ #category : 'testing' }
FamixOpenApiMappingEntry >> hasExplicitClass [

	^ targetClassName isNotNil
]

{ #category : 'testing' }
FamixOpenApiMappingEntry >> isImplicit [

	^ mode = #implicit
]

{ #category : 'testing' }
FamixOpenApiMappingEntry >> isNotApplicable [

	^ mode = #notApplicable
]

{ #category : 'testing' }
FamixOpenApiMappingEntry >> isNote [
	"True when the entry only annotates the row: it never decides the status, which the introspector computes."

	^ mode = #note
]

{ #category : 'accessing' }
FamixOpenApiMappingEntry >> mode [

	^ mode
]

{ #category : 'accessing' }
FamixOpenApiMappingEntry >> mode: aSymbol [

	mode := aSymbol
]

{ #category : 'accessing' }
FamixOpenApiMappingEntry >> note [

	^ note
]

{ #category : 'accessing' }
FamixOpenApiMappingEntry >> note: aString [

	note := aString
]

{ #category : 'accessing' }
FamixOpenApiMappingEntry >> selector [
	"Selector of the slot or relation that carries the field, nil when the mode is #notApplicable"

	^ selector
]

{ #category : 'accessing' }
FamixOpenApiMappingEntry >> selector: aSymbol [

	selector := aSymbol
]

{ #category : 'accessing' }
FamixOpenApiMappingEntry >> targetClassName [
	"Name of the OP class that carries the field, nil when it is the class of the spec object"

	^ targetClassName
]

{ #category : 'accessing' }
FamixOpenApiMappingEntry >> targetClassName: aStringOrNil [

	targetClassName := aStringOrNil
]
