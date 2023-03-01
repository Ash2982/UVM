///////////////////////////// Ashwin Alex George /////////////////////////////
/////////////////////////////// APB Interface ////////////////////////////////

interface apb_intf(input logic PCLK,PRESETn);

logic                           PSEL;
logic                           PENABLE;
logic [2:0]                     PPROT;
logic                           PWRITE;
logic [(`DATA_WIDTH/8)-1:0]     PSTRB;
logic [(`ADDR_WIDTH -1):0]      PADDR;
logic [(`DATA_WIDTH-1):0]       PWDATA;
logic [(`DATA_WIDTH-1):0]       PRDATA;
logic                           PREADY;
logic                           PSLVERR;

endinterface