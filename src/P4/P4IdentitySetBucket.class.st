Class {
	#name : #P4IdentitySetBucket,
	#superclass : #P4SetBucket,
	#type : #variable,
	#category : #'P4-Kernel-Collection'
}

{ #category : #'as yet unclassified' }
P4IdentitySetBucket >> includes: anObject [
	1 to: bucketSize do: [ :index | 
			(self at: index) == anObject ifTrue: [ ^ true ] ].
	^ false
]

{ #category : #'as yet unclassified' }
P4IdentitySetBucket >> remove: anObject ifAbsent: aBlock [
	1 to: bucketSize do: [ :index |
		(self at: index) == anObject
			ifTrue: [ self removeAt: index. ^ anObject ]].
	^ aBlock value
]
