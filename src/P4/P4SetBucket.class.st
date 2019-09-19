Class {
	#name : #P4SetBucket,
	#superclass : #P4AbstractBucket,
	#type : #variable,
	#category : #'P4-Kernel-Collection'
}

{ #category : #adding }
P4SetBucket >> addNew: value [
	^ self at: (bucketSize := bucketSize + 1) put: value
]

{ #category : #enumeration }
P4SetBucket >> do: aBlock [
	1 to: bucketSize do: [ :index | aBlock value: (self at: index) ]
]

{ #category : #testing }
P4SetBucket >> includes: anObject [
	1 to: bucketSize do: [ :index | 
			(self at: index) = anObject ifTrue: [ ^ true ] ].
	^ false
]

{ #category : #removing }
P4SetBucket >> remove: anObject ifAbsent: aBlock [
	1 to: bucketSize do: [ :index |
		(self at: index) = anObject
			ifTrue: [ self removeAt: index. ^ anObject ]].
	^ aBlock value
]

{ #category : #removing }
P4SetBucket >> removeAt: anInteger [
	self at: anInteger put: (self at: bucketSize).
	bucketSize := bucketSize - 1.
	self at: bucketSize + 1 put: nil. 
]
