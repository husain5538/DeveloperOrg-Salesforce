<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Weekly_Timesheet_Email_Alert_on_Approval</fullName>
        <description>Weekly Timesheet - Email Alert on Approval</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Weekly_Timesheet_Templates/Weekly_Timesheet_Entry_Approved</template>
    </alerts>
    <alerts>
        <fullName>Weekly_Timesheet_Email_Alert_on_Rejection</fullName>
        <description>Weekly Timesheet - Email Alert on Rejection</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Weekly_Timesheet_Templates/Weekly_Timesheet_Entry_Rejected</template>
    </alerts>
    <fieldUpdates>
        <fullName>Weekly_Timesheet_Field_update_Approved</fullName>
        <description>This Field update is used to update the Approval Status to Approved once record gets approved by Manager</description>
        <field>Approval_Status__c</field>
        <literalValue>Approved</literalValue>
        <name>Weekly Timesheet - Field update Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Weekly_Timesheet_Field_update_Rejection</fullName>
        <description>This field update is used to update the Approval Status to Rejected once record gets rejected by Manager</description>
        <field>Approval_Status__c</field>
        <literalValue>Rejected</literalValue>
        <name>Weekly Timesheet -Field update Rejection</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Weekly_Timesheet_Field_update_Submitted</fullName>
        <description>This Field update is used to update the Approval Status to Pending Approval once record gets submitted by User</description>
        <field>Approval_Status__c</field>
        <literalValue>Pending Approval</literalValue>
        <name>Weekly Timesheet -Field update Submitted</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
</Workflow>
