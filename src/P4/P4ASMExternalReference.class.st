Class {
	#name : #P4ASMExternalReference,
	#superclass : #P4ASMConstant,
	#instVars : [
		'label'
	],
	#category : #'P4-ASM-Values'
}

{ #category : #'as yet unclassified' }
P4ASMExternalReference >> constantValue [ 
	^0
]

{ #category : #'as yet unclassified' }
P4ASMExternalReference >> isExternal [ 
	^ true
]

{ #category : #'as yet unclassified' }
P4ASMExternalReference >> label [
	^ label
]

{ #category : #'as yet unclassified' }
P4ASMExternalReference >> label: aLabel [
	label := aLabel 
]
