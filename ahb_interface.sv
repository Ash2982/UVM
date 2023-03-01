///////////////////////////// Ashwin Alex George /////////////////////////////
/////////////////////////////// APB Interface ////////////////////////////////

interface ahb_intf(input logic HCLK,HRESETn);

logic 				HSEL;
logic [(`ADDR_WIDTH-1):0] 	HADDR;
logic [(`DATA_WIDTH-1):0] 	HWDATA;
logic [(`DATA_WIDTH-1):0] 	HRDATA;
logic				HWRITE;
logic [2:0]			HSIZE;
logic [2:0]			HBURST;
logic [3:0]			HPROT;
logic [1:0]			HTRANS;
logic 				HMASTERLOCK;
logic				HREADYIN;
logic				HREADYOUT;
logic				HRESP;

endinterface
