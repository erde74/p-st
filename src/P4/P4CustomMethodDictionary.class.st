Class {
	#name : #P4CustomMethodDictionary,
	#superclass : #P4Object,
	#type : #variable,
	#category : #'P4-Test'
}

{ #category : #'as yet unclassified' }
P4CustomMethodDictionary >> aMethod [ 
	'  -> i''m a catchall Method' print.
	^1
]

{ #category : #'as yet unclassified' }
P4CustomMethodDictionary >> at: key [
	(key == #callCustomMethodObject ) 
		ifTrue: [ ^ P4TestMethod new. ].
	(key == #callCustomMethodObjectWith:with:with:)
		ifTrue: [ ^ P4TestMethod2 new ].
	^ self class methodDictionary at: #aMethod
]

{ #category : #'as yet unclassified' }
P4CustomMethodDictionary >> print [
	'print method of a custom method dict called'
]
