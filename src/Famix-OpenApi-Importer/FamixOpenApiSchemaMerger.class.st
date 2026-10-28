"
I am pass 3 of the import. First I merge identical inline Schemas: a structural signature is computed bottom-up for every schema; component schemas are never merged into each other, an inline schema identical to a component is merged into the component, and among identical inline schemas the first one in document order survives; the others are removed from the model, their referrers re-pointed to the survivor and their canonical pointers appended to the survivor's mergedPointers (rounds are repeated until nothing changes). Then I detect SubSchemas: an inline plain property bag (object type, properties, no allOf/oneOf/anyOf/not/additionalProperties/items) whose property names are a STRICT subset of the effective properties (own and inherited through allOf) of another schema T, with an equivalent value schema for each (same entity, or equal primitive shape) and a required set included in the required set of T, is replaced by an OPSubSchema whose subSchemaOf is the smallest such T (ties: first in document order, with an info subSchemaAmbiguous diagnostic). Public protocol: #mergeIn: answers the report (merged, subSchemas, inlineSchemas).
"
Class {
	#name : 'FamixOpenApiSchemaMerger',
	#superclass : 'Object',
	#instVars : [
		'context',
		'model',
		'ids',
		'table',
		'visited',
		'merges',
		'effective',
		'holders',
		'required',
		'mergedCount',
		'subSchemaCount',
		'removed',
		'toRemove'
	],
	#category : 'Famix-OpenApi-Importer',
	#package : 'Famix-OpenApi-Importer'
}

{ #category : 'configuration' }
FamixOpenApiSchemaMerger class >> copiedSelectors [
	"Answer the selectors of every simple attribute of a Schema, to copy when a schema is replaced by a SubSchema."

	^ self signatureSelectors
	  , #( #types #requiredProperties #name #canonicalPointer
		     #mergedPointers #sourceText )
]

{ #category : 'configuration' }
FamixOpenApiSchemaMerger class >> signatureSelectors [
	"Answer the selectors of the simple attributes that make two schemas identical (name, canonical pointers and source text excluded; types and required names are read sorted)."

	^ #( #title #description #format #isNullable #enumValues #constValue
	     #defaultValue #exampleValue #deprecated #readOnly #writeOnly
	     #additionalPropertiesAllowed #maximum #minimum #exclusiveMaximum
	     #exclusiveMinimum #multipleOf #maxLength #minLength #pattern
	     #maxItems #minItems #uniqueItems #maxProperties #minProperties
	     #extensions #ref )
]

{ #category : 'merging' }
FamixOpenApiSchemaMerger >> absorb: aLoser into: aSurvivor [
	"Re-point the referrers of aLoser to aSurvivor, keep its pointers in the mergedPointers of aSurvivor and remove it from the model."

	self repointReferrersOf: aLoser to: aSurvivor.
	aSurvivor mergedPointers:
		(aSurvivor mergedPointers copyWith: aLoser canonicalPointer)
		, aLoser mergedPointers.
	self discard: aLoser
]

{ #category : 'merging' }
FamixOpenApiSchemaMerger >> applyMerges [
	"Absorb every loser of the round into its survivor and answer the number of losers."

	| losers redirects |
	merges ifEmpty: [ ^ 0 ].
	losers := merges keys asSortedCollection: [ :a :b |
		          (context creationIndexOf: a)
		          <= (context creationIndexOf: b) ].
	redirects := IdentityDictionary new.
	losers do: [ :each |
		redirects at: each put: (self finalSurvivorOf: each) ].
	losers do: [ :each | self absorb: each into: (redirects at: each) ].
	context index replaceEntities: redirects.
	mergedCount := mergedCount + losers size.
	^ losers size
]

{ #category : 'sub-schemas' }
FamixOpenApiSchemaMerger >> collectRequiredOf: aSchema into: aSet visited: aVisitedSet [

	(aVisitedSet includes: aSchema) ifTrue: [ ^ self ].
	aVisitedSet add: aSchema.
	aSet addAll: aSchema requiredProperties.
	aSchema allOf do: [ :each |
		self collectRequiredOf: each into: aSet visited: aVisitedSet ]
]

{ #category : 'sub-schemas' }
FamixOpenApiSchemaMerger >> convert: aCollectionOfAssociations [
	"Replace each key (an inline schema) by a SubSchema of its value (the larger schema, itself possibly replaced)."

	| replaced |
	replaced := IdentityDictionary new.
	aCollectionOfAssociations do: [ :each |
		replaced at: each key put: (self subSchemaReplacing: each key) ].
	aCollectionOfAssociations do: [ :each |
		(replaced at: each key) subSchemaOf:
			(replaced at: each value ifAbsent: [ each value ]) ].
	context index replaceEntities: replaced.
	subSchemaCount := aCollectionOfAssociations size
]

{ #category : 'sub-schemas' }
FamixOpenApiSchemaMerger >> copyAttributesOf: aSchema to: aSubSchema [
	"Copy the simple attributes (reflective boundary: the list is data, see FamixOpenApiSchemaMerger class>>copiedSelectors)."

	self class copiedSelectors do: [ :selector |
		aSubSchema
			perform: (selector , ':') asSymbol
			with: (aSchema perform: selector) ]
]

{ #category : 'sub-schemas' }
FamixOpenApiSchemaMerger >> detectSubSchemas [
	"Replace by a SubSchema every inline plain property bag whose properties are a strict subset of the (own and inherited) properties of a larger object schema."

	| schemas pairs |
	schemas := context schemasInCreationOrder.
	self indexSupersetCandidates: schemas.
	pairs := OrderedCollection new.
	schemas do: [ :each |
		(self isPlainBag: each) ifTrue: [
			(self supersetOf: each) ifNotNil: [ :superset |
				pairs add: each -> superset ] ] ].
	self convert: pairs
]

{ #category : 're-pointing' }
FamixOpenApiSchemaMerger >> discard: aSchema [
	"Detach aSchema from everything it owns or refers to, then remove it, with the entities it owns, from the model."

	aSchema properties asArray do: [ :each |
		each valueSchema: nil.
		aSchema properties remove: each.
		self remove: each ].
	aSchema
		items: nil;
		not: nil;
		additionalProperties: nil.
	aSchema allOf removeAll: aSchema allOf asArray.
	aSchema oneOf removeAll: aSchema oneOf asArray.
	aSchema anyOf removeAll: aSchema anyOf asArray.
	aSchema prefixItems removeAll: aSchema prefixItems asArray.
	aSchema discriminator ifNotNil: [ :discriminator |
		discriminator mapping asArray do: [ :each |
			each schema: nil.
			self remove: each ].
		aSchema discriminator: nil.
		self remove: discriminator ].
	aSchema xml ifNotNil: [ :xml |
		aSchema xml: nil.
		self remove: xml ].
	aSchema externalDocs ifNotNil: [ :docs |
		aSchema externalDocs: nil.
		self remove: docs ].
	self remove: aSchema
]

{ #category : 'merging' }
FamixOpenApiSchemaMerger >> finalSurvivorOf: aSchema [

	| current |
	current := aSchema.
	[ merges includesKey: current ] whileTrue: [
		current := merges at: current ].
	^ current
]

{ #category : 'signatures' }
FamixOpenApiSchemaMerger >> idOf: aSchema [

	^ ids at: aSchema ifAbsentPut: [ ids size + 1 ]
]

{ #category : 'sub-schemas' }
FamixOpenApiSchemaMerger >> indexSupersetCandidates: aCollection [
	"Compute the effective properties (name to Property) of every schema that can be the larger schema of a SubSchema, and index those schemas by property name, in document order."

	effective := IdentityDictionary new.
	holders := Dictionary new.
	required := IdentityDictionary new.
	aCollection do: [ :schema |
		(self isEligibleSuperset: schema) ifTrue: [
			| properties |
			properties := Dictionary new.
			schema allProperties do: [ :each |
				properties at: each name put: each ].
			properties ifNotEmpty: [
				effective at: schema put: properties.
				properties keysDo: [ :name |
					(holders at: name ifAbsentPut: [ OrderedCollection new ]) add:
						schema ] ] ] ]
]

{ #category : 'sub-schemas' }
FamixOpenApiSchemaMerger >> is: aSchema equivalentTo: anotherSchema [
	"Answer whether two value schemas are the same entity or have the same primitive shape."

	aSchema == anotherSchema ifTrue: [ ^ true ].
	(aSchema isNil or: [ anotherSchema isNil ]) ifTrue: [ ^ false ].
	^ (self shapeOf: aSchema)
		  ifNil: [ false ]
		  ifNotNil: [ :shape | shape = (self shapeOf: anotherSchema) ]
]

{ #category : 'sub-schemas' }
FamixOpenApiSchemaMerger >> is: aBag strictSubsetOf: aSuperset [
	"Answer whether every property of aBag exists in aSuperset (strictly more properties) with an equivalent value schema, and the required names of aBag are required by aSuperset."

	| properties |
	properties := effective at: aSuperset.
	aBag properties size < properties size ifFalse: [ ^ false ].
	(aBag properties allSatisfy: [ :each |
		 properties
			 at: each name
			 ifPresent: [ :other |
			 self is: each valueSchema equivalentTo: other valueSchema ]
			 ifAbsent: [ false ] ]) ifFalse: [ ^ false ].
	^ (self requiredNamesOf: aSuperset) includesAll:
		  aBag requiredProperties
]

{ #category : 'merging' }
FamixOpenApiSchemaMerger >> isComponent: aSchema [

	^ aSchema components notNil
]

{ #category : 'sub-schemas' }
FamixOpenApiSchemaMerger >> isEligibleSuperset: aSchema [
	"Answer whether aSchema may be the larger schema of a SubSchema: object like, without oneOf, anyOf or not."

	^ (self isObjectLike: aSchema) and: [
		  aSchema oneOf isEmpty and: [
			  aSchema anyOf isEmpty and: [ aSchema not isNil ] ] ]
]

{ #category : 'sub-schemas' }
FamixOpenApiSchemaMerger >> isObjectLike: aSchema [

	^ aSchema types isEmpty or: [ aSchema types includes: 'object' ]
]

{ #category : 'sub-schemas' }
FamixOpenApiSchemaMerger >> isPlainBag: aSchema [
	"Answer whether aSchema is an inline object schema that has properties and nothing else structural (no allOf, oneOf, anyOf, not, additionalProperties, items, prefixItems)."

	^ (self isComponent: aSchema) not and: [
		  (self isObjectLike: aSchema) and: [
			  aSchema properties notEmpty and: [
				  aSchema allOf isEmpty and: [
					  aSchema oneOf isEmpty and: [
						  aSchema anyOf isEmpty and: [
							  aSchema not isNil and: [
								  aSchema additionalProperties isNil and: [
									  aSchema items isNil and: [ aSchema prefixItems isEmpty ] ] ] ] ] ] ] ] ]
]

{ #category : 're-pointing' }
FamixOpenApiSchemaMerger >> membersOf: aCollection replacing: anOldSchema with: aNewSchema [

	^ (aCollection collect: [ :each |
		   each == anOldSchema
			   ifTrue: [ aNewSchema ]
			   ifFalse: [ each ] ]) asOrderedCollection
]

{ #category : 'merging' }
FamixOpenApiSchemaMerger >> merge: aLoser into: aSurvivor [

	merges at: aLoser put: aSurvivor.
	visited at: aLoser put: aSurvivor
]

{ #category : 'merging' }
FamixOpenApiSchemaMerger >> mergeIn: anImportContext [
	"Merge the identical inline schemas of the model of anImportContext then replace the strict subsets by SubSchemas. Answer the report: a Dictionary with #merged, #subSchemas and #inlineSchemas (the number of inline schemas before merging)."

	| inlineCount |
	context := anImportContext.
	model := context model.
	ids := IdentityDictionary new.
	removed := IdentitySet new.
	toRemove := IdentitySet new.
	mergedCount := 0.
	subSchemaCount := 0.
	inlineCount := context inlineSchemaCount.
	[ self mergeRound > 0 ] whileTrue.
	self detectSubSchemas.
	self removePendingFromModel.
	context index forgetEntities: removed.
	^ Dictionary new
		  at: #merged put: mergedCount;
		  at: #subSchemas put: subSchemaCount;
		  at: #inlineSchemas put: inlineCount;
		  yourself
]

{ #category : 'merging' }
FamixOpenApiSchemaMerger >> mergeRound [
	"Compute the survivor of every schema (components first, then the inline ones in document order), merge the losers and answer how many were merged. The inline schemas that only become identical after this round are merged by the next one."

	| count |
	table := Dictionary new.
	visited := IdentityDictionary new.
	merges := IdentityDictionary new.
	self schemasComponentsFirst do: [ :each | self survivorOf: each ].
	count := self applyMerges.
	self removePendingFromModel.
	^ count
]

{ #category : 'public' }
FamixOpenApiSchemaMerger >> mergedCount [
	"Answer the number of inline schemas merged into another schema."

	^ mergedCount ifNil: [ 0 ]
]

{ #category : 'sub-schemas' }
FamixOpenApiSchemaMerger >> moveOwnedEntitiesOf: aSchema to: aSubSchema [
	"Give to aSubSchema the properties, discriminator, xml and external documentation of aSchema."

	| discriminator xml docs |
	aSchema properties asArray do: [ :each |
		aSchema properties remove: each.
		aSubSchema addProperty: each ].
	discriminator := aSchema discriminator.
	xml := aSchema xml.
	docs := aSchema externalDocs.
	aSchema
		discriminator: nil;
		xml: nil;
		externalDocs: nil.
	aSubSchema
		discriminator: discriminator;
		xml: xml;
		externalDocs: docs
]

{ #category : 'merging' }
FamixOpenApiSchemaMerger >> register: aSchema signature: aString [
	"Answer the survivor of aSchema whose signature is aString. A component schema is never merged into another one and is preferred to an inline schema; among inline schemas the first one survives."

	| known |
	known := table at: aString ifAbsent: [
		         table at: aString put: aSchema.
		         ^ aSchema ].
	(self isComponent: aSchema) ifTrue: [
		(self isComponent: known) ifFalse: [
			self merge: known into: aSchema.
			table at: aString put: aSchema ].
		^ aSchema ].
	self merge: aSchema into: known.
	^ known
]

{ #category : 'merging' }
FamixOpenApiSchemaMerger >> remove: anEntity [
	"Remember anEntity as removed, to forget its pointers in the index, and queue its removal from the model (see #removePendingFromModel)."

	removed add: anEntity.
	toRemove add: anEntity
]

{ #category : 'merging' }
FamixOpenApiSchemaMerger >> removePendingFromModel [
	"Remove from the model in one pass the entities queued by #remove: (MooseModel>>remove: is linear for each entity, which makes the removal of tens of thousands of schemas quadratic). The entity storage and its per class index are filtered once."

	| storage |
	toRemove ifEmpty: [ ^ self ].
	storage := model entityStorage.
	storage elements removeAllSuchThat: [ :each |
		toRemove includes: each ].
	(toRemove collect: #class as: IdentitySet) do: [ :class |
		(storage selectAllWithType: class) removeAllSuchThat: [ :each |
			toRemove includes: each ] ].
	toRemove do: [ :each | each privateSetMooseModel: nil ].
	model flush.
	toRemove := IdentitySet new
]

{ #category : 're-pointing' }
FamixOpenApiSchemaMerger >> repointReferrersOf: anOldSchema to: aNewSchema [
	"Make every entity that refers to anOldSchema refer to aNewSchema instead, in the same slot and, for the members of allOf, oneOf, anyOf and prefixItems, at the same position."

	anOldSchema usedAsItemsBy asArray do: [ :each |
		each items: aNewSchema ].
	anOldSchema usedAsNotBy asArray do: [ :each | each not: aNewSchema ].
	anOldSchema usedAsAdditionalPropertiesBy asArray do: [ :each |
		each additionalProperties: aNewSchema ].
	anOldSchema usedAsPropertyValueBy asArray do: [ :each |
		each valueSchema: aNewSchema ].
	anOldSchema usedByDiscriminatorMappings asArray do: [ :each |
		each schema: aNewSchema ].
	anOldSchema usedByHeaders asArray do: [ :each |
		each schema: aNewSchema ].
	anOldSchema usedByMediaTypes asArray do: [ :each |
		each schema: aNewSchema ].
	anOldSchema usedByParameters asArray do: [ :each |
		each schema: aNewSchema ].
	anOldSchema usedAsAllOfBy asArray do: [ :each |
		each allOf:
			(self membersOf: each allOf replacing: anOldSchema with: aNewSchema) ].
	anOldSchema usedAsOneOfBy asArray do: [ :each |
		each oneOf:
			(self membersOf: each oneOf replacing: anOldSchema with: aNewSchema) ].
	anOldSchema usedAsAnyOfBy asArray do: [ :each |
		each anyOf:
			(self membersOf: each anyOf replacing: anOldSchema with: aNewSchema) ].
	anOldSchema usedAsPrefixItemsBy asArray do: [ :each |
		each prefixItems: (self
				 membersOf: each prefixItems
				 replacing: anOldSchema
				 with: aNewSchema) ]
]

{ #category : 'sub-schemas' }
FamixOpenApiSchemaMerger >> requiredNamesOf: aSchema [
	"Answer the Set of the names required by aSchema or by the schemas of its allOf, recursively."

	^ required at: aSchema ifAbsentPut: [
		  | names |
		  names := Set new.
		  self
			  collectRequiredOf: aSchema
			  into: names
			  visited: IdentitySet new.
		  names ]
]

{ #category : 'merging' }
FamixOpenApiSchemaMerger >> schemasComponentsFirst [

	| all |
	all := context schemasInCreationOrder.
	^ (all select: [ :each | self isComponent: each ])
	  , (all reject: [ :each | self isComponent: each ])
]

{ #category : 'sub-schemas' }
FamixOpenApiSchemaMerger >> shapeOf: aSchema [
	"Answer the primitive shape of aSchema (types, nullability, format, enum, const, pattern and bounds), or nil when it has a structure (properties, combinations, items, additional properties) or no type."

	(aSchema types isEmpty or: [
		 aSchema properties notEmpty or: [
			 aSchema allOf notEmpty or: [
				 aSchema oneOf notEmpty or: [
					 aSchema anyOf notEmpty or: [
						 aSchema prefixItems notEmpty or: [
							 aSchema not notNil or: [
								 aSchema items notNil or: [
									 aSchema additionalProperties notNil ] ] ] ] ] ] ] ])
		ifTrue: [ ^ nil ].
	^ {
		  aSchema types sorted.
		  (aSchema isNullable == true).
		  aSchema format.
		  aSchema enumValues.
		  aSchema constValue.
		  aSchema pattern.
		  aSchema maximum.
		  aSchema minimum.
		  aSchema exclusiveMaximum.
		  aSchema exclusiveMinimum.
		  aSchema multipleOf.
		  aSchema maxLength.
		  aSchema minLength }
]

{ #category : 'signatures' }
FamixOpenApiSchemaMerger >> signatureOf: aSchema [
	"Answer the String that is equal for two schemas of identical content: their attributes and, by survivor identity, their related schemas."

	^ String streamContents: [ :stream |
		  self writeAttributesOf: aSchema on: stream.
		  self writePropertiesOf: aSchema on: stream.
		  self writeRelationsOf: aSchema on: stream.
		  self writeDiscriminatorOf: aSchema on: stream.
		  self writeXmlOf: aSchema on: stream.
		  self writeExternalDocsOf: aSchema on: stream ]
]

{ #category : 'public' }
FamixOpenApiSchemaMerger >> subSchemaCount [
	"Answer the number of inline schemas replaced by a SubSchema."

	^ subSchemaCount ifNil: [ 0 ]
]

{ #category : 'sub-schemas' }
FamixOpenApiSchemaMerger >> subSchemaReplacing: aSchema [
	"Answer a new SubSchema carrying the content of aSchema, which is removed: its referrers refer to the SubSchema, which takes its place in the document order."

	| subSchema |
	subSchema := model add: OPSubSchema new.
	self copyAttributesOf: aSchema to: subSchema.
	context copyCreationIndexOf: aSchema to: subSchema.
	self moveOwnedEntitiesOf: aSchema to: subSchema.
	self repointReferrersOf: aSchema to: subSchema.
	self remove: aSchema.
	^ subSchema
]

{ #category : 'sub-schemas' }
FamixOpenApiSchemaMerger >> supersetOf: aBag [
	"Answer the smallest schema of which aBag is a strict subset (the first in document order among the equally small ones, reporting the ambiguity), or nil."

	| candidates matches smallest tied |
	candidates := (aBag properties collect: [ :each |
		               holders at: each name ifAbsent: [ ^ nil ] ])
		              detectMin: #size.
	matches := candidates select: [ :each |
		           each ~~ aBag and: [ self is: aBag strictSubsetOf: each ] ].
	matches ifEmpty: [ ^ nil ].
	smallest := (matches collect: [ :each | (effective at: each) size ])
		            min.
	tied := matches select: [ :each |
		        (effective at: each) size = smallest ].
	tied size > 1 ifTrue: [
		context diagnostics
			info: #subSchemaAmbiguous
			pointer: aBag canonicalPointer
			message:
				'Sub-schema of several schemas with ' , smallest printString
				, ' properties; chose ' , tied first canonicalPointer asString ].
	^ tied first
]

{ #category : 'merging' }
FamixOpenApiSchemaMerger >> survivorOf: aSchema [
	"Answer the schema that stands for aSchema after the merging: itself, or the identical schema that absorbs it."

	visited at: aSchema ifPresent: [ :known | ^ known ].
	visited at: aSchema put: aSchema.
	^ self register: aSchema signature: (self signatureOf: aSchema)
]

{ #category : 'signatures' }
FamixOpenApiSchemaMerger >> tokenOf: aSchemaOrNil [
	"Answer the token standing for a related schema in a signature: the id of its survivor, so that related schemas are compared by identity."

	aSchemaOrNil ifNil: [ ^ '-' ].
	^ (self idOf: ((self isComponent: aSchemaOrNil)
			    ifTrue: [ aSchemaOrNil ]
			    ifFalse: [ self survivorOf: aSchemaOrNil ])) printString
]

{ #category : 'signatures' }
FamixOpenApiSchemaMerger >> writeAttributesOf: aSchema on: aStream [
	"Write the simple attributes of aSchema (reflective boundary: the list of the attributes is data, see FamixOpenApiSchemaMerger class>>signatureSelectors)."

	self class signatureSelectors do: [ :selector |
		aStream
			print: (aSchema perform: selector);
			nextPut: $; ].
	aStream
		print: aSchema types sorted;
		print: aSchema requiredProperties sorted
]

{ #category : 'signatures' }
FamixOpenApiSchemaMerger >> writeDiscriminatorOf: aSchema on: aStream [

	aStream nextPutAll: ' D '.
	aSchema discriminator ifNotNil: [ :discriminator |
		aStream
			print: discriminator propertyName;
			print: discriminator extensions.
		(discriminator mapping asSortedCollection: [ :a :b |
			 a name <= b name ]) do: [ :each |
			aStream
				print: each name;
				print: each value;
				nextPutAll: (self tokenOf: each schema);
				nextPut: $; ] ]
]

{ #category : 'signatures' }
FamixOpenApiSchemaMerger >> writeExternalDocsOf: aSchema on: aStream [

	aStream nextPutAll: ' E '.
	aSchema externalDocs ifNotNil: [ :docs |
		aStream
			print: docs description;
			print: docs url;
			print: docs extensions ]
]

{ #category : 'signatures' }
FamixOpenApiSchemaMerger >> writePropertiesOf: aSchema on: aStream [

	aStream nextPutAll: ' P '.
	(aSchema properties asSortedCollection: [ :a :b | a name <= b name ])
		do: [ :each |
			aStream
				print: each name;
				print: each isRequired;
				nextPutAll: (self tokenOf: each valueSchema);
				nextPut: $; ]
]

{ #category : 'signatures' }
FamixOpenApiSchemaMerger >> writeRelationsOf: aSchema on: aStream [

	aStream
		nextPutAll: ' I ';
		nextPutAll: (self tokenOf: aSchema items);
		nextPutAll: ' N ';
		nextPutAll: (self tokenOf: aSchema not);
		nextPutAll: ' A ';
		nextPutAll: (self tokenOf: aSchema additionalProperties).
	self writeTokensOf: aSchema prefixItems tag: ' X ' on: aStream.
	self writeTokensOf: aSchema allOf tag: ' allOf ' on: aStream.
	self writeTokensOf: aSchema oneOf tag: ' oneOf ' on: aStream.
	self writeTokensOf: aSchema anyOf tag: ' anyOf ' on: aStream
]

{ #category : 'signatures' }
FamixOpenApiSchemaMerger >> writeTokensOf: aCollection tag: aString on: aStream [

	aStream nextPutAll: aString.
	aCollection do: [ :each |
		aStream
			nextPutAll: (self tokenOf: each);
			nextPut: $, ]
]

{ #category : 'signatures' }
FamixOpenApiSchemaMerger >> writeXmlOf: aSchema on: aStream [

	aStream nextPutAll: ' M '.
	aSchema xml ifNotNil: [ :xml |
		aStream
			print: xml name;
			print: xml namespace;
			print: xml prefix;
			print: xml attribute;
			print: xml wrapped;
			print: xml extensions ]
]
