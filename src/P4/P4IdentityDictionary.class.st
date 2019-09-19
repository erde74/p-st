Class {
	#name : #P4IdentityDictionary,
	#superclass : #P4Dictionary,
	#category : #'P4-Kernel-Collection'
}

{ #category : #statictyping }
P4IdentityDictionary class >> pExportedName [ 
	^ self == P4IdentityDictionary
		ifTrue: [ #IdentityDictionary ]
		ifFalse: [ super pExportedName ]
]

{ #category : #statictyping }
P4IdentityDictionary class >> typeHints [ 
	<preventExport>
	^ super typeHints addAll:
	{
		#buckets -> #'Kernel.Collection.Array'.
		#self-> #'Kernel.Collection.IdentityDictionary'
	} asDictionary
]

{ #category : #private }
P4IdentityDictionary >> at: key ifAbsent: aBlock [
	<typeHint: #bucket as: #'Kernel.Collection.IdentityDictBucket'>
	<typeHint: #hash as: #'Kernel.Number.SmallInteger'>
	<fixedType: #key as: #'Kernel.Object.Object'>
	<groundTypes>
	| bucket hash |
	linear ifTrue: [ bucket := (buckets at: 1). ^ bucket at: key ifAbsent: aBlock ].
	hash := key identityHash.
	bucket := buckets at: 1 + (hash \\ buckets size).
	^ bucket
		ifNil: [ aBlock value ]
		ifNotNil: [bucket at: key ifAbsent: aBlock ]
]

{ #category : #private }
P4IdentityDictionary >> at: key put: anObject [
	| bucketIndex bucket |
	
	linear ifTrue: [ ^ self inFirstBucketAt: key put: anObject ].
		
	bucketIndex := key identityHash \\ buckets size + 1.
	bucket := buckets at: bucketIndex.
	bucket ifNil: [
		(self newBucketAt: bucketIndex) newKey: key value: anObject.
		self checkGrow.
		^ anObject ].
	(bucket assign: key to: anObject) ifTrue: [ ^ anObject ].
	bucket isFull ifTrue: [ bucket := self growBucketAt: bucketIndex ].
	bucket newKey: key value: anObject.
	self checkGrow.
	^ anObject
]

{ #category : #private }
P4IdentityDictionary >> includesKey: key [
	linear ifTrue: [ ^ (buckets at: 1) includesKey: key ].
	^ (buckets at: key identityHash \\ buckets size + 1)
		ifNil: [ false ]
		ifNotNil: [ :bucket | bucket includesKey: key ]
]

{ #category : #private }
P4IdentityDictionary >> newBucket: sizeRequested [
	^ P4IdentityDictBucket new: sizeRequested
]

{ #category : #private }
P4IdentityDictionary >> reAddBucket: bucket at: index [
	| c key bucketIndex |
	c := 1.
	buckets at: index put: bucket.
	[ c <= bucket bucketSize ] whileTrue: [ 
			key := bucket at: c.
			bucketIndex := key identityHash \\ buckets size + 1.
			bucketIndex = index
				ifTrue: [ c := c + 2 ]
				ifFalse: [ 
					(self bucketWithRoomAt: bucketIndex) newKey: key value: (bucket at: c + 1).
					bucket removeAt: c ] ]
]

{ #category : #removing }
P4IdentityDictionary >> removeKey: key ifAbsent: aBlock [
	| value bucket |
	linear ifTrue: [
		value := (buckets at: 1) remove: key ifAbsent: [ ^ aBlock value ].
		self checkShrink.
		^ value ].
	bucket := buckets at: key identityHash \\ buckets size + 1.
	bucket ifNil: [ ^ aBlock value ].
	value := bucket remove: key ifAbsent: [ ^ aBlock value ].
	self checkShrink.
	^ value
]
