Class {
	#name : #P4TACOperation,
	#superclass : #P4TACInstruction,
	#instVars : [
		'left',
		'right'
	],
	#category : #'P4-TAC-IR'
}

{ #category : #'instance creation' }
P4TACOperation class >> a: left to: aRight [
	^ self new left: left; right: aRight
	
]

{ #category : #visiting }
P4TACOperation >> acceptRegisterSwapper: aVisitor [ 
	^ aVisitor visitOperation: self  
]

{ #category : #accessing }
P4TACOperation >> left [
	^ left
]

{ #category : #accessing }
P4TACOperation >> left: aLeft [
	left := aLeft.
]

{ #category : #printing }
P4TACOperation >> printOn: stream [
	self printLineNumberOn: stream.
	stream << self op << ' '.  
	left printOn: stream.
	stream << ', '.
	right printOn: stream.
	stream << Character tab << Character tab << Character tab << Character tab.
	stream << '#'.
	left printRegisterOn: stream .
	stream  << ', '.
	right printRegisterOn: stream.
	stream << Character cr

]

{ #category : #accessing }
P4TACOperation >> right [
	^ right
]

{ #category : #accessing }
P4TACOperation >> right: aValue [
	"self assert: ( aValue respondsTo: #asRegister )."
	right := aValue.
]
