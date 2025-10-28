//Ran simulation, appeared to pass. Later realized memory is not connected. Some issues fixed by deleting a reg identifier.
//First two switches work the same as was demonstrated in the video. Other switches not functional.

module dLatch(
    input D, E,
    output reg Q, 
    output NotQ
);
   always @(E,D) begin
        if(E)
            if(D)
                Q<=1;
            else if(~D)
                Q<=0;
        end
    assign NotQ = ~Q;
endmodule


module demux(
    input [7:0] data,
    input [1:0] sel,
    output reg [7:0] A,
    output reg [7:0] B,
    output reg [7:0] C,
    output reg [7:0] D
);
    always @(*) begin 
        case(sel)
            2'b00: {D, C, B, A} <= {8'b0, 8'b0, 8'b0, data}; 
            2'b01: {D, C, B, A} <= {8'b0, 8'b0, data, 8'b0};
            2'b10: {D, C, B, A} <= {8'b0, data, 8'b0, 8'b0};
            2'b11: {D, C, B, A} <= {data, 8'b0, 8'b0, 8'b0};
        endcase
    end
endmodule


module byte_memory(
    input [7:0] data,
    input store,
    output reg [7:0] memory
);
    always @(store) begin
        if(store)
            memory <= data;
        end
endmodule


module memory_system(
    input [7:0] data,
    input store,
    input [1:0] addr,
    output [7:0] memory
);

     wire [7:0]senddata[3:0];
     wire [7:0]sendstore[3:0];
     wire [3:0]sendloc;
     
         byte_memory bmOne_inst(
        .data(sendstore[0]),
        .store(sendloc[0]),
        .memory(senddata[0])
    );
     byte_memory bm2_inst(
        .data(sendstore[1]),
        .store(sendloc[1]),
        .memory(senddata[1])
    );
     byte_memory bm3_inst(
        .data(sendstore[2]),
        .store(sendloc[2]),
        .memory(senddata[2])
    );
     byte_memory bm4_inst(
        .data(sendstore[3]),
        .store(sendloc[3]),
        .memory(senddata[3])
    );
     
     
    demux demuxData_inst(
   // Demux to send (array of vectors) data to inst[addr]
        .sel(addr),
        .data(senddata[0]),
        .A(senddata[0]),
        .B(senddata[1]),
        .C(senddata[2]),
        .D(senddata[3])
    );
    
    demux demuxStore_inst(
   // Demux to send (vector) store to inst[addr]
        .sel(addr),
        .data(store),
        .A(sendstore[0]),
        .B(sendstore[1]),
        .C(sendstore[2]),
        .D(sendstore[3])
    );
    
    mux muxDataToMemory_inst(
   // Mux to send inst[addr].data -> memory  
        .sel(addr),
        .Y(sendstore[0]),
        .A(memory[0]),
        .B(memory[1]),
        .C(memory[2]),
        .D(memory[3])
        
       //Left off: should this be memory or sendstore? First 2 switches work w/ btn, others do not. 
    );
    


endmodule


module mux(
    input [7:0] sel,
    input [3:0] A, B, C, D,
    input Enable,
    output [3:0] Y
);
    assign Y = sel == 'b00 ? A :
    sel == 'b01 ? B:
    sel == 'b10 ? C: D;
endmodule


module top(
    input [15:0] sw,
    input btnC,
    output [15:0] led
);
    dLatch part1(
        .D(sw[0]),
        .Q(led[0]),
        .NotQ(led[1]),
        .E(btnC)
    );
    memory_system part2(
        .data(sw[15:8]),
        .addr(sw[7:6]),
        .store(btnC),
        .memory(led[15:8])
        //TA fixed this last line
    );
endmodule

