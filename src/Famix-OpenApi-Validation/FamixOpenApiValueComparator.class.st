"
How the value of a field of a source node is normalised and compared with the value of the slot of the entity that the importer built for it (V8, level 2 of the import fidelity). A comparator is chosen by name in a row of FamixOpenApiValueRules (#named:); each concrete subclass lists the names it implements (class>>comparatorNames) and may behave differently per name. For a node and a rule it says whether the field is compared (#applicabilityOf:rule:context: answers #compare, #notApplicable or #wrongType: a source value whose JSON type does not fit the field, which the importer reports as a diagnostic and does not store, is not compared), the EXPECTED value (#entriesOf:rule:context: answers associations pointer suffix -> expected value: the entity is at the pointer of the node plus the suffix) and the FOUND value (#foundFrom: normalises the value of the slot). Two values are equivalent when the normalised ones are equal. #aDifferentValueFrom: answers a value of the slot that is not equivalent to the expected one, for the mutation sweeps of the tests. The context is the FamixOpenApiValueCheck: it knows the version, the references of the clone sites and the owner of a node.
"
Class {
	#name : 'FamixOpenApiValueComparator',
	#superclass : 'Object',
	#instVars : [
		'name'
	],
	#category : 'Famix-OpenApi-Validation',
	#package : 'Famix-OpenApi-Validation'
}

{ #category : 'instance creation' }
FamixOpenApiValueComparator class >> allNames [
	"The names of every comparator"

	^ self allSubclasses flatCollect: [ :each | each comparatorNames ]
]

{ #category : 'accessing' }
FamixOpenApiValueComparator class >> comparatorNames [
	"The names of the comparators a concrete class implements"

	^ #(  )
]

{ #category : 'testing json values' }
FamixOpenApiValueComparator class >> isBoolean: aJsonValue [
	"True for the JSON values true and false"

	^ #( true false ) includes: aJsonValue
]

{ #category : 'testing json values' }
FamixOpenApiValueComparator class >> isTrue: aJsonValue [
	"True only for the JSON true: nil (a key that is not there) and the values of another type are not true"

	^ aJsonValue == true
]

{ #category : 'instance creation' }
FamixOpenApiValueComparator class >> named: aSymbol [
	"The comparator that implements the name aSymbol"

	^ (self allSubclasses
		   detect: [ :each | each comparatorNames includes: aSymbol ]
		   ifNone: [
			   self error: ('No comparator named {1}' format: { aSymbol }) ])
		  new
		  name: aSymbol;
		  yourself
]

{ #category : 'comparing' }
FamixOpenApiValueComparator >> aDifferentValueFrom: anExpectedValue [
	"A value of the slot that is not equivalent to the expected one (for the mutation sweeps of the tests)"

	^ self subclassResponsibility
]

{ #category : 'comparing' }
FamixOpenApiValueComparator >> applicabilityOf: aNode rule: aRule context: aContext [
	"#compare when the field is compared, #notApplicable when it is not (a field that is compared only when the source states it, and is absent), #wrongType when the source value has a JSON type that does not fit the field"

	(aNode includesKey: aRule fieldKey) ifFalse: [
		^ self applicabilityWhenAbsent ].
	^ (self fits: (aNode valueAt: aRule fieldKey) context: aContext)
		  ifTrue: [ #compare ]
		  ifFalse: [ #wrongType ]
]

{ #category : 'comparing' }
FamixOpenApiValueComparator >> applicabilityWhenAbsent [
	"What to do when the source object does not have the key: compare the absence by default"

	^ #compare
]

{ #category : 'comparing' }
FamixOpenApiValueComparator >> entriesOf: aNode rule: aRule context: aContext [
	"Associations pointer suffix -> expected value: the entity that carries the slot is at the pointer of the node followed by the suffix (empty for the node itself)"

	^ { ('' -> (self expectedOf: aNode rule: aRule context: aContext)) }
]

{ #category : 'comparing' }
FamixOpenApiValueComparator >> expectedOf: aNode rule: aRule context: aContext [
	"The expected value, normalised: by default the value of the field"

	^ aNode valueAt: aRule fieldKey
]

{ #category : 'comparing' }
FamixOpenApiValueComparator >> fits: aJsonValue context: aContext [
	"True when the JSON value has the type the field expects"

	^ true
]

{ #category : 'comparing' }
FamixOpenApiValueComparator >> foundFrom: aSlotValue [
	"The value of the slot, normalised the same way as the expected one"

	^ aSlotValue
]

{ #category : 'comparing' }
FamixOpenApiValueComparator >> gapKind [
	"The kind of the gap when the values are not equivalent"

	^ #valueMismatch
]

{ #category : 'testing json values' }
FamixOpenApiValueComparator >> isBoolean: aJsonValue [

	^ self class isBoolean: aJsonValue
]

{ #category : 'comparing' }
FamixOpenApiValueComparator >> isEquivalent: aFoundValue to: anExpectedValue [
	"True when the value of the slot is what the source says"

	^ (self foundFrom: aFoundValue) = anExpectedValue
]

{ #category : 'testing json values' }
FamixOpenApiValueComparator >> isTrue: aJsonValue [

	^ self class isTrue: aJsonValue
]

{ #category : 'accessing' }
FamixOpenApiValueComparator >> name [
	"The name the comparator was asked by"

	^ name
]

{ #category : 'accessing' }
FamixOpenApiValueComparator >> name: aSymbol [

	name := aSymbol
]
