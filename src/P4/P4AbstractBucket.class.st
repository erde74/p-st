Class {
	#name : #P4AbstractBucket,
	#superclass : #P4Array,
	#type : #variable,
	#instVars : [
		'bucketSize'
	],
	#category : #'P4-Kernel-Collection'
}

{ #category : #'instance creation' }
P4AbstractBucket class >> new [
	self shouldNotCall
]

{ #category : #'instance creation' }
P4AbstractBucket class >> new: sizeRequested [
	^ (super basicNew: sizeRequested) initialize
]

{ #category : #accessing }
P4AbstractBucket >> bucketSize [
	^ bucketSize
]

{ #category : #adding }
P4AbstractBucket >> copyFrom: aBucket [
	1 to: aBucket bucketSize do: [ :idx | self at: idx put: (aBucket at: idx) ].
	bucketSize := aBucket bucketSize
]

{ #category : #initialization }
P4AbstractBucket >> initialize [
	bucketSize := 0
]

{ #category : #testing }
P4AbstractBucket >> isFull [
	^ bucketSize = self size
]

{ #category : #'as yet unclassified' }
P4AbstractBucket >> printOn: aStream [
	aStream << 'a ' << self class name << ' {'.
	aStream cr.
	1 to: self bucketSize do: [ :i |
		(self pVariableAt: i) printOn: aStream.
		aStream << '. '  ].
	aStream << '}'.
]

{ #category : #removing }
P4AbstractBucket >> removeAll [
	|oldSize|
	oldSize := bucketSize.
	bucketSize := 0.
	1 to: oldSize do: [:index | self at: index put: nil]
]
