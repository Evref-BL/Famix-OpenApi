"
Mutation tests of the extensions check (V9): every kind must FIRE when the model, the diagnostics or the source are changed. On the small documents of the three versions, for EVERY key kept in the extensions: the key removed from the extensions text of its entity is #lost (even with its unmodelledKeyword diagnostic: it excuses nothing), its value altered in the extensions is a #valueMismatch, its value altered in the source too; for EVERY key ignored by a diagnostic, the diagnostics removed (or moved to another pointer) make it #lost or #silentDrop; a slot that holds a value of the wrong type is #valueKeptAnyway.
"
Class {
	#name : 'FamixOpenApiExtensionsMutationTest',
	#superclass : 'FamixOpenApiExtensionsTestCase',
	#category : 'Famix-OpenApi-Validation-Test',
	#package : 'Famix-OpenApi-Validation-Test'
}

{ #category : 'helpers' }
FamixOpenApiExtensionsMutationTest >> keptGapsOf: aJsonString [
	"The gaps #onlyInExtensions of the real import of the document, with the model, the diagnostics and the inventory that were checked: an Array of the gaps, the model, the diagnostics and the inventory"

	| imported inventory report |
	imported := self importedOf: aJsonString.
	inventory := self inventoryOf: aJsonString.
	report := FamixOpenApiExtensionsCheck
		          checkInventory: inventory
		          model: imported first
		          diagnostics: imported last.
	^ {
		  (report gapsOfKind: #onlyInExtensions).
		  imported first.
		  imported last.
		  inventory }
]

{ #category : 'helpers' }
FamixOpenApiExtensionsMutationTest >> kindAfterMutating: aGap in: aKeptResult by: aBlock [
	"The kind of the gap of the key of aGap, when the extensions of its entity are the JSON object that the block answers for the original one: the check is run again, the extensions are restored"

	| entity original report |
	entity := aGap entity.
	original := entity extensions.
	entity extensions: (NeoJSONWriter toString:
			 (aBlock value: (NeoJSONReader fromString: original))).
	report := FamixOpenApiExtensionsCheck
		          checkInventory: aKeptResult last
		          model: aKeptResult second
		          diagnostics: aKeptResult third.
	entity extensions: original.
	^ (self kindsAt: aGap sourcePointer key: aGap fieldKey in: report)
		  asArray
]

{ #category : 'helpers' }
FamixOpenApiExtensionsMutationTest >> richDocuments [
	"Associations name -> JSON text: the documents whose keys are kept in the extensions"

	^ {
		  ('30' -> self documentExtensions30).
		  ('31' -> self documentExtensions31).
		  ('swagger2' -> self documentExtensionsSwagger2) }
]

{ #category : 'tests' }
FamixOpenApiExtensionsMutationTest >> testADiagnosticAtAnotherPointerExcusesNothing [
	"A refSiblingsIgnored at the pointer of another node, a wrongNodeType at the pointer of another key, an unresolvedReference at the node (it is about the target): the keys stay lost"

	| json imported report |
	json := self documentSiblings30.
	imported := self importedOf: json.
	report := self
		          extensionsReportOf: json
		          model: imported first
		          diagnostics: {
				          (FamixOpenApiStubDiagnostic
					           code: #refSiblingsIgnored
					           pointer: '#/paths/~1p/get').
				          (FamixOpenApiStubDiagnostic
					           code: #unresolvedReference
					           pointer: '#/paths/~1r').
				          (FamixOpenApiStubDiagnostic
					           code: #wrongNodeType
					           pointer: '#/paths/~1r/other') }.
	self
		assertKind: #lost
		at: '#/paths/~1r'
		key: 'summary'
		in: report.
	self
		assertKind: #lost
		at: '#/paths/~1q'
		key: 'summary'
		in: report.
	self
		assertKind: #lost
		at: '#/components/schemas/S'
		key: 'title'
		in: report.
	self assert: (report gapsOfKind: #ignoredByDiagnostic) isEmpty
]

{ #category : 'tests' }
FamixOpenApiExtensionsMutationTest >> testAKeptParameterNextToADroppedOneStaysLostWhenItsKeyIsMissing [
	"Constructed case: the operation drops its formData parameter (conflictingBodyAndFormData at the operation), but the kept query and header parameters are not excused: the key removed from their extensions is lost (it was #ignoredByDiagnostic before the fix: the diagnostic of the operation excused every child)"

	| result |
	result := self keptGapsOf: self documentParametersSwagger2.
	#( 'x-q' 'x-h' 'x-b1' ) do: [ :key |
		| gap |
		gap := result first detect: [ :each | each fieldKey = key ].
		self
			assert: (self kindAfterMutating: gap in: result by: [ :object |
					 object
						 removeKey: key;
						 yourself ])
			equals: #( #lost )
			description: key ]
]

{ #category : 'tests' }
FamixOpenApiExtensionsMutationTest >> testAMismatchSaysWhatTheSourceAndTheExtensionsHold [

	| result gap report entity |
	result := self keptGapsOf: self documentExtensions30.
	gap := result first detect: [ :each | each fieldKey = 'summary' ].
	entity := gap entity.
	entity extensions: '{"summary":"other"}'.
	report := FamixOpenApiExtensionsCheck
		          checkInventory: result last
		          model: result second
		          diagnostics: result third.
	self assert: report valueMismatches size equals: 1.
	gap := report valueMismatches first.
	self assert: gap fieldKey equals: 'summary'.
	self assert: gap expected equals: '"S"'.
	self assert: gap found equals: '"other"'.
	self assert: gap entity identicalTo: entity.
	self assert: (report failingGaps includes: gap)
]

{ #category : 'tests' }
FamixOpenApiExtensionsMutationTest >> testASlotThatHoldsAValueOfTheWrongTypeKeepsItAnyway [
	"Constructed case: the slot of a schema holds the text of the source for maximum (the importer drops it): #valueKeptAnyway, informational; the other wrong values stay silent drops"

	| json imported schema report |
	json := self documentWrongTypes30.
	imported := self importedOf: json.
	schema := self
		          entityAt: '#/components/schemas/S'
		          ofClass: OPSchema
		          in: imported first.
	schema maximum: '5'.
	report := self
		          extensionsReportOf: json
		          model: imported first
		          diagnostics: imported last.
	self
		assertKind: #valueKeptAnyway
		at: '#/components/schemas/S'
		key: 'maximum'
		in: report.
	self
		assertKind: #silentDrop
		at: '#/components/schemas/S'
		key: 'minimum'
		in: report.
	self assert: (report informationalGaps includes:
			 (report gapsOfKind: #valueKeptAnyway) first).
	self deny: (report failingGaps includes:
			 (report gapsOfKind: #valueKeptAnyway) first)
]

{ #category : 'tests' }
FamixOpenApiExtensionsMutationTest >> testEveryKeyRemovedFromTheExtensionsIsLost [
	"Constructed case: the key is not in the extensions any more (the diagnostic that says it is kept is still there: it excuses nothing)"

	| total |
	total := 0.
	self richDocuments do: [ :each |
		| result |
		result := self keptGapsOf: each value.
		result first do: [ :gap |
			total := total + 1.
			self
				assert: (self kindAfterMutating: gap in: result by: [ :object |
						 object
							 removeKey: gap fieldKey;
							 yourself ])
				equals: #( #lost )
				description:
				each key , ' ' , gap sourcePointer , ' ' , gap fieldKey ] ].
	self assert: total >= 60
]

{ #category : 'tests' }
FamixOpenApiExtensionsMutationTest >> testEveryValueAlteredInTheExtensionsIsAMismatch [
	"The extensions hold the key with another value: #valueMismatch with what the source says and what the extensions hold"

	self richDocuments do: [ :each |
		| result |
		result := self keptGapsOf: each value.
		result first do: [ :gap |
			self
				assert: (self kindAfterMutating: gap in: result by: [ :object |
						 object
							 at: gap fieldKey put: 'V9-mutant';
							 yourself ])
				equals: #( #valueMismatch )
				description:
				each key , ' ' , gap sourcePointer , ' ' , gap fieldKey ] ]
]

{ #category : 'tests' }
FamixOpenApiExtensionsMutationTest >> testEveryValueAlteredInTheSourceIsAMismatch [
	"Source-side sweep: the value of every classified key of the source is changed in turn, the check says #valueMismatch"

	| total |
	total := 0.
	self richDocuments do: [ :each |
		| result |
		result := self keptGapsOf: each value.
		result first do: [ :gap |
			| node original report |
			node := result last nodeAt: gap sourcePointer.
			original := node value at: gap fieldKey.
			node value at: gap fieldKey put: 'V9-source-mutant'.
			report := FamixOpenApiExtensionsCheck
				          checkInventory: result last
				          model: result second
				          diagnostics: result third.
			node value at: gap fieldKey put: original.
			total := total + 1.
			self
				assert:
				(self kindsAt: gap sourcePointer key: gap fieldKey in: report)
				equals: #( #valueMismatch )
				description:
				each key , ' ' , gap sourcePointer , ' ' , gap fieldKey ] ].
	self assert: total >= 60
]

{ #category : 'tests' }
FamixOpenApiExtensionsMutationTest >> testWithoutTheirDiagnosticsTheIgnoredKeysAreLostOrDropped [
	"Constructed case: the diagnostics that excuse a key are removed (an empty collection, not nil): #lost for a key ignored beside a $ref or in a dropped parameter, #silentDrop for a value of a wrong type"

	| total |
	total := 0.
	#( #documentSiblings30 #documentSiblingsSwagger2
	   #documentBodiesSwagger2 #documentWrongTypes30 ) do: [ :selector |
		| json imported base report |
		json := self perform: selector.
		imported := self importedOf: json.
		base := self
			        extensionsReportOf: json
			        model: imported first
			        diagnostics: imported last.
		report := self
			          extensionsReportOf: json
			          model: imported first
			          diagnostics: #(  ).
		(base gapsOfKind: #ignoredByDiagnostic) do: [ :gap |
			total := total + 1.
			self
				assert:
					((self kindsAt: gap sourcePointer key: gap fieldKey in: report)
						 asArray = #( #lost ) or: [
						 (self kindsAt: gap sourcePointer key: gap fieldKey in: report)
							 asArray = #( #silentDrop ) ])
				description:
				selector , ' ' , gap sourcePointer , ' ' , gap fieldKey ].
		self assert: (report gapsOfKind: #ignoredByDiagnostic) isEmpty ].
	self assert: total >= 14
]
