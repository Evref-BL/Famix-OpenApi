"
I am one slot or relation of the OpenAPI metamodel (Famix-OpenAPI-Model), as described by its Fame meta-description. I know the name of the class or trait that declares me, my selector, my kind (#slot for a scalar property, #relation for a link to another entity), the name of my target class and my opposite relation when I am a relation, and whether I hold many values. I am a value object produced by FamixOpenApiMetamodelIntrospector.
"
Class {
	#name : 'FamixOpenApiModelSlot',
	#superclass : 'Object',
	#instVars : [
		'declaringClassName',
		'selector',
		'kind',
		'targetName',
		'oppositeName',
		'isMany',
		'oppositeKey'
	],
	#category : 'Famix-OpenApi-Validation',
	#package : 'Famix-OpenApi-Validation'
}

{ #category : 'accessing' }
FamixOpenApiModelSlot >> declaringClassName [

	^ declaringClassName
]

{ #category : 'accessing' }
FamixOpenApiModelSlot >> declaringClassName: aString [

	declaringClassName := aString
]

{ #category : 'testing' }
FamixOpenApiModelSlot >> hasOpposite [

	^ oppositeName isNotNil
]

{ #category : 'accessing' }
FamixOpenApiModelSlot >> isMany [

	^ isMany
]

{ #category : 'accessing' }
FamixOpenApiModelSlot >> isMany: aBoolean [

	isMany := aBoolean
]

{ #category : 'testing' }
FamixOpenApiModelSlot >> isRelation [

	^ kind = #relation
]

{ #category : 'testing' }
FamixOpenApiModelSlot >> isSlot [

	^ kind = #slot
]

{ #category : 'printing' }
FamixOpenApiModelSlot >> key [
	"Unique key of the slot in the metamodel, for example OPSchema>>items"

	^ declaringClassName , '>>' , selector
]

{ #category : 'accessing' }
FamixOpenApiModelSlot >> kind [
	"#slot for a scalar property, #relation for a link to another entity"

	^ kind
]

{ #category : 'accessing' }
FamixOpenApiModelSlot >> kind: aSymbol [

	kind := aSymbol
]

{ #category : 'accessing' }
FamixOpenApiModelSlot >> oppositeKey [
	"Key of the opposite relation, for example OPSchema>>usedAsItemsBy, nil when there is none"

	^ oppositeKey
]

{ #category : 'accessing' }
FamixOpenApiModelSlot >> oppositeKey: aStringOrNil [

	oppositeKey := aStringOrNil
]

{ #category : 'accessing' }
FamixOpenApiModelSlot >> oppositeName [
	"Selector of the opposite relation, nil when there is none"

	^ oppositeName
]

{ #category : 'accessing' }
FamixOpenApiModelSlot >> oppositeName: aSymbolOrNil [

	oppositeName := aSymbolOrNil
]

{ #category : 'printing' }
FamixOpenApiModelSlot >> printOn: aStream [

	super printOn: aStream.
	aStream
		nextPut: $(;
		nextPutAll: self key;
		nextPut: $)
]

{ #category : 'accessing' }
FamixOpenApiModelSlot >> selector [

	^ selector
]

{ #category : 'accessing' }
FamixOpenApiModelSlot >> selector: aSymbol [

	selector := aSymbol
]

{ #category : 'accessing' }
FamixOpenApiModelSlot >> targetName [
	"Name of the target class of a relation, or of the type of a slot"

	^ targetName
]

{ #category : 'accessing' }
FamixOpenApiModelSlot >> targetName: aString [

	targetName := aString
]
