Class {
	#name : #P4ELFMarkerSection,
	#superclass : #P4ELFSection,
	#category : #'P4-Exec-ELF'
}

{ #category : #header }
P4ELFMarkerSection >> entrySize: pointerSize [
	^ 0
]

{ #category : #header }
P4ELFMarkerSection >> headerIndex [
	^ 0
]

{ #category : #'initialize-release' }
P4ELFMarkerSection >> initialize [
	super initialize.
	nameIndex := 0.
	offset := 0.
]

{ #category : #header }
P4ELFMarkerSection >> offset [
	^ 0
]

{ #category : #header }
P4ELFMarkerSection >> size: pointerSize [
	^ 0
]

{ #category : #header }
P4ELFMarkerSection >> type [
	"
	The number of entries in the program header table. The product of e_phentsize and e_phnum gives
	the table's size in bytes. If a file has no program header table, e_phnum holds the value zero.

	If the number of program headers is greater than or equal to PN_XNUM (0xffff), this member has
	the value PN_XNUM (0xffff). The actual number of program header table entries is contained in the
	sh_info field of the section header at index 0. Otherwise, the sh_info member of the initial section
	header entry contains the value zero.
	"
	^ 16r0
]
