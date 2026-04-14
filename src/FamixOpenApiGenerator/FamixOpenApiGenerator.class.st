Class {
	#name : 'FamixOpenApiGenerator',
	#superclass : 'FamixMetamodelGenerator',
	#instVars : [
		'entities',
		'traits'
	],
	#category : 'FamixOpenApiGenerator',
	#package : 'FamixOpenApiGenerator'
}

{ #category : 'accessing' }
FamixOpenApiGenerator class >> packageName [
    ^ #'Famix-OpenAPI-Model'
]

{ #category : 'accessing' }
FamixOpenApiGenerator class >> prefix [
    ^ #'OP'
]

{ #category : 'accessing' }
FamixOpenApiGenerator class >> submetamodels [ 
	^ { FamixMooseQueryGenerator . FamixGenerator }
]

{ #category : 'definition' }
FamixOpenApiGenerator >> defineClasses [
    super defineClasses.
    entities := Dictionary new.
    self defineEntityNamed: #ContainedCollections.
    self defineEntityNamed: #Api.
    self defineEntityNamed: #Components.
    self defineEntityNamed: #Info.
    self defineEntityNamed: #Contact.
    self defineEntityNamed: #License.
    self defineEntityNamed: #Path.
    self defineEntityNamed: #Operation.
    self defineEntityNamed: #ExternalDocs.
    self defineEntityNamed: #Parameter.
    self defineEntityNamed: #ItemsDefinition.
    self defineEntityNamed: #Schema.
    self defineEntityNamed: #Response.
    self defineEntityNamed: #Header.
    self defineEntityNamed: #Tag.
    self defineEntityNamed: #SecurityScheme.
    self defineEntityNamed: #Example.
    self defineEntityNamed: #RequestBody.
    self defineEntityNamed: #MediaType.
    self defineEntityNamed: #Link.
    self defineEntityNamed: #Callback.
    self defineEntityNamed: #XMLElement.
    self defineEntityNamed: #SecurityScope.
    self defineEntityNamed: #SecurityRequirement.
    self defineEntityNamed: #Property.
    self defineEntityNamed: #ResponseEntry.
    self defineEntityNamed: #SchemaEntry.
    self defineEntityNamed: #ResponseDefinitionEntry.
    self defineEntityNamed: #ParameterEntry.
    self defineEntityNamed: #SecuritySchemeEntry.
    self defineEntityNamed: #MediaTypeEntry.
    self defineEntityNamed: #RequestBodyEntry.
    self defineEntityNamed: #HeaderEntry.
    self defineEntityNamed: #ExampleEntry.
    self defineEntityNamed: #LinkEntry.
    self defineEntityNamed: #CallbackEntry.
    self defineEntityNamed: #RequiredSecurityScheme.
]

{ #category : 'private' }
FamixOpenApiGenerator >> defineEntityNamed: aSymbol [
    entities at: aSymbol put: (builder newClassNamed: aSymbol comment: 'Generated from openapi2.ecore')
]

{ #category : 'definition' }
FamixOpenApiGenerator >> defineHierarchy [
    super defineHierarchy.
    #(
        ContainedCollections Api Components Info Contact License Path Operation
        ExternalDocs Parameter ItemsDefinition Schema Response Header Tag
        SecurityScheme Example RequestBody MediaType Link Callback XMLElement
        SecurityScope SecurityRequirement Property ResponseEntry SchemaEntry
        ResponseDefinitionEntry ParameterEntry SecuritySchemeEntry MediaTypeEntry
        RequestBodyEntry HeaderEntry ExampleEntry LinkEntry CallbackEntry
        RequiredSecurityScheme)
        do: [ :entityName | (self entityNamed: entityName) --|> #TNamedEntity ].
    #(
        ContainedCollections Api Components Info Contact License Path Operation
        ExternalDocs Parameter ItemsDefinition Schema Response Header Tag
        SecurityScheme Example RequestBody MediaType Link Callback XMLElement
        SecurityScope SecurityRequirement Property ResponseEntry SchemaEntry
        ResponseDefinitionEntry ParameterEntry SecuritySchemeEntry MediaTypeEntry
        RequestBodyEntry HeaderEntry ExampleEntry LinkEntry CallbackEntry
        RequiredSecurityScheme)
        do: [ :entityName | (self entityNamed: entityName) --|> (self traitNamed: #SourceText) ].
    (self entityNamed: #Api) --|> (self traitNamed: #ExternalDocsContainer).
    (self entityNamed: #Api) --|> (self traitNamed: #SecurityContainer).
    (self entityNamed: #Path) --|> (self traitNamed: #ParameterContainer).
    (self entityNamed: #Path) --|> (self traitNamed: #Referenceable).
    (self entityNamed: #Operation) --|> (self traitNamed: #ParameterContainer).
    (self entityNamed: #Operation) --|> (self traitNamed: #ExternalDocsContainer).
    (self entityNamed: #Operation) --|> (self traitNamed: #SecurityContainer).
    (self entityNamed: #Operation) --|> (self traitNamed: #ResponseContainer).
    (self entityNamed: #RequestBody) --|> (self traitNamed: #ContentContainer).
    (self entityNamed: #RequestBody) --|> (self traitNamed: #Referenceable).
    (self entityNamed: #Parameter) --|> (self traitNamed: #SchemaContainer).
    (self entityNamed: #Parameter) --|> (self traitNamed: #JSONSchemaSubset).
    (self entityNamed: #Parameter) --|> (self traitNamed: #ArrayContainer).
    (self entityNamed: #Parameter) --|> (self traitNamed: #Referenceable).
    (self entityNamed: #ItemsDefinition) --|> (self traitNamed: #JSONSchemaSubset).
    (self entityNamed: #ItemsDefinition) --|> (self traitNamed: #ArrayContainer).
    (self entityNamed: #Schema) --|> (self traitNamed: #JSONSchemaSubset).
    (self entityNamed: #Schema) --|> (self traitNamed: #SchemaContainer).
    (self entityNamed: #Schema) --|> (self traitNamed: #ExternalDocsContainer).
    (self entityNamed: #Schema) --|> (self traitNamed: #Referenceable).
    (self entityNamed: #Response) --|> (self traitNamed: #SchemaContainer).
    (self entityNamed: #Response) --|> (self traitNamed: #Referenceable).
    (self entityNamed: #Response) --|> (self traitNamed: #ContentContainer).
    (self entityNamed: #Header) --|> (self traitNamed: #JSONSchemaSubset).
    (self entityNamed: #Header) --|> (self traitNamed: #ArrayContainer).
    (self entityNamed: #Header) --|> (self traitNamed: #Referenceable).
    (self entityNamed: #Tag) --|> (self traitNamed: #ExternalDocsContainer).
    (self entityNamed: #Example) --|> (self traitNamed: #Referenceable).
    (self entityNamed: #Link) --|> (self traitNamed: #Referenceable).
    (self entityNamed: #Callback) --|> (self traitNamed: #Referenceable).
    (self entityNamed: #SecurityScheme) --|> (self traitNamed: #Referenceable).
    (self entityNamed: #Property) --|> (self traitNamed: #SchemaContainer).
    (self entityNamed: #SchemaEntry) --|> (self traitNamed: #SchemaContainer).
    (self entityNamed: #ResponseDefinitionEntry) --|> (self traitNamed: #ResponseContainer).
    (self entityNamed: #ParameterEntry) --|> (self traitNamed: #ParameterContainer).
]

{ #category : 'definition' }
FamixOpenApiGenerator >> defineProperties [
    super defineProperties.
    (((self traitNamed: #JSONSchemaSubset) property: #type type: #String) comment: 'Attribute type from JSONSchemaSubset [1]').
    (((self traitNamed: #JSONSchemaSubset) property: #format type: #String) comment: 'Attribute format from JSONSchemaSubset [1]').
    (((self traitNamed: #JSONSchemaSubset) property: #description type: #String) comment: 'Attribute description from JSONSchemaSubset [1]').
    (((self traitNamed: #JSONSchemaSubset) property: #maximum type: #Number) comment: 'Attribute maximum from JSONSchemaSubset [1]').
    (((self traitNamed: #JSONSchemaSubset) property: #exclusiveMaximum type: #Boolean) comment: 'Attribute exclusiveMaximum from JSONSchemaSubset [1]').
    (((self traitNamed: #JSONSchemaSubset) property: #minimum type: #Number) comment: 'Attribute minimum from JSONSchemaSubset [1]').
    (((self traitNamed: #JSONSchemaSubset) property: #exclusiveMinimum type: #Boolean) comment: 'Attribute exclusiveMinimum from JSONSchemaSubset [1]').
    (((self traitNamed: #JSONSchemaSubset) property: #maxLength type: #Number) comment: 'Attribute maxLength from JSONSchemaSubset [1]').
    (((self traitNamed: #JSONSchemaSubset) property: #minLength type: #Number) comment: 'Attribute minLength from JSONSchemaSubset [1]').
    (((self traitNamed: #JSONSchemaSubset) property: #pattern type: #String) comment: 'Attribute pattern from JSONSchemaSubset [1]').
    (((self traitNamed: #JSONSchemaSubset) property: #maxItems type: #Number) comment: 'Attribute maxItems from JSONSchemaSubset [1]').
    (((self traitNamed: #JSONSchemaSubset) property: #minItems type: #Number) comment: 'Attribute minItems from JSONSchemaSubset [1]').
    (((self traitNamed: #JSONSchemaSubset) property: #uniqueItems type: #Boolean) comment: 'Attribute uniqueItems from JSONSchemaSubset [1]').
    (((self traitNamed: #JSONSchemaSubset) property: #enum type: #Object) comment: 'Attribute enum from JSONSchemaSubset [*]').
    (((self traitNamed: #JSONSchemaSubset) property: #default type: #String) comment: 'Attribute default from JSONSchemaSubset [1]').
    (((self traitNamed: #JSONSchemaSubset) property: #multipleOf type: #Number) comment: 'Attribute multipleOf from JSONSchemaSubset [1]').
    (((self entityNamed: #Api) property: #openapi type: #String) comment: 'Attribute openapi from API [1]').
    (((self entityNamed: #Api) property: #host type: #String) comment: 'Attribute host from API [1]').
    (((self entityNamed: #Api) property: #basePath type: #String) comment: 'Attribute basePath from API [1]').
    (((self entityNamed: #Api) property: #schemes type: #Object) comment: 'Attribute schemes from API [*]').
    (((self entityNamed: #Api) property: #consumes type: #Object) comment: 'Attribute consumes from API [*]').
    (((self entityNamed: #Api) property: #produces type: #Object) comment: 'Attribute produces from API [*]').
    (((self entityNamed: #Info) property: #title type: #String) comment: 'Attribute title from Info [1]').
    (((self entityNamed: #Info) property: #description type: #String) comment: 'Attribute description from Info [1]').
    (((self entityNamed: #Info) property: #termsOfService type: #String) comment: 'Attribute termsOfService from Info [1]').
    (((self entityNamed: #Info) property: #version type: #String) comment: 'Attribute version from Info [1]').
    (((self entityNamed: #Contact) property: #url type: #String) comment: 'Attribute url from Contact [1]').
    (((self entityNamed: #Contact) property: #email type: #String) comment: 'Attribute email from Contact [1]').
    (((self entityNamed: #License) property: #url type: #String) comment: 'Attribute url from License [1]').
    (((self entityNamed: #Path) property: #relativePath type: #String) comment: 'Attribute relativePath from Path [1]').
    (((self entityNamed: #Path) property: #summary type: #String) comment: 'Attribute summary from Path [1]').
    (((self entityNamed: #Path) property: #description type: #String) comment: 'Attribute description from Path [1]').
    (((self entityNamed: #Operation) property: #tagReferences type: #Object) comment: 'Attribute tagReferences from Operation [*]').
    (((self entityNamed: #Operation) property: #summary type: #String) comment: 'Attribute summary from Operation [1]').
    (((self entityNamed: #Operation) property: #description type: #String) comment: 'Attribute description from Operation [1]').
    (((self entityNamed: #Operation) property: #operationId type: #String) comment: 'Attribute operationId from Operation [1]').
    (((self entityNamed: #Operation) property: #consumes type: #Object) comment: 'Attribute consumes from Operation [*]').
    (((self entityNamed: #Operation) property: #produces type: #Object) comment: 'Attribute produces from Operation [*]').
    (((self entityNamed: #Operation) property: #schemes type: #Object) comment: 'Attribute schemes from Operation [*]').
    (((self entityNamed: #Operation) property: #deprecated type: #Boolean) comment: 'Attribute deprecated from Operation [1]').
    (((self entityNamed: #ExternalDocs) property: #description type: #String) comment: 'Attribute description from ExternalDocs [1]').
    (((self entityNamed: #ExternalDocs) property: #url type: #String) comment: 'Attribute url from ExternalDocs [1]').
    (((self entityNamed: #Parameter) property: #location type: #String) comment: 'Attribute location from Parameter [1]').
    (((self entityNamed: #Parameter) property: #required type: #Boolean) comment: 'Attribute required from Parameter [1]').
    (((self entityNamed: #Parameter) property: #allowEmplyValue type: #Boolean) comment: 'Attribute allowEmplyValue from Parameter [1]').
    (((self entityNamed: #Parameter) property: #example type: #String) comment: 'Attribute example from Parameter [1]').
    (((self entityNamed: #Schema) property: #title type: #String) comment: 'Attribute title from Schema [1]').
    (((self entityNamed: #Schema) property: #maxProperties type: #Number) comment: 'Attribute maxProperties from Schema [1]').
    (((self entityNamed: #Schema) property: #minProperties type: #Number) comment: 'Attribute minProperties from Schema [1]').
    (((self entityNamed: #Schema) property: #example type: #String) comment: 'Attribute example from Schema [1]').
    (((self entityNamed: #Schema) property: #discriminator type: #String) comment: 'Attribute discriminator from Schema [1]').
    (((self entityNamed: #Schema) property: #readOnly type: #Boolean) comment: 'Attribute readOnly from Schema [1]').
    (((self entityNamed: #Schema) property: #additonalPropertiesAllowed type: #Boolean) comment: 'Attribute additonalPropertiesAllowed from Schema [1]').
    (((self entityNamed: #Response) property: #description type: #String) comment: 'Attribute description from Response [1]').
    (((self entityNamed: #Tag) property: #description type: #String) comment: 'Attribute description from Tag [1]').
    (((self entityNamed: #SecurityScheme) property: #type type: #String) comment: 'Attribute type from SecurityScheme [1]').
    (((self entityNamed: #SecurityScheme) property: #description type: #String) comment: 'Attribute description from SecurityScheme [1]').
    (((self entityNamed: #SecurityScheme) property: #location type: #String) comment: 'Attribute location from SecurityScheme [1]').
    (((self entityNamed: #SecurityScheme) property: #scheme type: #String) comment: 'Attribute scheme from SecurityScheme [1]').
    (((self entityNamed: #SecurityScheme) property: #bearerFormat type: #String) comment: 'Attribute bearerFormat from SecurityScheme [1]').
    (((self entityNamed: #SecurityScheme) property: #openIdConnectUrl type: #String) comment: 'Attribute openIdConnectUrl from SecurityScheme [1]').
    (((self entityNamed: #SecurityScheme) property: #flow type: #String) comment: 'Attribute flow from SecurityScheme [1]').
    (((self entityNamed: #SecurityScheme) property: #authorizationUrl type: #String) comment: 'Attribute authorizationUrl from SecurityScheme [1]').
    (((self entityNamed: #SecurityScheme) property: #tokenUrl type: #String) comment: 'Attribute tokenUrl from SecurityScheme [1]').
    (((self entityNamed: #Example) property: #mimeType type: #String) comment: 'Attribute mimeType from Example [1]').
    (((self entityNamed: #Example) property: #value type: #String) comment: 'Attribute value from Example [1]').
    (((self entityNamed: #RequestBody) property: #description type: #String) comment: 'Attribute description from RequestBody [1]').
    (((self entityNamed: #RequestBody) property: #required type: #Boolean) comment: 'Attribute required from RequestBody [1]').
    (((self entityNamed: #MediaType) property: #example type: #Object) comment: 'Attribute example from MediaType [1]').
    (((self entityNamed: #Link) property: #operationRef type: #String) comment: 'Attribute operationRef from Link [1]').
    (((self entityNamed: #Link) property: #operationId type: #String) comment: 'Attribute operationId from Link [1]').
    (((self entityNamed: #Link) property: #requestBody type: #String) comment: 'Attribute requestBody from Link [1]').
    (((self entityNamed: #Link) property: #description type: #String) comment: 'Attribute description from Link [1]').
    (((self entityNamed: #XMLElement) property: #namespace type: #String) comment: 'Attribute namespace from XMLElement [1]').
    (((self entityNamed: #XMLElement) property: #prefix type: #String) comment: 'Attribute prefix from XMLElement [1]').
    (((self entityNamed: #XMLElement) property: #attribute type: #Boolean) comment: 'Attribute attribute from XMLElement [1]').
    (((self entityNamed: #XMLElement) property: #wrapped type: #Boolean) comment: 'Attribute wrapped from XMLElement [1]').
    (((self entityNamed: #SecurityScope) property: #description type: #String) comment: 'Attribute description from SecurityScope [1]').
    (((self traitNamed: #ArrayContainer) property: #collectionFormat type: #String) comment: 'Attribute collectionFormat from ArrayContainer [1]').
    (((self traitNamed: #Referenceable) property: #ref type: #String) comment: 'Attribute ref from Reference Object [1]').
    (((self traitNamed: #SourceText) property: #sourceText type: #String) comment: 'Attribute sourceText from original JSON node [1]').
    (((self entityNamed: #Property) property: #enum type: #Object) comment: 'Attribute enum from Property [*] (array of strings)').
    (((self entityNamed: #Property) property: #required type: #Boolean) comment: 'Attribute required from Property [1]').
    (((self entityNamed: #ResponseEntry) property: #key type: #String) comment: 'Attribute key from ResponseEntry [1]').
    (((self entityNamed: #SchemaEntry) property: #key type: #String) comment: 'Attribute key from SchemaEntry [1]').
    (((self entityNamed: #ResponseDefinitionEntry) property: #key type: #String) comment: 'Attribute key from ResponseDefinitionEntry [1]').
    (((self entityNamed: #ParameterEntry) property: #key type: #String) comment: 'Attribute key from ParameterEntry [1]').
    (((self entityNamed: #SecuritySchemeEntry) property: #key type: #String) comment: 'Attribute key from SecuritySchemeEntry [1]').
    (((self entityNamed: #MediaTypeEntry) property: #key type: #String) comment: 'Attribute key from MediaTypeEntry [1]').
    (((self entityNamed: #RequestBodyEntry) property: #key type: #String) comment: 'Attribute key from RequestBodyEntry [1]').
    (((self entityNamed: #HeaderEntry) property: #key type: #String) comment: 'Attribute key from HeaderEntry [1]').
    (((self entityNamed: #ExampleEntry) property: #key type: #String) comment: 'Attribute key from ExampleEntry [1]').
    (((self entityNamed: #LinkEntry) property: #key type: #String) comment: 'Attribute key from LinkEntry [1]').
    (((self entityNamed: #CallbackEntry) property: #key type: #String) comment: 'Attribute key from CallbackEntry [1]').
]

{ #category : 'definition' }
FamixOpenApiGenerator >> defineRelations [
    super defineRelations.
    (((self entityNamed: #ContainedCollections) property: #paramters) comment: 'Reference paramters from ContainedCollections to Parameter [0..*].') <>-* (self entityNamed: #Parameter).
    (((self entityNamed: #ContainedCollections) property: #schemas) comment: 'Reference schemas from ContainedCollections to Schema [0..*].') <>-* (self entityNamed: #Schema).
    (((self entityNamed: #ContainedCollections) property: #responses) comment: 'Reference responses from ContainedCollections to Response [0..*].') <>-* (self entityNamed: #Response).
    (((self entityNamed: #Api) property: #info) comment: 'Reference info from API to Info [0..1].') <>- (self entityNamed: #Info).
    (((self entityNamed: #Api) property: #paths) comment: 'Reference paths from API to Path [0..*].') <>-* (((self entityNamed: #Path) property: #api) comment: 'Opposite reference api from Path to API [0..1].').
    (((self entityNamed: #Api) property: #components) comment: 'Reference components from API to Components [0..1].') <>- (((self entityNamed: #Components) property: #api) comment: 'Opposite reference api from Components to API [0..1].').
    (((self entityNamed: #Api) property: #definitions) comment: 'Reference definitions from API to SchemaEntry [0..*].') <>-* (self entityNamed: #SchemaEntry).
    (((self entityNamed: #Api) property: #responses) comment: 'Reference responses from API to ResponseDefinitionEntry [0..*].') <>-* (self entityNamed: #ResponseDefinitionEntry).
    (((self entityNamed: #Api) property: #securityDefinitions) comment: 'Reference securityDefinitions from API to SecuritySchemeEntry [0..*].') <>-* (self entityNamed: #SecuritySchemeEntry).
    (((self entityNamed: #Api) property: #tags) comment: 'Reference tags from API to Tag [0..*].') <>-* ((self entityNamed: #Tag) property: #anApi).
    (((self entityNamed: #Api) property: #parameters) comment: 'Reference parameters from API to ParameterEntry [0..*].') <>-* (self entityNamed: #ParameterEntry).
    (((self entityNamed: #Api) property: #containedCollections) comment: 'Reference containedCollections from API to ContainedCollections [0..1].') <>- (self entityNamed: #ContainedCollections).
    (((self entityNamed: #Components) property: #schemas) comment: 'Reference schemas from Components to SchemaEntry [0..*].') <>-* (self entityNamed: #SchemaEntry).
    (((self entityNamed: #Components) property: #responses) comment: 'Reference responses from Components to ResponseDefinitionEntry [0..*].') <>-* (self entityNamed: #ResponseDefinitionEntry).
    (((self entityNamed: #Components) property: #parameters) comment: 'Reference parameters from Components to ParameterEntry [0..*].') <>-* (self entityNamed: #ParameterEntry).
    (((self entityNamed: #Components) property: #securitySchemes) comment: 'Reference securitySchemes from Components to SecuritySchemeEntry [0..*].') <>-* (self entityNamed: #SecuritySchemeEntry).
    (((self entityNamed: #Components) property: #requestBodies) comment: 'Reference requestBodies from Components to RequestBodyEntry [0..*].') <>-* (self entityNamed: #RequestBodyEntry).
    (((self entityNamed: #Components) property: #headers) comment: 'Reference headers from Components to HeaderEntry [0..*].') <>-* (self entityNamed: #HeaderEntry).
    (((self entityNamed: #Components) property: #examples) comment: 'Reference examples from Components to ExampleEntry [0..*].') <>-* (self entityNamed: #ExampleEntry).
    (((self entityNamed: #Components) property: #links) comment: 'Reference links from Components to LinkEntry [0..*].') <>-* (self entityNamed: #LinkEntry).
    (((self entityNamed: #Components) property: #callbacks) comment: 'Reference callbacks from Components to CallbackEntry [0..*].') <>-* (self entityNamed: #CallbackEntry).
    (((self entityNamed: #Info) property: #contact) comment: 'Reference contact from Info to Contact [0..1].') <>- (self entityNamed: #Contact).
    (((self entityNamed: #Info) property: #license) comment: 'Reference license from Info to License [0..1].') <>- (self entityNamed: #License).
    (((self entityNamed: #Path) property: #get) comment: 'Reference get from Path to Operation [0..1].') <>- (self entityNamed: #Operation).
    ((((self entityNamed: #Path) property: #put) comment: 'Reference put from Path to Operation [0..1].') <>- (self entityNamed: #Operation)) right noContainer.
    ((((self entityNamed: #Path) property: #post) comment: 'Reference post from Path to Operation [0..1].') <>- (self entityNamed: #Operation)) right noContainer.
    ((((self entityNamed: #Path) property: #delete) comment: 'Reference delete from Path to Operation [0..1].') <>- (self entityNamed: #Operation)) right noContainer.
    ((((self entityNamed: #Path) property: #options) comment: 'Reference options from Path to Operation [0..1].') <>- (self entityNamed: #Operation)) right noContainer.
    ((((self entityNamed: #Path) property: #head) comment: 'Reference head from Path to Operation [0..1].') <>- (self entityNamed: #Operation)) right noContainer.
    ((((self entityNamed: #Path) property: #patch) comment: 'Reference patch from Path to Operation [0..1].') <>- (self entityNamed: #Operation)) right noContainer.
    ((((self entityNamed: #Path) property: #trace) comment: 'Reference trace from Path to Operation [0..1].') <>- (self entityNamed: #Operation)) right noContainer.
    (((self entityNamed: #Path) property: #parameters) comment: 'Reference parameters from Path to Parameter [0..*].') -* (self entityNamed: #Parameter).
    (((self entityNamed: #Operation) property: #responses) comment: 'Reference responses from Operation to ResponseEntry [1..*].') <>-* (self entityNamed: #ResponseEntry).
    (((self entityNamed: #Operation) property: #parameters) comment: 'Reference parameters from Operation to Parameter [0..*].') -* (self entityNamed: #Parameter).
    (((self entityNamed: #Operation) property: #requestBody) comment: 'Reference requestBody from Operation to RequestBody [0..1].') <>- (self entityNamed: #RequestBody).
    (((self entityNamed: #Operation) property: #callbacks) comment: 'Reference callbacks from Operation to CallbackEntry [0..*].') <>-* (self entityNamed: #CallbackEntry).
    (((self entityNamed: #Parameter) property: #declaringContext) comment: 'Reference declaringContext from Parameter to ParameterContainer [0..1].') - (self traitNamed: #ParameterContainer).
    (((self entityNamed: #Parameter) property: #schema) comment: 'Reference schema from Parameter to Schema [0..1].') - (self entityNamed: #Schema).
    (((self entityNamed: #Schema) property: #properties) comment: 'Reference properties from Schema to Property [0..*].') <>-* (((self entityNamed: #Property) property: #schema) comment: 'Opposite reference schema from Property to Schema [0..1].').
    (((self entityNamed: #Schema) property: #allOf) comment: 'Reference allOf from Schema to Schema [0..*].') -* (self entityNamed: #Schema).
    (((self entityNamed: #Schema) property: #items) comment: 'Reference items from Schema to Schema [0..1].') - (self entityNamed: #Schema).
    (((self entityNamed: #Schema) property: #xml) comment: 'Reference xml from Schema to XMLElement [0..1].') <>- (self entityNamed: #XMLElement).
    (((self entityNamed: #Schema) property: #additonalProperties) comment: 'Reference additonalProperties from Schema to Schema [0..1].') - (self entityNamed: #Schema).
    (((self entityNamed: #Schema) property: #declaringContext) comment: 'Reference declaringContext from Schema to SchemaContainer [0..1].') - (self traitNamed: #SchemaContainer).
    (((self entityNamed: #Schema) property: #tupleItems) comment: 'Reference tupleItems from Schema to Schema [0..*].') -* (self entityNamed: #Schema).
    (((self entityNamed: #Response) property: #headers) comment: 'Reference headers from Response to Header [0..*].') <>-* (self entityNamed: #Header).
    (((self entityNamed: #Response) property: #examples) comment: 'Reference examples from Response to Example [0..*].') <>-* (self entityNamed: #Example).
    (((self entityNamed: #Response) property: #declaringContext) comment: 'Reference declaringContext from Response to ResponseContainer [0..1].') - (self traitNamed: #ResponseContainer).
    (((self entityNamed: #Response) property: #schema) comment: 'Reference schema from Response to Schema [0..1].') - (self entityNamed: #Schema).
    (((self entityNamed: #Header) property: #schema) comment: 'Reference schema from Header to Schema [0..1].') - (self entityNamed: #Schema).
    (((self traitNamed: #ContentContainer) property: #content) comment: 'Reference content from ContentContainer to MediaTypeEntry [0..*].') <>-* (self entityNamed: #MediaTypeEntry).
    (((self entityNamed: #MediaType) property: #schema) comment: 'Reference schema from MediaType to Schema [0..1].') - (self entityNamed: #Schema).
    (((self entityNamed: #MediaType) property: #examples) comment: 'Reference examples from MediaType to ExampleEntry [0..*].') <>-* (self entityNamed: #ExampleEntry).
    (((self entityNamed: #SecurityScheme) property: #scopes) comment: 'Reference scopes from SecurityScheme to SecurityScope [0..*].') <>-* (self entityNamed: #SecurityScope).
    (((self traitNamed: #ExternalDocsContainer) property: #externalDocs) comment: 'Reference externalDocs from ExternalDocsContainer to ExternalDocs [0..1].') <>- (self entityNamed: #ExternalDocs).
    (((self traitNamed: #ArrayContainer) property: #items) comment: 'Reference items from ArrayContainer to ItemsDefinition [0..1].') <>- (self entityNamed: #ItemsDefinition).
    (((self entityNamed: #SecurityRequirement) property: #securitySchemes) comment: 'Reference securitySchemes from SecurityRequirement to RequiredSecurityScheme [0..*].') <>-* (self entityNamed: #RequiredSecurityScheme).
    (((self entityNamed: #ResponseEntry) property: #value) comment: 'Reference value from ResponseEntry to Response [0..1].') - (self entityNamed: #Response).
    (((self entityNamed: #SchemaEntry) property: #value) comment: 'Reference value from SchemaEntry to Schema [0..1].') - (self entityNamed: #Schema).
    (((self entityNamed: #ResponseDefinitionEntry) property: #value) comment: 'Reference value from ResponseDefinitionEntry to Response [0..1].') - (self entityNamed: #Response).
    (((self entityNamed: #ParameterEntry) property: #value) comment: 'Reference value from ParameterEntry to Parameter [0..1].') - (self entityNamed: #Parameter).
    (((self entityNamed: #MediaTypeEntry) property: #value) comment: 'Reference value from MediaTypeEntry to MediaType [0..1].') - (self entityNamed: #MediaType).
    (((self entityNamed: #RequestBodyEntry) property: #value) comment: 'Reference value from RequestBodyEntry to RequestBody [0..1].') - (self entityNamed: #RequestBody).
    (((self entityNamed: #HeaderEntry) property: #value) comment: 'Reference value from HeaderEntry to Header [0..1].') - (self entityNamed: #Header).
    (((self entityNamed: #ExampleEntry) property: #value) comment: 'Reference value from ExampleEntry to Example [0..1].') - (self entityNamed: #Example).
    (((self entityNamed: #LinkEntry) property: #value) comment: 'Reference value from LinkEntry to Link [0..1].') - (self entityNamed: #Link).
    (((self entityNamed: #CallbackEntry) property: #value) comment: 'Reference value from CallbackEntry to Callback [0..1].') - (self entityNamed: #Callback).
    (((self traitNamed: #SecurityContainer) property: #security) comment: 'Reference security from SecurityContainer to SecurityRequirement [0..*].') <>-* (self entityNamed: #SecurityRequirement).
    (((self entityNamed: #SecuritySchemeEntry) property: #value) comment: 'Reference value from SecuritySchemeEntry to SecurityScheme [0..1].') <>- (self entityNamed: #SecurityScheme).
    (((self entityNamed: #RequiredSecurityScheme) property: #securityScopes) comment: 'Reference securityScopes from RequiredSecurityScheme to SecurityScope [0..*].') -* (self entityNamed: #SecurityScope).
    (((self entityNamed: #RequiredSecurityScheme) property: #securityScheme) comment: 'Reference securityScheme from RequiredSecurityScheme to SecurityScheme [0..1].') - (self entityNamed: #SecurityScheme).
]

{ #category : 'definition' }
FamixOpenApiGenerator >> defineTraitNamed: aSymbol [
    traits at: aSymbol put: (builder newTraitNamed: aSymbol comment: 'Generated from openapi2.ecore')
]

{ #category : 'definition' }
FamixOpenApiGenerator >> defineTraits [
    super defineTraits.
    traits := Dictionary new.
    self defineTraitNamed: #JSONSchemaSubset.
    self defineTraitNamed: #ParameterContainer.
    self defineTraitNamed: #SchemaContainer.
    self defineTraitNamed: #ResponseContainer.
    self defineTraitNamed: #ExternalDocsContainer.
    self defineTraitNamed: #ArrayContainer.
    self defineTraitNamed: #SecurityContainer.
    self defineTraitNamed: #ContentContainer.
    self defineTraitNamed: #Referenceable.
    self defineTraitNamed: #SourceText.
]

{ #category : 'private' }
FamixOpenApiGenerator >> entityNamed: aSymbol [
    ^ entities at: aSymbol
]

{ #category : 'private' }
FamixOpenApiGenerator >> traitNamed: aSymbol [
    ^ traits at: aSymbol
]
