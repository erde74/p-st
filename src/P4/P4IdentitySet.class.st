Class {
	#name : #P4IdentitySet,
	#superclass : #P4Set,
	#category : #'P4-Kernel-Collection'
}

{ #category : #accessing }
P4IdentitySet class >> bucketClass [
	^ P4IdentitySetBucket
]

{ #category : #adding }
P4IdentitySet >> add: value [
	| bucketIndex bucket |
	linear ifTrue: [ ^ self addInFirstBucket: value ].
	
	bucketIndex := (value identityHash \\ buckets size) + 1.
	bucket := buckets at: bucketIndex.
	bucket ifNil: [
		bucket := self newBucketAt: bucketIndex.
		bucket addNew: value.
		self checkGrow.
		^ value ].
	(bucket includes: value) ifTrue: [ ^ value ].
	bucket isFull ifTrue: [ bucket := self growBucketAt: bucketIndex ].
	bucket addNew: value.
	self checkGrow.
	^ value
]

{ #category : #testing }
P4IdentitySet >> includes: anObject [
	linear ifTrue: [ ^ (buckets at: 1) includes: anObject ].
	^ (buckets at: anObject identityHash \\ buckets size + 1)
		ifNil: [ false ]
		ifNotNil: [ :bucket | bucket includes: anObject ]
]

{ #category : #private }
P4IdentitySet >> newBucket: sizeRequested [
	<preventExport>
	self flag: 'ne'.
	^ P4IdentitySetBucket new: sizeRequested
]

{ #category : #private }
P4IdentitySet >> reAddBucket: bucket at: index [
	| c item bucketIndex |
	buckets at: index put: bucket.
	c := 1.
	[ c <= bucket bucketSize ] whileTrue: [ 
		item := bucket at: c.
		bucketIndex := item identityHash \\ buckets size + 1.
		bucketIndex = index
			ifTrue: [ c := c + 1 ]
			ifFalse: [
				(self bucketWithRoomAt: bucketIndex) addNew: item.
				bucket removeAt: c ]]
]

{ #category : #removing }
P4IdentitySet >> remove: anObject ifAbsent: aBlock [
	| bucket value |
	linear ifTrue: [ bucket := buckets at: 1 ]
		ifFalse: [
			bucket := buckets at: anObject identityHash \\ buckets size + 1.
			bucket ifNil: [ ^ aBlock value ]].
	value := bucket remove: anObject ifAbsent: [ ^ aBlock value ].
	self checkShrink.
	^ value
]
