"
I read the root of a document: the OpenApi entity (versions, dialect, $self), its Info (Contact, License), servers (with variables), tags, external documentation, specification extensions and the empty Components skeleton. The other top level keys (paths, webhooks, security, the sections of the components other than the schemas, and the Swagger 2 parameters, responses, securityDefinitions, consumes and produces) are left to the visitors of the next steps: see #keysHandledByLaterSteps.
"
Class {
	#name : 'FamixOpenApiDocumentVisitor',
	#superclass : 'FamixOpenApiNodeVisitor',
	#category : 'Famix-OpenApi-Importer',
	#package : 'Famix-OpenApi-Importer'
}

{ #category : 'visiting' }
FamixOpenApiDocumentVisitor >> contactIn: anInfoNode [
	"Answer the Contact of the Info node, or nil."

	| node contact |
	node := self dictionaryAt: 'contact' in: anInfoNode at: '#/info'.
	node ifNil: [ ^ nil ].
	contact := self
		           newEntity: OPContact
		           named:
		           (self stringAt: 'name' in: node at: '#/info/contact')
		           pointer: '#/info/contact'.
	contact
		url: (self stringAt: 'url' in: node at: '#/info/contact');
		email: (self stringAt: 'email' in: node at: '#/info/contact');
		extensions: (self
				 extensionsOf: node
				 known: #( 'name' 'url' 'email' )
				 at: '#/info/contact').
	context recordSourceTextOf: contact from: node category: #inline.
	^ contact
]

{ #category : 'visiting' }
FamixOpenApiDocumentVisitor >> fillRoot: aRoot [
	"Set the attributes of the root: versions, dialect, $self and extensions."

	aRoot
		sourceVersion: self specVersion sourceVersion;
		openapiVersion: self specVersion canonicalVersion;
		jsonSchemaDialect:
			(self stringAt: 'jsonSchemaDialect' in: self json at: '#');
		selfUrl: (self stringAt: '$self' in: self json at: '#');
		extensions:
			(self extensionsOf: self json known: self knownRootKeys at: '#').
	context recordSourceTextOf: aRoot from: self json category: #root
]

{ #category : 'visiting' }
FamixOpenApiDocumentVisitor >> keysReadHere [
	"Answer the top level keys read by this visitor and the ones it delegates (the schemas, the paths, the webhooks, the security)."

	^ self specVersion isSwagger2
		  ifTrue: [
		  #( 'swagger' 'info' 'tags' 'externalDocs' 'paths' 'security' ) ]
		  ifFalse: [
			  #( 'openapi' 'info' 'jsonSchemaDialect' '$self' 'servers'
			     'tags' 'externalDocs' 'paths' 'webhooks' 'security' 'components' ) ]
]

{ #category : 'known keys' }
FamixOpenApiDocumentVisitor >> knownComponentKeys [
	"Answer the keys of a components object: the schemas and the other sections, read by the components visitor."

	^ #( 'schemas' 'responses' 'parameters' 'examples' 'requestBodies'
	     'headers' 'securitySchemes' 'links' 'callbacks' 'pathItems' )
]

{ #category : 'known keys' }
FamixOpenApiDocumentVisitor >> knownRootKeys [
	"Answer the top level keys that are not unknown: the ones read here and the Swagger 2 ones."

	^ self keysReadHere , self swagger2RootKeys
]

{ #category : 'visiting' }
FamixOpenApiDocumentVisitor >> licenseIn: anInfoNode [
	"Answer the License of the Info node, or nil. Its identifier has no slot: it goes to the extensions."

	| node license |
	node := self dictionaryAt: 'license' in: anInfoNode at: '#/info'.
	node ifNil: [ ^ nil ].
	license := self
		           newEntity: OPLicense
		           named:
		           (self stringAt: 'name' in: node at: '#/info/license')
		           pointer: '#/info/license'.
	license
		url: (self stringAt: 'url' in: node at: '#/info/license');
		extensions: (context
				 extensionsTextOf: node
				 known: #( 'name' 'url' 'identifier' )
				 extra: #( 'identifier' )
				 unmodelled: #(  )
				 at: '#/info/license').
	context recordSourceTextOf: license from: node category: #inline.
	^ license
]

{ #category : 'visiting' }
FamixOpenApiDocumentVisitor >> swagger2RootKeys [
	"Answer the top level keys that only Swagger 2 documents have (the others are read by the visitors of the paths, the security and the components). They are not reported as unknown keywords."

	^ self specVersion isSwagger2
		  ifTrue: [
			  #( 'host' 'basePath' 'schemes' 'consumes' 'produces' 'definitions'
			     'parameters' 'responses' 'securityDefinitions' ) ]
		  ifFalse: [ #(  ) ]
]

{ #category : 'visiting' }
FamixOpenApiDocumentVisitor >> tagFrom: aNode at: aPointer [
	"Answer the Tag described by aNode."

	| tag |
	tag := self
		       newEntity: OPTag
		       named: (self stringAt: 'name' in: aNode at: aPointer)
		       pointer: aPointer.
	tag
		description: (self stringAt: 'description' in: aNode at: aPointer);
		externalDocs: (self externalDocsIn: aNode at: aPointer);
		extensions: (self
				 extensionsOf: aNode
				 known: #( 'name' 'description' 'externalDocs' )
				 at: aPointer).
	context recordSourceTextOf: tag from: aNode category: #inline.
	^ tag
]

{ #category : 'visiting' }
FamixOpenApiDocumentVisitor >> visit [
	"Read the root entity and what hangs directly from it: info, servers, tags, external documentation, extensions and the components skeleton. The root is named after the info title, or 'openapi' when there is none."

	| root |
	root := self newEntity: OPOpenApi named: nil pointer: '#'.
	context openApi: root.
	self fillRoot: root.
	self guard: [ self visitInfo ] at: '#/info'.
	root name ifNil: [ root name: 'openapi' ].
	self guard: [ self visitServers ] at: '#/servers'.
	self guard: [ self visitTags ] at: '#/tags'.
	self
		guard: [
		root externalDocs: (self externalDocsIn: self json at: '#') ]
		at: '#/externalDocs'.
	self guard: [ self visitComponentsSkeleton ] at: '#/components'
]

{ #category : 'visiting' }
FamixOpenApiDocumentVisitor >> visitComponentsSkeleton [
	"Create the Components entity when the document has components (Swagger 2: definitions, parameters, responses or securityDefinitions at the root) and keep its extensions. Its sections are filled by the visitors of each kind of component."

	| node |
	self specVersion isSwagger2 ifTrue: [
		(#( 'definitions' 'parameters' 'responses' 'securityDefinitions' )
			 anySatisfy: [ :each | self json includesKey: each ]) ifTrue: [
			context ensureComponents ].
		^ self ].
	node := self dictionaryAt: 'components' in: self json at: '#'.
	node ifNil: [ ^ self ].
	context ensureComponents extensions: (self
			 extensionsOf: node
			 known: self knownComponentKeys
			 at: '#/components').
	context
		recordSourceTextOf: context components
		from: node
		category: #root
]

{ #category : 'visiting' }
FamixOpenApiDocumentVisitor >> visitInfo [
	"Read the Info with its Contact and License. The Info is named after its title, limited in length, or 'info' when the document has no title or a blank one; the OpenApi root takes the title."

	| node info title |
	node := self dictionaryAt: 'info' in: self json at: '#'.
	node ifNil: [ ^ self ].
	title := self stringAt: 'title' in: node at: '#/info'.
	info := self
		        newEntity: OPInfo
		        named:
		        (FamixOpenApiNaming nameFromAny: { title } fallback: 'info')
		        pointer: '#/info'.
	info
		title: title;
		version: (self stringAt: 'version' in: node at: '#/info');
		description: (self stringAt: 'description' in: node at: '#/info');
		termsOfService:
			(self stringAt: 'termsOfService' in: node at: '#/info');
		contact: (self contactIn: node);
		license: (self licenseIn: node);
		extensions: (context
				 extensionsTextOf: node
				 known:
					 #( 'title' 'version' 'description' 'termsOfService'
					    'contact' 'license' )
				 extra: #( 'summary' )
				 unmodelled: #(  )
				 at: '#/info').
	context recordSourceTextOf: info from: node category: #inline.
	self openApi info: info.
	self openApi name: title
]

{ #category : 'visiting' }
FamixOpenApiDocumentVisitor >> visitServers [
	"Read the servers as the version normalises them (Swagger 2 host, basePath and schemes become servers; a missing list gives the default server)."

	| servers |
	servers := self specVersion serversFrom: self json.
	servers withIndexDo: [ :node :position |
		| pointer |
		pointer := self pointer: '#/servers' appending: position - 1.
		self
			guard: [
			self openApi addServer: (self serverFrom: node at: pointer) ]
			at: pointer ]
]

{ #category : 'visiting' }
FamixOpenApiDocumentVisitor >> visitTags [
	"Read the tags declared by the document."

	| tags |
	tags := self listAt: 'tags' in: self json at: '#'.
	tags ifNil: [ ^ self ].
	tags withIndexDo: [ :node :position |
		| pointer |
		pointer := self pointer: '#/tags' appending: position - 1.
		node isDictionary
			ifTrue: [
				self
					guard: [ self openApi addTag: (self tagFrom: node at: pointer) ]
					at: pointer ]
			ifFalse: [
			context wrongNodeAt: pointer expecting: 'an object' found: node ] ]
]
