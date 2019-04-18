Class {
	#name : #P4TACArgument,
	#superclass : #P4TACFixedVariable,
	#category : #'P4-TAC-Values'
}

{ #category : #liveness }
P4TACArgument >> isUnused [
	"arguments are used to pass to another function, therefore they are used by definition, even if they are not used in the current context" 
	^ false
]
