Class {
	#name : #P4UndefinedObject,
	#superclass : #P4Object,
	#category : #'P4-Kernel-Object'
}

{ #category : #'as yet unclassified' }
P4UndefinedObject >> ifFalse: aBlock [
	^ aBlock value  
]

{ #category : #'as yet unclassified' }
P4UndefinedObject >> ifFalse: aFalseBlock ifTrue: aBlock [ 
	^aFalseBlock value
]

{ #category : #'as yet unclassified' }
P4UndefinedObject >> ifNil: aBlock [
	^ aBlock value
]

{ #category : #'as yet unclassified' }
P4UndefinedObject >> ifNil: aBlock ifNotNil: anOtherBlock [
	^ aBlock value
]

{ #category : #'as yet unclassified' }
P4UndefinedObject >> ifTrue: aBlock [

]

{ #category : #'as yet unclassified' }
P4UndefinedObject >> ifTrue: aBlock  ifFalse: aFalseBlock [
	^aFalseBlock value
]

{ #category : #'as yet unclassified' }
P4UndefinedObject >> value [
	^ nil
]
