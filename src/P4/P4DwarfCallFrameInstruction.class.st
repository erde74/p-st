"
""Each call frame instruction is defined to take 0 or more operands. Some of the operands may be
encoded as part of the opcode (see section 7.23). The instructions are as follows:

1. DW_CFA_advance_loc takes a single argument that represents a constant delta. The
  required action is to create a new table row with a location value that is computed by taking
  the current entrys location value and adding (delta * code_alignment_factor). All
  other values in the new row are initially identical to the current row

2. DW_CFA_offset takes two arguments: an unsigned LEB128 constant representing a
  factored offset and a register number. The required action is to change the rule for the
  register indicated by the register number to be an offset(N) rule with a value of (N =
  factored offset * data_alignment_factor).

3. DW_CFA_restore takes a single argument that represents a register number. The
   required action is to change the rule for the indicated register to the rule assigned it by the
   initial_instructions in the CIE.

4. DW_CFA_set_loc takes a single argument that represents an address. The required
   action is to create a new table row using the specified address as the location. All other
   values in the new row are initially identical to the current row. The new location value
   should always be greater than the current one.

5. DW_CFA_advance_loc1 takes a single ubyte argument that represents a constant delta.
   This instruction is identical to DW_CFA_advance_loc except for the encoding and size
   of the delta argument.

6. DW_CFA_advance_loc2 takes a single uhalf argument that represents a constant delta.
   This instruction is identical to DW_CFA_advance_loc except for the encoding and size
   of the delta argument.

7. DW_CFA_advance_loc4 takes a single uword argument that represents a constant delta.
   This instruction is identical to DW_CFA_advance_loc except for the encoding and size
   of the delta argument.

8. DW_CFA_offset_extended takes two unsigned LEB128 arguments representing a
   register number and a factored offset. This instruction is identical to DW_CFA_offset
   except for the encoding and size of the register argument.

9. DW_CFA_restore_extended takes a single unsigned LEB128 argument that
   represents a register number. This instruction is identical to DW_CFA_restore except
   for the encoding and size of the register argument.

10. DW_CFA_undefined takes a single unsigned LEB128 argument that represents a register
   number. The required action is to set the rule for the specified register to 'undefined'

11. DW_CFA_same_value takes a single unsigned LEB128 argument that represents a
   register number. The required action is to set the rule for the specified register to 'same value'

12. DW_CFA_register takes two unsigned LEB128 arguments representing register
   numbers. The required action is to set the rule for the first register to be the second register.

13. DW_CFA_remember_state

14. DW_CFA_restore_state
   These  instructions define  a stack of information. Encountering the DW_CFA_remember_state instruction means 
   to save the rules for every register on the current row on the stack. Encountering the DW_CFA_restore_state instruction
   means to pop the set of rules off the stack and place them in the current row. (This operation is useful for compilers 
   that move epilogue code into the body of a function.)

15. DW_CFA_def_cfa takes two unsigned LEB128 arguments representing a register number
   and an offset. The required action is to define the current CFA rule to use the provided
    register and offset.

16. DW_CFA_def_cfa_register takes a single unsigned LEB128 argument representing
   a register number. The required action is to define the current CFA rule to use the provided
    register (but to keep the old offset).

17. DW_CFA_def_cfa_offset takes a single unsigned LEB128 argument representing an
   offset. The required action is to define the current CFA rule to use the provided offset (but
    to keep the old register).

18. DW_CFA_nop has no arguments and no required actions. It is used as padding to make the
   FDE an appropriate size.""
"
Class {
	#name : #P4DwarfCallFrameInstruction,
	#superclass : #P4Object,
	#category : #'P4-Exec-ELF-Dwarf'
}
