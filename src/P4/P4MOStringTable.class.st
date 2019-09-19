Class {
	#name : #P4MOStringTable,
	#superclass : #P4MOSectionWithData,
	#category : #'P4-Exec-MachO'
}

{ #category : #'as yet unclassified' }
P4MOStringTable >> allocateString: aName [
	| ndx |
	ndx := data position.
	" Encode as 0-terminated C-strings "
	data nextPut: $_ asInteger.
	data nextPutAll: aName asByteArray.
	data nextPut: 16r0.
	^ ndx
]

{ #category : #'as yet unclassified' }
P4MOStringTable >> fileSize [
	^ data size
]

{ #category : #'as yet unclassified' }
P4MOStringTable >> initialize [
	super initialize.
	data := ReadWriteStream on: (ByteArray new: 1024).
]
