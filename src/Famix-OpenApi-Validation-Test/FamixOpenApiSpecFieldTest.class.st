"
I test FamixOpenApiSpecField: creation from a literal row, validity predicates and version applicability.
"
Class {
	#name : 'FamixOpenApiSpecFieldTest',
	#superclass : 'TestCase',
	#category : 'Famix-OpenApi-Validation-Test',
	#package : 'Famix-OpenApi-Validation-Test'
}

{ #category : 'tests' }
FamixOpenApiSpecFieldTest >> testAppliesIn [

	| field |
	field := FamixOpenApiSpecField
		         fromRow:
		         #( 'trace' object #( v30 v31 ) structural false '' )
		         specObject: 'PathItem'.
	self assert: (field appliesIn: #v30).
	self deny: (field appliesIn: #v2)
]

{ #category : 'tests' }
FamixOpenApiSpecFieldTest >> testDefaults [

	self deny: FamixOpenApiSpecField new isRequired.
	self assert: FamixOpenApiSpecField new note equals: ''
]

{ #category : 'tests' }
FamixOpenApiSpecFieldTest >> testEmptyVersionsAreInvalid [

	self deny: (FamixOpenApiSpecField new
			 versions: #(  );
			 yourself) hasValidVersions
]

{ #category : 'tests' }
FamixOpenApiSpecFieldTest >> testFromRow [

	| field |
	field := FamixOpenApiSpecField
		         fromRow:
		         #( 'exclusiveMinimum' scalar #( v30 v2 ) structural
		            false 'a note' )
		         specObject: 'Schema'.
	self assert: field specObject equals: 'Schema'.
	self assert: field name equals: 'exclusiveMinimum'.
	self assert: field kind equals: #scalar.
	self assert: field versions equals: #( v30 v2 ).
	self assert: field level equals: #structural.
	self deny: field isRequired.
	self assert: field note equals: 'a note'
]

{ #category : 'tests' }
FamixOpenApiSpecFieldTest >> testPrintOn [

	| field |
	field := FamixOpenApiSpecField
		         fromRow: #( 'a' scalar #( v2 ) useful true '' )
		         specObject: 'X'.
	self assert: (field printString beginsWith: 'X.a')
]

{ #category : 'tests' }
FamixOpenApiSpecFieldTest >> testValidityPredicates [

	| field |
	field := FamixOpenApiSpecField
		         fromRow: #( 'a' scalar #( v2 ) useful true '' )
		         specObject: 'X'.
	self assert: field hasValidKind.
	self assert: field hasValidLevel.
	self assert: field hasValidVersions.
	field
		kind: #bogus;
		level: #bogus;
		versions: #( v99 ).
	self deny: field hasValidKind.
	self deny: field hasValidLevel.
	self deny: field hasValidVersions
]
