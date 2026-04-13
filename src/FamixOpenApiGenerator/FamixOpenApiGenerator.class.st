Class {
	#name : #FamixOpenApiGenerator,
	#superclass : #FamixMetamodelGenerator,
	#instVars : [
		'entities'
	],
	#category : 'FamixOpenApiGenerator'
}

{ #category : 'accessing' }
FamixOpenApiGenerator class >> packageName [
    ^ #'OpenAPI-Model'
]

{ #category : 'accessing' }
FamixOpenApiGenerator class >> prefix [
    ^ #'OAPI'
]

{ #category : 'private' }
FamixOpenApiGenerator >> entityNamed: aSymbol [
    ^ entities at: aSymbol
]

{ #category : 'private' }
FamixOpenApiGenerator >> defineEntityNamed: aSymbol [
    entities at: aSymbol put: (builder newClassNamed: aSymbol comment: 'Generated from openapi2.ecore')
]

{ #category : 'definition' }
FamixOpenApiGenerator >> defineClasses [
    super defineClasses.
    entities := Dictionary new.
    self defineEntityNamed: #JSONSchemaSubset.
    self defineEntityNamed: #ContainedCollections.
    self defineEntityNamed: #API.
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
    self defineEntityNamed: #XMLElement.
    self defineEntityNamed: #SecurityScope.
    self defineEntityNamed: #ParameterContainer.
    self defineEntityNamed: #SchemaContainer.
    self defineEntityNamed: #ResponseContainer.
    self defineEntityNamed: #ExternalDocsContainer.
    self defineEntityNamed: #ArrayContainer.
    self defineEntityNamed: #SecurityRequirement.
    self defineEntityNamed: #JSONPointer.
    self defineEntityNamed: #Property.
    self defineEntityNamed: #ResponseEntry.
    self defineEntityNamed: #SchemaEntry.
    self defineEntityNamed: #ResponseDefinitionEntry.
    self defineEntityNamed: #ParameterEntry.
    self defineEntityNamed: #SecurityContainer.
    self defineEntityNamed: #SecuritySchemeEntry.
    self defineEntityNamed: #RequiredSecurityScheme.
]

{ #category : 'definition' }
FamixOpenApiGenerator >> defineHierarchy [
    super defineHierarchy.
    (self entityNamed: #API) --|> (self entityNamed: #ExternalDocsContainer).
    (self entityNamed: #API) --|> (self entityNamed: #SecurityContainer).
    (self entityNamed: #Path) --|> (self entityNamed: #ParameterContainer).
    (self entityNamed: #Operation) --|> (self entityNamed: #ParameterContainer).
    (self entityNamed: #Operation) --|> (self entityNamed: #ExternalDocsContainer).
    (self entityNamed: #Operation) --|> (self entityNamed: #SecurityContainer).
    (self entityNamed: #Operation) --|> (self entityNamed: #ResponseContainer).
    (self entityNamed: #Parameter) --|> (self entityNamed: #SchemaContainer).
    (self entityNamed: #Parameter) --|> (self entityNamed: #JSONSchemaSubset).
    (self entityNamed: #Parameter) --|> (self entityNamed: #ArrayContainer).
    (self entityNamed: #Parameter) --|> (self entityNamed: #JSONPointer).
    (self entityNamed: #ItemsDefinition) --|> (self entityNamed: #JSONSchemaSubset).
    (self entityNamed: #ItemsDefinition) --|> (self entityNamed: #ArrayContainer).
    (self entityNamed: #Schema) --|> (self entityNamed: #JSONSchemaSubset).
    (self entityNamed: #Schema) --|> (self entityNamed: #SchemaContainer).
    (self entityNamed: #Schema) --|> (self entityNamed: #ExternalDocsContainer).
    (self entityNamed: #Schema) --|> (self entityNamed: #JSONPointer).
    (self entityNamed: #Response) --|> (self entityNamed: #SchemaContainer).
    (self entityNamed: #Response) --|> (self entityNamed: #JSONPointer).
    (self entityNamed: #Header) --|> (self entityNamed: #JSONSchemaSubset).
    (self entityNamed: #Header) --|> (self entityNamed: #ArrayContainer).
    (self entityNamed: #Tag) --|> (self entityNamed: #ExternalDocsContainer).
    (self entityNamed: #Property) --|> (self entityNamed: #JSONPointer).
    (self entityNamed: #Property) --|> (self entityNamed: #SchemaContainer).
    (self entityNamed: #SchemaEntry) --|> (self entityNamed: #SchemaContainer).
    (self entityNamed: #ResponseDefinitionEntry) --|> (self entityNamed: #ResponseContainer).
    (self entityNamed: #ParameterEntry) --|> (self entityNamed: #ParameterContainer).
]

{ #category : 'definition' }
FamixOpenApiGenerator >> defineRelations [
    super defineRelations.
    (((self entityNamed: #ContainedCollections) property: #paramters) comment: 'Reference paramters from ContainedCollections to Parameter [0..*].') <>-* (self entityNamed: #Parameter).
    (((self entityNamed: #ContainedCollections) property: #schemas) comment: 'Reference schemas from ContainedCollections to Schema [0..*].') <>-* (self entityNamed: #Schema).
    (((self entityNamed: #ContainedCollections) property: #responses) comment: 'Reference responses from ContainedCollections to Response [0..*].') <>-* (self entityNamed: #Response).
    (((self entityNamed: #API) property: #info) comment: 'Reference info from API to Info [0..1].') <>- (self entityNamed: #Info).
    (((self entityNamed: #API) property: #paths) comment: 'Reference paths from API to Path [0..*].') <>-* (((self entityNamed: #Path) property: #api) comment: 'Opposite reference api from Path to API [0..1].').
    (((self entityNamed: #API) property: #definitions) comment: 'Reference definitions from API to SchemaEntry [0..*].') <>-* (self entityNamed: #SchemaEntry).
    (((self entityNamed: #API) property: #responses) comment: 'Reference responses from API to ResponseDefinitionEntry [0..*].') <>-* (self entityNamed: #ResponseDefinitionEntry).
    (((self entityNamed: #API) property: #securityDefinitions) comment: 'Reference securityDefinitions from API to SecuritySchemeEntry [0..*].') <>-* (self entityNamed: #SecuritySchemeEntry).
    (((self entityNamed: #API) property: #tags) comment: 'Reference tags from API to Tag [0..*].') <>-* (self entityNamed: #Tag).
    (((self entityNamed: #API) property: #parameters) comment: 'Reference parameters from API to ParameterEntry [0..*].') <>-* (self entityNamed: #ParameterEntry).
    (((self entityNamed: #API) property: #containedCollections) comment: 'Reference containedCollections from API to ContainedCollections [0..1].') <>- (self entityNamed: #ContainedCollections).
    (((self entityNamed: #Info) property: #contact) comment: 'Reference contact from Info to Contact [0..1].') <>- (self entityNamed: #Contact).
    (((self entityNamed: #Info) property: #license) comment: 'Reference license from Info to License [0..1].') <>- (self entityNamed: #License).
    (((self entityNamed: #Path) property: #get) comment: 'Reference get from Path to Operation [0..1].') <>- (self entityNamed: #Operation).
    ((((self entityNamed: #Path) property: #put) comment: 'Reference put from Path to Operation [0..1].') <>- (self entityNamed: #Operation)) withoutPrimaryContainer.
    ((((self entityNamed: #Path) property: #post) comment: 'Reference post from Path to Operation [0..1].') <>- (self entityNamed: #Operation)) withoutPrimaryContainer.
    ((((self entityNamed: #Path) property: #delete) comment: 'Reference delete from Path to Operation [0..1].') <>- (self entityNamed: #Operation)) withoutPrimaryContainer.
    ((((self entityNamed: #Path) property: #options) comment: 'Reference options from Path to Operation [0..1].') <>- (self entityNamed: #Operation)) withoutPrimaryContainer.
    ((((self entityNamed: #Path) property: #head) comment: 'Reference head from Path to Operation [0..1].') <>- (self entityNamed: #Operation)) withoutPrimaryContainer.
    ((((self entityNamed: #Path) property: #patch) comment: 'Reference patch from Path to Operation [0..1].') <>- (self entityNamed: #Operation)) withoutPrimaryContainer.
    (((self entityNamed: #Path) property: #parameters) comment: 'Reference parameters from Path to Parameter [0..*].') -* (self entityNamed: #Parameter).
    (((self entityNamed: #Operation) property: #responses) comment: 'Reference responses from Operation to ResponseEntry [1..*].') <>-* (self entityNamed: #ResponseEntry).
    (((self entityNamed: #Operation) property: #parameters) comment: 'Reference parameters from Operation to Parameter [0..*].') -* (self entityNamed: #Parameter).
    (((self entityNamed: #Parameter) property: #declaringContext) comment: 'Reference declaringContext from Parameter to ParameterContainer [0..1].') - (self entityNamed: #ParameterContainer).
    (((self entityNamed: #Parameter) property: #schema) comment: 'Reference schema from Parameter to Schema [0..1].') - (self entityNamed: #Schema).
    (((self entityNamed: #Schema) property: #properties) comment: 'Reference properties from Schema to Property [0..*].') <>-* (((self entityNamed: #Property) property: #schema) comment: 'Opposite reference schema from Property to Schema [0..1].').
    (((self entityNamed: #Schema) property: #allOf) comment: 'Reference allOf from Schema to Schema [0..*].') -* (self entityNamed: #Schema).
    (((self entityNamed: #Schema) property: #items) comment: 'Reference items from Schema to Schema [0..1].') - (self entityNamed: #Schema).
    (((self entityNamed: #Schema) property: #xml) comment: 'Reference xml from Schema to XMLElement [0..1].') <>- (self entityNamed: #XMLElement).
    (((self entityNamed: #Schema) property: #additonalProperties) comment: 'Reference additonalProperties from Schema to Schema [0..1].') - (self entityNamed: #Schema).
    (((self entityNamed: #Schema) property: #declaringContext) comment: 'Reference declaringContext from Schema to SchemaContainer [0..1].') - (self entityNamed: #SchemaContainer).
    (((self entityNamed: #Schema) property: #tupleItems) comment: 'Reference tupleItems from Schema to Schema [0..*].') -* (self entityNamed: #Schema).
    (((self entityNamed: #Response) property: #headers) comment: 'Reference headers from Response to Header [0..*].') <>-* (self entityNamed: #Header).
    (((self entityNamed: #Response) property: #examples) comment: 'Reference examples from Response to Example [0..*].') <>-* (self entityNamed: #Example).
    (((self entityNamed: #Response) property: #declaringContext) comment: 'Reference declaringContext from Response to ResponseContainer [0..1].') - (self entityNamed: #ResponseContainer).
    (((self entityNamed: #Response) property: #schema) comment: 'Reference schema from Response to Schema [0..1].') - (self entityNamed: #Schema).
    (((self entityNamed: #SecurityScheme) property: #scopes) comment: 'Reference scopes from SecurityScheme to SecurityScope [0..*].') <>-* (self entityNamed: #SecurityScope).
    (((self entityNamed: #ExternalDocsContainer) property: #externalDocs) comment: 'Reference externalDocs from ExternalDocsContainer to ExternalDocs [0..1].') <>- (self entityNamed: #ExternalDocs).
    (((self entityNamed: #ArrayContainer) property: #items) comment: 'Reference items from ArrayContainer to ItemsDefinition [0..1].') <>- (self entityNamed: #ItemsDefinition).
    (((self entityNamed: #SecurityRequirement) property: #securitySchemes) comment: 'Reference securitySchemes from SecurityRequirement to RequiredSecurityScheme [0..*].') <>-* (self entityNamed: #RequiredSecurityScheme).
    (((self entityNamed: #ResponseEntry) property: #value) comment: 'Reference value from ResponseEntry to Response [0..1].') - (self entityNamed: #Response).
    (((self entityNamed: #SchemaEntry) property: #value) comment: 'Reference value from SchemaEntry to Schema [0..1].') - (self entityNamed: #Schema).
    (((self entityNamed: #ResponseDefinitionEntry) property: #value) comment: 'Reference value from ResponseDefinitionEntry to Response [0..1].') - (self entityNamed: #Response).
    (((self entityNamed: #ParameterEntry) property: #value) comment: 'Reference value from ParameterEntry to Parameter [0..1].') - (self entityNamed: #Parameter).
    (((self entityNamed: #SecurityContainer) property: #security) comment: 'Reference security from SecurityContainer to SecurityRequirement [0..*].') <>-* (self entityNamed: #SecurityRequirement).
    (((self entityNamed: #SecuritySchemeEntry) property: #value) comment: 'Reference value from SecuritySchemeEntry to SecurityScheme [0..1].') <>- (self entityNamed: #SecurityScheme).
    (((self entityNamed: #RequiredSecurityScheme) property: #securityScopes) comment: 'Reference securityScopes from RequiredSecurityScheme to SecurityScope [0..*].') -* (self entityNamed: #SecurityScope).
    (((self entityNamed: #RequiredSecurityScheme) property: #securityScheme) comment: 'Reference securityScheme from RequiredSecurityScheme to SecurityScheme [0..1].') - (self entityNamed: #SecurityScheme).
]

{ #category : 'definition' }
FamixOpenApiGenerator >> defineProperties [
    super defineProperties.
    (((self entityNamed: #JSONSchemaSubset) property: #type type: #String) comment: 'Attribute type from JSONSchemaSubset [1]').
    (((self entityNamed: #JSONSchemaSubset) property: #format type: #String) comment: 'Attribute format from JSONSchemaSubset [1]').
    (((self entityNamed: #JSONSchemaSubset) property: #description type: #String) comment: 'Attribute description from JSONSchemaSubset [1]').
    (((self entityNamed: #JSONSchemaSubset) property: #maximum type: #Number) comment: 'Attribute maximum from JSONSchemaSubset [1]').
    (((self entityNamed: #JSONSchemaSubset) property: #exclusiveMaximum type: #Boolean) comment: 'Attribute exclusiveMaximum from JSONSchemaSubset [1]').
    (((self entityNamed: #JSONSchemaSubset) property: #minimum type: #Number) comment: 'Attribute minimum from JSONSchemaSubset [1]').
    (((self entityNamed: #JSONSchemaSubset) property: #exclusiveMinimum type: #Boolean) comment: 'Attribute exclusiveMinimum from JSONSchemaSubset [1]').
    (((self entityNamed: #JSONSchemaSubset) property: #maxLength type: #Number) comment: 'Attribute maxLength from JSONSchemaSubset [1]').
    (((self entityNamed: #JSONSchemaSubset) property: #minLength type: #Number) comment: 'Attribute minLength from JSONSchemaSubset [1]').
    (((self entityNamed: #JSONSchemaSubset) property: #pattern type: #String) comment: 'Attribute pattern from JSONSchemaSubset [1]').
    (((self entityNamed: #JSONSchemaSubset) property: #maxItems type: #Number) comment: 'Attribute maxItems from JSONSchemaSubset [1]').
    (((self entityNamed: #JSONSchemaSubset) property: #minItems type: #Number) comment: 'Attribute minItems from JSONSchemaSubset [1]').
    (((self entityNamed: #JSONSchemaSubset) property: #uniqueItems type: #Boolean) comment: 'Attribute uniqueItems from JSONSchemaSubset [1]').
    (((self entityNamed: #JSONSchemaSubset) property: #enum type: #Object) comment: 'Attribute enum from JSONSchemaSubset [*]').
    (((self entityNamed: #JSONSchemaSubset) property: #default type: #String) comment: 'Attribute default from JSONSchemaSubset [1]').
    (((self entityNamed: #JSONSchemaSubset) property: #multipleOf type: #Number) comment: 'Attribute multipleOf from JSONSchemaSubset [1]').
    (((self entityNamed: #API) property: #host type: #String) comment: 'Attribute host from API [1]').
    (((self entityNamed: #API) property: #basePath type: #String) comment: 'Attribute basePath from API [1]').
    (((self entityNamed: #API) property: #schemes type: #Object) comment: 'Attribute schemes from API [*]').
    (((self entityNamed: #API) property: #consumes type: #Object) comment: 'Attribute consumes from API [*]').
    (((self entityNamed: #API) property: #produces type: #Object) comment: 'Attribute produces from API [*]').
    (((self entityNamed: #Info) property: #title type: #String) comment: 'Attribute title from Info [1]').
    (((self entityNamed: #Info) property: #description type: #String) comment: 'Attribute description from Info [1]').
    (((self entityNamed: #Info) property: #termsOfService type: #String) comment: 'Attribute termsOfService from Info [1]').
    (((self entityNamed: #Info) property: #version type: #String) comment: 'Attribute version from Info [1]').
    (((self entityNamed: #Contact) property: #name type: #String) comment: 'Attribute name from Contact [1]').
    (((self entityNamed: #Contact) property: #url type: #String) comment: 'Attribute url from Contact [1]').
    (((self entityNamed: #Contact) property: #email type: #String) comment: 'Attribute email from Contact [1]').
    (((self entityNamed: #License) property: #name type: #String) comment: 'Attribute name from License [1]').
    (((self entityNamed: #License) property: #url type: #String) comment: 'Attribute url from License [1]').
    (((self entityNamed: #Path) property: #relativePath type: #String) comment: 'Attribute relativePath from Path [1]').
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
    (((self entityNamed: #Parameter) property: #name type: #String) comment: 'Attribute name from Parameter [1]').
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
    (((self entityNamed: #Header) property: #name type: #String) comment: 'Attribute name from Header [1]').
    (((self entityNamed: #Tag) property: #name type: #String) comment: 'Attribute name from Tag [1]').
    (((self entityNamed: #Tag) property: #description type: #String) comment: 'Attribute description from Tag [1]').
    (((self entityNamed: #SecurityScheme) property: #type type: #String) comment: 'Attribute type from SecurityScheme [1]').
    (((self entityNamed: #SecurityScheme) property: #description type: #String) comment: 'Attribute description from SecurityScheme [1]').
    (((self entityNamed: #SecurityScheme) property: #name type: #String) comment: 'Attribute name from SecurityScheme [1]').
    (((self entityNamed: #SecurityScheme) property: #location type: #String) comment: 'Attribute location from SecurityScheme [1]').
    (((self entityNamed: #SecurityScheme) property: #flow type: #String) comment: 'Attribute flow from SecurityScheme [1]').
    (((self entityNamed: #SecurityScheme) property: #authorizationUrl type: #String) comment: 'Attribute authorizationUrl from SecurityScheme [1]').
    (((self entityNamed: #SecurityScheme) property: #tokenUrl type: #String) comment: 'Attribute tokenUrl from SecurityScheme [1]').
    (((self entityNamed: #Example) property: #mimeType type: #String) comment: 'Attribute mimeType from Example [1]').
    (((self entityNamed: #Example) property: #value type: #String) comment: 'Attribute value from Example [1]').
    (((self entityNamed: #XMLElement) property: #name type: #String) comment: 'Attribute name from XMLElement [1]').
    (((self entityNamed: #XMLElement) property: #namespace type: #String) comment: 'Attribute namespace from XMLElement [1]').
    (((self entityNamed: #XMLElement) property: #prefix type: #String) comment: 'Attribute prefix from XMLElement [1]').
    (((self entityNamed: #XMLElement) property: #attribute type: #Boolean) comment: 'Attribute attribute from XMLElement [1]').
    (((self entityNamed: #XMLElement) property: #wrapped type: #Boolean) comment: 'Attribute wrapped from XMLElement [1]').
    (((self entityNamed: #SecurityScope) property: #name type: #String) comment: 'Attribute name from SecurityScope [1]').
    (((self entityNamed: #SecurityScope) property: #description type: #String) comment: 'Attribute description from SecurityScope [1]').
    (((self entityNamed: #ArrayContainer) property: #collectionFormat type: #String) comment: 'Attribute collectionFormat from ArrayContainer [1]').
    (((self entityNamed: #JSONPointer) property: #ref type: #String) comment: 'Attribute ref from JSONPointer [1]').
    (((self entityNamed: #Property) property: #required type: #Boolean) comment: 'Attribute required from Property [1]').
    (((self entityNamed: #Property) property: #name type: #String) comment: 'Attribute name from Property [1]').
    (((self entityNamed: #ResponseEntry) property: #key type: #String) comment: 'Attribute key from ResponseEntry [1]').
    (((self entityNamed: #SchemaEntry) property: #key type: #String) comment: 'Attribute key from SchemaEntry [1]').
    (((self entityNamed: #ResponseDefinitionEntry) property: #key type: #String) comment: 'Attribute key from ResponseDefinitionEntry [1]').
    (((self entityNamed: #ParameterEntry) property: #key type: #String) comment: 'Attribute key from ParameterEntry [1]').
    (((self entityNamed: #SecuritySchemeEntry) property: #key type: #String) comment: 'Attribute key from SecuritySchemeEntry [1]').
]
