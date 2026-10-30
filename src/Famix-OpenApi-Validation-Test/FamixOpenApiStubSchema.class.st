"
A schema of the family OPSchema that is neither an OPSchema nor an OPSubSchema: the tests of the existence check replace a real OPSchema by it to prove that a wrong class of the right family is reported (OPSubSchema cannot be used: it triggers the merged-mode precondition).
"
Class {
	#name : 'FamixOpenApiStubSchema',
	#superclass : 'OPSchema',
	#category : 'Famix-OpenApi-Validation-Test',
	#package : 'Famix-OpenApi-Validation-Test'
}

{ #category : 'meta' }
FamixOpenApiStubSchema class >> annotation [

	<ignoreForCoverage>
	<FMClass: #StubSchema super: #OPSchema>
	<package: #'Famix-OpenApi-Validation-Test'>
	
]
