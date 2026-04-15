"
Generated from openapi2.ecore

## Properties
======================

| Name | Type | Default value | Comment |
|---|
| `default` | `String` | nil | Attribute default from JSONSchemaSubset [1]|
| `description` | `String` | nil | Attribute description from JSONSchemaSubset [1]|
| `enum` | `Object` | nil | Attribute enum from JSONSchemaSubset [*]|
| `exclusiveMaximum` | `Boolean` | nil | Attribute exclusiveMaximum from JSONSchemaSubset [1]|
| `exclusiveMinimum` | `Boolean` | nil | Attribute exclusiveMinimum from JSONSchemaSubset [1]|
| `format` | `String` | nil | Attribute format from JSONSchemaSubset [1]|
| `maxItems` | `Number` | nil | Attribute maxItems from JSONSchemaSubset [1]|
| `maxLength` | `Number` | nil | Attribute maxLength from JSONSchemaSubset [1]|
| `maximum` | `Number` | nil | Attribute maximum from JSONSchemaSubset [1]|
| `minItems` | `Number` | nil | Attribute minItems from JSONSchemaSubset [1]|
| `minLength` | `Number` | nil | Attribute minLength from JSONSchemaSubset [1]|
| `minimum` | `Number` | nil | Attribute minimum from JSONSchemaSubset [1]|
| `multipleOf` | `Number` | nil | Attribute multipleOf from JSONSchemaSubset [1]|
| `pattern` | `String` | nil | Attribute pattern from JSONSchemaSubset [1]|
| `type` | `String` | nil | Attribute type from JSONSchemaSubset [1]|
| `uniqueItems` | `Boolean` | nil | Attribute uniqueItems from JSONSchemaSubset [1]|

"
Trait {
	#name : 'OPJSONSchemaSubset',
	#instVars : [
		'#type => FMProperty',
		'#format => FMProperty',
		'#description => FMProperty',
		'#maximum => FMProperty',
		'#exclusiveMaximum => FMProperty',
		'#minimum => FMProperty',
		'#exclusiveMinimum => FMProperty',
		'#maxLength => FMProperty',
		'#minLength => FMProperty',
		'#pattern => FMProperty',
		'#maxItems => FMProperty',
		'#minItems => FMProperty',
		'#uniqueItems => FMProperty',
		'#enum => FMProperty',
		'#default => FMProperty',
		'#multipleOf => FMProperty'
	],
	#category : 'Famix-OpenAPI-Model-Traits',
	#package : 'Famix-OpenAPI-Model',
	#tag : 'Traits'
}

{ #category : 'meta' }
OPJSONSchemaSubset classSide >> annotation [

	<FMClass: #JSONSchemaSubset super: #Object>
	<package: #'Famix-OpenAPI-Model'>
	<generated>
	^ self
]

{ #category : 'accessing' }
OPJSONSchemaSubset >> default [

	<FMProperty: #default type: #String>
	<generated>
	<FMComment: 'Attribute default from JSONSchemaSubset [1]'>
	^ default
]

{ #category : 'accessing' }
OPJSONSchemaSubset >> default: anObject [
	<generated>
	default := anObject
]

{ #category : 'accessing' }
OPJSONSchemaSubset >> description [

	<FMProperty: #description type: #String>
	<generated>
	<FMComment: 'Attribute description from JSONSchemaSubset [1]'>
	^ description
]

{ #category : 'accessing' }
OPJSONSchemaSubset >> description: anObject [
	<generated>
	description := anObject
]

{ #category : 'accessing' }
OPJSONSchemaSubset >> enum [

	<FMProperty: #enum type: #Object>
	<generated>
	<FMComment: 'Attribute enum from JSONSchemaSubset [*]'>
	^ enum
]

{ #category : 'accessing' }
OPJSONSchemaSubset >> enum: anObject [
	<generated>
	enum := anObject
]

{ #category : 'accessing' }
OPJSONSchemaSubset >> exclusiveMaximum [

	<FMProperty: #exclusiveMaximum type: #Boolean>
	<generated>
	<FMComment: 'Attribute exclusiveMaximum from JSONSchemaSubset [1]'>
	^ exclusiveMaximum
]

{ #category : 'accessing' }
OPJSONSchemaSubset >> exclusiveMaximum: anObject [
	<generated>
	exclusiveMaximum := anObject
]

{ #category : 'accessing' }
OPJSONSchemaSubset >> exclusiveMinimum [

	<FMProperty: #exclusiveMinimum type: #Boolean>
	<generated>
	<FMComment: 'Attribute exclusiveMinimum from JSONSchemaSubset [1]'>
	^ exclusiveMinimum
]

{ #category : 'accessing' }
OPJSONSchemaSubset >> exclusiveMinimum: anObject [
	<generated>
	exclusiveMinimum := anObject
]

{ #category : 'accessing' }
OPJSONSchemaSubset >> format [

	<FMProperty: #format type: #String>
	<generated>
	<FMComment: 'Attribute format from JSONSchemaSubset [1]'>
	^ format
]

{ #category : 'accessing' }
OPJSONSchemaSubset >> format: anObject [
	<generated>
	format := anObject
]

{ #category : 'accessing' }
OPJSONSchemaSubset >> maxItems [

	<FMProperty: #maxItems type: #Number>
	<generated>
	<FMComment: 'Attribute maxItems from JSONSchemaSubset [1]'>
	^ maxItems
]

{ #category : 'accessing' }
OPJSONSchemaSubset >> maxItems: anObject [
	<generated>
	maxItems := anObject
]

{ #category : 'accessing' }
OPJSONSchemaSubset >> maxLength [

	<FMProperty: #maxLength type: #Number>
	<generated>
	<FMComment: 'Attribute maxLength from JSONSchemaSubset [1]'>
	^ maxLength
]

{ #category : 'accessing' }
OPJSONSchemaSubset >> maxLength: anObject [
	<generated>
	maxLength := anObject
]

{ #category : 'accessing' }
OPJSONSchemaSubset >> maximum [

	<FMProperty: #maximum type: #Number>
	<generated>
	<FMComment: 'Attribute maximum from JSONSchemaSubset [1]'>
	^ maximum
]

{ #category : 'accessing' }
OPJSONSchemaSubset >> maximum: anObject [
	<generated>
	maximum := anObject
]

{ #category : 'accessing' }
OPJSONSchemaSubset >> minItems [

	<FMProperty: #minItems type: #Number>
	<generated>
	<FMComment: 'Attribute minItems from JSONSchemaSubset [1]'>
	^ minItems
]

{ #category : 'accessing' }
OPJSONSchemaSubset >> minItems: anObject [
	<generated>
	minItems := anObject
]

{ #category : 'accessing' }
OPJSONSchemaSubset >> minLength [

	<FMProperty: #minLength type: #Number>
	<generated>
	<FMComment: 'Attribute minLength from JSONSchemaSubset [1]'>
	^ minLength
]

{ #category : 'accessing' }
OPJSONSchemaSubset >> minLength: anObject [
	<generated>
	minLength := anObject
]

{ #category : 'accessing' }
OPJSONSchemaSubset >> minimum [

	<FMProperty: #minimum type: #Number>
	<generated>
	<FMComment: 'Attribute minimum from JSONSchemaSubset [1]'>
	^ minimum
]

{ #category : 'accessing' }
OPJSONSchemaSubset >> minimum: anObject [
	<generated>
	minimum := anObject
]

{ #category : 'accessing' }
OPJSONSchemaSubset >> multipleOf [

	<FMProperty: #multipleOf type: #Number>
	<generated>
	<FMComment: 'Attribute multipleOf from JSONSchemaSubset [1]'>
	^ multipleOf
]

{ #category : 'accessing' }
OPJSONSchemaSubset >> multipleOf: anObject [
	<generated>
	multipleOf := anObject
]

{ #category : 'accessing' }
OPJSONSchemaSubset >> pattern [

	<FMProperty: #pattern type: #String>
	<generated>
	<FMComment: 'Attribute pattern from JSONSchemaSubset [1]'>
	^ pattern
]

{ #category : 'accessing' }
OPJSONSchemaSubset >> pattern: anObject [
	<generated>
	pattern := anObject
]

{ #category : 'accessing' }
OPJSONSchemaSubset >> type [

	<FMProperty: #type type: #String>
	<generated>
	<FMComment: 'Attribute type from JSONSchemaSubset [1]'>
	^ type
]

{ #category : 'accessing' }
OPJSONSchemaSubset >> type: anObject [
	<generated>
	type := anObject
]

{ #category : 'accessing' }
OPJSONSchemaSubset >> uniqueItems [

	<FMProperty: #uniqueItems type: #Boolean>
	<generated>
	<FMComment: 'Attribute uniqueItems from JSONSchemaSubset [1]'>
	^ uniqueItems
]

{ #category : 'accessing' }
OPJSONSchemaSubset >> uniqueItems: anObject [
	<generated>
	uniqueItems := anObject
]
