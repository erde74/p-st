Class {
	#name : #P4MOSectionWithData,
	#superclass : #P4MOSection,
	#instVars : [
		'data'
	],
	#category : #'P4-Exec-MachO'
}

{ #category : #'as yet unclassified' }
P4MOSectionWithData >> byteAlignment [
	"2^4 = 16 byte aligned"
	^ 4
]

{ #category : #accessing }
P4MOSectionWithData >> data [
	^ data
]

{ #category : #accessing }
P4MOSectionWithData >> data: anObject [
	data := anObject
]

{ #category : #accessing }
P4MOSectionWithData >> fileSize [
	data alignBy: (2 raisedTo: self byteAlignment) with: 0.
	^ data size
]

{ #category : #'as yet unclassified' }
P4MOSectionWithData >> writeOn: aStream [
	aStream fillTo: fileOffset with: 16r00.
	aStream nextPutAll: data contents.
	relocationTable writeOn: aStream.
]
