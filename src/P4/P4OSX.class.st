Class {
	#name : #P4OSX,
	#superclass : #P4AbstractOS,
	#category : #'P4-SystemSpec'
}

{ #category : #'as yet unclassified' }
P4OSX >> executableFormat [
	^ P4MachO new 
]
