Class {
	#name : #P4DwarfCommonInformationEntry,
	#superclass : #P4Object,
	#instVars : [
		'dataAlignFactor',
		'codeAlignFactor',
		'returnAddressRegister'
	],
	#category : #'P4-Exec-ELF-Dwarf'
}

{ #category : #'as yet unclassified' }
P4DwarfCommonInformationEntry >> augmentation [
	"null-terminated string with legal values being  or 'z' optionally followed by single occurrances of 'P', 'L', or 'R' in any order.
         The presence of character(s) in the string dictates the content of field 8, the Augmentation Section. Each character has one 
         or two associated operands in the AS. Operand order depends on position in the string ('z' must be first)."
	^ 0
	
]

{ #category : #'as yet unclassified' }
P4DwarfCommonInformationEntry >> cieId. [
	^ 0
]

{ #category : #accessing }
P4DwarfCommonInformationEntry >> codeAlignFactor [
	"To be multiplied with the Advance Location instructions in the CFIs"
	^ codeAlignFactor
]

{ #category : #accessing }
P4DwarfCommonInformationEntry >> codeAlignFactor: anObject [
	codeAlignFactor := anObject
]

{ #category : #accessing }
P4DwarfCommonInformationEntry >> dataAlignFactor [
	"To be multiplied with all offset in the Call Frame Instructions"
	^ dataAlignFactor
]

{ #category : #accessing }
P4DwarfCommonInformationEntry >> dataAlignFactor: anObject [
	dataAlignFactor := anObject
]

{ #category : #'as yet unclassified' }
P4DwarfCommonInformationEntry >> length [
	"length without length field"
	^ 46	
]

{ #category : #'as yet unclassified' }
P4DwarfCommonInformationEntry >> putOn: stream [
	stream putUnsigned: self length bytes: 4.	
	stream put: self cieId bytes: 4.
	stream nextPut: self version.
	stream nextPut: self augmentation.
	stream putUnsigned: self codeAlignFactor bytes: 16. 
	stream put: self dataAlignFactor bytes: 16.
	stream nextPut: self returnAddressRegister.
	
	
]

{ #category : #accessing }
P4DwarfCommonInformationEntry >> returnAddressRegister [
	"A virtual register representation of the return address. 
	In Dwarf V2, this is a byte, otherwise it is uleb128. It is a byte in gcc 3.3.x"
	^ returnAddressRegister
]

{ #category : #accessing }
P4DwarfCommonInformationEntry >> returnAddressRegister: anObject [
	returnAddressRegister := anObject
]

{ #category : #'as yet unclassified' }
P4DwarfCommonInformationEntry >> version. [
	^ 1
]
