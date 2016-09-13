<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Assigned_Task_Updated_Email_Alert</fullName>
        <description>Assigned Task Updated Email Alert</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <field>Assigned_To__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Task_details_updated_Template</template>
    </alerts>
    <alerts>
        <fullName>New_Task_Assignment_Email_Alert</fullName>
        <description>New Task Assignment Email Alert</description>
        <protected>false</protected>
        <recipients>
            <field>Assigned_To__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/New_Task_assigned_to_User_Template</template>
    </alerts>
    <rules>
        <fullName>Assigned Task Updated</fullName>
        <actions>
            <name>Assigned_Task_Updated_Email_Alert</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>OR(ISCHANGED( Description__c ),ISCHANGED(  Due_Date__c  ), ISCHANGED(Start_Date__c ), ISCHANGED(Due_Date__c) ,ISCHANGED( Status__c ) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>New Task assigned to User</fullName>
        <actions>
            <name>New_Task_Assignment_Email_Alert</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Assigned_Task__c.Subject__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
