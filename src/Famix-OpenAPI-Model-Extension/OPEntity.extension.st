Extension { #name : 'OPEntity' }

{ #category : '*Famix-OpenAPI-Model-Extension' }
OPEntity >> addDeclaringOpenApi: aDocument to: aCollection [
	"Add aDocument to aCollection unless it is nil or already there."

	aDocument ifNil: [ ^ self ].
	(aCollection identityIncludes: aDocument) ifFalse: [
		aCollection add: aDocument ]
]

{ #category : '*Famix-OpenAPI-Model-Extension' }
OPEntity >> allReferrers [
	"Answer the entities that refer to the receiver directly or through a chain of referrers. Cycles are followed only once and the receiver is never part of the answer."

	| result pending |
	result := OrderedCollection new.
	pending := OrderedCollection with: self.
	[ pending isEmpty ] whileFalse: [
		pending removeFirst referrers do: [ :each |
			(each == self or: [ result identityIncludes: each ]) ifFalse: [
				result add: each.
				pending add: each ] ] ].
	^ result
]

{ #category : '*Famix-OpenAPI-Model-Extension' }
OPEntity >> referrerSlots [
	"Answer the slots of the receiver's class that hold the entities referring to the receiver (usedBy* and usedAs* relations). Reflection is used on purpose: these slots are generated and new ones may appear at each regeneration."

	^ self class allSlots select: [ :slot |
		  slot isFMRelationSlot and: [
			  (slot name beginsWith: 'usedBy') or: [
				  slot name beginsWith: 'usedAs' ] ] ]
]

{ #category : '*Famix-OpenAPI-Model-Extension' }
OPEntity >> referrers [
	"Answer the distinct entities that directly refer to the receiver, collected from the usedBy* and usedAs* relations of its class. The receiver is part of the answer only when it refers to itself."

	| result |
	result := OrderedCollection new.
	self referrerSlots do: [ :slot |
		(slot read: self) do: [ :each |
			(result identityIncludes: each) ifFalse: [ result add: each ] ] ].
	^ result
]
