"
Entry point of metamodel and importer validation tools: field-coverage conformance, model coherence, import fidelity. Each is added step by step. This class is intentionally minimal for now.
"
Class {
	#name : 'FamixOpenApiValidation',
	#superclass : 'Object',
	#category : 'Famix-OpenApi-Validation',
	#package : 'Famix-OpenApi-Validation'
}

{ #category : 'accessing' }
FamixOpenApiValidation class >> description [
	"Intentionally minimal: a short description of the validation tools."

	^ 'Validation tools for the Famix OpenApi metamodel and importer'
]
