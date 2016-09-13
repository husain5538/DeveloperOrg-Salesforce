<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>TimeEntry_Update_Billed_Amount</fullName>
        <field>Billed_Amount__c</field>
        <formula>Total_Time_Spent__c *  Related_Task__r.Hourly_Rate__c</formula>
        <name>TimeEntry Update Billed Amount</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>TimeEntry Update Billed Amount</fullName>
        <actions>
            <name>TimeEntry_Update_Billed_Amount</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Time_Entry__c.Total_Time_Spent__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
