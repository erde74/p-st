Class {
	#name : #P4ProbeMethod,
	#superclass : #P4Object,
	#instVars : [
		'returnValues',
		'arguments'
	],
	#category : #'P4-Examples'
}

{ #category : #'as yet unclassified' }
P4ProbeMethod >> initialize [ 
	returnValues := P4IdentityDictionary new.
]

{ #category : #'as yet unclassified' }
P4ProbeMethod >> perform: selector on: name with: args [
	^ returnValues at: selector 
]

{ #category : #'as yet unclassified' }
P4ProbeMethod >> return: returnValue when: selector [
	returnValues at: selector put: returnValue
]
