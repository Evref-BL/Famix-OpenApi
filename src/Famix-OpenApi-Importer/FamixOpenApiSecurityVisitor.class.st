Class {
	#name : 'FamixOpenApiSecurityVisitor',
	#superclass : 'FamixOpenApiNodeVisitor',
	#category : 'Famix-OpenApi-Importer',
	#package : 'Famix-OpenApi-Importer'
}

{ #category : 'visiting' }
FamixOpenApiSecurityVisitor >> declaresEmptySecurityIn: aNode [

	| value |
	value := aNode at: 'security' ifAbsent: [ nil ].
	^ (context isList: value) and: [ value isEmpty ]
]

{ #category : 'visiting' }
FamixOpenApiSecurityVisitor >> fillFlowsOf: aScheme from: aNode at: aPointer [
	"Add to aScheme one OAuthFlow per entry of the flows object of aNode."

	self
		fixedEntriesAt: 'flows'
		in: aNode
		at: aPointer
		do: [ :key :node :pointer |
			aScheme addFlow: (self flowNamed: key from: node at: pointer) ]
]

{ #category : 'visiting' }
FamixOpenApiSecurityVisitor >> fillScopesOf: aFlow from: aNode at: aPointer [
	"Add to aFlow one SecurityScope per entry of the scopes object of aNode: its name is the scope, its description the value."

	| scopes base |
	scopes := self dictionaryAt: 'scopes' in: aNode at: aPointer.
	scopes ifNil: [ ^ self ].
	base := self pointer: aPointer appending: 'scopes'.
	scopes keysAndValuesDo: [ :name :description |
		| scope pointer |
		pointer := self pointer: base appending: name.
		scope := self
			         newEntity: OPSecurityScope
			         named: name
			         pointer: pointer.
		description isString ifTrue: [ scope description: description ].
		description isString ifFalse: [
			context
				wrongNodeAt: pointer
				expecting: 'a string'
				found: description ].
		aFlow addScope: scope ]
]

{ #category : 'visiting' }
FamixOpenApiSecurityVisitor >> fillSecurityOfOpenApi: anOpenApi from: aNode at: aPointer [
	"Add the SecurityRequirements of the security array of the root aNode to anOpenApi."

	(self requirementsIn: aNode at: aPointer) do: [ :each |
		anOpenApi addSecurityRequirement: each ]
]

{ #category : 'visiting' }
FamixOpenApiSecurityVisitor >> fillSecurityOfOperation: anOperation from: aNode at: aPointer [
	"Add the SecurityRequirements of the security array of aNode to anOperation. An empty array turns the security off for the operation."

	(self declaresEmptySecurityIn: aNode) ifTrue: [
		anOperation securityDisabled: true ].
	(self requirementsIn: aNode at: aPointer) do: [ :each |
		anOperation addSecurityRequirement: each ]
]

{ #category : 'visiting' }
FamixOpenApiSecurityVisitor >> fillSecurityScheme: aScheme from: aNode at: aPointer [
	"Fill aScheme, a component created with the key as name, from aNode, with its OAuth flows."

	aScheme
		type: (self stringAt: 'type' in: aNode at: aPointer);
		description: (self stringAt: 'description' in: aNode at: aPointer);
		parameterName: (self stringAt: 'name' in: aNode at: aPointer);
		inLocation: (self stringAt: 'in' in: aNode at: aPointer);
		scheme: (self stringAt: 'scheme' in: aNode at: aPointer);
		bearerFormat: (self stringAt: 'bearerFormat' in: aNode at: aPointer);
		openIdConnectUrl:
			(self stringAt: 'openIdConnectUrl' in: aNode at: aPointer);
		extensions: (self
				 extensionsOf: aNode
				 known:
					 #( 'type' 'description' 'name' 'in' 'scheme' 'bearerFormat'
					    'flows' 'openIdConnectUrl' )
				 at: aPointer).
	self fillFlowsOf: aScheme from: aNode at: aPointer.
	context
		recordSourceTextOf: aScheme
		from: aNode
		category: (self sourceCategoryOf: aScheme)
]

{ #category : 'visiting' }
FamixOpenApiSecurityVisitor >> flowNamed: aKey from: aNode at: aPointer [
	"Answer the OAuthFlow of type aKey described by aNode, with its scopes."

	| flow |
	flow := self newEntity: OPOAuthFlow named: aKey pointer: aPointer.
	flow
		flowType: aKey;
		authorizationUrl:
			(self stringAt: 'authorizationUrl' in: aNode at: aPointer);
		tokenUrl: (self stringAt: 'tokenUrl' in: aNode at: aPointer);
		refreshUrl: (self stringAt: 'refreshUrl' in: aNode at: aPointer);
		extensions: (self
				 extensionsOf: aNode
				 known: #( 'authorizationUrl' 'tokenUrl' 'refreshUrl' 'scopes' )
				 at: aPointer).
	self fillScopesOf: flow from: aNode at: aPointer.
	context recordSourceTextOf: flow from: aNode category: #inline.
	^ flow
]

{ #category : 'visiting' }
FamixOpenApiSecurityVisitor >> itemNamed: aName scopes: aScopes at: aPointer [
	"Answer the item of a requirement for the scheme aName with its scopes. A scheme that is not declared is reported and the item has no scheme."

	| item scheme |
	item := self
		        newEntity: OPSecurityRequirementItem
		        named: aName
		        pointer: aPointer.
	(context isList: aScopes)
		ifTrue: [ item scopeNames: (aScopes select: #isString) asArray ]
		ifFalse: [
			context
				wrongNodeAt: aPointer
				expecting: 'an array of scope names'
				found: aScopes.
			item scopeNames: #(  ) ].
	scheme := self schemeNamed: aName.
	scheme
		ifNil: [
			self diagnostics
				warning: #securitySchemeUnresolved
				pointer: aPointer
				message: 'No security scheme named ' , aName printString ]
		ifNotNil: [ item scheme: scheme ].
	^ item
]

{ #category : 'visiting' }
FamixOpenApiSecurityVisitor >> requirementFrom: aNode at: aPointer [
	"Answer the SecurityRequirement described by aNode: one item per scheme name (none for an empty object)."

	| requirement |
	requirement := self
		               newEntity: OPSecurityRequirement
		               named: nil
		               pointer: aPointer.
	aNode keysAndValuesDo: [ :key :scopes |
		requirement addItem: (self
				 itemNamed: key
				 scopes: scopes
				 at: (self pointer: aPointer appending: key)) ].
	context recordSourceTextOf: requirement from: aNode category: #inline.
	^ requirement
]

{ #category : 'visiting' }
FamixOpenApiSecurityVisitor >> requirementsIn: aNode at: aPointer [
	"Answer the Array of the SecurityRequirements of the security array of aNode, in order."

	| requirements |
	requirements := OrderedCollection new.
	self
		elementsAt: 'security'
		in: aNode
		at: aPointer
		do: [ :node :pointer |
			requirements add: (self requirementFrom: node at: pointer) ].
	^ requirements asArray
]

{ #category : 'visiting' }
FamixOpenApiSecurityVisitor >> schemeNamed: aName [
	"Answer the component SecurityScheme named aName, or nil."

	context components ifNil: [ ^ nil ].
	^ context components securitySchemes
		  detect: [ :each | each name = aName ]
		  ifNone: [ nil ]
]
