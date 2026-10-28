"
Generated from openapi2.ecore

## Relations
======================

### Parents
| Relation | Origin | Opposite | Type | Comment |
|---|
| `components` | `OPExample` | `directExamples` | `OPComponents` | Opposite reference components from Example to Components [0..1], when the object is a reusable one.|
| `mediaType` | `OPExample` | `directExamples` | `OPMediaType` | Opposite reference mediaType from Example to MediaType [0..1].|
| `parameter` | `OPExample` | `examples` | `OPParameter` | Opposite reference parameter from Example to Parameter [0..1].|
| `response` | `OPExample` | `examples` | `OPResponse` | |

### Other
| Relation | Origin | Opposite | Type | Comment |
|---|
| `usedByExampleEntries` | `OPExample` | `value` | `OPExampleEntry` | ExampleEntry entries whose value is this Example [0..*].|


## Properties
======================

| Name | Type | Default value | Comment |
|---|
| `canonicalPointer` | `String` | nil | JSON pointer of the entity in the canonical OpenAPI 3.1 document, for example #/components/schemas/Pet [1].|
| `extensions` | `String` | nil | Specification extensions (x-* keys) of the source node, as a JSON object text [1].|
| `externalValue` | `String` | nil | URL of a document holding the example value [1].|
| `mimeType` | `String` | nil | Attribute mimeType from Example [1]|
| `name` | `String` | nil | Basic name of the entity, not full reference.|
| `ref` | `String` | nil | Attribute ref from Reference Object [1]|
| `sourceText` | `String` | nil | Attribute sourceText from original JSON node [1]|
| `summary` | `String` | nil | Short description of the example [1].|
| `value` | `String` | nil | Attribute value from Example [1]|

"
Class {
	#name : 'OPExample',
	#superclass : 'OPEntity',
	#traits : 'FamixTNamedEntity + OPCanonicalNode + OPReferenceable + OPSourceText',
	#classTraits : 'FamixTNamedEntity classTrait + OPCanonicalNode classTrait + OPReferenceable classTrait + OPSourceText classTrait',
	#instVars : [
		'#components => FMOne type: #OPComponents opposite: #directExamples',
		'#externalValue => FMProperty',
		'#mediaType => FMOne type: #OPMediaType opposite: #directExamples',
		'#mimeType => FMProperty',
		'#parameter => FMOne type: #OPParameter opposite: #examples',
		'#response => FMOne type: #OPResponse opposite: #examples',
		'#summary => FMProperty',
		'#usedByExampleEntries => FMMany type: #OPExampleEntry opposite: #value',
		'#value => FMProperty'
	],
	#category : 'Famix-OpenAPI-Model-Entities',
	#package : 'Famix-OpenAPI-Model',
	#tag : 'Entities'
}

{ #category : 'meta' }
OPExample class >> annotation [

	<ignoreForCoverage>
	<FMClass: #Example super: #OPEntity>
	<package: #'Famix-OpenAPI-Model'>
	<generated>
]

{ #category : 'adding' }
OPExample >> addUsedByExampleEntry: anObject [

	<ignoreForCoverage>
	<generated>
	^ self usedByExampleEntries add: anObject
]

{ #category : 'accessing' }
OPExample >> components [
	"Relation named: #components type: #OPComponents opposite: #directExamples"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'Opposite reference components from Example to Components [0..1], when the object is a reusable one.'>
	<container>
	^ components
]

{ #category : 'accessing' }
OPExample >> components: anObject [

	<ignoreForCoverage>
	<generated>
	components := anObject
]

{ #category : 'accessing' }
OPExample >> externalValue [

	<FMProperty: #externalValue type: #String>
	<ignoreForCoverage>
	<generated>
	<FMComment: 'URL of a document holding the example value [1].'>
	^ externalValue
]

{ #category : 'accessing' }
OPExample >> externalValue: anObject [
	<ignoreForCoverage>
	<generated>
	externalValue := anObject
]

{ #category : 'accessing' }
OPExample >> mediaType [
	"Relation named: #mediaType type: #OPMediaType opposite: #directExamples"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'Opposite reference mediaType from Example to MediaType [0..1].'>
	<container>
	^ mediaType
]

{ #category : 'accessing' }
OPExample >> mediaType: anObject [

	<ignoreForCoverage>
	<generated>
	mediaType := anObject
]

{ #category : 'accessing' }
OPExample >> mimeType [

	<FMProperty: #mimeType type: #String>
	<ignoreForCoverage>
	<generated>
	<FMComment: 'Attribute mimeType from Example [1]'>
	^ mimeType
]

{ #category : 'accessing' }
OPExample >> mimeType: anObject [
	<ignoreForCoverage>
	<generated>
	mimeType := anObject
]

{ #category : 'accessing' }
OPExample >> parameter [
	"Relation named: #parameter type: #OPParameter opposite: #examples"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'Opposite reference parameter from Example to Parameter [0..1].'>
	<container>
	^ parameter
]

{ #category : 'accessing' }
OPExample >> parameter: anObject [

	<ignoreForCoverage>
	<generated>
	parameter := anObject
]

{ #category : 'accessing' }
OPExample >> response [
	"Relation named: #response type: #OPResponse opposite: #examples"

	<ignoreForCoverage>
	<generated>
	<container>
	^ response
]

{ #category : 'accessing' }
OPExample >> response: anObject [

	<ignoreForCoverage>
	<generated>
	response := anObject
]

{ #category : 'accessing' }
OPExample >> summary [

	<FMProperty: #summary type: #String>
	<ignoreForCoverage>
	<generated>
	<FMComment: 'Short description of the example [1].'>
	^ summary
]

{ #category : 'accessing' }
OPExample >> summary: anObject [
	<ignoreForCoverage>
	<generated>
	summary := anObject
]

{ #category : 'accessing' }
OPExample >> usedByExampleEntries [
	"Relation named: #usedByExampleEntries type: #OPExampleEntry opposite: #value"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'ExampleEntry entries whose value is this Example [0..*].'>
	^ usedByExampleEntries
]

{ #category : 'accessing' }
OPExample >> usedByExampleEntries: anObject [

	<ignoreForCoverage>
	<generated>
	usedByExampleEntries value: anObject
]

{ #category : 'accessing' }
OPExample >> value [

	<FMProperty: #value type: #String>
	<ignoreForCoverage>
	<generated>
	<FMComment: 'Attribute value from Example [1]'>
	^ value
]

{ #category : 'accessing' }
OPExample >> value: anObject [
	<ignoreForCoverage>
	<generated>
	value := anObject
]
