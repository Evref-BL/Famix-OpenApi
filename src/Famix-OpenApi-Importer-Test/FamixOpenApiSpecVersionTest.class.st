"
Tests of FamixOpenApiSpecVersion: detection, canonical version and reference target translation.
"
Class {
	#name : 'FamixOpenApiSpecVersionTest',
	#superclass : 'TestCase',
	#instVars : [
		'diagnostics'
	],
	#category : 'Famix-OpenApi-Importer-Test',
	#package : 'Famix-OpenApi-Importer-Test'
}

{ #category : 'tests' }
FamixOpenApiSpecVersionTest >> assert: actual equals: expected description: aString [

	self
		assert: actual = expected
		description:
			aString , ' (expected ' , expected printString , ', got '
			, actual printString , ')'
]

{ #category : 'tests' }
FamixOpenApiSpecVersionTest >> assertUnsupported: aValue [

	| result |
	result := self detect: aValue.
	self assert: result isNil description: 'nil'.
	self
		assert: (diagnostics countOf: #unsupportedVersion)
		equals: 1
		description: 'count'.
	self
		assert: diagnostics errors size
		equals: 1
		description: 'is an error'.
	self
		assert: (diagnostics withCode: #unsupportedVersion) first pointer
		equals: '#'
		description: 'pointer'
]

{ #category : 'tests' }
FamixOpenApiSpecVersionTest >> detect: aDictionary [

	^ FamixOpenApiSpecVersion
		  detectIn: aDictionary
		  diagnostics: diagnostics
]

{ #category : 'tests' }
FamixOpenApiSpecVersionTest >> openApi: aString [

	^ self detect: (Dictionary new
			   at: 'openapi' put: aString;
			   yourself)
]

{ #category : 'tests' }
FamixOpenApiSpecVersionTest >> setUp [

	super setUp.
	diagnostics := FamixOpenApiDiagnostics new
]

{ #category : 'tests' }
FamixOpenApiSpecVersionTest >> swagger2 [

	^ self detect: (Dictionary new
			   at: 'swagger' put: '2.0';
			   yourself)
]

{ #category : 'tests' }
FamixOpenApiSpecVersionTest >> test30RefsAreUnchanged [

	self
		assert:
		((self openApi: '3.0.0') refTargetPointerFor: '#/definitions/Pet')
		equals: '#/definitions/Pet'
		description: 'definitions kept'.
	self
		assert: ((self openApi: '3.0.0') refTargetPointerFor:
				 '#/components/schemas/Pet')
		equals: '#/components/schemas/Pet'
		description: 'components kept'
]

{ #category : 'tests' }
FamixOpenApiSpecVersionTest >> test31RefsAreUnchanged [

	self
		assert:
		((self openApi: '3.1.0') refTargetPointerFor: '#/definitions/Pet')
		equals: '#/definitions/Pet'
		description: 'definitions kept'.
	self
		assert: ((self openApi: '3.1.0') refTargetPointerFor:
				 '#/components/schemas/Pet/properties/a')
		equals: '#/components/schemas/Pet/properties/a'
		description: 'nested kept'
]

{ #category : 'tests' }
FamixOpenApiSpecVersionTest >> testArrayIsUnsupported [

	self assertUnsupported: #( 1 2 )
]

{ #category : 'tests' }
FamixOpenApiSpecVersionTest >> testBothKeysPreferOpenApiAndWarn [

	| result |
	result := self detect: (Dictionary new
			           at: 'swagger' put: '2.0';
			           at: 'openapi' put: '3.0.0';
			           yourself).
	self
		assert: result class
		equals: FamixOpenApi30Version
		description: 'class'.
	self
		assert: (diagnostics countOf: #ambiguousVersion)
		equals: 1
		description: 'count'.
	self
		assert: diagnostics warnings size
		equals: 1
		description: 'is a warning'
]

{ #category : 'tests' }
FamixOpenApiSpecVersionTest >> testCanonicalVersionIs310ForAll [

	self
		assert: self swagger2 canonicalVersion
		equals: '3.1.0'
		description: 'swagger'.
	self
		assert: (self openApi: '3.0.2') canonicalVersion
		equals: '3.1.0'
		description: '3.0'.
	self
		assert: (self openApi: '3.1.0') canonicalVersion
		equals: '3.1.0'
		description: '3.1'
]

{ #category : 'tests' }
FamixOpenApiSpecVersionTest >> testEmptyDictionaryIsUnsupported [

	self assertUnsupported: Dictionary new
]

{ #category : 'tests' }
FamixOpenApiSpecVersionTest >> testNilIsUnsupported [

	self assertUnsupported: nil
]

{ #category : 'tests' }
FamixOpenApiSpecVersionTest >> testNilOpenApiIsUnsupported [

	self assertUnsupported: (Dictionary new
			 at: 'openapi' put: nil;
			 yourself)
]

{ #category : 'tests' }
FamixOpenApiSpecVersionTest >> testNumericOpenApiIsUnsupported [

	self assertUnsupported: (Dictionary new
			 at: 'openapi' put: 3.1;
			 yourself)
]

{ #category : 'tests' }
FamixOpenApiSpecVersionTest >> testNumericSwaggerIsUnsupported [

	self assertUnsupported: (Dictionary new
			 at: 'swagger' put: 2.0;
			 yourself)
]

{ #category : 'tests' }
FamixOpenApiSpecVersionTest >> testOpenApi12IsUnsupported [

	self assertUnsupported: (Dictionary new
			 at: 'openapi' put: '1.2';
			 yourself)
]

{ #category : 'tests' }
FamixOpenApiSpecVersionTest >> testOpenApi2xStringIsUnsupported [

	self assertUnsupported: (Dictionary new
			 at: 'openapi' put: '2.0';
			 yourself)
]

{ #category : 'tests' }
FamixOpenApiSpecVersionTest >> testOpenApi300IsDetected [

	self
		assert: (self openApi: '3.0.0') class
		equals: FamixOpenApi30Version
		description: 'class'.
	self assert: diagnostics isEmpty description: 'no diagnostic'
]

{ #category : 'tests' }
FamixOpenApiSpecVersionTest >> testOpenApi304IsDetected [

	self
		assert: (self openApi: '3.0.4') class
		equals: FamixOpenApi30Version
		description: 'class'
]

{ #category : 'tests' }
FamixOpenApiSpecVersionTest >> testOpenApi310IsDetected [

	self
		assert: (self openApi: '3.1.0') class
		equals: FamixOpenApi31Version
		description: 'class'.
	self assert: diagnostics isEmpty description: 'no diagnostic'
]

{ #category : 'tests' }
FamixOpenApiSpecVersionTest >> testOpenApi320IsToleratedAs31WithUnknownVersionWarning [

	self
		assert: (self openApi: '3.2.0') class
		equals: FamixOpenApi31Version
		description: 'class'.
	self
		assert: (diagnostics countOf: #unknownVersion)
		equals: 1
		description: 'count'.
	self
		assert: diagnostics warnings size
		equals: 1
		description: 'is a warning'.
	self
		assert: (diagnostics withCode: #unknownVersion) first pointer
		equals: '#/openapi'
		description: 'pointer'
]

{ #category : 'tests' }
FamixOpenApiSpecVersionTest >> testPrintOnMentionsTheSourceVersion [

	self
		assert:
		((self openApi: '3.0.4') printString includesSubstring: '3.0.4')
		description: 'printString'
]

{ #category : 'tests' }
FamixOpenApiSpecVersionTest >> testSourceVersionIsTheStringAsRead [

	self
		assert: (self openApi: '3.0.4') sourceVersion
		equals: '3.0.4'
		description: 'openapi'.
	self
		assert: self swagger2 sourceVersion
		equals: '2.0'
		description: 'swagger'
]

{ #category : 'tests' }
FamixOpenApiSpecVersionTest >> testStringDocumentIsUnsupported [

	self assertUnsupported: 'openapi'
]

{ #category : 'tests' }
FamixOpenApiSpecVersionTest >> testSwagger12IsUnsupported [

	self assertUnsupported: (Dictionary new
			 at: 'swagger' put: '1.2';
			 yourself)
]

{ #category : 'tests' }
FamixOpenApiSpecVersionTest >> testSwagger20VersionOnlyIsNotUnsupported [

	self
		assert: (self detect: (Dictionary new
					  at: 'swagger' put: '2.0';
					  yourself)) notNil
		description: 'detected'.
	self deny: diagnostics hasErrors
]

{ #category : 'tests' }
FamixOpenApiSpecVersionTest >> testSwagger2DoesNotRewriteDefinitionsWithoutSlashBoundary [

	self
		assert: (self swagger2 refTargetPointerFor: '#/definitionsX/Y')
		equals: '#/definitionsX/Y'
		description: 'no boundary'
]

{ #category : 'tests' }
FamixOpenApiSpecVersionTest >> testSwagger2IsDetected [

	self
		assert: self swagger2 class
		equals: FamixOpenApiSwagger2Version
		description: 'class'.
	self assert: diagnostics isEmpty description: 'no diagnostic'
]

{ #category : 'tests' }
FamixOpenApiSpecVersionTest >> testSwagger2KeepsDeeplyNestedRemainder [

	self
		assert: (self swagger2 refTargetPointerFor:
				 '#/definitions/A/properties/b/items')
		equals: '#/components/schemas/A/properties/b/items'
		description: 'deep'
]

{ #category : 'tests' }
FamixOpenApiSpecVersionTest >> testSwagger2KeepsNestedRemainder [

	self
		assert: (self swagger2 refTargetPointerFor:
				 '#/definitions/Pet/properties/name')
		equals: '#/components/schemas/Pet/properties/name'
		description: 'nested'
]

{ #category : 'tests' }
FamixOpenApiSpecVersionTest >> testSwagger2LeavesExternalRefUnchanged [

	self
		assert:
		(self swagger2 refTargetPointerFor: 'other.json#/definitions/X')
		equals: 'other.json#/definitions/X'
		description: 'external'
]

{ #category : 'tests' }
FamixOpenApiSpecVersionTest >> testSwagger2LeavesOtherRefsUnchanged [

	self
		assert: (self swagger2 refTargetPointerFor: '#/paths/~1pets/get')
		equals: '#/paths/~1pets/get'
		description: 'paths'.
	self
		assert:
		(self swagger2 refTargetPointerFor: '#/components/schemas/X')
		equals: '#/components/schemas/X'
		description: 'components'
]

{ #category : 'tests' }
FamixOpenApiSpecVersionTest >> testSwagger2TranslatesDefinitionsRef [

	self
		assert: (self swagger2 refTargetPointerFor: '#/definitions/Pet')
		equals: '#/components/schemas/Pet'
		description: 'definitions'
]

{ #category : 'tests' }
FamixOpenApiSpecVersionTest >> testSwagger2TranslatesParametersRef [

	self
		assert: (self swagger2 refTargetPointerFor: '#/parameters/limit')
		equals: '#/components/parameters/limit'
		description: 'parameters'
]

{ #category : 'tests' }
FamixOpenApiSpecVersionTest >> testSwagger2TranslatesResponsesRef [

	self
		assert: (self swagger2 refTargetPointerFor: '#/responses/NotFound')
		equals: '#/components/responses/NotFound'
		description: 'responses'
]

{ #category : 'tests' }
FamixOpenApiSpecVersionTest >> testSwagger2TranslatesSecurityDefinitionsRef [

	self
		assert:
		(self swagger2 refTargetPointerFor: '#/securityDefinitions/key')
		equals: '#/components/securitySchemes/key'
		description: 'securityDefinitions'
]

{ #category : 'tests' }
FamixOpenApiSpecVersionTest >> testSwaggerWithMinorVersionIsDetected [

	self
		assert: (self detect: (Dictionary new
					  at: 'swagger' put: '2.0.1';
					  yourself)) class
		equals: FamixOpenApiSwagger2Version
		description: 'class'
]

{ #category : 'tests' }
FamixOpenApiSpecVersionTest >> testVersionPredicatesOf30 [

	| v |
	v := self openApi: '3.0.0'.
	self deny: v isSwagger2.
	self assert: v isOpenApi30 description: 'isOpenApi30'.
	self deny: v isOpenApi31
]

{ #category : 'tests' }
FamixOpenApiSpecVersionTest >> testVersionPredicatesOf31 [

	| v |
	v := self openApi: '3.1.0'.
	self deny: v isSwagger2.
	self deny: v isOpenApi30.
	self assert: v isOpenApi31 description: 'isOpenApi31'
]

{ #category : 'tests' }
FamixOpenApiSpecVersionTest >> testVersionPredicatesOfSwagger2 [

	| v |
	v := self swagger2.
	self assert: v isSwagger2 description: 'isSwagger2'.
	self deny: v isOpenApi30.
	self deny: v isOpenApi31
]
