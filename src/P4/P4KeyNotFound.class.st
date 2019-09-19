Class {
	#name : #P4KeyNotFound,
	#superclass : #P4Exception,
	#instVars : [
		'dictionary',
		'key'
	],
	#category : #'P4-Kernel-Collection'
}

{ #category : #accessing }
P4KeyNotFound >> dictionary [
	^ dictionary
]

{ #category : #accessing }
P4KeyNotFound >> dictionary: anObject [
	dictionary := anObject
]

{ #category : #accessing }
P4KeyNotFound >> key [
	^ key
]

{ #category : #accessing }
P4KeyNotFound >> key: anObject [
	key := anObject
]

{ #category : #printing }
P4KeyNotFound >> warnOn: aStream [
	aStream << 'Key not found: '.
	key printOn: aStream.
]
