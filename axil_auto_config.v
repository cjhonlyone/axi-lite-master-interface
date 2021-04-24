module axil_auto_config(
    // for simulate
    output      [7:0] ocfg_cur_state  ,

    input             s_axi_aclk      ,
    input             s_axi_aresetn   ,
    input             s_axi_arready   ,
    input             s_axi_rvalid    ,
    input      [31:0] s_axi_rdata     ,
    input       [1:0] s_axi_rresp     ,
    output     [31:0] s_axi_araddr    ,
    output            s_axi_arvalid   ,
    output            s_axi_rready    ,

    input             s_axi_awready   ,
    input             s_axi_wready    ,
    input             s_axi_bvalid    ,
    input       [1:0] s_axi_bresp     ,
    output     [31:0] s_axi_awaddr    ,
    output            s_axi_awvalid   ,
    output     [31:0] s_axi_wdata     ,
    output            s_axi_wvalid    ,
    output            s_axi_bready    
);

    reg             s_axi_cfg_wvalid;
    reg      [31:0] s_axi_cfg_waddr ;
    reg      [31:0] s_axi_cfg_wdata ;
    wire            s_axi_cfg_wready;

    reg             s_axi_cfg_rvalid;
    reg      [31:0] s_axi_cfg_raddr ;
    wire     [31:0] s_axi_cfg_rdata ;
    wire            s_axi_cfg_rdv   ;
    wire            s_axi_cfg_rready;

    axil_write inst_axil_write
        (
            .s_axi_aclk       (s_axi_aclk),
            .s_axi_aresetn    (s_axi_aresetn),
            .s_axi_awready    (s_axi_awready),
            .s_axi_wready     (s_axi_wready),
            .s_axi_bvalid     (s_axi_bvalid),
            .s_axi_bresp      (s_axi_bresp),
            .s_axi_awaddr     (s_axi_awaddr),
            .s_axi_awvalid    (s_axi_awvalid),
            .s_axi_wdata      (s_axi_wdata),
            .s_axi_wvalid     (s_axi_wvalid),
            .s_axi_bready     (s_axi_bready),

            .s_axi_cfg_wvalid (s_axi_cfg_wvalid),
            .s_axi_cfg_waddr  (s_axi_cfg_waddr),
            .s_axi_cfg_wdata  (s_axi_cfg_wdata),
            .s_axi_cfg_wready (s_axi_cfg_wready)
        );


    axil_read inst_axil_read
        (
            .s_axi_aclk       (s_axi_aclk),
            .s_axi_aresetn    (s_axi_aresetn),
            .s_axi_arready    (s_axi_arready),
            .s_axi_rvalid     (s_axi_rvalid),
            .s_axi_rdata      (s_axi_rdata),
            .s_axi_rresp      (s_axi_rresp),
            .s_axi_araddr     (s_axi_araddr),
            .s_axi_arvalid    (s_axi_arvalid),
            .s_axi_rready     (s_axi_rready),

            .s_axi_cfg_rvalid (s_axi_cfg_rvalid),
            .s_axi_cfg_raddr  (s_axi_cfg_raddr),
            .s_axi_cfg_rdata  (s_axi_cfg_rdata),
            .s_axi_cfg_rdv    (s_axi_cfg_rdv),
            .s_axi_cfg_rready (s_axi_cfg_rready)
        );

    reg     [7:0]       rcfg_cur_state;
    reg    [31:0]       r_cfg_rdata   ;
    reg    [31:0]       r_timer       ;

    always @ (posedge s_axi_aclk) begin
        if(!s_axi_aresetn) begin
            rcfg_cur_state   <= 8'd0;

            s_axi_cfg_wvalid <= 1'b0;
            s_axi_cfg_waddr  <= 32'd0;
            s_axi_cfg_wdata  <= 32'd0;
            
            s_axi_cfg_rvalid <= 1'b0;
            s_axi_cfg_raddr  <= 32'd0;

            r_timer          <= 32'd0;
            r_cfg_rdata      <= 32'd0;
        end else begin
            case (rcfg_cur_state)
            8'd00: begin 
                rcfg_cur_state   <= ((s_axi_cfg_wready==1'b1) && (r_timer==32'd1)) ? 8'd01 : 8'd00;

                s_axi_cfg_wvalid <= s_axi_cfg_wready ? 1'b1 : 1'b0;
                s_axi_cfg_waddr  <= {29'd02 ,2'b00}; 
                s_axi_cfg_wdata  <= {32'h00000001}; 

                s_axi_cfg_rvalid <= 1'b0;
                s_axi_cfg_raddr  <= 32'd0;

                r_timer          <= ((s_axi_cfg_wready==1'b1) && (r_timer==32'd0)) ? (32'd1) : 32'd0;
                r_cfg_rdata      <= 32'd0;
            end
            8'd01: begin 
                rcfg_cur_state   <= ((s_axi_cfg_wready==1'b1) && (r_timer==32'd1)) ? 8'd02 : 8'd01;

                s_axi_cfg_wvalid <= s_axi_cfg_wready ? 1'b1 : 1'b0;
                s_axi_cfg_waddr  <= {29'd03 ,2'b00}; 
                s_axi_cfg_wdata  <= {32'h00000000}; 

                s_axi_cfg_rvalid <= 1'b0;
                s_axi_cfg_raddr  <= 32'd0;

                r_timer          <= ((s_axi_cfg_wready==1'b1) && (r_timer==32'd0)) ? (32'd1) : 32'd0;
                r_cfg_rdata      <= 32'd0;
            end
            8'd02: begin 
                rcfg_cur_state   <= ((s_axi_cfg_wready==1'b1) && (r_timer==32'd1)) ? 8'd03 : 8'd02;

                s_axi_cfg_wvalid <= s_axi_cfg_wready ? 1'b1 : 1'b0;
                s_axi_cfg_waddr  <= {29'd04 ,2'b00}; 
                s_axi_cfg_wdata  <= {32'h00000001};

                s_axi_cfg_rvalid <= 1'b0;
                s_axi_cfg_raddr  <= 32'd0;

                r_timer          <= ((s_axi_cfg_wready==1'b1) && (r_timer==32'd0)) ? (32'd1) : 32'd0;
                r_cfg_rdata      <= 32'd0;
            end
            8'd03: begin 
                rcfg_cur_state   <= ((s_axi_cfg_wready==1'b1) && (r_timer==32'd1)) ? 8'd04 : 8'd03;

                s_axi_cfg_wvalid <= s_axi_cfg_wready ? 1'b1 : 1'b0;
                s_axi_cfg_waddr  <= {29'd06 ,2'b00}; 
                s_axi_cfg_wdata  <= {32'h00000000};

                s_axi_cfg_rvalid <= 1'b0;
                s_axi_cfg_raddr  <= 32'd0;

                r_timer          <= ((s_axi_cfg_wready==1'b1) && (r_timer==32'd0)) ? (32'd1) : 32'd0;
                r_cfg_rdata      <= 32'd0;
            end
            8'd04: begin 
                rcfg_cur_state   <= ((s_axi_cfg_wready==1'b1) && (r_timer==32'd1)) ? 8'd05 : 8'd04;

                s_axi_cfg_wvalid <= s_axi_cfg_wready ? 1'b1 : 1'b0;
                s_axi_cfg_waddr  <= {29'd08 ,2'b00}; 
                s_axi_cfg_wdata  <= {32'h00000001};

                s_axi_cfg_rvalid <= 1'b0;
                s_axi_cfg_raddr  <= 32'd0;

                r_timer          <= ((s_axi_cfg_wready==1'b1) && (r_timer==32'd0)) ? (32'd1) : 32'd0;
                r_cfg_rdata      <= 32'd0;
            end
            8'd05: begin 
                rcfg_cur_state   <= ((s_axi_cfg_wready==1'b1) && (r_timer==32'd1)) ? 8'd06 : 8'd05;

                s_axi_cfg_wvalid <= s_axi_cfg_wready ? 1'b1 : 1'b0;
                s_axi_cfg_waddr  <= {29'd09 ,2'b00}; 
                s_axi_cfg_wdata  <= {32'h0000001F};

                s_axi_cfg_rvalid <= 1'b0;
                s_axi_cfg_raddr  <= 32'd0;

                r_timer          <= ((s_axi_cfg_wready==1'b1) && (r_timer==32'd0)) ? (32'd1) : 32'd0;
                r_cfg_rdata      <= 32'd0;
            end
            8'd06: begin 
                rcfg_cur_state   <= ((s_axi_cfg_wready==1'b1) && (r_timer==32'd1)) ? 8'd07 : 8'd06;

                s_axi_cfg_wvalid <= s_axi_cfg_wready ? 1'b1 : 1'b0;
                s_axi_cfg_waddr  <= {29'd10 ,2'b00}; 
                s_axi_cfg_wdata  <= {32'h00000003};

                s_axi_cfg_rvalid <= 1'b0;
                s_axi_cfg_raddr  <= 32'd0;

                r_timer          <= ((s_axi_cfg_wready==1'b1) && (r_timer==32'd0)) ? (32'd1) : 32'd0;
                r_cfg_rdata      <= 32'd0;
            end
            8'd07: begin 
                rcfg_cur_state   <= ((s_axi_cfg_wready==1'b1) && (r_timer==32'd1)) ? 8'd08 : 8'd07;

                s_axi_cfg_wvalid <= s_axi_cfg_wready ? 1'b1 : 1'b0;
                s_axi_cfg_waddr  <= {29'd11 ,2'b00}; 
                s_axi_cfg_wdata  <= {32'h00000001};

                s_axi_cfg_rvalid <= 1'b0;
                s_axi_cfg_raddr  <= 32'd0;

                r_timer          <= ((s_axi_cfg_wready==1'b1) && (r_timer==32'd0)) ? (32'd1) : 32'd0;
                r_cfg_rdata      <= 32'd0;
            end
            8'd08: begin 
                rcfg_cur_state   <= ((s_axi_cfg_wready==1'b1) && (r_timer==32'd1)) ? 8'd09 : 8'd08;

                s_axi_cfg_wvalid <= s_axi_cfg_wready ? 1'b1 : 1'b0;
                s_axi_cfg_waddr  <= {29'd12 ,2'b00}; 
                s_axi_cfg_wdata  <= {32'h00000000};

                s_axi_cfg_rvalid <= 1'b0;
                s_axi_cfg_raddr  <= 32'd0;

                r_timer          <= ((s_axi_cfg_wready==1'b1) && (r_timer==32'd0)) ? (32'd1) : 32'd0;
                r_cfg_rdata      <= 32'd0;
            end
            8'd09: begin 
                rcfg_cur_state   <= ((s_axi_cfg_wready==1'b1) && (r_timer==32'd1)) ? 8'd10 : 8'd09;

                s_axi_cfg_wvalid <= s_axi_cfg_wready ? 1'b1 : 1'b0;
                s_axi_cfg_waddr  <= {29'd13 ,2'b00}; 
                s_axi_cfg_wdata  <= {32'h00000000};

                s_axi_cfg_rvalid <= 1'b0;
                s_axi_cfg_raddr  <= 32'd0;

                r_timer          <= ((s_axi_cfg_wready==1'b1) && (r_timer==32'd0)) ? (32'd1) : 32'd0;
                r_cfg_rdata      <= 32'd0;
            end
            // Link configuration has changed so reset the interface
            8'd10: begin 
                rcfg_cur_state   <= ((s_axi_cfg_wready==1'b1) && (r_timer==32'd1)) ? 8'd11 : 8'd10;

                s_axi_cfg_wvalid <= s_axi_cfg_wready ? 1'b1 : 1'b0;
                s_axi_cfg_waddr  <= {29'd01 ,2'b00}; 
                s_axi_cfg_wdata  <= {32'h00000001};

                s_axi_cfg_rvalid <= 1'b0;
                s_axi_cfg_raddr  <= 32'd0;

                r_timer          <= ((s_axi_cfg_wready==1'b1) && (r_timer==32'd0)) ? (32'd1) : 32'd0;
                r_cfg_rdata      <= 32'd0;
            end

            // Now poll register until reset has cleared
            8'd11: begin 
                rcfg_cur_state   <= (s_axi_cfg_rdv==1'b1) ? 8'd12 : 8'd11;

                s_axi_cfg_wvalid <= 1'b0;
                s_axi_cfg_waddr  <= 32'd0;
                s_axi_cfg_wdata  <= 32'd0;

                s_axi_cfg_rvalid <= s_axi_cfg_rready ? 1'b1 : 1'b0;
                s_axi_cfg_raddr  <= {29'd01 ,2'b00}; 

                r_timer          <= ((s_axi_cfg_rready==1'b1) && (r_timer==32'd0)) ? 32'd1 : 32'd0;
                r_cfg_rdata      <= (s_axi_cfg_rdv==1'b1) ? s_axi_cfg_rdata : 32'd0;
            end
            8'd12: begin
                rcfg_cur_state   <= (r_cfg_rdata[0] != 1'b0) ? 8'd11 : 8'd13;

                s_axi_cfg_wvalid <= 1'b0;
                s_axi_cfg_waddr  <= 32'd0;
                s_axi_cfg_wdata  <= 32'd0;

                s_axi_cfg_rvalid <= 1'b0;
                s_axi_cfg_raddr  <= 32'd0; 

                r_timer          <= 32'd0;
                r_cfg_rdata      <= 32'd0;
            end

            // Poll status until Rx is in sync
            8'd13: begin 
                rcfg_cur_state   <= (s_axi_cfg_rdv==1'b1) ? 8'd14 : 8'd13;

                s_axi_cfg_wvalid <= 1'b0;
                s_axi_cfg_waddr  <= 32'd0;
                s_axi_cfg_wdata  <= 32'd0;

                s_axi_cfg_rvalid <= s_axi_cfg_rready ? 1'b1 : 1'b0;
                s_axi_cfg_raddr  <= {29'd14 ,2'b00}; 

                r_timer          <= ((s_axi_cfg_rready==1'b1) && (r_timer==32'd0)) ? 32'd1 : 32'd0;
                r_cfg_rdata      <= (s_axi_cfg_rdv==1'b1) ? s_axi_cfg_rdata : 32'd0;
            end
            8'd14: begin
                rcfg_cur_state   <= (r_cfg_rdata[0] != 1'b1) ? 8'd13 : 8'd15;

                s_axi_cfg_wvalid <= 1'b0;
                s_axi_cfg_waddr  <= 32'd0;
                s_axi_cfg_wdata  <= 32'd0;

                s_axi_cfg_rvalid <= 1'b0;
                s_axi_cfg_raddr  <= 32'd0; 

                r_timer          <= 32'd0;
                r_cfg_rdata      <= 32'd0;
            end

            // IDLE
            8'd15: begin
                rcfg_cur_state   <= 8'd15;

                s_axi_cfg_wvalid <= 1'b0;
                s_axi_cfg_waddr  <= 32'd0;
                s_axi_cfg_wdata  <= 32'd0;

                s_axi_cfg_rvalid <= 1'b0;
                s_axi_cfg_raddr  <= 32'd0; 

                r_timer          <= 32'd0;
                r_cfg_rdata      <= 32'd0;
            end
            default:rcfg_cur_state <= rcfg_cur_state;
            endcase
        end

    end
    
    assign ocfg_cur_state = rcfg_cur_state;
endmodule