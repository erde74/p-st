Class {
	#name : #P4MOSymbol,
	#superclass : #P4Object,
	#instVars : [
		'nameIndex',
		'section',
		'value',
		'name',
		'index',
		'size',
		'global'
	],
	#category : #'P4-Exec-MachO'
}

{ #category : #'as yet unclassified' }
P4MOSymbol >> description [
	"The bit 0x0020 of the n_desc field is used for two non-overlapping purposes
	and has two different symbolic names, N_NO_DEAD_STRIP and N_DESC_DISCARDED.

	The N_NO_DEAD_STRIP bit of the n_desc field only ever appears in a 
	relocatable .o file (MH_OBJECT filetype). And is used to indicate to the
	static link editor it is never to dead strip the symbol.

	N_NO_DEAD_STRIP 0x0020 /* symbol is not to be dead stripped */

	The N_DESC_DISCARDED bit of the n_desc field never appears in linked image.
	But is used in very rare cases by the dynamic link editor to mark an in
	memory symbol as discared and longer used for linking.

	N_DESC_DISCARDED 0x0020	/* symbol is discarded */

	The N_WEAK_REF bit of the n_desc field indicates to the dynamic linker that
	the undefined symbol is allowed to be missing and is to have the address of
	zero when missing.

	N_WEAK_REF	0x0040 /* symbol is weak referenced */

	The N_WEAK_DEF bit of the n_desc field indicates to the static and dynamic
	linkers that the symbol definition is weak, allowing a non-weak symbol to
	also be used which causes the weak definition to be discared.  Currently this
	is only supported for symbols in coalesed sections.

	N_WEAK_DEF	0x0080 /* coalesed symbol is a weak definition */

	The N_REF_TO_WEAK bit of the n_desc field indicates to the dynamic linker
	that the undefined symbol should be resolved using flat namespace searching.

	N_REF_TO_WEAK	0x0080 /* reference to a weak symbol */

	The N_ARM_THUMB_DEF bit of the n_desc field indicates that the symbol is
	a defintion of a Thumb function.

	N_ARM_THUMB_DEF	0x0008 /* symbol is a Thumb function (ARM) */

	The N_SYMBOL_RESOLVER bit of the n_desc field indicates that the
	that the function is actually a resolver function and should
	be called to get the address of the real function to use.
	This bit is only available in .o files (MH_OBJECT filetype)

	N_SYMBOL_RESOLVER  0x0100 "
	
	self subclassResponsibility 
]

{ #category : #accessing }
P4MOSymbol >> global [
	global := true
]

{ #category : #accessing }
P4MOSymbol >> index [
	^ index
]

{ #category : #accessing }
P4MOSymbol >> index: aNumber [
	index := aNumber
]

{ #category : #'as yet unclassified' }
P4MOSymbol >> initialize [ 
	global := false.
]

{ #category : #accessing }
P4MOSymbol >> name [
	^ name
]

{ #category : #accessing }
P4MOSymbol >> name: anObject [
	name := anObject
]

{ #category : #accessing }
P4MOSymbol >> nameIndex [
	^ nameIndex
]

{ #category : #accessing }
P4MOSymbol >> nameIndex: anObject [
	nameIndex := anObject
]

{ #category : #'as yet unclassified' }
P4MOSymbol >> section [
	"If the type is N_SECT then the n_sect field contains an ordinal of the
	section the symbol is defined in.  The sections are numbered from 1 and 
	refer to sections in order they appear in the load commands for the file
	they are in.  This means the same ordinal may very well refer to different
	sections in different files.

	The n_value field for all symbol table entries (including N_STAB's) gets
	updated by the link editor based on the value of it's n_sect field and where
	the section n_sect references gets relocated.  If the value of the n_sect 
	field is NO_SECT then it's n_value field is not changed by the link editor.
"
	^ section
]

{ #category : #accessing }
P4MOSymbol >> section: anObject [
	section := anObject
]

{ #category : #'as yet unclassified' }
P4MOSymbol >> sectionOffset [
	^ value
]

{ #category : #'as yet unclassified' }
P4MOSymbol >> size [
	^ size
]

{ #category : #'as yet unclassified' }
P4MOSymbol >> size: aNumber [
	size := aNumber
]

{ #category : #'as yet unclassified' }
P4MOSymbol >> type [
	"
	Values for N_TYPE bits of the n_type field.

	N_UNDF	0x0		/* undefined, n_sect == NO_SECT */
	N_ABS	0x2		/* absolute, n_sect == NO_SECT */
	N_SECT	0xe		/* defined in section number n_sect */
	N_PBUD	0xc		/* prebound undefined (defined in a dylib) */
	fine N_INDR	0xa		/* indirect */


	If the type is N_INDR then the symbol is defined to be the same as another
	symbol.  In this case the n_value field is an index into the string table
	of the other symbol's name.  When the other symbol is defined then they both
	take on the defined type and value.
"
	^ self subclassResponsibility 
]

{ #category : #'as yet unclassified' }
P4MOSymbol >> typeFlags [
	"The n_type field really contains four fields:
	 unsigned char N_STAB:3,
	 	      N_PEXT:1,
	 	      N_TYPE:3,
	 	      N_EXT:1;
	which are used via the following masks.

	N_STAB	0xe0  /* if any of these bits set, a symbolic debugging entry */
	N_PEXT	0x10  /* private external symbol bit */
	N_TYPE	0x0e  /* mask for the type bits */
	N_EXT	0x01  /* external symbol bit, set for external symbols */

	Only symbolic debugging entries have some of the N_STAB bits set and if any
	of these bits are set then it is a symbolic debugging entry (a stab).  In
	which case then the values of the n_type field (the entire field) are given
	in <mach-o/stab.h>"
	^ (self type bitAnd: 16r0E) bitOr:( global asBit bitAnd: 16r01)
]

{ #category : #'as yet unclassified' }
P4MOSymbol >> value [
	"An integer that contains the value of the symbol. The format of this value is different for each type of symbol table entry (as specified by the n_type field). For the N_SECT symbol type, n_value is the address of the symbol. See the description of the n_type field for information on other possible values."
	^ value
]

{ #category : #accessing }
P4MOSymbol >> value: anObject [
	value := anObject
]

{ #category : #'as yet unclassified' }
P4MOSymbol >> writeOn: aStream [
	aStream wordPut: nameIndex.
	aStream nextPut: self typeFlags.
	aStream nextPut: section index.
	aStream halfWordPut: self description.
	aStream pointerPut: self value.
]
