Class {
	#name : #P4TACVariable,
	#superclass : #P4TACFixedVariable,
	#instVars : [
		'firstAssign',
		'lastAssign',
		'lastUse',
		'methodCalled'
	],
	#category : #'P4-TAC-Values'
}

{ #category : #visiting }
P4TACVariable >> assignRegister: aRegister for: aRegisterAllocator [
	aRegisterAllocator assignRegister: aRegister to: self.
]

{ #category : #liveness }
P4TACVariable >> assignedAt: number [
	(firstAssign isNil or: [ firstAssign > number ]) ifTrue: [ firstAssign := number ].
	lastAssign := number
]

{ #category : #liveness }
P4TACVariable >> canBeVolatile [
	methodCalled ifNotNil: [
		^ (lastUse <= methodCalled) ].
	^ true.
]

{ #category : #liveness }
P4TACVariable >> firstAssign [
	^ firstAssign
]

{ #category : #testing }
P4TACVariable >> hasRegisterAssigned [
	^ self register ~~ nil
]

{ #category : #liveness }
P4TACVariable >> index [
	self error: 'no access'
]

{ #category : #testing }
P4TACVariable >> isAccess [
	^ self asAsm isAccess
]

{ #category : #liveness }
P4TACVariable >> isSelf [ 
	 ^ false
]

{ #category : #liveness }
P4TACVariable >> isUnused [
	^ self lastUse isNil 
]

{ #category : #liveness }
P4TACVariable >> lastAssign [
	^ lastAssign
]

{ #category : #liveness }
P4TACVariable >> lastUse [
	^ lastUse
]

{ #category : #liveness }
P4TACVariable >> methodCalled: pos [
	firstAssign ifNotNil: [ methodCalled ifNil: [methodCalled := pos]].
]

{ #category : #printing }
P4TACVariable >> printRegisterOn: stream [
	(self hasRegisterAssigned )
		ifTrue: [	self asAsm printOn: stream ]
		ifFalse: [ stream << 'n/a' ]
]

{ #category : #accessing }
P4TACVariable >> register: aRegister [
	register := aRegister
]

{ #category : #liveness }
P4TACVariable >> usedAt: number [
	lastUse ifNotNil: [(number < lastUse) ifTrue: [ ^self ]].
	lastUse := number
]
