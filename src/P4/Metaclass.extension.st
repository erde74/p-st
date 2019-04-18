Extension { #name : #Metaclass }

{ #category : #'*P4' }
Metaclass >> asPClass [
	^ thisClass asPClass pclass
]

{ #category : #'*P4' }
Metaclass >> earlySelectorAddress: aSelector [
	| method |
	method := self pLookupSelector: aSelector.
	^ method earlySelectorAddress.
]

{ #category : #'*P4' }
Metaclass >> mapToPclass [
	^ thisClass mapToPclass class
]

{ #category : #'*P4' }
Metaclass >> p4super [
	self == P4Object class ifTrue: [ ^ P4Class ].
	^ self super
]

{ #category : #'*P4' }
Metaclass >> pInstSize [
	^ self instSize - P4Object class instSize + P4Class instSize
]
