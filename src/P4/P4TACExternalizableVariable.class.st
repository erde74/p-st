Class {
	#name : #P4TACExternalizableVariable,
	#superclass : #P4TACVariable,
	#instVars : [
		'remote'
	],
	#category : #'P4-TAC-Values'
}

{ #category : #conversion }
P4TACExternalizableVariable >> accept: aVisitor [
	self shouldBeRemote ifTrue: [ ^ aVisitor visitVariableAccess: self remote ].
	^ super accept: aVisitor.  
]

{ #category : #conversion }
P4TACExternalizableVariable >> asAsm [
	self shouldBeRemote ifTrue: [ ^ self remote asAsm ] .
	^ super asAsm.

]

{ #category : #accessing }
P4TACExternalizableVariable >> beRemote [
	remote := true
]

{ #category : #accessing }
P4TACExternalizableVariable >> index [
	self shouldBeRemote ifTrue: [ ^ remote index ].
	self error: 'no access'
]

{ #category : #testing }
P4TACExternalizableVariable >> isDoubleAccess [
	self shouldBeRemote ifTrue:  [ ^ remote isDoubleAccess ].
	^ false.
]

{ #category : #printing }
P4TACExternalizableVariable >> printOn: stream [
	self shouldBeRemote ifTrue: [ stream << '@' ].
	super printOn: stream  
]

{ #category : #printing }
P4TACExternalizableVariable >> printRegisterOn: stream [
	self hasRegisterAssigned
		ifTrue: [	^super printRegisterOn: stream ].
	self shouldBeRemote
		ifTrue: [	
			remote == true ifTrue: [ ^ stream << 'n/a'].
			^ remote printRegisterOn: stream ].
	stream << 'n/a'
]

{ #category : #accessing }
P4TACExternalizableVariable >> remote [
	^ remote
]

{ #category : #accessing }
P4TACExternalizableVariable >> remote: aRemoteArray [
	remote := aRemoteArray
]

{ #category : #accessing }
P4TACExternalizableVariable >> remoteIndex: next [
	(remote isKindOf: P4TACValue) ifTrue: [^remote index].
	^ next
]

{ #category : #accessing }
P4TACExternalizableVariable >> remoteVariable [
	^ remote variable
]

{ #category : #testing }
P4TACExternalizableVariable >> shouldBeRemote [
	^ remote isNil not
]

{ #category : #accessing }
P4TACExternalizableVariable >> variable [
	self shouldBeRemote ifTrue: [ ^ remote variable ].
	self error: 'Not an access'.
]
