"
I read schemas in two passes. Pass 1 (#createComponentSchemas, or #schemaFrom:at: for an inline schema met elsewhere) creates an empty Schema for every component schema and every inline schema reachable inside it (properties, items, prefixItems, allOf/oneOf/anyOf, not, additionalProperties) at its own canonical pointer and registers it in the index; a node that is only a $ref gets an alias instead of an entity. Pass 2 (#fillPending) fills the schemas: attributes, bounds, types, values, properties, compositions, $ref targets (resolved strictly through the index), discriminator, xml, external documentation and extensions. Swagger 2 definitions are read at their document pointer (#/definitions/X) and are also registered under the translated components pointer so that refs written either way resolve to the same entity.
"
Class {
	#name : 'FamixOpenApiSchemaVisitor',
	#superclass : 'FamixOpenApiNodeVisitor',
	#instVars : [
		'pending'
	],
	#category : 'Famix-OpenApi-Importer',
	#package : 'Famix-OpenApi-Importer'
}

{ #category : 'pass 2: filling' }
FamixOpenApiSchemaVisitor >> addPrefixItemsTo: aSchema from: aList at: aPointer [
	"Add to the prefixItems of aSchema the schemas of the elements of aList, located at aPointer."

	aList withIndexDo: [ :each :position |
		(self
			 entityFor: each
			 at: (self pointer: aPointer appending: position - 1)) ifNotNil: [
			:member | aSchema addPrefixItem: member ] ]
]

{ #category : 'pass 1: creation' }
FamixOpenApiSchemaVisitor >> createChildrenAt: aKey of: aNode pointer: aPointer [
	"Create the inline schema under aKey of aNode: an object, or the elements of an array."

	| value base |
	value := aNode at: aKey ifAbsent: [ ^ self ].
	base := self pointer: aPointer appending: aKey.
	value isDictionary ifTrue: [ ^ self createSchemaFrom: value at: base ].
	(context isList: value) ifTrue: [
		value withIndexDo: [ :element :position |
			self
				createSchemaFrom: element
				at: (self pointer: base appending: position - 1) ] ]
]

{ #category : 'pass 1: creation' }
FamixOpenApiSchemaVisitor >> createChildrenOf: aNode at: aPointer [
	"Create the inline schemas located inside the schema aNode."

	| properties |
	aNode isDictionary ifFalse: [ ^ self ].
	properties := aNode at: 'properties' ifAbsent: [ nil ].
	properties isDictionary ifTrue: [
		properties keysAndValuesDo: [ :name :node |
			self
				createSchemaFrom: node
				at:
				(self pointer: aPointer appending: 'properties' appending: name) ] ].
	#( 'not' 'additionalProperties' ) do: [ :key |
		self
			createSchemaFrom: (aNode at: key ifAbsent: [ nil ])
			at: (self pointer: aPointer appending: key) ].
	#( 'items' 'prefixItems' 'allOf' 'oneOf' 'anyOf' ) do: [ :key |
		self createChildrenAt: key of: aNode pointer: aPointer ]
]

{ #category : 'pass 1: creation' }
FamixOpenApiSchemaVisitor >> createComponentSchemaNamed: aKey from: aNode at: aPointer [
	"Create the component schema aKey, or register an alias when it is only a reference. Answer the Schema or nil."

	| schema |
	(self isPureReference: aNode) ifTrue: [
		self registerAliasFrom: aNode at: aPointer.
		^ nil ].
	schema := self newEntity: OPSchema named: aKey pointer: aPointer.
	context ensureComponents addSchema: schema.
	pending add: schema -> aNode.
	self createChildrenOf: aNode at: aPointer.
	^ schema
]

{ #category : 'pass 1: creation' }
FamixOpenApiSchemaVisitor >> createComponentSchemas [
	"Pass 1: create and register an empty Schema for every component schema and every inline schema inside them."

	| section base |
	section := self schemasSection.
	section ifNil: [ ^ self ].
	base := self schemasBasePointer.
	section keysAndValuesDo: [ :key :node |
		| pointer |
		pointer := self pointer: base appending: key.
		self
			guard: [
			self createComponentSchemaNamed: key from: node at: pointer ]
			at: pointer ]
]

{ #category : 'pass 1: creation' }
FamixOpenApiSchemaVisitor >> createSchemaFrom: aNode at: aPointer [
	"Create and register the inline Schema described by aNode, and the inline schemas inside it. A node that is only a reference gets an alias; a node that is not an object gets nothing (reported when filling). Answer the new Schema or nil."

	| schema |
	aNode isDictionary ifFalse: [ ^ nil ].
	(self isPureReference: aNode) ifTrue: [
		self registerAliasFrom: aNode at: aPointer.
		^ nil ].
	schema := self newEntity: OPSchema named: nil pointer: aPointer.
	pending add: schema -> aNode.
	self createChildrenOf: aNode at: aPointer.
	^ schema
]

{ #category : 'entry points' }
FamixOpenApiSchemaVisitor >> entityFor: aNode at: aPointer [
	"Answer the Schema that stands for the node aNode located at aPointer inside a schema: the resolved target when it is a reference, the inline schema created there otherwise, nil for a boolean schema or a node of the wrong type."

	(self isPureReference: aNode) ifTrue: [
		^ context
			  resolveReference: (aNode at: '$ref')
			  at: aPointer
			  expecting: OPSchema ].
	aNode isDictionary ifTrue: [ ^ context entityAt: aPointer ].
	(context isBooleanValue: aNode) ifFalse: [
		context
			wrongNodeAt: aPointer
			expecting: 'a schema object'
			found: aNode ].
	^ nil
]

{ #category : 'pass 2: filling' }
FamixOpenApiSchemaVisitor >> fill: aSchema from: aNode [
	"Fill aSchema, created in pass 1, from the JSON node aNode."

	| pointer |
	pointer := aSchema canonicalPointer.
	aNode isDictionary ifFalse: [
		(context isBooleanValue: aNode) ifFalse: [
			context
				wrongNodeAt: pointer
				expecting: 'a schema object'
				found: aNode ].
		^ self ].
	self fillAnnotationsOf: aSchema from: aNode at: pointer.
	self fillValidationOf: aSchema from: aNode at: pointer.
	self fillTypesOf: aSchema from: aNode.
	self fillValuesOf: aSchema from: aNode.
	self fillReferenceOf: aSchema from: aNode at: pointer.
	self fillPropertiesOf: aSchema from: aNode at: pointer.
	self fillCompositionOf: aSchema from: aNode at: pointer.
	self fillItemsOf: aSchema from: aNode at: pointer.
	self fillAdditionalPropertiesOf: aSchema from: aNode at: pointer.
	self fillDiscriminatorOf: aSchema from: aNode at: pointer.
	aSchema
		xml: (self xmlIn: aNode at: pointer);
		externalDocs: (self externalDocsIn: aNode at: pointer);
		extensions: (context
				 extensionsTextOf: aNode
				 known: self specVersion schemaKeywords
				 extra: #(  )
				 unmodelled: self specVersion unmodelledSchemaKeywords
				 at: pointer).
	context
		recordSourceTextOf: aSchema
		from: aNode
		category:
		(aSchema components ifNil: [ #inline ] ifNotNil: [ #component ])
]

{ #category : 'pass 2: filling' }
FamixOpenApiSchemaVisitor >> fillAdditionalPropertiesOf: aSchema from: aNode at: aPointer [
	"A boolean additionalProperties sets additionalPropertiesAllowed; a schema sets additionalProperties."

	| value pointer |
	value := aNode at: 'additionalProperties' ifAbsent: [ nil ].
	value ifNil: [ ^ self ].
	pointer := self pointer: aPointer appending: 'additionalProperties'.
	(context isBooleanValue: value) ifTrue: [
		^ aSchema additionalPropertiesAllowed: value ].
	value isDictionary ifTrue: [
		^ aSchema additionalProperties: (self entityFor: value at: pointer) ].
	context
		wrongNodeAt: pointer
		expecting: 'a boolean or a schema object'
		found: value
]

{ #category : 'pass 2: filling' }
FamixOpenApiSchemaVisitor >> fillAnnotationsOf: aSchema from: aNode at: aPointer [
	"Set title, description, format, pattern and the deprecated, readOnly and writeOnly flags."

	aSchema
		title: (self stringAt: 'title' in: aNode at: aPointer);
		description: (self stringAt: 'description' in: aNode at: aPointer);
		format: (self stringAt: 'format' in: aNode at: aPointer);
		pattern: (self stringAt: 'pattern' in: aNode at: aPointer);
		deprecated: (self booleanAt: 'deprecated' in: aNode at: aPointer);
		readOnly: (self booleanAt: 'readOnly' in: aNode at: aPointer);
		writeOnly: (self booleanAt: 'writeOnly' in: aNode at: aPointer)
]

{ #category : 'pass 2: filling' }
FamixOpenApiSchemaVisitor >> fillCompositionOf: aSchema from: aNode at: aPointer [
	"Add the members of allOf, oneOf and anyOf in their order, and set not."

	(self schemasInListAt: 'allOf' of: aNode at: aPointer) do: [ :each |
		aSchema addAllOf: each ].
	(self schemasInListAt: 'oneOf' of: aNode at: aPointer) do: [ :each |
		aSchema addOneOf: each ].
	(self schemasInListAt: 'anyOf' of: aNode at: aPointer) do: [ :each |
		aSchema addAnyOf: each ].
	(aNode at: 'not' ifAbsent: [ nil ]) ifNotNil: [ :node |
		aSchema not:
			(self entityFor: node at: (self pointer: aPointer appending: 'not')) ]
]

{ #category : 'pass 2: discriminator and xml' }
FamixOpenApiSchemaVisitor >> fillDiscriminator: aDiscriminator from: aNode at: aPointer [
	"Set the property name, the mapping and the extensions of aDiscriminator."

	| mapping |
	aDiscriminator
		propertyName: (self stringAt: 'propertyName' in: aNode at: aPointer);
		extensions: (self
				 extensionsOf: aNode
				 known: #( 'propertyName' 'mapping' )
				 at: aPointer).
	mapping := self dictionaryAt: 'mapping' in: aNode at: aPointer.
	mapping ifNil: [ ^ self ].
	mapping keysAndValuesDo: [ :key :value |
		aDiscriminator addMapping: (self
				 mappingNamed: key
				 value: value
				 at: (self pointer: aPointer appending: 'mapping' appending: key)) ]
]

{ #category : 'pass 2: discriminator and xml' }
FamixOpenApiSchemaVisitor >> fillDiscriminatorOf: aSchema from: aNode at: aPointer [
	"Set the Discriminator: a string is the propertyName (Swagger 2); an object has a propertyName and a mapping (OpenAPI 3)."

	| value pointer discriminator |
	value := aNode at: 'discriminator' ifAbsent: [ ^ self ].
	pointer := self pointer: aPointer appending: 'discriminator'.
	discriminator := self
		                 newEntity: OPDiscriminator
		                 named: nil
		                 pointer: pointer.
	value isString ifTrue: [ discriminator propertyName: value ].
	value isDictionary ifTrue: [
		self fillDiscriminator: discriminator from: value at: pointer ].
	(value isString or: [ value isDictionary ]) ifFalse: [
		context
			wrongNodeAt: pointer
			expecting: 'an object or a string'
			found: value ].
	aSchema discriminator: discriminator
]

{ #category : 'pass 2: filling' }
FamixOpenApiSchemaVisitor >> fillItemsOf: aSchema from: aNode at: aPointer [
	"Set items (an object), and the prefixItems: the 3.1 prefixItems array, or the array form of items of Swagger 2 and 3.0."

	| items pointer |
	items := aNode at: 'items' ifAbsent: [ nil ].
	pointer := self pointer: aPointer appending: 'items'.
	items isDictionary ifTrue: [
		aSchema items: (self entityFor: items at: pointer) ].
	(context isList: items) ifTrue: [
		self addPrefixItemsTo: aSchema from: items at: pointer ].
	(items isNil or: [
		 items isDictionary or: [
			 (context isList: items) or: [ context isBooleanValue: items ] ] ])
		ifFalse: [
			context
				wrongNodeAt: pointer
				expecting: 'a schema object or an array'
				found: items ].
	(self listAt: 'prefixItems' in: aNode at: aPointer) ifNotNil: [ :list |
		self
			addPrefixItemsTo: aSchema
			from: list
			at: (self pointer: aPointer appending: 'prefixItems') ]
]

{ #category : 'entry points' }
FamixOpenApiSchemaVisitor >> fillPending [
	"Pass 2: fill the schemas created and not filled yet."

	| work |
	work := pending.
	pending := OrderedCollection new.
	work do: [ :each |
		self
			guard: [ self fill: each key from: each value ]
			at: each key canonicalPointer ]
]

{ #category : 'pass 2: filling' }
FamixOpenApiSchemaVisitor >> fillPropertiesOf: aSchema from: aNode at: aPointer [
	"Set the required names and add a Property for every entry of properties; its value schema is the inline schema or the resolved target."

	| required properties |
	required := self requiredNamesIn: aNode at: aPointer.
	aSchema requiredProperties: required.
	properties := self dictionaryAt: 'properties' in: aNode at: aPointer.
	properties ifNil: [ ^ self ].
	properties keysAndValuesDo: [ :name :node |
		| pointer property |
		pointer := self
			           pointer: aPointer
			           appending: 'properties'
			           appending: name.
		property := context
			            newUnindexedEntity: OPProperty
			            named: name
			            pointer: pointer.
		property
			isRequired: (required includes: name);
			valueSchema: (self entityFor: node at: pointer).
		aSchema addProperty: property ]
]

{ #category : 'pass 2: filling' }
FamixOpenApiSchemaVisitor >> fillReferenceOf: aSchema from: aNode at: aPointer [
	"A schema with a $ref next to other keywords (OpenAPI 3.1) keeps the raw reference and gets the target as the first member of its allOf."

	| ref target |
	ref := aNode at: '$ref' ifAbsent: [ ^ self ].
	ref isString ifFalse: [
		^ context
			  wrongNodeAt: (self pointer: aPointer appending: '$ref')
			  expecting: 'a string'
			  found: ref ].
	aSchema ref: ref.
	target := context
		          resolveReference: ref
		          at: aPointer
		          expecting: OPSchema.
	target ifNotNil: [ aSchema addAllOf: target ]
]

{ #category : 'pass 2: filling' }
FamixOpenApiSchemaVisitor >> fillTypesOf: aSchema from: aNode [
	"Set the types (without null) and the nullability, as the version reads them."

	aSchema
		types: (self specVersion typesFrom: aNode);
		isNullable: (self specVersion isNullableFrom: aNode)
]

{ #category : 'pass 2: filling' }
FamixOpenApiSchemaVisitor >> fillValidationOf: aSchema from: aNode at: aPointer [
	"Set the numeric bounds (through the version hooks), the multipleOf and the length, items and properties limits."

	aSchema
		minimum: (self specVersion minimumFrom: aNode);
		maximum: (self specVersion maximumFrom: aNode);
		exclusiveMinimum: (self specVersion exclusiveMinimumFrom: aNode);
		exclusiveMaximum: (self specVersion exclusiveMaximumFrom: aNode);
		multipleOf: (self numberAt: 'multipleOf' in: aNode at: aPointer);
		minLength: (self numberAt: 'minLength' in: aNode at: aPointer);
		maxLength: (self numberAt: 'maxLength' in: aNode at: aPointer);
		minItems: (self numberAt: 'minItems' in: aNode at: aPointer);
		maxItems: (self numberAt: 'maxItems' in: aNode at: aPointer);
		uniqueItems: (self booleanAt: 'uniqueItems' in: aNode at: aPointer);
		minProperties:
			(self numberAt: 'minProperties' in: aNode at: aPointer);
		maxProperties:
			(self numberAt: 'maxProperties' in: aNode at: aPointer)
]

{ #category : 'pass 2: filling' }
FamixOpenApiSchemaVisitor >> fillValuesOf: aSchema from: aNode [
	"Set the enum, const, default and example values as JSON text. The 3.1 examples array is left to the extensions."

	(aNode includesKey: 'enum') ifTrue: [
		aSchema enumValues: (context jsonTextOf: (aNode at: 'enum')) ].
	(aNode includesKey: 'const') ifTrue: [
		aSchema constValue: (context jsonTextOf: (aNode at: 'const')) ].
	(aNode includesKey: 'default') ifTrue: [
		aSchema defaultValue: (context jsonTextOf: (aNode at: 'default')) ].
	(aNode includesKey: 'example') ifTrue: [
		aSchema exampleValue: (context jsonTextOf: (aNode at: 'example')) ]
]

{ #category : 'initialization' }
FamixOpenApiSchemaVisitor >> initialize [

	super initialize.
	pending := OrderedCollection new
]

{ #category : 'pass 1: creation' }
FamixOpenApiSchemaVisitor >> isPureReference: aNode [
	"Answer whether aNode only designates another schema: an object with a $ref string and, in OpenAPI 3.1, no other key (a 3.1 node with siblings is a schema of its own whose allOf holds the target; in Swagger 2 and 3.0 the siblings are ignored)."

	^ aNode isDictionary and: [
		  (aNode at: '$ref' ifAbsent: [ nil ]) isString and: [
			  self specVersion isOpenApi31 not or: [ aNode size = 1 ] ] ]
]

{ #category : 'pass 2: discriminator and xml' }
FamixOpenApiSchemaVisitor >> mappingNamed: aKey value: aValue at: aPointer [
	"Answer the DiscriminatorMapping of aKey: its value as written and its schema. A short name designates a component schema; a target that cannot be resolved is reported as discriminatorUnresolved."

	| mapping target |
	mapping := self
		           newEntity: OPDiscriminatorMapping
		           named: aKey
		           pointer: aPointer.
	aValue isString ifFalse: [
		context wrongNodeAt: aPointer expecting: 'a string' found: aValue.
		^ mapping ].
	mapping value: aValue.
	target := context
		          resolveQuietly: (self referenceForMappingValue: aValue)
		          at: aPointer
		          expecting: OPSchema.
	target
		ifNil: [
			self diagnostics
				warning: #discriminatorUnresolved
				pointer: aPointer
				message: 'Cannot resolve the mapping target ' , aValue printString ]
		ifNotNil: [ mapping schema: target ].
	^ mapping
]

{ #category : 'pass 2: discriminator and xml' }
FamixOpenApiSchemaVisitor >> referenceForMappingValue: aValue [
	"Answer the reference designated by a mapping value: the value itself when it is a reference or a path, else the component schema of that name."

	^ ((aValue includes: $/) or: [ aValue beginsWith: '#' ])
		  ifTrue: [ aValue ]
		  ifFalse: [
			  '#/components/schemas/'
			  , (FamixOpenApiJsonPointer encodeToken: aValue) ]
]

{ #category : 'pass 1: creation' }
FamixOpenApiSchemaVisitor >> registerAliasFrom: aReferenceNode at: aPointer [
	"Register the node at aPointer, a reference, as an alias so that pointers into it resolve to the target; report the siblings of the $ref that are ignored."

	aReferenceNode size > 1 ifTrue: [
		self diagnostics
			info: #refSiblingsIgnored
			pointer: aPointer
			message: 'Keys next to $ref are ignored: '
				, (aReferenceNode keys copyWithout: '$ref') asArray printString ].
	context registerAlias: aPointer to: (aReferenceNode at: '$ref')
]

{ #category : 'pass 2: filling' }
FamixOpenApiSchemaVisitor >> requiredNamesIn: aNode at: aPointer [
	"Answer the Array of the required property names of the schema aNode. A boolean required (a parameter-like mistake of Swagger 2 and 3.0) is ignored with a diagnostic."

	| value |
	value := aNode at: 'required' ifAbsent: [ ^ #(  ) ].
	(context isList: value) ifTrue: [
		^ (value select: #isString) asArray ].
	value ifNotNil: [
		context
			wrongNodeAt: (self pointer: aPointer appending: 'required')
			expecting: 'an array of property names'
			found: value ].
	^ #(  )
]

{ #category : 'entry points' }
FamixOpenApiSchemaVisitor >> schemaFrom: aNode at: aPointer [
	"Answer the Schema described by aNode located at aPointer, created, registered and filled at once: the shared target when aNode is only a reference (nil when it cannot be resolved), nil when aNode is not an object. For the schemas met inside paths, parameters, responses, and so on."

	| schema |
	(self isPureReference: aNode) ifTrue: [
		self createSchemaFrom: aNode at: aPointer.
		^ self entityFor: aNode at: aPointer ].
	schema := self createSchemaFrom: aNode at: aPointer.
	self fillPending.
	^ schema
]

{ #category : 'pass 1: creation' }
FamixOpenApiSchemaVisitor >> schemasBasePointer [
	"Answer the document pointer of the component schemas."

	^ self specVersion isSwagger2
		  ifTrue: [ '#/definitions' ]
		  ifFalse: [ '#/components/schemas' ]
]

{ #category : 'pass 2: filling' }
FamixOpenApiSchemaVisitor >> schemasInListAt: aKey of: aNode at: aPointer [
	"Answer the Array of the Schemas of the elements of the array under aKey (the ones that could not be resolved are left out)."

	| list base |
	list := self listAt: aKey in: aNode at: aPointer.
	list ifNil: [ ^ #(  ) ].
	base := self pointer: aPointer appending: aKey.
	^ (list withIndexCollect: [ :each :position |
		   self
			   entityFor: each
			   at: (self pointer: base appending: position - 1) ]) reject:
		  #isNil
]

{ #category : 'pass 1: creation' }
FamixOpenApiSchemaVisitor >> schemasSection [
	"Answer the JSON object holding the component schemas (components.schemas, or definitions in Swagger 2), or nil."

	| holder |
	self specVersion isSwagger2 ifTrue: [
		^ self dictionaryAt: 'definitions' in: self json at: '#' ].
	holder := self json isDictionary
		          ifTrue: [ self json at: 'components' ifAbsent: [ nil ] ]
		          ifFalse: [ nil ].
	holder isDictionary ifFalse: [ ^ nil ].
	^ self dictionaryAt: 'schemas' in: holder at: '#/components'
]

{ #category : 'pass 1: creation' }
FamixOpenApiSchemaVisitor >> visit [
	"Read the component schemas: create them all, then fill them."

	self createComponentSchemas.
	self fillPending
]

{ #category : 'pass 2: discriminator and xml' }
FamixOpenApiSchemaVisitor >> xmlIn: aNode at: aPointer [
	"Answer the XmlElement described under the xml key of aNode, or nil."

	| node pointer xml |
	node := self dictionaryAt: 'xml' in: aNode at: aPointer.
	node ifNil: [ ^ nil ].
	pointer := self pointer: aPointer appending: 'xml'.
	xml := self
		       newEntity: OPXmlElement
		       named: (self stringAt: 'name' in: node at: pointer)
		       pointer: pointer.
	xml
		namespace: (self stringAt: 'namespace' in: node at: pointer);
		prefix: (self stringAt: 'prefix' in: node at: pointer);
		attribute: (self booleanAt: 'attribute' in: node at: pointer);
		wrapped: (self booleanAt: 'wrapped' in: node at: pointer);
		extensions: (self
				 extensionsOf: node
				 known: #( 'name' 'namespace' 'prefix' 'attribute' 'wrapped' )
				 at: pointer).
	^ xml
]
