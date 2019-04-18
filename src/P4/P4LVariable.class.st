Class {
	#name : #P4LVariable,
	#superclass : #P4LSized,
	#instVars : [
		'extra'
	],
	#category : #'P4-Kernel-Structure'
}

{ #category : #allocation }
P4LVariable >> allocate: memoryManager [
	^ memoryManager allocatePointers: size variable: extra
]
