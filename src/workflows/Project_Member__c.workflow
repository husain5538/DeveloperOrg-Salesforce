<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>ProjectMember_New_member_added</fullName>
        <description>ProjectMember-New member added</description>
        <protected>false</protected>
        <recipients>
            <field>Member__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/New_Project_Member_added_to_Project</template>
    </alerts>
    <rules>
        <fullName>New Project Member added to Project</fullName>
        <actions>
            <name>ProjectMember_New_member_added</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Project_Member__c.Role__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
