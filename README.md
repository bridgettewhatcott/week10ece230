# Sequential Circuits: Latches

In this lab, you learned about the basic building block of sequential circuits: the latch.

## Rubric

| Item | Description | Value |
| ---- | ----------- | ----- |
| Summary Answers | Your writings about what you learned in this lab. | 25% |
| Question 1 | Your answers to the question | 25% |
| Question 2 | Your answers to the question | 25% |
| Question 3 | Your answers to the question | 25% |

## Lab Questions

###  Why can we not just use structural Verilog to implement latches?
Behavioral verilog allows our circuit to have memory. In order to build a latch, the circuit must have memory.
Structural verilog does not allow the circuits to have memory, because it only uses continuous assignment.
It will give a combinatorial loop error and will not let you run the code.

### What is the meaning of always @(*) in a sensitivity block?
A sensitivity block allows us to state what signals our memory is connected to. 
The always @(*) syntax allows continuous assignment (without memory) to also be included.

### What importance is memory to digital circuits?
Allows data to remain even when inputs return to zero.
