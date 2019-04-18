Class {
	#name : #P4TACClosure,
	#superclass : #P4TACCallable,
	#instVars : [
		'code',
		'outerScope',
		'imports'
	],
	#category : #'P4-TAC-IR'
}

{ #category : #accessing }
P4TACClosure >> accept: visitor [
	visitor visitClosure: self 
]

{ #category : #accessing }
P4TACClosure >> code [
	^ code
]

{ #category : #accessing }
P4TACClosure >> code: anObject [
	code := anObject
]

{ #category : #accessing }
P4TACClosure >> export: aVariable [
	locals at: aVariable ifPresent: [ :var | ^ var ].
	self import: aVariable.
	^ locals at: aVariable ifAbsent: [ nil ]
]

{ #category : #accessing }
P4TACClosure >> hasNonLocalReturn [ 
	^ false
]

{ #category : #accessing }
P4TACClosure >> import: aVariable [
	| tacVariable |
	tacVariable := outerScope export: aVariable.
	tacVariable ifNil: [ ^ tacVariable ].
	imports add: tacVariable.
	^ locals at: aVariable put: tacVariable asAlias.
]

{ #category : #accessing }
P4TACClosure >> imports [
	^ imports
]

{ #category : #'initialize-release' }
P4TACClosure >> initialize [
	super initialize.
	imports := OrderedCollection new.
]

{ #category : #testing }
P4TACClosure >> isAssignment [
	^ true
]

{ #category : #testing }
P4TACClosure >> isConstant [
	^ true
]

{ #category : #accessing }
P4TACClosure >> methodFrameSize [
	^ outerScope methodFrameSize
]

{ #category : #accessing }
P4TACClosure >> methodObject [ 
	^ outerScope methodObject 
]

{ #category : #testing }
P4TACClosure >> numOfArguments [
	^ locals inject: 0 into: [ :size :var | var shouldBeRemote ifTrue: [ size ] ifFalse: [ size + 1 ]  ]
]

{ #category : #accessing }
P4TACClosure >> origin [
	" ^ self "
]

{ #category : #accessing }
P4TACClosure >> outerScope [
	^ outerScope
]

{ #category : #accessing }
P4TACClosure >> outerScope: anObject [
	outerScope := anObject
]
