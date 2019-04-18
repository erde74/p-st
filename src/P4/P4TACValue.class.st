Class {
	#name : #P4TACValue,
	#superclass : #P4Object,
	#instVars : [
		'typeHint',
		'staticType'
	],
	#category : #'P4-TAC-Values'
}

{ #category : #testing }
P4TACValue >> asAsm [ 
	^ self
]

{ #category : #visiting }
P4TACValue >> asValue [
	^self
]

{ #category : #accessing }
P4TACValue >> hasTypeHint [
	^ self typeHint ~~ nil
]

{ #category : #testing }
P4TACValue >> isAccess [
	^ false
]

{ #category : #testing }
P4TACValue >> isConstant [ 
	^ false
]

{ #category : #testing }
P4TACValue >> isDoubleAccess [
	^ false
]

{ #category : #accessing }
P4TACValue >> isStaticallyTyped [
	^ self staticType ~~ nil
]

{ #category : #'instruction-creation' }
P4TACValue >> loadAddressIn: aVariable [
	^P4TACLoadAddress load: self in: aVariable 
]

{ #category : #accessing }
P4TACValue >> moveTo: aVariable [
	self hasTypeHint ifTrue: [ aVariable typeHint: self typeHint ].
	self isStaticallyTyped ifTrue: [ aVariable staticType: self staticType ].
	^P4TACAssignment move: self to: aVariable  

]

{ #category : #printing }
P4TACValue >> printRegisterOn: stream [  
	stream << 'n/a' 
]

{ #category : #accessing }
P4TACValue >> staticType [
	^ staticType
]

{ #category : #accessing }
P4TACValue >> staticType: anObject [
	(self hasTypeHint and: [ typeHint ~~ anObject ]) ifTrue: [ self error: 'trying to change the type of a variable']. 
	staticType := anObject
]

{ #category : #accessing }
P4TACValue >> typeHint [
	^ typeHint
]

{ #category : #accessing }
P4TACValue >> typeHint: anObject [
	(self hasTypeHint and: [ typeHint ~~ anObject ]) ifTrue: [ self error: 'not allowed to change type of ', self asString ,' from ',self typeHint asString,' to ',anObject asString ].  
	typeHint := anObject
]

{ #category : #liveness }
P4TACValue >> usedAt: number [  
]

{ #category : #testing }
P4TACValue >> wrapTypeGuard: types andCondition: conditions around: aBlock fallback: anOtherBlock with: helper [
	^ helper insertTypeGuard: types andCondition: conditions for: self around: aBlock fallback: anOtherBlock
]

{ #category : #testing }
P4TACValue >> wrapTypeGuard: types around: aBlock fallback: anOtherBlock with: helper [
	^ self wrapTypeGuard: types andCondition: {} around: aBlock fallback: anOtherBlock with: helper
]
