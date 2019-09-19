Class {
	#name : #P4TACVariableAlias,
	#superclass : #P4TACExternalizableVariable,
	#instVars : [
		'variable'
	],
	#category : #'P4-TAC-Values'
}

{ #category : #liveness }
P4TACVariableAlias >> assignedAt: number [
	" Aliases you assign to will become remote. Then they behave like variable access. See variable access for more info. "
	super assignedAt: number.
	self usedAt: number.
	variable beRemote
]

{ #category : #liveness }
P4TACVariableAlias >> beRemote [
	variable beRemote
]

{ #category : #accessing }
P4TACVariableAlias >> fixedType [
	^ variable fixedType
]

{ #category : #accessing }
P4TACVariableAlias >> fixedType: aType [
	^ variable fixedType: aType
]

{ #category : #accessing }
P4TACVariableAlias >> initialize [ 
	super initialize .
	lastAssign := firstAssign := 0.
]

{ #category : #testing }
P4TACVariableAlias >> isUnused [ 
	^false
]

{ #category : #accessing }
P4TACVariableAlias >> name [
	^ variable name.
]

{ #category : #printing }
P4TACVariableAlias >> printOn: stream [
	variable printOn: stream.
	stream << '`'  
]

{ #category : #accessing }
P4TACVariableAlias >> remoteIndex: next [
	^ variable remoteIndex: next    
]

{ #category : #testing }
P4TACVariableAlias >> shouldBeRemote [
	^ variable shouldBeRemote 
]

{ #category : #accessing }
P4TACVariableAlias >> typeHint [ 
	^ variable typeHint 
]

{ #category : #accessing }
P4TACVariableAlias >> typeHint: hint [
	^ variable typeHint: hint 
]

{ #category : #accessing }
P4TACVariableAlias >> variable: aVariable [
	variable := aVariable 
]
