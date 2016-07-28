<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <rules>
        <fullName>testOnlylead2</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Lead.City</field>
            <operation>equals</operation>
            <value>as</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
