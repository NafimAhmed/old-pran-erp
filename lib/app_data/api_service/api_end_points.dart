class ApiEndPoints {
  static const String login = "/ords/rpro/batch/login";
  static const String sendProdQrInfo = "/ords/rpro/batch/qrinfo";
  static const String getTempBatchData = "/ords/rpro/batch/temp_batch_data";
  static const String transferBatch = "/ords/rpro/batch/userbatchstock";
  static const String getUserMachine = "/ords/rpro/batch/usermachine";
  static const String rackTransfer = "/ords/rpro/batch/userstocksubinvtrns";
  static const String getJobHistory = "/ords/rpro/batch/jobhist";
  static const String tranferDelete = "/ords/rpro/batch/userskttrnfdel";
  static const String getUserMenu = "/ords/rpro/batch/usermenu";
  static const String getUserOrg = "/ords/rpro/batch/userorgs";
  static const String getRcvingOrgs = "/ords/rpro/opm/batch/rcvingOrgs";
  static const String getUserBatchData = "/ords/rpro/batch/prodBatchData";
  static const String getUserBasicData = "/ords/rpro/batch/userbasicdata";
  static const String getProdBasicData = "/ords/rpro/batch/prodBasicData";
  static const String interOrgTransfer = "/ords/rpro/invtran/IOTapi";
  static const String ebsInterOrgTransfer = "/ords/rpro/invtran/EBSIOTapi";
  static const String userQrSave = "/ords/rpro/batch/userqrsave";
  static const String userQrSaveWithTrn = "/ords/rpro/batch/batch_trn_complete";
  static const String getUserQrPrintData = "/ords/rpro/batch/userqrprint";
  static const String updateProdQrPrintStatus = "/ords/rpro/batch/userqrsave";
  static const String getSystemModule = "/ords/rpro/sysadmin/sysmanager";
  static const String getSystemMenuParent = "/ords/rpro/sysadmin/sysmenu";
  static const String sysCreateMenu = "/ords/rpro/sysadmin/syscreatemenu";
  static const String getAppsUser = "/ords/rpro/sysadmin/appsuser";
  static const String createUser = "/ords/rpro/sysadmin/usercreation";
  static const String getQrUsers = "/ords/rpro/sysadmin/qruser";
  static const String getQrUserMenu = "/ords/rpro/sysadmin/qrmodule";
  static const String getQrUserChildMenu = "/ords/rpro/sysadmin/qrchildmenu";
  static const String giveUserMenuPermission =
      "/ords/rpro/sysadmin/menupermission";
  static const String getLotTrnData = "/ords/rpro/invtran/IOTstkdata";
  static const String getBatchCloseData = "/ords/rpro/opm/batch/BatchCloseData";
  static const String batchClose = "/ords/rpro/opm/batch/BatchClose";
  static const String getBatchCompData =
      "/ords/rpro/opm/batch/BatchCompleteData";
  static const String getBatchCompDtlData =
      "/ords/rpro/opm/batch/BatchComDtlData";
  static const String batchCompDtlDataLnUpdt =
      "/ords/rpro/opm/batch/BatchComLnUpdt";
  static const String completeBatch = "/ords/rpro/opm/batch/BatchComplete";
  static const String getBatchReleaseData = "/ords/rpro/opm/batch/BatchRelease";
  static const String getRcvInvOrgTrnData = "/ords/rpro/invtran/RcvIOTData";
  static const String getIotTrnData = "/ords/rpro/invtran/IOTTrnsData";
  static const String getJobOrderSumHistory =
      "/ords/rpro/batch/JoborderSumHistory";
  static const String getOrgs = "/ords/rpro/sysadmin/userAnOrgs";
  static const String giveOrgAccess = "/ords/rpro/sysadmin/OrgAccessCreation";
  static const String createMachine = "/ords/rpro/sysadmin/newMachineCreare";
  static const String assignMachineToOrg = "/ords/rpro/batch/machineAssign";
  static const String getSubInv = "/ords/rpro/sysadmin/subinv";
  static const String createLocator =
      "/ords/rpro/sysadmin/itemRackLocatorCreate";
  static const String getRePrintData = "/ords/rpro/opm/batch/qrReprintEnbl";
  static const String getJobDtlDrillDw = "/ords/rpro/batch/userJobDtlDrillDw";
  static const String getJobLocDrillDw = "/ords/rpro/batch/JOLocDrillDw";
  static const String getOpmDashboardSM = "/ords/rpro/batch/opmDashboardSM";
  static const String askAdd = "/ords/rpro/glaiml/askadd";
  static const String getMessages = "/ords/rpro/glaiml/askans";
  static const String getOrgWiseMessage = "/ords/rpro/glaiml/orgWiseMessage";
  static const String getTaskInfoList = "/ords/rpro/taskapi/taskupdt";
  static const String getJoList = "/ords/rpro/taskapi/jobtask";
  static const String saveTaskStatus = "/ords/rpro/taskapi/taskupdt";
  static const String getJobOrderInfo = "/ords/rpro/batch/jobhistSum";
  static const String getShiftData = "/ords/rpro/batch/batchShift";
  static const String getBatchShiftData = "/ords/rpro/batch/batchShiftChange";
  static const String batchShiftChange = "/ords/rpro/batch/batchShiftChange";
  static const String getJoComplList = "/ords/rpro/opm/batch/jobStatusData";
  static const String completeJO = "/ords/rpro/opm/batch/jobStatusData";
  static const String getTopJOInfoList = "/ords/rpro/batch/jobhistTop";
  static const String getTaskList = "/ords/rpro/taskapi/tasklist";
  static const String taskAssign = "/ords/rpro/taskapi/taskassignApi";
  static const String getBatchStatus = "/ords/rpro/batch/userBatchCheck";
  static const String createProject = "/ords/rpro/taskapi/projectAPI";
  static const String getDeptList = "/ords/rpro/taskapi/deptinfo";
  static const String getBuyerList = "/ords/rpro/taskapi/buyerinfo";
  static const String getProjectList = "/ords/rpro/taskapi/projectInfo";
  static const String createMainTask = "/ords/rpro/taskapi/newTaskParentApi";
  static const String getParentTaskList = "/ords/rpro/taskapi/parentTaskList";
  static const String getPoJobList = "/ords/rpro/taskapi/poJobList";
  static const String addTaskNote = "/ords/rpro/taskapi/taskNoteApi";
  static const String getTaskNoteList = "/ords/rpro/taskapi/taskNoteData";
  static const String locatorTranfer = "/ords/rpro/invtran/tmplocatortrnf";
  static const String userPassChange = "/ords/rpro/sysadmin/userPassChng";
  static const String getPurchaseRequisitionList =
      "/ords/rpro/po/purchaseRequisitionList";
  static const String getPurchaseRequisitionDetails =
      "/ords/rpro/po/purchaseRequisitionDetails";
  static const String updatePurReqDtl = "/ords/rpro/po/purchaseReqDtlUpdate";
  static const String approvePurReq = "/ords/rpro/po/purchaseReqApprove";
  static const String getOperationUnit = "/ords/rpro/po/OUList";
  static const String getGrnJOList = "/ords/rpro/po/JOList";
  static const String getGrnPurchaseReqList = "/ords/rpro/po/PRList";
  static const String getGrnPOList = "/ords/rpro/po/GrnPOList";
  static const String getGrnQrSave = "/ords/rpro/invtran/GrnQRSave";
  static const String getGrnOrgList = "/ords/rpro/po/GrnOrgList";
  static const String getMOReqList = "/ords/rpro/taskapi/dlivyTaskUdtList";
  static const String moReqSave = "/ords/rpro/taskapi/dlivyTaskUdtList";
  static const String getCustomerList = "/ords/rpro/opm/batch/customerList";
  static const String smplColHdrSave = "/ords/rpro/opm/batch/smplColHdrSave";
  static const String smplColHdrDtlSave =
      "/ords/rpro/opm/batch/smplColHdrDtlSave";
  static const String getSmplColQrList = "/ords/rpro/opm/batch/smlColQrList";
  static const String prodTransfer = "/ords/rpro/batch/prodTransfer";
  static const String getItemStock = "/ords/rpro/invtran/OrgWiseStock";
  static const String grnTrans = "/ords/rpro/invtran/grn-trans";
}
