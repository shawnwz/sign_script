# -*- coding: utf-8 -*-
from selenium import webdriver
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.support.ui import Select
import os, time, sys

folder = os.environ["NASC_FOLDER"]
user = os.environ["NASC_USER"]
password = os.environ["PASSWORD"]
model = sys.argv[1]
signing_type = sys.argv[2]

step=5

if signing_type == "SBP":
	folder += "/SBP_In"
elif signing_type == "SSD":
	folder += "/SSD_In"

print("User: "+user)
print(";Input: "+folder)
print(";Model: "+model)
print(";SigningType: "+signing_type)

browser = webdriver.Chrome()
browser.get("https://extranet.nagra.com")
browser.find_element_by_id("username_entry").click()
browser.find_element_by_id("username_entry").clear()
browser.find_element_by_id("username_entry").send_keys(user)
browser.find_element_by_id("password_entry").clear()
browser.find_element_by_id("password_entry").send_keys(password)
browser.find_element_by_id("Submit").click()
browser.find_element_by_link_text("- NASC 1.X Signing Request").click()
Select(browser.find_element_by_id("cmbLST_TRIPLET_MANUFACTURER")).select_by_visible_text("Samsung Electronics Company Ltd.")
Select(browser.find_element_by_id("cmbLST_TRIPLET_MODELE")).select_by_visible_text(model)
Select(browser.find_element_by_id("cmbLST_TRIPLET_OPERATOR")).select_by_visible_text("Starhub Cable Vision")

for parent,dirnames,filenames in os.walk(folder):
	for filename in filenames:
		if signing_type == "SBP":
			browser.find_element_by_xpath("//u").click()
		elif signing_type == "SSD":
			browser.find_element_by_xpath("//tr[9]/td[2]/span[2]/a/u").click()
		else:
			print("Error: Invalid signing type: "+signing_type)
			browser.quit()
			sys.exit(1)
		browser.switch_to.window(browser.window_handles[1])
		browser.find_element_by_xpath("(//input[@id='file'])[1]").send_keys(os.path.join(parent,filename))
		browser.find_element_by_xpath("(//input[@id='btnAdd'])[1]").click()
		browser.find_element_by_id("upload").click()
		
		for i in range(0,241,step):
			time.sleep(step)
			if len(browser.window_handles)==1:
				break

		if i==240 and len(browser.window_handles)>1:
			browser.close()
		browser.switch_to.window(browser.window_handles[0])

browser.find_element_by_id("Submit").click()
number = browser.find_element_by_xpath("//table[4]/tbody/tr/td/a").text
print(";Number: "+number)
browser.quit()

