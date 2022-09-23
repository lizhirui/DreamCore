`include "config.svh"
`include "common.svh"

module rat(
        input logic clk,
        input logic rst,
        
        output logic[`PHY_REG_ID_WIDTH - 1:0] rat_rename_new_phy_id[0:`RENAME_WIDTH - 1],
        output logic[`RENAME_WIDTH - 1:0] rat_rename_new_phy_id_valid,
        input logic[`PHY_REG_ID_WIDTH - 1:0] rename_rat_phy_id[0:`RENAME_WIDTH - 1],
        input logic[`RENAME_WIDTH - 1:0] rename_rat_phy_id_valid,
        input logic[`ARCH_REG_ID_WIDTH - 1:0] rename_rat_arch_id[0:`RENAME_WIDTH - 1],
        input logic rename_rat_map,
        
        input logic[`ARCH_REG_ID_WIDTH - 1:0] rename_rat_read_arch_id[0:`RENAME_WIDTH - 1][0:2],
        output logic[`PHY_REG_ID_WIDTH - 1:0] rat_rename_read_phy_id[0:`RENAME_WIDTH - 1][0:2],
        
        output logic[`PHY_REG_NUM - 1:0] rat_rename_map_table_valid,
        output logic[`PHY_REG_NUM - 1:0] rat_rename_map_table_visible,
        
        input logic[`PHY_REG_NUM - 1:0] commit_rat_map_table_valid,
        input logic[`PHY_REG_NUM - 1:0] commit_rat_map_table_visible,
        input logic commit_rat_map_table_restore,
        
        input logic[`PHY_REG_ID_WIDTH - 1:0] commit_rat_release_phy_id[0:`COMMIT_WIDTH - 1],
        input logic[`COMMIT_WIDTH - 1:0] commit_rat_release_phy_id_valid,
        input logic commit_rat_release_map,
        
        input logic[`PHY_REG_ID_WIDTH - 1:0] commit_rat_commit_phy_id[0:`COMMIT_WIDTH - 1],
        input logic[`COMMIT_WIDTH - 1:0] commit_rat_commit_phy_id_valid,
        input logic commit_rat_commit_map,
        
        input logic[`PHY_REG_ID_WIDTH - 1:0] commit_rat_restore_new_phy_id,
        input logic[`PHY_REG_ID_WIDTH - 1:0] commit_rat_restore_old_phy_id,
        input logic commit_rat_restore_map
    );

    
    logic[`ARCH_REG_ID_WIDTH - 1:0] map_table[0:`PHY_REG_NUM - 1];
    logic[`PHY_REG_NUM - 1:0] map_valid;
    logic[`PHY_REG_NUM - 1:0] map_visible;
    logic[`PHY_REG_NUM - 1:0] map_commit;

    logic[`PHY_REG_ID_WIDTH - 1:0] new_phy_id_temp[0:`PHY_REG_NUM - 1][0:`RENAME_WIDTH - 1];
    logic[$clog2(`RENAME_WIDTH):0] new_phy_id_cnt_temp[0:`PHY_REG_NUM - 1];

    logic[`RENAME_WIDTH - 1:0] visible_channel_disable_cmp[0:`RENAME_WIDTH - 1];
    logic[`RENAME_WIDTH - 1:0] visible_enable_cmp[0:`PHY_REG_NUM - 1];
    logic[`PHY_REG_NUM - 1:0] visible_enable;

    logic[`RENAME_WIDTH - 1:0] new_arch_id_cmp[0:`PHY_REG_NUM - 1];
    logic[$clog2(`RENAME_WIDTH) - 1:0] new_arch_id_channel_index[0:`PHY_REG_NUM - 1];
    logic[`ARCH_REG_ID_WIDTH - 1:0] new_arch_id[0:`PHY_REG_NUM - 1];
    logic[`PHY_REG_NUM - 1:0] new_arch_id_valid;

    logic[`RENAME_WIDTH - 1:0] hide_phy_id_cmp[0:`PHY_REG_NUM - 1];
    logic[`PHY_REG_NUM - 1:0] hide_phy_id;

    logic[`COMMIT_WIDTH - 1:0] release_phy_id_cmp[0:`PHY_REG_NUM - 1];
    logic[`PHY_REG_NUM - 1:0] release_phy_id_valid;

    logic[`COMMIT_WIDTH - 1:0] commit_phy_id_cmp[0:`PHY_REG_NUM - 1];
    logic[`PHY_REG_NUM - 1:0] commit_phy_id_valid;

    logic[`PHY_REG_NUM - 1:0] cam_arch_id_cmp[0:`RENAME_WIDTH - 1][0:2];

    genvar i, i2, j;
    integer k;

    //output valid and visible properties
    assign rat_rename_map_table_valid = map_valid;
    assign rat_rename_map_table_visible = map_visible;

    //generate new phy id list
    generate
        for(j = 0;j < `RENAME_WIDTH;j++) begin
            assign new_phy_id_temp[0][j] = 'b0;
        end
        
        assign new_phy_id_cnt_temp[0] = map_valid[0] ? 'b0 : 'b1;

        for(i = 1;i < `PHY_REG_NUM;i++) begin
            always_comb begin
                new_phy_id_temp[i] = new_phy_id_temp[i - 1];

                if(!map_valid[i] && (new_phy_id_cnt_temp[i - 1] < unsigned'(`RENAME_WIDTH))) begin
                    new_phy_id_temp[i][new_phy_id_cnt_temp[i - 1]] = i;
                    new_phy_id_cnt_temp[i] = new_phy_id_cnt_temp[i - 1] + 'b1;
                end
                else begin
                    new_phy_id_cnt_temp[i] = new_phy_id_cnt_temp[i - 1];
                end
            end
        end
    endgenerate

    generate
        for(i = 0;i < `RENAME_WIDTH;i++) begin
            assign rat_rename_new_phy_id[i] = new_phy_id_temp[`PHY_REG_NUM - 1][i];
            assign rat_rename_new_phy_id_valid[i] = i < new_phy_id_cnt_temp[`PHY_REG_NUM - 1];
        end
    endgenerate

    //get new arch id for every new phy id
    generate
        for(i = 0;i < `PHY_REG_NUM;i++) begin: new_arch_id_generate
            for(j = 0;j < `RENAME_WIDTH;j++) begin
                assign new_arch_id_cmp[i][j] = (rename_rat_phy_id[j] == unsigned'(i)) && rename_rat_phy_id_valid[j];
            end

            parallel_finder #(
                .WIDTH(`RENAME_WIDTH)
            )parallel_finder_new_arch_id_inst(
                .data_in(new_arch_id_cmp[i]),
                .index(new_arch_id_channel_index[i]),
                .index_valid(new_arch_id_valid[i])
            );

            assign new_arch_id[i] = rename_rat_arch_id[new_arch_id_channel_index[i]];
        end
    endgenerate

    //get visible enable signal
    generate
        assign visible_channel_disable_cmp[`RENAME_WIDTH - 1] = 'b0;

        for(i = 0;i < `RENAME_WIDTH - 1;i++) begin
            for(j = 0;j < `RENAME_WIDTH;j++) begin
                if(j <= i) begin
                    assign visible_channel_disable_cmp[i][j] = 'b0;
                end
                else begin
                    assign visible_channel_disable_cmp[i][j] = (rename_rat_arch_id[i] == rename_rat_arch_id[j]) && rename_rat_phy_id_valid[j];
                end
            end
        end

        for(i = 0;i < `PHY_REG_NUM;i++) begin
            for(j = 0;j < `RENAME_WIDTH;j++) begin
                assign visible_enable_cmp[i][j] = (rename_rat_phy_id[j] == unsigned'(i)) && rename_rat_phy_id_valid[j] && !(|visible_channel_disable_cmp[j]);
            end

            parallel_finder #(
                .WIDTH(`RENAME_WIDTH)
            )parallel_finder_visible_enable_inst(
                .data_in(visible_enable_cmp[i]),
                .index_valid(visible_enable[i])
            );
        end
    endgenerate

    //get hide phy id for every new map
    generate
        for(i = 0;i < `PHY_REG_NUM;i++) begin: hide_phy_id_generate
            for(j = 0;j < `RENAME_WIDTH;j++) begin
                assign hide_phy_id_cmp[i][j] = (rename_rat_arch_id[j] == map_table[i]) && map_valid[i] && map_visible[i] && rename_rat_phy_id_valid[j];
            end

            parallel_finder #(
                .WIDTH(`RENAME_WIDTH)
            )parallel_finder_hide_phy_id_inst(
                .data_in(hide_phy_id_cmp[i]),
                .index_valid(hide_phy_id[i])
            );
        end
    endgenerate

    //get releasing maps
    generate
        for(i = 0;i < `PHY_REG_NUM;i++) begin: release_phy_id_generate
            for(j = 0;j < `RENAME_WIDTH;j++) begin
                assign release_phy_id_cmp[i][j] = (commit_rat_release_phy_id[j] == i) && commit_rat_release_phy_id_valid[j];
            end

            parallel_finder #(
                .WIDTH(`RENAME_WIDTH)
            )parallel_finder_release_phy_id_inst(
                .data_in(release_phy_id_cmp[i]),
                .index_valid(release_phy_id_valid[i])
            );
        end
    endgenerate

    //get committing maps
    generate
        for(i = 0;i < `PHY_REG_NUM;i++) begin: commit_phy_id_generate
            for(j = 0;j < `RENAME_WIDTH;j++) begin
                assign commit_phy_id_cmp[i][j] = (commit_rat_commit_phy_id[j] == i) && commit_rat_commit_phy_id_valid[j];
            end

            parallel_finder #(
                .WIDTH(`RENAME_WIDTH)
            )parallel_finder_commit_phy_id_inst(
                .data_in(commit_phy_id_cmp[i]),
                .index_valid(commit_phy_id_valid[i])
            );
        end
    endgenerate

    //update valid property
    generate
        for(i = 0;i < `PHY_REG_NUM;i++) begin
            always_ff @(posedge clk) begin
                if(rst) begin
                    if((i >= 1) && (i < `ARCH_REG_NUM)) begin
                        map_valid[i] <= 'b1;//1 only for 1~`ARCH_REG_NUM - 1
                    end
                    else begin
                        map_valid[i] <= 'b0;
                    end
                end
                else if(commit_rat_map_table_restore) begin //restore valid property vector
                    map_valid[i] <= commit_rat_map_table_valid[i];
                end
                else if((i == commit_rat_restore_new_phy_id) && commit_rat_restore_map) begin //restore a new map
                    map_valid[i] <= 'b0;
                end
                else if((i == commit_rat_restore_old_phy_id) && commit_rat_restore_map) begin //restore a old map
                    map_valid[i] <= 'b1;
                end
                else if(release_phy_id_valid[i] && commit_rat_release_map) begin //release a map
                    map_valid[i] <= 'b0;
                end
                else if(new_arch_id_valid[i] && rename_rat_map) begin //create a new map
                    map_valid[i] <= 'b1;
                end
            end
        end
    endgenerate

    //update visible property
    generate
        for(i = 0;i < `PHY_REG_NUM;i++) begin
            always_ff @(posedge clk) begin
                if(rst) begin
                    if((i >= 1) && (i < `ARCH_REG_NUM)) begin
                        map_visible[i] <= 'b1;//1 only for 1~`ARCH_REG_NUM - 1
                    end
                    else begin
                        map_visible[i] <= 'b0;
                    end
                end
                else if(commit_rat_map_table_restore) begin //restore visible property vector
                    map_visible[i] <= commit_rat_map_table_visible[i];
                end
                else if((i == commit_rat_restore_new_phy_id) && commit_rat_restore_map) begin //restore a new map
                    map_visible[i] <= 'b0;
                end
                else if((i == commit_rat_restore_old_phy_id) && commit_rat_restore_map) begin //restore a old map
                    map_visible[i] <= 'b1;
                end
                else if(hide_phy_id[i] && rename_rat_map) begin //hide a old map
                    map_visible[i] <= 'b0;
                end
                else if(visible_enable[i] && rename_rat_map) begin //create a new map
                    map_visible[i] <= 'b1;
                end
            end
        end
    endgenerate

    generate
        for(i = 0;i < `PHY_REG_NUM;i++) begin
            always_ff @(posedge clk) begin
                if(rst) begin
                    if((i >= 1) && (i < `ARCH_REG_NUM)) begin
                        map_commit[i] <= 'b1;//1 only for 1~`ARCH_REG_NUM - 1
                    end
                    else begin
                        map_commit[i] <= 'b0;
                    end
                end
                else if(commit_rat_commit_map && commit_phy_id_valid[i]) begin //commit a map
                    map_commit[i] <= 'b1;
                end
                else if(new_arch_id_valid[i] && rename_rat_map) begin //create a new map
                    map_commit[i] <= 'b0;
                end
            end
        end
    endgenerate

    generate
        for(i = 0;i < `PHY_REG_NUM;i++) begin
            always_ff @(posedge clk) begin
                if(rst) begin
                    if((i >= 1) && (i < `ARCH_REG_NUM)) begin
                        map_table[i] <= i;//1~`ARCH_REG_NUM - 1 only for 1~`ARCH_REG_NUM - 1
                    end
                    else begin
                        map_table[i] <= 'b0;
                    end
                end
                else if(new_arch_id_valid[i] && rename_rat_map) begin //create a new map
                    map_table[i] <= new_arch_id[i];
                end
            end
        end
    endgenerate

    generate 
        for(i = 0;i < `RENAME_WIDTH;i++) begin: cam_phy_id_generate
            for(i2 = 0;i2 < 3;i2 = i2 + 1) begin
                for(j = 0;j < `PHY_REG_NUM;j++) begin
                    assign cam_arch_id_cmp[i][i2][j] = map_valid[j] && map_visible[j] && (map_table[j] == rename_rat_read_arch_id[i][i2]);
                end

                parallel_finder #(
                    .WIDTH(`PHY_REG_NUM)
                )parallel_finder_cam_arch_id_inst(
                    .data_in(cam_arch_id_cmp[i][i2]),
                    .index(rat_rename_read_phy_id[i][i2])
                );
            end
        end
    endgenerate
endmodule