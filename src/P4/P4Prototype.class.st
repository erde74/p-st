Class {
	#name : #P4Prototype,
	#superclass : #P4Object,
	#instVars : [
		'slots',
		'delegate'
	],
	#category : #'P4-Examples'
}

{ #category : #'as yet unclassified' }
P4Prototype >> addMethod: method at: selector [
	slots at: selector put: method
]

{ #category : #'as yet unclassified' }
P4Prototype >> behavior [
	<pprimitive: #'behavior'>
	self pHalt
]

{ #category : #'as yet unclassified' }
P4Prototype >> clone [
	| clone |
	clone := P4Prototype basicNew.
	clone initializeClone.    
	clone delegate: self.
	^clone
]

{ #category : #accessing }
P4Prototype >> delegate [
	^ delegate
]

{ #category : #accessing }
P4Prototype >> delegate: anObject [
	delegate := anObject
]

{ #category : #accessing }
P4Prototype >> doesNotUnderstand: aMessage [
	'doesNotUnderstand' print
]

{ #category : #'as yet unclassified' }
P4Prototype >> initialize [
	slots := P4IdentityDictionary new.
	delegate := nil.
	self behavior: (P4PrototypeBehavior new initialize: self).
	P4Prototype setBehavior:  self behavior.  
]

{ #category : #'as yet unclassified' }
P4Prototype >> initializeClone [
	slots := P4IdentityDictionary new.
	delegate := nil.
]

{ #category : #'as yet unclassified' }
P4Prototype >> slot: name [ 
	^ slots at: name ifAbsent: nil
]
