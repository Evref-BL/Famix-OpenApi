"
V10, the negative tests: a relation of the MODEL changed (a related entity removed, a stray one added, an ordered relation reordered, a target replaced by another entity, two entities of the wrong families related) is a #relationMismatch with the right field, the right node and the expected and found targets; and the SOURCE side changed with the original model kept (two allOf entries swapped, a $ref that designates another target, a child added or removed) is a gap too.
"
Class {
	#name : 'FamixOpenApiRelationMutationTest',
	#superclass : 'FamixOpenApiRelationTestCase',
	#category : 'Famix-OpenApi-Validation-Test',
	#package : 'Famix-OpenApi-Validation-Test'
}

{ #category : 'tests - source' }
FamixOpenApiRelationMutationTest >> assertSource: aModelJson changedFrom: anOldText to: aNewText gives: anArray [
	"The model of the original document against the document with the text replaced: exactly the gaps of the array, each 'kind pointer field'"

	self
		assert: (self
				 relationGapsOfModelOf: aModelJson
				 against: (self replace: anOldText with: aNewText in: aModelJson))
		equals: anArray
]

{ #category : 'tests - source' }
FamixOpenApiRelationMutationTest >> testAChildAddedToTheSourceIsAGap [

	self
		assertSource: self documentStructure30
		changedFrom: '"404":{"description":"nf"'
		to: '"500":{"description":"e"},"404":{"description":"nf"'
		gives: #( 'relationMismatch #/paths/~1p/get responses'
			   'relationMismatch #/paths/~1q/get responses' )
]

{ #category : 'tests - source' }
FamixOpenApiRelationMutationTest >> testAChildTakenOutOfTheSourceIsAGap [

	self
		assertSource: self documentRefs30
		changedFrom: '{"name":"pa","in":"query"},'
		to: ''
		gives: #( 'relationMismatch #/paths/~1p parameters' )
]

{ #category : 'tests - model' }
FamixOpenApiRelationMutationTest >> testADocumentOfAnUnknownVersionIsAPreconditionFinding [

	| report |
	report := FamixOpenApiRelationCheck
		          checkInventory: (self inventoryOf: '{"info":{}}')
		          model: OPModel new
		          diagnostics: nil.
	self assert: (report gapsOfKind: #preconditionVersion) size equals: 1
]

{ #category : 'tests - model' }
FamixOpenApiRelationMutationTest >> testALinkThatHoldsTheSecondOfTwoOperationsWithTheSameIdIsAGap [
	"The operationId designates the FIRST operation of the document (/z, not /a, which comes first in the alphabet)"

	| gap |
	gap := self
		       firstGapOf: self documentDuplicateOperationIds30
		       after: [ :model |
			       (self
				        entity: OPLink
				        at: '#/paths/~1m/get/responses/200/links/l'
				        in: model) operation:
				       (self entity: OPOperation at: '#/paths/~1a/get' in: model) ].
	self assert: gap fieldKey equals: 'operationId'.
	self
		assert: gap sourcePointer
		equals: '#/paths/~1m/get/responses/200/links/l'.
	self assert:
		(gap message includesSubstring: 'missing #(''#/paths/~1z/get'')').
	self assert:
		(gap message includesSubstring: 'extra #(''#/paths/~1a/get'')')
]

{ #category : 'tests - source' }
FamixOpenApiRelationMutationTest >> testALinkThatNamesAnotherOperationIsAGap [

	self
		assertSource: self documentSecurity31
		changedFrom: '"l1":{"operationId":"g"}'
		to: '"l1":{"operationId":"q"}'
		gives:
		#( 'relationMismatch #/paths/~1p/get/responses/200/links/l1 operationId' )
]

{ #category : 'tests - source' }
FamixOpenApiRelationMutationTest >> testAMappingValueThatDesignatesAnotherSchemaIsAGap [

	self
		assertSource: self documentSecurity31
		changedFrom: '"b":"#/components/schemas/T"'
		to: '"b":"#/components/schemas/Ar"'
		gives:
		#( 'relationMismatch #/components/schemas/Disc/discriminator/mapping/b mapping' )
]

{ #category : 'tests - model' }
FamixOpenApiRelationMutationTest >> testAMergedModelIsAPreconditionFindingNotARelationGap [

	| model report |
	model := FamixOpenApiImporter new
		         mergesInlineSchemas: true;
		         importFromString: self documentStructure30.
	report := FamixOpenApiRelationCheck
		          checkInventory:
		          (self inventoryOf: self documentStructure30)
		          model: model
		          diagnostics: nil.
	self assert: (report gapsOfKind: #preconditionMerged) size equals: 1.
	self assert: report relationGaps isEmpty
]

{ #category : 'tests - source' }
FamixOpenApiRelationMutationTest >> testARefThatDesignatesAnotherTargetIsAGapAtTheNodeAndAtItsClone [

	self
		assertSource: self documentStructure30
		changedFrom:
		'"content":{"application/json":{"schema":{"$ref":"#/components/schemas/S"}}}'
		to:
		'"content":{"application/json":{"schema":{"$ref":"#/components/schemas/T"}}}'
		gives:
			#( 'relationMismatch #/paths/~1p/get/responses/404/content/application~1json schema'
			   'relationMismatch #/paths/~1q/get/responses/404/content/application~1json schema' )
]

{ #category : 'tests - model' }
FamixOpenApiRelationMutationTest >> testARelatedEntityTakenOutIsMissing [

	| gap |
	gap := self firstGapOf: self documentStructure30 after: [ :model |
		       (self entity: OPOperation at: '#/paths/~1p/get' in: model)
			       parameters remove:
			       (self
				        entity: OPParameter
				        at: '#/components/parameters/P'
				        in: model) ].
	self assert: gap kind equals: #relationMismatch.
	self assert: gap sourcePointer equals: '#/paths/~1p/get'.
	self assert: gap fieldKey equals: 'parameters'.
	self assert: gap specObject equals: 'Operation'.
	self assert: (gap expected includes: '#/components/parameters/P').
	self deny: (gap found includes: '#/components/parameters/P').
	self assert:
		('*missing #(''#/components/parameters/P'')*' match: gap message)
]

{ #category : 'tests - source' }
FamixOpenApiRelationMutationTest >> testASchemeAddedToARequirementIsAGap [

	self
		assertSource: self documentStructure30
		changedFrom: '"security":[{"k":["a","b"]},{}]'
		to: '"security":[{"k":["a","b"],"k2":[]},{}]'
		gives: #( 'relationMismatch #/paths/~1p/get/security/0 {name}'
			   'relationMismatch #/paths/~1q/get/security/0 {name}' )
]

{ #category : 'tests - source' }
FamixOpenApiRelationMutationTest >> testASchemeTakenOutOfSwagger2IsAGapOfTheServers [

	self
		assertSource: self documentStructureSwagger2
		changedFrom: '"schemes":["https","http"]'
		to: '"schemes":["https"]'
		gives: #( 'relationMismatch # host' )
]

{ #category : 'tests - source' }
FamixOpenApiRelationMutationTest >> testAServerAddedToTheSourceIsAGapOfTheRoot [

	self
		assertSource: self documentStructure30
		changedFrom: '"servers":[{"url":"http://s"}],'
		to: '"servers":[{"url":"http://s"},{"url":"http://s2"}],'
		gives: #( 'relationMismatch # servers' )
]

{ #category : 'tests - model' }
FamixOpenApiRelationMutationTest >> testASharedEntityHasNoOwnerAtItsUseSiteSoNothingIsComparedThere [
	"A shared parameter has no entity at its use site: nothing to compare there, and nothing to report"

	| report key |
	report := self relationReportFor: self documentStructure30.
	key := 'v30 Parameter.schema -> OPParameter>>schema'.
	self assert: (report coverage withoutEntityCountOf: key) > 0.
	self assert: report gaps isEmpty
]

{ #category : 'tests - model' }
FamixOpenApiRelationMutationTest >> testASingleRelationEmptiedIsMissing [

	| gap |
	gap := self firstGapOf: self documentStructure30 after: [ :model |
		       (self entity: OPOperation at: '#/paths/~1p/get' in: model)
			       requestBody: nil ].
	self assert: gap fieldKey equals: 'requestBody'.
	self assert: gap expected equals: #( '#/components/requestBodies/B' ).
	self assert: gap found equals: #(  )
]

{ #category : 'tests - model' }
FamixOpenApiRelationMutationTest >> testAStrayEntityInARelationIsExtra [

	| gap |
	gap := self firstGapOf: self documentStructure30 after: [ :model |
		       (self entity: OPOperation at: '#/paths/~1p/get' in: model)
			       parameters add: (OPParameter new
				        canonicalPointer: '#/stray';
				        yourself) ].
	self assert: gap kind equals: #relationMismatch.
	self assert: gap fieldKey equals: 'parameters'.
	self assert: (gap found includes: '#/stray').
	self deny: (gap expected includes: '#/stray').
	self assert: ('*extra #(''#/stray'')*' match: gap message)
]

{ #category : 'tests - model' }
FamixOpenApiRelationMutationTest >> testAStrayEntityInAnEmptyRelationIsExtra [

	| gap |
	gap := self firstGapOf: self documentStructure30 after: [ :model |
		       (self entity: OPOperation at: '#/paths/~1p/get' in: model)
			       servers add: (OPServer new
				        canonicalPointer: '#/stray';
				        yourself) ].
	self assert: gap fieldKey equals: 'servers'.
	self assert: gap expected equals: #(  ).
	self assert: gap found equals: #( '#/stray' )
]

{ #category : 'tests - model' }
FamixOpenApiRelationMutationTest >> testATargetReplacedByAnotherEntityIsMissingAndExtra [
	"The schema of a media type replaced by another schema"

	| gap |
	gap := self firstGapOf: self documentStructure30 after: [ :model |
		       (self
			        entity: OPMediaType
			        at:
			        '#/paths/~1p/get/responses/404/content/application~1json'
			        in: model) schema:
			       (self
				        entity: OPSchema
				        at: '#/components/schemas/T'
				        in: model) ].
	self assert: gap fieldKey equals: 'schema'.
	self assert: gap expected equals: #( '#/components/schemas/S' ).
	self assert: gap found equals: #( '#/components/schemas/T' ).
	self assert: ('*missing*extra*' match: gap message)
]

{ #category : 'tests - model' }
FamixOpenApiRelationMutationTest >> testAnEntityOfAnotherFamilyInARelationIsExtraWithItsClass [
	"Two entities of the wrong families related: a request body among the parameters of an operation (the metamodel lets it: both have usedByOperations)"

	| gap |
	gap := self firstGapOf: self documentStructure30 after: [ :model |
		       (self entity: OPOperation at: '#/paths/~1p/get' in: model)
			       parameters add: (OPRequestBody new
				        canonicalPointer: '#/components/requestBodies/B';
				        yourself) ].
	self assert: gap fieldKey equals: 'parameters'.
	self assert:
		(gap found includes: '#/components/requestBodies/B (OPRequestBody)').
	self assert:
		('*extra #(''#/components/requestBodies/B (OPRequestBody)'')*'
			 match: gap message)
]

{ #category : 'tests - model' }
FamixOpenApiRelationMutationTest >> testAnOrderedRelationInAnotherOrderIsAnOrderDifference [
	"allOf: T then U in the source, U then T in the model"

	| gap |
	gap := self firstGapOf: self documentStructure31 after: [ :model |
		       | allOf t |
		       allOf := (self
			                 entity: OPSchema
			                 at: '#/components/schemas/S'
			                 in: model) allOf.
		       t := self
			            entity: OPSchema
			            at: '#/components/schemas/T'
			            in: model.
		       allOf remove: t.
		       allOf add: t ].
	self assert: gap kind equals: #relationMismatch.
	self assert: gap fieldKey equals: 'allOf'.
	self
		assert: gap expected
		equals: #( '#/components/schemas/T' '#/components/schemas/U' ).
	self
		assert: gap found
		equals: #( '#/components/schemas/U' '#/components/schemas/T' ).
	self assert: ('*order differs*' match: gap message)
]

{ #category : 'tests - model' }
FamixOpenApiRelationMutationTest >> testAnUnresolvedReferenceTakenOutOfTheModelIsMissingInTheSet [

	| gap |
	gap := self firstGapOf: self documentUnresolved30 after: [ :model |
		       | root |
		       root := self entity: OPOpenApi at: '#' in: model.
		       root unresolvedReferences remove:
			       root unresolvedReferences first ].
	self assert: gap fieldKey equals: '$ref'.
	self assert: gap specObject equals: 'OpenAPI'.
	self assert: gap sourcePointer equals: '#'
]

{ #category : 'tests - source' }
FamixOpenApiRelationMutationTest >> testTheConsumesOfAFormOperationDecideItsMediaTypesInTheSource [
	"The model of the original document against a source whose consumes changed: the form media types are those of the consumes of the operation, else of the root; a consumes of the root without form media type changes nothing (the default of the form applies)"

	| json |
	json := self documentFormsSwagger2.
	self
		assertSource: json
		changedFrom:
		'"operationId":"b","consumes":["application/x-www-form-urlencoded"]'
		to: '"operationId":"b"'
		gives: #( 'relationMismatch #/paths/~1p/put/requestBody content' ).
	self
		assertSource: json
		changedFrom: '"operationId":"a"'
		to:
		'"operationId":"a","consumes":["application/x-www-form-urlencoded"]'
		gives: #( 'relationMismatch #/paths/~1p/post/requestBody content' ).
	self
		assertSource: json
		changedFrom: '"consumes":["a/b","multipart/form-data"]'
		to: '"consumes":["a/b"]'
		gives: #( 'relationMismatch #/paths/~1p/patch/requestBody content' ).
	self
		assertSource: json
		changedFrom: '"consumes":["application/json"],"paths"'
		to: '"consumes":["multipart/form-data"],"paths"'
		gives: #( 'relationMismatch #/paths/~1p/get/requestBody content' ).
	self
		assertSource: json
		changedFrom: '"consumes":["application/json"],"paths"'
		to: '"paths"'
		gives: #(  )
]

{ #category : 'tests - model' }
FamixOpenApiRelationMutationTest >> testTheOrderOfASetIsNotAGap [
	"The unresolved references are compared as a set"

	self
		assert:
			(self relationGapsOf: self documentUnresolved30 after: [ :model |
				 | root all |
				 root := self entity: OPOpenApi at: '#' in: model.
				 all := root unresolvedReferences asArray.
				 all do: [ :each | root unresolvedReferences remove: each ].
				 all reverse do: [ :each | root unresolvedReferences add: each ] ])
		equals: #(  )
]

{ #category : 'tests - source' }
FamixOpenApiRelationMutationTest >> testTheProducesOfSwagger2InAnotherOrderAreAGapOfEveryResponseThatHasASchema [

	self
		assertSource: self documentStructureSwagger2
		changedFrom: '"produces":["application/json","text/plain"]'
		to: '"produces":["text/plain","application/json"]'
		gives: #( 'relationMismatch #/paths/~1p/post/responses/200 content'
			   'relationMismatch #/paths/~1p/post/responses/201 content'
			   'relationMismatch #/responses/R content' )
]

{ #category : 'tests - model' }
FamixOpenApiRelationMutationTest >> testTheResponsesInAnotherOrderAreAnOrderDifference [

	| gap |
	gap := self firstGapOf: self documentStructure30 after: [ :model |
		       | responses first |
		       responses := (self
			                     entity: OPOperation
			                     at: '#/paths/~1p/get'
			                     in: model) responses.
		       first := responses first.
		       responses remove: first.
		       responses add: first ].
	self assert: gap fieldKey equals: 'responses'.
	self assert: ('*order differs*' match: gap message)
]

{ #category : 'tests - source' }
FamixOpenApiRelationMutationTest >> testTwoAllOfEntriesSwappedInTheSourceAreAnOrderGap [

	self
		assertSource: self documentStructure31
		changedFrom:
		'"allOf":[{"$ref":"#/components/schemas/T"},{"$ref":"#/components/schemas/T"},{"$ref":"#/components/schemas/U"}]'
		to:
		'"allOf":[{"$ref":"#/components/schemas/U"},{"$ref":"#/components/schemas/T"}]'
		gives: #( 'relationMismatch #/components/schemas/S allOf' )
]

{ #category : 'tests - source' }
FamixOpenApiRelationMutationTest >> testTwoPropertiesSwappedInTheSourceAreAnOrderGap [

	self
		assertSource: self documentStructure31
		changedFrom:
		'"properties":{"b":{"type":"string"},"a":{"$ref":"#/components/schemas/T"}}'
		to:
		'"properties":{"a":{"$ref":"#/components/schemas/T"},"b":{"type":"string"}}'
		gives: #( 'relationMismatch #/components/schemas/S properties' )
]
