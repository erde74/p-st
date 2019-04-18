Class {
	#name : #P4True,
	#superclass : #P4Boolean,
	#category : #'P4-Kernel-Boolean'
}

{ #category : #'as yet unclassified' }
P4True >> not [
	^ false
]

{ #category : #'as yet unclassified' }
P4True >> shouldBeTrue [

]

{ #category : #'as yet unclassified' }
P4True >> xor: aBoolean [
	^aBoolean value not
]
