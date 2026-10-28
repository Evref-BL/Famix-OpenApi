Class {
	#name : 'FamixOpenApiComponentsVisitor',
	#superclass : 'FamixOpenApiNodeVisitor',
	#instVars : [
		'pending'
	],
	#category : 'Famix-OpenApi-Importer',
	#package : 'Famix-OpenApi-Importer'
}

{ #category : 'visiting' }
FamixOpenApiComponentsVisitor >> components [

	^ context ensureComponents
]

{ #category : 'visiting' }
FamixOpenApiComponentsVisitor >> createComponents [
	"Pass 1: create and register an empty entity for every component of the reusable sections other than the schemas, so that every reference resolves (to an entity of the right kind or not). Swagger 2 sections are read by step C."

	self specVersion isSwagger2 ifTrue: [ ^ self ].
	self createSections
]

{ #category : 'visiting' }
FamixOpenApiComponentsVisitor >> createSection: aKey of: aClass adding: anAddBlock filling: aFillBlock [
	"Create, for every entry of the components section aKey, an empty entity of aClass named by the key, add it with anAddBlock and register it for pass 2 (aFillBlock gets the entity and its node). An entry that is only a reference is an alias, reported as a componentAlias."

	| holder |
	holder := self json at: 'components' ifAbsent: [ ^ self ].
	holder isDictionary ifFalse: [ ^ self ].
	self
		entriesAt: aKey
		in: holder
		at: '#/components'
		do: [ :key :node :pointer |
			(self isReferenceNode: node)
				ifTrue: [ self registerAliasFrom: node at: pointer ]
				ifFalse: [
					| entity |
					entity := self newEntity: aClass named: key pointer: pointer.
					anAddBlock value: entity.
					pending add: {
							entity.
							node.
							aFillBlock } ] ]
]

{ #category : 'visiting' }
FamixOpenApiComponentsVisitor >> createSections [

	| parameters |
	parameters := self parameterVisitor.
	self
		createSection: 'parameters'
		of: OPParameter
		adding: [ :each | self components addParameter: each ]
		filling: [ :each :node |
			parameters
				fillComponentParameter: each
				from: node
				at: each canonicalPointer ].
	self
		createSection: 'responses'
		of: OPResponse
		adding: [ :each | self components addResponse: each ]
		filling: [ :each :node |
			self responseVisitor
				fillResponse: each
				from: node
				at: each canonicalPointer ].
	self
		createSection: 'requestBodies'
		of: OPRequestBody
		adding: [ :each | self components addRequestBody: each ]
		filling: [ :each :node |
			self contentVisitor
				fillRequestBody: each
				from: node
				at: each canonicalPointer ].
	self
		createSection: 'headers'
		of: OPHeader
		adding: [ :each | self components addHeader: each ]
		filling: [ :each :node |
			self responseVisitor
				fillHeader: each
				from: node
				at: each canonicalPointer ].
	self
		createSection: 'examples'
		of: OPExample
		adding: [ :each | self components addExample: each ]
		filling: [ :each :node |
			self contentVisitor
				fillExample: each
				from: node
				at: each canonicalPointer ].
	self
		createSection: 'links'
		of: OPLink
		adding: [ :each | self components addLink: each ]
		filling: [ :each :node |
			self responseVisitor
				fillLink: each
				from: node
				at: each canonicalPointer ].
	self
		createSection: 'callbacks'
		of: OPCallback
		adding: [ :each | self components addCallback: each ]
		filling: [ :each :node |
			self pathVisitor
				fillCallback: each
				from: node
				at: each canonicalPointer ].
	self
		createSection: 'securitySchemes'
		of: OPSecurityScheme
		adding: [ :each | self components addSecurityScheme: each ]
		filling: [ :each :node |
			self securityVisitor
				fillSecurityScheme: each
				from: node
				at: each canonicalPointer ].
	self
		createSection: 'pathItems'
		of: OPPath
		adding: [ :each | self components addPathItem: each ]
		filling: [ :each :node |
			self pathVisitor
				fillPathItem: each
				from: node
				at: each canonicalPointer ]
]

{ #category : 'visiting' }
FamixOpenApiComponentsVisitor >> fillComponents [
	"Pass 2: fill the components created by #createComponents (after the schemas they refer to are filled)."

	self fillPending
]

{ #category : 'visiting' }
FamixOpenApiComponentsVisitor >> fillPending [
	"Pass 2: fill the components created and not filled yet."

	| work |
	work := pending.
	pending := OrderedCollection new.
	work do: [ :each |
		self
			guard: [ (each at: 3) value: (each at: 1) value: (each at: 2) ]
			at: (each at: 1) canonicalPointer ]
]

{ #category : 'visiting' }
FamixOpenApiComponentsVisitor >> initialize [

	super initialize.
	pending := OrderedCollection new
]

{ #category : 'visiting' }
FamixOpenApiComponentsVisitor >> registerAliasFrom: aReferenceNode at: aPointer [
	"Register the component at aPointer, which is only a reference, as an alias of its target."

	context registerAlias: aPointer to: (aReferenceNode at: '$ref').
	self diagnostics
		info: #componentAlias
		pointer: aPointer
		message: 'Component that is only the reference '
			, (aReferenceNode at: '$ref') printString.
	aReferenceNode size > 1 ifTrue: [
		self diagnostics
			info: #refSiblingsIgnored
			pointer: aPointer
			message: 'Keys next to $ref are ignored: '
				, (aReferenceNode keys copyWithout: '$ref') asArray printString ]
]

{ #category : 'visiting' }
FamixOpenApiComponentsVisitor >> visit [
	"Create then fill the components other than the schemas."

	self createComponents.
	self fillComponents
]
