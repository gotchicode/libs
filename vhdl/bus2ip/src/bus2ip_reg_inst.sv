bus2ip_reg #(
  .USE_ASYNC_RESET      (USE_ASYNC_RESET),
  .USE_SYNC_RESET       (USE_SYNC_RESET),
  .ASYNC_RESET_ACTIVE   (ASYNC_RESET_ACTIVE),
  .SYNC_RESET_ACTIVE    (SYNC_RESET_ACTIVE)
) bus2ip_reg_inst (
  .clock                (clock),
  .async_reset          (async_reset),
  .sync_reset           (sync_reset),
  .Bus2IP_CS_Slave      (Bus2IP_CS_Slave),
  .Bus2IP_addr_Slave    (Bus2IP_addr_Slave),
  .Bus2IP_WrCE_Slave    (Bus2IP_WrCE_Slave),
  .Bus2IP_RdCE_Slave    (Bus2IP_RdCE_Slave),
  .Bus2IP_Data_Slave    (Bus2IP_Data_Slave),
  .IP2Bus_WrAck_Slave   (IP2Bus_WrAck_Slave),
  .IP2Bus_RdAck_Slave   (IP2Bus_RdAck_Slave),
  .IP2Bus_Data_Slave    (IP2Bus_Data_Slave),
  .IP2Bus_Error_Slave   (IP2Bus_Error_Slave),
  .IP2Bus_CS_Master     (IP2Bus_CS_Master),
  .IP2Bus_addr_Master   (IP2Bus_addr_Master),
  .IP2Bus_WrCE_Master   (IP2Bus_WrCE_Master),
  .IP2Bus_RdCE_Master   (IP2Bus_RdCE_Master),
  .IP2Bus_Data_Master   (IP2Bus_Data_Master),
  .Bus2IP_WrAck_Master  (Bus2IP_WrAck_Master),
  .Bus2IP_RdAck_Master  (Bus2IP_RdAck_Master),
  .Bus2IP_Data_Master   (Bus2IP_Data_Master),
  .Bus2IP_Error_Master  (Bus2IP_Error_Master)
);