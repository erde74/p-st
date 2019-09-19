Class {
	#name : #P4TACAbstractVariable,
	#superclass : #P4TACValue,
	#instVars : [
		'name'
	],
	#category : #'P4-TAC-Values'
}

{ #category : #'instance creation' }
P4TACAbstractVariable class >> named: aName [
self haltIf: aName == #closure.
	^ (self new) name: aName 
]

{ #category : #visiting }
P4TACAbstractVariable >> accept: aVisitor [
	^ aVisitor visitVariableNode: self
]

{ #category : #conversion }
P4TACAbstractVariable >> accessAt: anIndex [
	^ P4TACVariableAccess new index: anIndex ; variable: self
]

{ #category : #accessing }
P4TACAbstractVariable >> accessClass [
	^ self accessAt: P4SmalltalkConfiguration classIndex 
]

{ #category : #conversion }
P4TACAbstractVariable >> asAlias [
	^ P4TACVariableAlias new variable: self
]

{ #category : #liveness }
P4TACAbstractVariable >> assignedAt: num [  
]

{ #category : #liveness }
P4TACAbstractVariable >> isUnused [ 
	^false
]

{ #category : #liveness }
P4TACAbstractVariable >> isUsed [ 
	^self isUnused not
]

{ #category : #accessing }
P4TACAbstractVariable >> name [ 
	^name
]

{ #category : #accessing }
P4TACAbstractVariable >> name: aName [
	name := aName asSymbol
]

{ #category : #accessing }
P4TACAbstractVariable >> pop [
	self register ifNil: [ self error: 'pop cannot be called before register allocation' ].
	^ P4TACPop new register: self register.
]

{ #category : #printing }
P4TACAbstractVariable >> printOn: stream [ 
	(self name isKindOf: String) ifFalse: [ ^ stream << name class asString ].
	stream << self name.
]

{ #category : #accessing }
P4TACAbstractVariable >> printRegisterOn: stream [
	self hasRegisterAssigned ifFalse: [ ^ stream << 'n/a']  .
	self asAsm printOn: stream
]

{ #category : #accessing }
P4TACAbstractVariable >> push [
	^ P4TACPush new variable: self.
]
