package org.example.crm.workbench.service;

import org.example.crm.workbench.domain.Contacts;

import java.util.List;
import java.util.Map;

public interface ContactsService {

    List<Contacts> queryContactsByConditionForPage(Map<String,Object> map);

    int queryCountOfContactsByCondition(Map<String,Object> map);

    void saveCreateContacts(Map<String,Object> map);

    Contacts queryContactsForDetailById(String id);

    List<Contacts> queryContactsForSaveByName(String name);
}
