Class {
	#name : #P4TACConstant,
	#superclass : #P4TACValue,
	#instVars : [
		'value'
	],
	#category : #'P4-TAC-Values'
}

{ #category : #'as yet unclassified' }
P4TACConstant class >> with: aValue [
	^ (self new) value: aValue 
]

{ #category : #accessing }
P4TACConstant >> accept: aVisitor [
	^ aVisitor visitConstant: self
]

{ #category : #accessing }
P4TACConstant >> constantValue [
	^ value
]

{ #category : #testing }
P4TACConstant >> isAccess [
	^ false
]

{ #category : #testing }
P4TACConstant >> isConstant [
	^ true
]

{ #category : #accessing }
P4TACConstant >> isStaticallyTyped [
	^ false
]

{ #category : #printing }
P4TACConstant >> printOn: stream [ 
	stream << '"'.
	value printOn: stream.
	 stream << '"'.
]

{ #category : #printing }
P4TACConstant >> printString [ 
	^ '"',value printString ,'"'
]

{ #category : #accessing }
P4TACConstant >> value: aValue [
	(aValue isKindOf: SmallInteger) ifTrue: [
		typeHint := P4Package byPathName: #'Kernel.Number.SmallInteger' ].    
	value := aValue
]

{ #category : #accessing }
P4TACConstant >> wrapTypeGuard: types andCondition: condition around: aBlock fallback: anOtherBlock with: helper [
	(types anySatisfy: [ :type | value pclass == type ])
		ifTrue: [ 
			aBlock value.
			^ condition ifNotEmpty: [ helper insertCondition: condition fallback: anOtherBlock ]].
	anOtherBlock value.
]
